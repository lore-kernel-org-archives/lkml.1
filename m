Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbYDCVHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbYDCVHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 17:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbYDCVHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 17:07:30 -0400
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:40448 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755248AbYDCVH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 17:07:29 -0400
Date: Fri, 4 Apr 2008 00:07:01 +0300
From: Pekka Paalanen <pq@iki.fi>
To: avi@qumranet.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com
Subject: Re: mmiotrace bug: recursive probe hit
Message-ID: <20080404000701.70bbc1a4@daedalus.pq.iki.fi>
In-Reply-To: <20080330202608.054702a4@daedalus.pq.iki.fi>
References: <20080309164050.2194461e@daedalus.pq.iki.fi>
	<20080328222500.21863a44@daedalus.pq.iki.fi>
	<20080330202608.054702a4@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Mar 2008 20:26:08 +0300
Pekka Paalanen <pq@iki.fi> wrote:

> 
> C) Vegard mentioned something about per-cpu page tables for kmemcheck.
> This would be the ultimate solution, because it would solve two problems:
> - recursive probe hits
> - missed events due to another cpu disarming the page for single stepping
> Would it be possible to have a single temporary per-cpu pte?
> 
> I understood kmemcheck has similar issues. Of course, one could force the
> system down to a single running CPU, but that feels nasty.

One more idea:

D) Emulate the faulting instruction.
In __ioremap(), do the mapping, but steal it for mmiotrace's personal use,
and return a bogus mapping that is identifiable in #pf handler. When
something accesses the bogus mapping, emulate and step over the faulting
instruction using the stolen IO memory mapping. This would get rid of
the debug trap and single stepping, and also remove the need to disarm
the mmio page, which means tracing would work reliably on SMP without
any page table kludges. This would also remove the yet another instruction
decoding code that mmiotrace has.

The catch is the instruction emulation. I see KVM has some emulation code,
but I cannot understand it without a deep study that would take me weeks.
Is that general enough to be used, or could it be generalized?
Mmiotrace, apart from executing the instruction with a modified address,
would need to extract the type of IO memory access, width and the data
read/written. And since it is dealing with IO memory, the emulation
should be very careful to access the hardware exactly like the original
instruction would have.

Maybe also kmemcheck could use this approach, since the current approach
is very much like in mmiotrace: #pf, show page, single step, #db trap,
hide page.

Are there other x86(_64) instruction emulation facilities in the kernel
I might use?

Or, if the emulation cannot be used, what would it take to make at least
instruction decoding general enough so that mmiotrace could use that instead
of its own decoding?

I fear modifying KVM emulation code is a too heavy job for me personally.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
