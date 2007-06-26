Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbXFZJCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbXFZJCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 05:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbXFZJCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 05:02:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42642 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751147AbXFZJCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 05:02:39 -0400
Date: Tue, 26 Jun 2007 02:00:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?UTF-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v18
Message-Id: <20070626020047.f019b731.akpm@linux-foundation.org>
In-Reply-To: <20070626083813.GA16151@elte.hu>
References: <20070622220202.GA16872@elte.hu>
	<200706230109.08310.caglar@pardus.org.tr>
	<200706230116.29615.caglar@pardus.org.tr>
	<20070622222036.GC27445@elte.hu>
	<20070625200235.9d24f6cd.akpm@linux-foundation.org>
	<20070626083813.GA16151@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 10:38:13 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> > - __exit_signal() does apparently-unlocked 64-bit arith.  Is there 
> >   some implicit locking here or do we not care about the occasional 
> >   race-induced inaccuracy?
> 
> do you mean the tsk->se.sum_exec_runtime addition, etc? That runs with 
> interrupts disabled so sum_sched_runtime is protected.
> 
> >   (ditto, lots of places, I expect)
> 
> which places do you mean?

I forget ;) There seemed to be rather a lot of 64-bit addition with no
obvious locking in sight, that's all.

> > ...
> >   (Gee, there's shitloads of 64-bit stuff in there.  Does it all 
> >   _really_ need to be 64-bit on 32-bit?)
>
> yes - CFS is fundamentally designed for 64-bit, with still pretty OK 
> arithmetics performance for 32-bit.

It may have been designed for 64-bit, but was that the correct design?  The
cost on 32-bit appears to be pretty high.  Perhaps a round of uninlining
will help.

> > - overall, CFS takes sched.o from 41157 of .text up to 48781 on x86_64,
> >   which at 18% is rather a large bloat.  Hopefully a lot of this is 
> >   the new debug stuff.
> 
> > - On i386 sched.o went from 33755 up to 43660 which is 29% growth. 
> >   Possibly acceptable, but why did it increase a lot more than the x86_64
> >   version?  All that 64-bit arith, I assume?
> 
> the main reason is the sched debugging stuff:

That would serve to explain the 18% growth on x86_64.  But why did i386
grow by much more: 29%?  I'd be suspecting all the new 64-bit arithmetic.


