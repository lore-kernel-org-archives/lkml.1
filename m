Return-Path: <linux-kernel-owner+w=401wt.eu-S1761910AbYEGRz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761910AbYEGRz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbYEGRzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:55:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751538AbYEGRzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:55:47 -0400
Date: Wed, 7 May 2008 10:55:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <20080507173612.GA13591@elte.hu>
Message-ID: <alpine.LFD.1.10.0805071049180.3024@woody.linux-foundation.org>
References: <1210126286.3453.37.camel@ymzhang> <1210131712.3453.43.camel@ymzhang> <87lk2mbcqp.fsf@basil.nowhere.org> <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org>
 <20080507162012.GA10096@elte.hu> <alpine.LFD.1.10.0805070929310.3024@woody.linux-foundation.org> <20080507170528.GA11511@elte.hu> <alpine.LFD.1.10.0805071017130.3024@woody.linux-foundation.org> <20080507173612.GA13591@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Ingo Molnar wrote:
> 
> no, there was another problem (which i couldnt immediately find because 
> lkml.org only indexes part of the threads, i'll research it some more), 
> which was some cond_resched() thing in the !PREEMPT_BKL case.

Hmm. I do agree that _cond_resched() looks a bit iffy, although in a safe 
way. It uses just

	!(preempt_count() & PREEMPT_ACTIVE)

to see whether it can schedule, and it should probably use in_atomic() 
which ignores the kernel lock.

But right now, that whole thing is disabled if PREEMPT is on anyway, so in 
effect (with my test patch, at least) cond_preempt() would just be a no-op 
if PREEMPT is on, even if BKL isn't preemptable.

So it doesn't look buggy, but it looks like it might cause longer 
latencies than strictly necessary. And if somebody depends on 
cond_resched() to avoid some bad livelock situation, that would obviously 
not work (but that sounds like a fundamental bug anyway, I really hope 
nobody has ever written their code that way).

> The !PREEMPT_BKL crash was some simple screwup on my part of getting 
> atomicity checks wrong in cond_resched() - and it went unnoticed for a 
> long time - or something like that. I'll try to find that discussion.

Yes, some silly bug sounds more likely. Especially considering how many 
different cases there were (semaphores vs spinlocks vs preemptable 
spinlocks).

			Linus
