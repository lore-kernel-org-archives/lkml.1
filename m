Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbZLDO3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbZLDO3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 09:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756529AbZLDO3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 09:29:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756421AbZLDO3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 09:29:18 -0500
Date: Fri, 4 Dec 2009 15:28:14 +0100
From: Veaceslav Falico <vfalico@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Al Viro <viro@zeniv.linux.org.uk>, Miloslav Trmac <mitr@redhat.com>,
       James Morris <jmorris@namei.org>, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Renaud Lottiaux <renaud.lottiaux@kerlabs.com>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       David Howells <dhowells@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 1/4] copy_signal cleanup: use zalloc and remove
	initializations
Message-ID: <20091204142814.GH10052@darkmag.usersys.redhat.com>
References: <20091201221036.GA10052@darkmag.usersys.redhat.com> <20091202135759.GA791@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202135759.GA791@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kmem_cache_zalloc() on signal creation and remove unneeded initialization
lines in copy_signal().

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
---

diff --git a/kernel/fork.c b/kernel/fork.c
index 166b8c4..160477d 100644
@@ -855,7 +844,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	if (clone_flags & CLONE_THREAD)
 		return 0;
 
-	sig = kmem_cache_alloc(signal_cachep, GFP_KERNEL);
+	sig = kmem_cache_zalloc(signal_cachep, GFP_KERNEL);
 	tsk->signal = sig;
 	if (!sig)
 		return -ENOMEM;
@@ -863,33 +852,16 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	atomic_set(&sig->count, 1);
 	atomic_set(&sig->live, 1);
 	init_waitqueue_head(&sig->wait_chldexit);
-	sig->flags = 0;
 	if (clone_flags & CLONE_NEWPID)
 		sig->flags |= SIGNAL_UNKILLABLE;
-	sig->group_exit_code = 0;
-	sig->group_exit_task = NULL;
-	sig->group_stop_count = 0;
 	sig->curr_target = tsk;
 	init_sigpending(&sig->shared_pending);
 	INIT_LIST_HEAD(&sig->posix_timers);
 
 	hrtimer_init(&sig->real_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	sig->it_real_incr.tv64 = 0;
 	sig->real_timer.function = it_real_fn;
 
-	sig->leader = 0;	/* session leadership doesn't inherit */
-	sig->tty_old_pgrp = NULL;
-	sig->tty = NULL;
-
-	sig->utime = sig->stime = sig->cutime = sig->cstime = cputime_zero;
-	sig->gtime = cputime_zero;
-	sig->cgtime = cputime_zero;
-	sig->nvcsw = sig->nivcsw = sig->cnvcsw = sig->cnivcsw = 0;
-	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
-	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
-	sig->maxrss = sig->cmaxrss = 0;
 	task_io_accounting_init(&sig->ioac);
-	sig->sum_sched_runtime = 0;
 	taskstats_tgid_init(sig);
 
 	task_lock(current->group_leader);
