Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbYJUAUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbYJUAUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 20:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYJUAUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 20:20:37 -0400
Received: from relais.videotron.ca ([24.201.245.36]:45423 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbYJUAUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 20:20:36 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 20 Oct 2008 20:20:29 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC patch 00/15] Tracer Timestamping
In-reply-to: <20081020202517.GF28562@Krystal>
Message-id: <alpine.LFD.2.00.0810202003260.26244@xanadu.home>
References: <20081016232729.699004293@polymtl.ca>
 <1224230353.28131.65.camel@twins> <20081020202517.GF28562@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008, Mathieu Desnoyers wrote:

> * Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> > Have you looked at the existing 32->63 extention code in
> > include/linux/cnt32_to_63.h and considered unifying it?
> > 
> 
> Yep, I felt this code was dangerous on SMP given it could suffer from
> the following type of race due to lack of proper barriers :

You are wrong.

> CPU    A                                 B
>        read hw cnt low
>        read __m_cnt_hi
>                                          read hw cnt low
>        (wrap detected)
>        write __m_cnt_hi (incremented)
>                                          read __m_cnt_hi
>                                          (wrap detected)
>                                          write __m_cnt_hi (incremented)
> 
> we therefore increment the high bits twice in the given race.

No.  Either you do the _same_ incrementation twice effectively writing 
the _same_ high value twice, or you don't have simultaneous wrap 
detections.  Simulate it on paper with real numbers if you are not 
convinced.

> On UP, the same race could happen if the code is called with preemption
> enabled.

Wrong again.

> I don't think the "volatile" statement would necessarily make sure the
> compiler and CPU would do the __m_cnt_hi read before the hw cnt low
> read. A real memory barrier to order mmio reads wrt memory reads (or
> instruction sync barrier if the value is taken from the cpu registers)
> would be required to insure such order.

That's easy enough to fix, right?

> I also felt it would be more solid to have per-cpu structures to keep
> track of 32->64 bits TSC updates, given the TSCs can always be slightly
> out-of-sync :

If the low part is a per CPU value then the high part has to be a per 
CPU value too.  There only needs to be a per-CPU variant of the same 
algorithm where the only difference is that __m_cnt_hi would be per CPU.

If the low part is global then __m_cnt_hi has to be global, even on SMP.


Nicolas
