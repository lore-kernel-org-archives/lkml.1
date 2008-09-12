Return-Path: <linux-kernel-owner+w=401wt.eu-S1758088AbYILWFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbYILWFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 18:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842AbYILWE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 18:04:59 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49784 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580AbYILWE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 18:04:58 -0400
Subject: Re: [BUG -rt] Priority inversion deadlock caused by condvars
From: john stultz <johnstul@us.ibm.com>
To: drepper@redhat.com
Cc: Thomas Gleixner <tglx@linutronix.de>, mingo <mingo@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>, Ankita Garg <ankita@in.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Sripathi Kodi <sripathi@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1221256895.6695.55.camel@localhost.localdomain>
References: <1221256895.6695.55.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 15:04:54 -0700
Message-Id: <1221257094.6695.56.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, originally sent to the wrong Ulrich.

Sorry
-john


On Fri, 2008-09-12 at 15:01 -0700, john stultz wrote:
> 	So we've been seeing application hangs with a very threaded (~8k
> threads) realtime java test. After a fair amount of debugging we found
> most of the SCHED_FIFO threads are blocked in futex_wait(). This raised
> some alarm, since futex_wait isn't priority-inheritance aware.
> 
> After seeing what was going on, Dino came up with a possible deadlock
> case in the pthread_cond_wait() code.
> 
> The problem, as I understand it, assuming there is only one cpu, is if a
> low priority thread is going to call pthread_cond_wait(), it takes the
> associated PI mutex, and calls the function. The glibc implementation
> acquires the condvar's internal non-PI lock, releases the PI mutex and
> tries to block on futex_wait().
> 
> However if a medium priority cpu hog, and a high priority start up while
> the low priority thread holds the mutex, the low priority thread will be
> boosted until it releases that mutex, but not long enough for it to
> release the condvar's internal lock (since the internal lock is not
> priority inherited). 
> 
> Then the high priority thread will aquire the mutex, and try to acquire
> the condvar's internal lock (which is still held). However, since we
> also have a medium prio cpu hog, it will block the low priority thread
> from running, and thus block it from releasing the lock.
> 
> And then we're deadlocked.
> 
> Thomas mentioned this is a known problem, but I wanted to send this
> example out so maybe others might become aware.
> 
> The attached test illustrates this hang as described above when bound to
> a single cpu. I believe its correct, but these sorts of tests often have
> their own bugs that create false positives, so please forgive me and let
> me know if you see any problems. :)
> 
> Many thanks to Dino, Ankita and Sripathi for helping to sort out this
> issue.
> 
> To run:
> 	./pthread_cond_hang               => will PASS (on SMP)
> 	taskset -c 0 ./pthread_cond_hang  => will HANG
> 
> 
> thanks
> -john

