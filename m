Return-Path: <linux-kernel-owner+w=401wt.eu-S1751515AbZH1Cx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbZH1Cx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 22:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbZH1Cx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 22:53:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:37191 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbZH1Cx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 22:53:28 -0400
Message-ID: <4A97468A.6080502@kernel.org>
Date: Fri, 28 Aug 2009 11:52:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] lockup with the latest kernel
References: <alpine.DEB.2.00.0908191134260.12663@gandalf.stny.rr.com> <alpine.DEB.2.00.0908271836140.26718@gandalf.stny.rr.com> <4A9744F4.7010208@kernel.org>
In-Reply-To: <4A9744F4.7010208@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Aug 2009 02:53:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>>> Always happens where one CPU is sending an IPI and the other has the rq 
>>> spinlock. Seems to be that the IPI expects the other CPU to not have 
>>> interrupts disabled or something?
> 
> I'm not too familiar with apics but AFAIK sending IPI isn't an
> interlocked operation (not at least at the software level) so I doubt
> it has much to do with the other cpu doing or not doing anything.  It
> looks like the local apic is stuck hardware-wise.  The only thing the
> commit changes is that cpu1 would be using vector 0xf1 instead of 0xf0
> together with cpu0.
> 
> (reading the doc...) Okay, here's something interesting.  It's from
> section 9.8.4 of intel doc 253668.pdf - Intel 64 and IA-32
> Architectures Software Developer's Manual Volume 3A: System
> Programming Guide, Part 1.
> 
>  For the P6 family and Pentium processors, the IRR and ISR registers
>  can queue no more than two interrupts per priority level, and will
>  reject other interrupts that are received within the same priority
>  level.
> 
> And from AMD's 24593 - AMD64 Architecture Programmer's Manual Volume
> 2: System Programming, section 16.6.3.
> 
>  No more than two interrupts can be pending for the same interrupt
>  vector number. Subsequent interrupt requests to the same interrupt
>  vector number will be rejected. See Figure 16-23 on page 445.
> 

Oh... there are differences that I missed.

 All intels: If more than one interrupt is generated with the same
	     vector number, the local APIC can set the bit for the
	     vector both in the IRR and the ISR. This means that for
	     the Pentium 4 and Intel Xeon processors, the IRR and ISR
	     can queue two interrupts for each interrupt vector: one
	     in the IRR and one in the ISR. Any additional interrupts
	     issued FOR THE SAME INTERRUPT VECTOR are COLLAPSED INTO
	     THE SINGLE BIT in the IRR.

 Ppro: no more than two interrupts PER PRIORITY LEVEL, and will REJECT
       OTHER interrupts

 AMD64: Subsequent interrupt requests to THE SAME INTERRUPT VECTOR
        NUMBER will be REJECTED.

Eh... don't have earlier AMD doc and gotta go now.  Can somebody
please check?  But it looks like we can deadlock by simply sending
RESCHEDULE_VECTOR more than two times while holding rq lock on AMD?

Thanks.

-- 
tejun
