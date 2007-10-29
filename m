Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbXJ2WNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbXJ2WNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbXJ2WNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:13:32 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:36249 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbXJ2WNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:13:31 -0400
Date: Tue, 30 Oct 2007 03:13:22 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frans Pop <elendil@planet.nl>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Chuck Ebbert <cebbert@redhat.com>, Greg KH <greg@kroah.com>,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
Message-ID: <20071029214321.GA25669@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <200710122231.50739.elendil@planet.nl> <200710161234.35529.borntraeger@de.ibm.com> <4714B5BF.1090001@linux.vnet.ibm.com> <200710291305.52992.elendil@planet.nl> <4725D2A5.1050908@linux.vnet.ibm.com> <20071029200425.GA830@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029200425.GA830@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 09:04:25PM +0100, Ingo Molnar wrote:
> 
> * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > We'll I initially thought of it and then I remembered that the 
> > regression occurs only when the accounting itself is inaccurate. I am 
> > tempted to ack the removal, but I would like to get input from others. 
> > Meanwhile, I'll try and see if I can fix the problem
> 
> i've got a patch from Peter queued up. (see below) This should fix the 
> main issue.
> 
> 	Ingo
>

We'll also need this additional patch (untested), but in the long run
I think the approach needs to be

1. Update stime and utime at the time of context switching -- keep it
   in sync with p->sum_exec_runtime
2. Keep track of system/user context at system call entry points

 
Extend Peter's patch to fix accounting issues.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 fs/proc/array.c       |    3 ++-
 include/linux/sched.h |    2 +-
 kernel/fork.c         |    1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/proc/array.c~fix-accounting-issue-extended fs/proc/array.c
--- 2.6.24-rc1/fs/proc/array.c~fix-accounting-issue-extended	2007-10-30 03:08:18.000000000 +0530
+++ 2.6.24-rc1-balbir/fs/proc/array.c	2007-10-30 03:09:46.000000000 +0530
@@ -374,7 +374,8 @@ static cputime_t task_stime(struct task_
 	stime = nsec_to_clock_t(p->se.sum_exec_runtime) -
 			cputime_to_clock_t(task_utime(p));
 
-	return clock_t_to_cputime(stime);
+	p->prev_stime = max(p->prev_stime, clock_t_to_cputime(stime));
+	return p->prev_stime;
 }
 #endif
 
diff -puN include/linux/sched.h~fix-accounting-issue-extended include/linux/sched.h
--- 2.6.24-rc1/include/linux/sched.h~fix-accounting-issue-extended	2007-10-30 03:08:18.000000000 +0530
+++ 2.6.24-rc1-balbir/include/linux/sched.h	2007-10-30 03:08:32.000000000 +0530
@@ -1004,7 +1004,7 @@ struct task_struct {
 	unsigned int rt_priority;
 	cputime_t utime, stime, utimescaled, stimescaled;
 	cputime_t gtime;
-	cputime_t prev_utime;
+	cputime_t prev_utime, prev_stime;
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time; 		/* monotonic time */
 	struct timespec real_start_time;	/* boot based time */
diff -puN kernel/fork.c~fix-accounting-issue-extended kernel/fork.c
--- 2.6.24-rc1/kernel/fork.c~fix-accounting-issue-extended	2007-10-30 03:08:18.000000000 +0530
+++ 2.6.24-rc1-balbir/kernel/fork.c	2007-10-30 03:08:42.000000000 +0530
@@ -1057,6 +1057,7 @@ static struct task_struct *copy_process(
 	p->utimescaled = cputime_zero;
 	p->stimescaled = cputime_zero;
 	p->prev_utime = cputime_zero;
+	p->prev_stime = cputime_zero;
 
 #ifdef CONFIG_TASK_XACCT
 	p->rchar = 0;		/* I/O counter: bytes read */
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
