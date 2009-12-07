Return-Path: <linux-kernel-owner+w=401wt.eu-S932844AbZLGTqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844AbZLGTqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 14:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932771AbZLGTp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 14:45:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932278AbZLGTp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 14:45:57 -0500
Date: Mon, 7 Dec 2009 20:45:14 +0100
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
Subject: [PATCH] kill taskstats_tgid_init() and acct_init_pacct() and
	cleanup copy_signal()
Message-ID: <20091207194514.GA20386@darkmag.usersys.redhat.com>
References: <20091201221036.GA10052@darkmag.usersys.redhat.com> <20091202135759.GA791@redhat.com> <20091204142901.GI10052@darkmag.usersys.redhat.com> <20091205163314.GB23152@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091205163314.GB23152@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(on top of previous patchset)

Kill taskstats_tgid_init() and acct_init_pacct() because we don't
need them any more. Cleanup copy_signal() from these functions
and remove the call to task_io_accounting_init() (we can't kill
it because it's still being used by copy_process(), so just removing
it from copy_signal()).

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
---

--- a/include/linux/taskstats_kern.h	2009-12-07 20:20:02.000000000 +0100
+++ b/include/linux/taskstats_kern.h	2009-12-07 20:20:48.000000000 +0100
@@ -14,10 +14,6 @@
 extern struct kmem_cache *taskstats_cache;
 extern struct mutex taskstats_exit_mutex;
 
-static inline void taskstats_tgid_init(struct signal_struct *sig)
-{
-}
-
 static inline void taskstats_tgid_free(struct signal_struct *sig)
 {
 	if (sig->stats)
@@ -29,8 +25,6 @@ extern void taskstats_init_early(void);
 #else
 static inline void taskstats_exit(struct task_struct *tsk, int group_dead)
 {}
-static inline void taskstats_tgid_init(struct signal_struct *sig)
-{}
 static inline void taskstats_tgid_free(struct signal_struct *sig)
 {}
 static inline void taskstats_init_early(void)
--- a/kernel/acct.c	2009-12-07 20:23:43.000000000 +0100
+++ b/kernel/acct.c	2009-12-07 20:24:30.000000000 +0100
@@ -587,14 +587,6 @@ out:
 }
 
 /**
- * acct_init_pacct - initialize a new pacct_struct
- * @pacct: per-process accounting info struct to initialize
- */
-void acct_init_pacct(struct pacct_struct *pacct)
-{
-}
-
-/**
  * acct_collect - collect accounting information into pacct_struct
  * @exitcode: task exit code
  * @group_dead: not 0, if this thread is the last one in the process.
--- a/include/linux/acct.h	2009-12-07 20:26:35.000000000 +0100
+++ b/include/linux/acct.h	2009-12-07 20:26:43.000000000 +0100
@@ -123,14 +123,12 @@ struct pacct_struct;
 struct pid_namespace;
 extern void acct_auto_close_mnt(struct vfsmount *m);
 extern void acct_auto_close(struct super_block *sb);
-extern void acct_init_pacct(struct pacct_struct *pacct);
 extern void acct_collect(long exitcode, int group_dead);
 extern void acct_process(void);
 extern void acct_exit_ns(struct pid_namespace *);
 #else
 #define acct_auto_close_mnt(x)	do { } while (0)
 #define acct_auto_close(x)	do { } while (0)
-#define acct_init_pacct(x)	do { } while (0)
 #define acct_collect(x,y)	do { } while (0)
 #define acct_process()		do { } while (0)
 #define acct_exit_ns(ns)	do { } while (0)
--- a/kernel/fork.c	2009-12-07 20:25:18.000000000 +0100
+++ b/kernel/fork.c	2009-12-07 20:36:49.000000000 +0100
@@ -861,17 +861,12 @@ static int copy_signal(unsigned long clo
 	hrtimer_init(&sig->real_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	sig->real_timer.function = it_real_fn;
 
-	task_io_accounting_init(&sig->ioac);
-	taskstats_tgid_init(sig);
-
 	task_lock(current->group_leader);
 	memcpy(sig->rlim, current->signal->rlim, sizeof sig->rlim);
 	task_unlock(current->group_leader);
 
 	posix_cpu_timers_init_group(sig);
 
-	acct_init_pacct(&sig->pacct);
-
 	tty_audit_fork(sig);
 
 	sig->oom_adj = current->signal->oom_adj;
