Return-Path: <linux-kernel-owner+w=401wt.eu-S1760002AbYEHNVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002AbYEHNVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758940AbYEHNUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:20:53 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:48527 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757577AbYEHNUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:20:51 -0400
Date: Thu, 8 May 2008 07:20:49 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] speed up / fix the new generic semaphore code (fix AIM7 40% regression with 2.6.26-rc1)
Message-ID: <20080508132049.GG19219@parisc-linux.org>
References: <87lk2mbcqp.fsf@basil.nowhere.org> <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org> <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508120130.GA2860@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 02:01:30PM +0200, Ingo Molnar wrote:
> Looking at the workload i found and fixed what i believe to be the real 
> bug causing the AIM7 regression: it was inefficient wakeup / scheduling 
> / locking behavior of the new generic semaphore code, causing suboptimal 
> performance.

I did note that earlier downthread ... although to be fair, I thought of
it in terms of three tasks with the third task coming in and stealing
the second tasks's wakeup rather than the first task starving the second
by repeatedly locking/unlocking the semaphore.

> So if the old owner, even if just a few instructions later, does a 
> down() [lock_kernel()] again, it will be blocked and will have to wait 
> on the new owner to eventually be scheduled (possibly on another CPU)! 
> Or if another other task gets to lock_kernel() sooner than the "new 
> owner" scheduled, it will be blocked unnecessarily and for a very long 
> time when there are 2000 tasks running.
> 
> I.e. the implementation of the new semaphores code does wake-one and 
> lock ownership in a very restrictive way - it does not allow 
> opportunistic re-locking of the lock at all and keeps the scheduler from 
> picking task order intelligently.

Fair is certainly the enemy of throughput (see also dbench arguments
passim).  It may be that some semaphore users really do want fairness --
it seems pretty clear that we don't want fairness for the BKL.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
