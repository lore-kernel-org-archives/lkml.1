Return-Path: <linux-kernel-owner+w=401wt.eu-S1765407AbYEGSBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765407AbYEGSBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759568AbYEGSAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:00:11 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41241 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342AbYEGSAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:00:01 -0400
Date: Wed, 7 May 2008 11:59:59 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080507175959.GZ19219@parisc-linux.org>
References: <87lk2mbcqp.fsf@basil.nowhere.org> <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <20080507162012.GA10096@elte.hu> <alpine.LFD.1.10.0805070929310.3024@woody.linux-foundation.org> <20080507170528.GA11511@elte.hu> <alpine.LFD.1.10.0805071017130.3024@woody.linux-foundation.org> <20080507173612.GA13591@elte.hu> <alpine.LFD.1.10.0805071049180.3024@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805071049180.3024@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 10:55:26AM -0700, Linus Torvalds wrote:
> Hmm. I do agree that _cond_resched() looks a bit iffy, although in a safe 
> way. It uses just
> 
> 	!(preempt_count() & PREEMPT_ACTIVE)
> 
> to see whether it can schedule, and it should probably use in_atomic() 
> which ignores the kernel lock.
> 
> But right now, that whole thing is disabled if PREEMPT is on anyway, so in 
> effect (with my test patch, at least) cond_preempt() would just be a no-op 
> if PREEMPT is on, even if BKL isn't preemptable.
> 
> So it doesn't look buggy, but it looks like it might cause longer 
> latencies than strictly necessary. And if somebody depends on 
> cond_resched() to avoid some bad livelock situation, that would obviously 
> not work (but that sounds like a fundamental bug anyway, I really hope 
> nobody has ever written their code that way).

Funny you should mention it; locks.c uses cond_resched() assuming that
it ignores the BKL.  Not through needing to avoid livelock, but it does
presume that other higher priority tasks contending for the lock will
get a chance to take it.  You'll notice the patch I posted yesterday
drops the file_lock_lock around the call to cond_resched().

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
