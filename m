Return-Path: <linux-kernel-owner+w=401wt.eu-S1755065AbZGAJrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbZGAJrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbZGAJrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:47:03 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:48405 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755183AbZGAJrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:47:01 -0400
Subject: Re: [PATCH] kmemleak: Fix scheduling-while-atomic bug
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       git-commits-head@vger.kernel.org
In-Reply-To: <20090701093015.GA6862@elte.hu>
References: <200907010300.n6130rRf026194@hera.kernel.org>
	 <20090701075332.GA17252@elte.hu>
	 <1246439937.8492.18.camel@pc1117.cambridge.arm.com>
	 <20090701093015.GA6862@elte.hu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 01 Jul 2009 10:46:31 +0100
Message-Id: <1246441592.8492.38.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jul 2009 09:46:32.0941 (UTC) FILETIME=[D10CA1D0:01C9FA30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 11:30 +0200, Ingo Molnar wrote:
> * Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > > The minimal fix below removes scan_yield() and adds a 
> > > cond_resched() to the outmost (safe) place of the scanning 
> > > thread. This solves the regression.
> > 
> > With CONFIG_PREEMPT disabled it won't reschedule during the bss 
> > scanning but I don't see this as a real issue (task stacks 
> > scanning probably takes longer anyway).
> 
> Yeah. I suspect one more cond_resched() could be added - i just 
> didnt see an obvious place for it, given that scan_block() is being 
> called with asymetric held-locks contexts.

Yes, scan_block shouldn't call cond_resched(). The code is cleaner if
functions don't have too many side-effects. I can see about 1 sec of bss
scanning on an ARM board but with processor at < 500MHz and slow memory
system. On a standard x86 systems BSS scanning may not be noticeable
(and I think PREEMPT enabling is quite common these days).

Since we are at locking, I just noticed this on my x86 laptop when
running cat /sys/kernel/debug/kmemleak (I haven't got it on an ARM
board):

================================================
[ BUG: lock held when returning to user space! ]
------------------------------------------------
cat/3687 is leaving the kernel with locks still held!
1 lock held by cat/3687:
#0:  (scan_mutex){+.+.+.}, at: [<c01e0c5c>] kmemleak_open+0x3c/0x70

kmemleak_open() acquires scan_mutex and unconditionally releases it in
kmemleak_release(). The mutex seems to be released as a subsequent
acquiring works fine.

Is this caused just because cat may have exited without closing the file
descriptor (which should be done automatically anyway)?

Thanks.

-- 
Catalin

