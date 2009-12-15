Return-Path: <linux-kernel-owner+w=401wt.eu-S1759651AbZLOKUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651AbZLOKUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 05:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759643AbZLOKUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 05:20:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158AbZLOKUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 05:20:39 -0500
Date: Tue, 15 Dec 2009 11:19:36 +0100
From: Veaceslav Falico <vfalico@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Miloslav Trmac <mitr@redhat.com>, James Morris <jmorris@namei.org>,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Renaud Lottiaux <renaud.lottiaux@kerlabs.com>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       David Howells <dhowells@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v3 2/4 -mmotm] copy_signal() cleanup: kill
	taskstats_tgid_init() and acct_init_pacct()
Message-ID: <20091215101936.GC9134@darkmag.usersys.redhat.com>
References: <20091201221036.GA10052@darkmag.usersys.redhat.com> <20091202135759.GA791@redhat.com> <20091204142814.GH10052@darkmag.usersys.redhat.com> <20091207123615.fc841a83.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207123615.fc841a83.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill unused functions taskstats_tgid_init() and acct_init_pacct() because we
don't use them anywhere after using kmem_cache_zalloc() in copy_signal().

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
---
diff --git a/include/linux/acct.h b/include/linux/acct.h
index 882dc72..93f4609 100644
--- a/include/linux/acct.h
+++ b/include/linux/acct.h
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
diff --git a/include/linux/taskstats_kern.h b/include/linux/taskstats_kern.h
index 3398f45..b6523c1 100644
--- a/include/linux/taskstats_kern.h
+++ b/include/linux/taskstats_kern.h
@@ -14,11 +14,6 @@
 extern struct kmem_cache *taskstats_cache;
 extern struct mutex taskstats_exit_mutex;
 
-static inline void taskstats_tgid_init(struct signal_struct *sig)
-{
-	sig->stats = NULL;
-}
-
 static inline void taskstats_tgid_free(struct signal_struct *sig)
 {
 	if (sig->stats)
@@ -30,8 +25,6 @@ extern void taskstats_init_early(void);
 #else
 static inline void taskstats_exit(struct task_struct *tsk, int group_dead)
 {}
-static inline void taskstats_tgid_init(struct signal_struct *sig)
-{}
 static inline void taskstats_tgid_free(struct signal_struct *sig)
 {}
 static inline void taskstats_init_early(void)
diff --git a/kernel/acct.c b/kernel/acct.c
index a6605ca..24f8c81 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -588,16 +588,6 @@ out:
 }
 
 /**
- * acct_init_pacct - initialize a new pacct_struct
- * @pacct: per-process accounting info struct to initialize
- */
-void acct_init_pacct(struct pacct_struct *pacct)
-{
-	memset(pacct, 0, sizeof(struct pacct_struct));
-	pacct->ac_utime = pacct->ac_stime = cputime_zero;
-}
-
-/**
  * acct_collect - collect accounting information into pacct_struct
  * @exitcode: task exit code
  * @group_dead: not 0, if this thread is the last one in the process.
