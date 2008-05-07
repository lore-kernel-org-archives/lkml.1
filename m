Return-Path: <linux-kernel-owner+w=401wt.eu-S1764998AbYEGSS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764998AbYEGSS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbYEGSSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:18:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754826AbYEGSSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:18:43 -0400
Date: Wed, 7 May 2008 11:17:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <20080507175959.GZ19219@parisc-linux.org>
Message-ID: <alpine.LFD.1.10.0805071104290.3024@woody.linux-foundation.org>
References: <87lk2mbcqp.fsf@basil.nowhere.org> <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <20080507162012.GA10096@elte.hu> <alpine.LFD.1.10.0805070929310.3024@woody.linux-foundation.org>
 <20080507170528.GA11511@elte.hu> <alpine.LFD.1.10.0805071017130.3024@woody.linux-foundation.org> <20080507173612.GA13591@elte.hu> <alpine.LFD.1.10.0805071049180.3024@woody.linux-foundation.org> <20080507175959.GZ19219@parisc-linux.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Matthew Wilcox wrote:
> > 
> > So it doesn't look buggy, but it looks like it might cause longer 
> > latencies than strictly necessary. And if somebody depends on 
> > cond_resched() to avoid some bad livelock situation, that would obviously 
> > not work (but that sounds like a fundamental bug anyway, I really hope 
> > nobody has ever written their code that way).
> 
> Funny you should mention it; locks.c uses cond_resched() assuming that
> it ignores the BKL.  Not through needing to avoid livelock, but it does
> presume that other higher priority tasks contending for the lock will
> get a chance to take it.  You'll notice the patch I posted yesterday
> drops the file_lock_lock around the call to cond_resched().

Well, this would only be noticeable with CONFIG_PREEMPT.

If you don't have preempt enabled, it looks like everything should work 
ok: the kernel lock wouldn't increase the preempt count, and 
_cond_resched() works fine.

If you're PREEMPT, then the kernel lock would increase the preempt count, 
and _cond_resched() would refuse to re-schedule it, *but* with PREEMPT 
you'd never see it *anyway*, because PREEMPT will disable cond_resched() 
entirely (because preemption takes care of normal scheduling latencies 
without it).

And I'm also sure that this all worked fine at some point, and it's 
largely a result just of the multiple different variations of BKL 
preemption coupled with some of them getting removed entirely, so the code 
that used to handle it just got corrupt over time. See commit 02b67cc3b, 
for example. 

.. Hmm ... Time passes. Linus looks at git history.

It does look like "cond_resched()" has not worked with the BKL since 2005, 
and hasn't taken the BKL into account. Commit 5bbcfd9000:

    [PATCH] cond_resched(): fix bogus might_sleep() warning

+       if (unlikely(preempt_count()))
+               return;

which talks about the BKS, ie it only took the *semaphore* implementation 
into account. Never the spinlock-with-preemption-count one.

Or am I blind?

		Linus
