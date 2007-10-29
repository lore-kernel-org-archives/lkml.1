Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbXJ2UFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbXJ2UFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbXJ2UFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:05:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46325 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267AbXJ2UFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:05:01 -0400
Date: Mon, 29 Oct 2007 21:04:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Frans Pop <elendil@planet.nl>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Chuck Ebbert <cebbert@redhat.com>, Greg KH <greg@kroah.com>,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
Message-ID: <20071029200425.GA830@elte.hu>
References: <200710122231.50739.elendil@planet.nl> <200710161234.35529.borntraeger@de.ibm.com> <4714B5BF.1090001@linux.vnet.ibm.com> <200710291305.52992.elendil@planet.nl> <4725D2A5.1050908@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4725D2A5.1050908@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> We'll I initially thought of it and then I remembered that the 
> regression occurs only when the accounting itself is inaccurate. I am 
> tempted to ack the removal, but I would like to get input from others. 
> Meanwhile, I'll try and see if I can fix the problem

i've got a patch from Peter queued up. (see below) This should fix the 
main issue.

	Ingo

-------------------->
Subject: sched: keep utime/stime monotonic
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

keep utime/stime monotonic.

cpustats use utime/stime as a ratio against sum_exec_runtime, as a
consequence it can happen - when the ratio changes faster than time
accumulates - that either can be appear to go backwards.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/proc/array.c       |    3 ++-
 include/linux/sched.h |    1 +
 kernel/fork.c         |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

Index: linux/fs/proc/array.c
===================================================================
--- linux.orig/fs/proc/array.c
+++ linux/fs/proc/array.c
@@ -358,7 +358,8 @@ static cputime_t task_utime(struct task_
 	}
 	utime = (clock_t)temp;
 
-	return clock_t_to_cputime(utime);
+	p->prev_utime = max(p->prev_utime, clock_t_to_cputime(utime));
+	return p->prev_utime;
 }
 
 static cputime_t task_stime(struct task_struct *p)
Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -1009,6 +1009,7 @@ struct task_struct {
 	unsigned int rt_priority;
 	cputime_t utime, stime, utimescaled, stimescaled;
 	cputime_t gtime;
+	cputime_t prev_utime;
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time; 		/* monotonic time */
 	struct timespec real_start_time;	/* boot based time */
Index: linux/kernel/fork.c
===================================================================
--- linux.orig/kernel/fork.c
+++ linux/kernel/fork.c
@@ -1056,6 +1056,7 @@ static struct task_struct *copy_process(
 	p->gtime = cputime_zero;
 	p->utimescaled = cputime_zero;
 	p->stimescaled = cputime_zero;
+	p->prev_utime = cputime_zero;
 
 #ifdef CONFIG_TASK_XACCT
 	p->rchar = 0;		/* I/O counter: bytes read */
