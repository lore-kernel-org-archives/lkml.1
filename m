Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbYIOJWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbYIOJWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 05:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbYIOJW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 05:22:26 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:57029 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbYIOJWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 05:22:25 -0400
Date: Mon, 15 Sep 2008 14:51:35 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: john stultz <johnstul@us.ibm.com>
Cc: drepper@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
       mingo <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       Sripathi Kodi <sripathi@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [BUG -rt] Priority inversion deadlock caused by condvars
Message-ID: <20080915092135.GA7725@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <1221256895.6695.55.camel@localhost.localdomain> <1221257094.6695.56.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221257094.6695.56.camel@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

> On Fri, 2008-09-12 at 15:01 -0700, john stultz wrote:
> > 	So we've been seeing application hangs with a very threaded (~8k
> > threads) realtime java test. After a fair amount of debugging we found
> > most of the SCHED_FIFO threads are blocked in futex_wait(). This raised
> > some alarm, since futex_wait isn't priority-inheritance aware.
> > 
> > After seeing what was going on, Dino came up with a possible deadlock
> > case in the pthread_cond_wait() code.
> > 
> > The problem, as I understand it, assuming there is only one cpu, is if a
> > low priority thread is going to call pthread_cond_wait(), it takes the
> > associated PI mutex, and calls the function. The glibc implementation
> > acquires the condvar's internal non-PI lock, releases the PI mutex and
> > tries to block on futex_wait().
> > 
> > However if a medium priority cpu hog, and a high priority start up while
> > the low priority thread holds the mutex, the low priority thread will be
> > boosted until it releases that mutex, but not long enough for it to
> > release the condvar's internal lock (since the internal lock is not
> > priority inherited). 
> > 
> > Then the high priority thread will aquire the mutex, and try to acquire
> > the condvar's internal lock (which is still held). However, since we
> > also have a medium prio cpu hog, it will block the low priority thread
> > from running, and thus block it from releasing the lock.
> > 
> > And then we're deadlocked.
> > 
> > Thomas mentioned this is a known problem, but I wanted to send this
> > example out so maybe others might become aware.

Looks like a similar issue was raised sometime back.

http://sourceware.org/bugzilla/show_bug.cgi?id=5192

> > 
> > The attached test illustrates this hang as described above when bound to
> > a single cpu. I believe its correct, but these sorts of tests often have
> > their own bugs that create false positives, so please forgive me and let
> > me know if you see any problems. :)
> > 
> > Many thanks to Dino, Ankita and Sripathi for helping to sort out this
> > issue.
> > 
> > To run:
> > 	./pthread_cond_hang               => will PASS (on SMP)
> > 	taskset -c 0 ./pthread_cond_hang  => will HANG

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs, 
Bangalore, India   
