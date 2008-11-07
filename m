Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbYKGUhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbYKGUhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 15:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYKGUh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 15:37:27 -0500
Received: from relais.videotron.ca ([24.201.245.36]:44123 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbYKGUh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 15:37:26 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 07 Nov 2008 15:36:45 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: David Howells <dhowells@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
In-reply-to: <20081107170902.GD22134@Krystal>
Message-id: <alpine.LFD.2.00.0811071522270.13034@xanadu.home>
References: <20081107053349.861709786@polymtl.ca>
 <20081107052336.652868737@polymtl.ca> <25257.1226055312@redhat.com>
 <20081107170902.GD22134@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008, Mathieu Desnoyers wrote:

> I want to make sure
> 
>   __m_cnt_hi
>  is read before
>   mmio cnt_lo read
> 
> for the detailed reasons explained in my previous discussion with
> Nicolas here :
> http://lkml.org/lkml/2008/10/21/1
> 
> I use smp_rmb() to do this on SMP systems (hrm, actually, a rmb() could
> be required so it works also on UP systems safely wrt interrupts).
> 
> The write side is between the hardware counter, which is assumed to
> increment monotonically between each read, and the value __m_cnt_hi
> updated by the CPU. I don't see where we could put a wmb() there.
> 
> Without barrier, the smp race looks as follow :
> 
> 
> CPU    A                                    B
>                                             read hw cnt low (0xFFFFFFFA)
>        read __m_cnt_hi (0x80000000)
>        read hw cnt low (0x00000001)
>        (wrap detected :
>         (s32)(0x80000000 ^ 0x1) < 0)
>        write __m_cnt_hi = 0x00000001
>                                             read __m_cnt_hi (0x00000001)
>        return 0x0000000100000001
>                                             (wrap detected :
>                                              (s32)(0x00000001 ^ 0xFFFFFFFA) < 0)
>                                             write __m_cnt_hi = 0x80000001
>                                             return 0x80000001FFFFFFFA
>                                                                   (time jumps)

Could you have hardware doing such things?  You would get a non cached 
and more expensive read on CPU B which is not in program order with the 
read that should have happened before, and before that second out of 
order read could be performed, you'd have a full sequence in program 
order performed on CPU A.


Nicolas
