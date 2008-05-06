Return-Path: <linux-kernel-owner+w=401wt.eu-S933768AbYEFWM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933768AbYEFWM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 18:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933494AbYEFWLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 18:11:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56617 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933227AbYEFWLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 18:11:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 2/2] Freezer: Try to handle killable tasks
Date: Wed, 7 May 2008 00:07:55 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Matt Helsley <matthltc@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Liam Howlett <howlett@gmail.com>, Matthew Wilcox <matthew@wil.cx>
References: <200805070003.56387.rjw@sisk.pl>
In-Reply-To: <200805070003.56387.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805070007.56998.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The introduction of TASK_KILLABLE allows the freezer to work in some situation
that it could not handle before.

Make the freezer handle killable tasks and add try_to_freeze() in some places
where it is safe to freeze a (killable) task.  Introduce the
wait_event_killable_freezable() macro to be used wherever the freezing of
a waiting killable task is desirable.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 fs/nfs/inode.c          |    2 ++
 fs/nfs/nfs3proc.c       |    2 ++
 fs/nfs/nfs4proc.c       |    4 ++++
 fs/nfs/pagelist.c       |    8 ++++++--
 fs/smbfs/request.c      |    2 ++
 include/linux/freezer.h |   20 +++++++++++++++++---
 kernel/mutex.c          |    3 +++
 kernel/power/process.c  |    6 ++++--
 kernel/sched.c          |    2 ++
 net/sunrpc/sched.c      |    2 ++
 10 files changed, 44 insertions(+), 7 deletions(-)

Index: linux-2.6/fs/nfs/nfs3proc.c
===================================================================
--- linux-2.6.orig/fs/nfs/nfs3proc.c
+++ linux-2.6/fs/nfs/nfs3proc.c
@@ -17,6 +17,7 @@
 #include <linux/nfs_page.h>
 #include <linux/lockd/bind.h>
 #include <linux/nfs_mount.h>
+#include <linux/freezer.h>
 
 #include "iostat.h"
 #include "internal.h"
@@ -33,6 +34,7 @@ nfs3_rpc_wrapper(struct rpc_clnt *clnt, 
 		if (res != -EJUKEBOX)
 			break;
 		schedule_timeout_killable(NFS_JUKEBOX_RETRY_TIME);
+		try_to_freeze();
 		res = -ERESTARTSYS;
 	} while (!fatal_signal_pending(current));
 	return res;
Index: linux-2.6/fs/nfs/nfs4proc.c
===================================================================
--- linux-2.6.orig/fs/nfs/nfs4proc.c
+++ linux-2.6/fs/nfs/nfs4proc.c
@@ -48,6 +48,7 @@
 #include <linux/smp_lock.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
+#include <linux/freezer.h>
 
 #include "nfs4_fs.h"
 #include "delegation.h"
@@ -2788,6 +2789,7 @@ static int nfs4_wait_bit_killable(void *
 	if (fatal_signal_pending(current))
 		return -ERESTARTSYS;
 	schedule();
+	try_to_freeze();
 	return 0;
 }
 
@@ -2819,6 +2821,8 @@ static int nfs4_delay(struct rpc_clnt *c
 	schedule_timeout_killable(*timeout);
 	if (fatal_signal_pending(current))
 		res = -ERESTARTSYS;
+	else
+		try_to_freeze();
 	*timeout <<= 1;
 	return res;
 }
Index: linux-2.6/fs/nfs/pagelist.c
===================================================================
--- linux-2.6.orig/fs/nfs/pagelist.c
+++ linux-2.6/fs/nfs/pagelist.c
@@ -18,6 +18,7 @@
 #include <linux/nfs_page.h>
 #include <linux/nfs_fs.h>
 #include <linux/nfs_mount.h>
+#include <linux/freezer.h>
 
 #include "internal.h"
 
@@ -68,6 +69,7 @@ nfs_create_request(struct nfs_open_conte
 
 		if (fatal_signal_pending(current))
 			return ERR_PTR(-ERESTARTSYS);
+		try_to_freeze();
 		yield();
 	}
 
@@ -180,10 +182,12 @@ static int nfs_wait_bit_killable(void *w
 {
 	int ret = 0;
 
-	if (fatal_signal_pending(current))
+	if (fatal_signal_pending(current)) {
 		ret = -ERESTARTSYS;
-	else
+	} else {
 		schedule();
+		try_to_freeze();
+	}
 	return ret;
 }
 
Index: linux-2.6/fs/smbfs/request.c
===================================================================
--- linux-2.6.orig/fs/smbfs/request.c
+++ linux-2.6/fs/smbfs/request.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/net.h>
 #include <linux/sched.h>
+#include <linux/freezer.h>
 
 #include <linux/smb_fs.h>
 #include <linux/smbno.h>
@@ -109,6 +110,7 @@ struct smb_request *smb_alloc_request(st
 			return ERR_PTR(-ERESTARTSYS);
 		current->policy = SCHED_YIELD;
 		schedule();
+		try_to_freeze();
 #else
 		/* FIXME: we want something like nfs does above, but that
 		   requires changes to all callers and can wait. */
Index: linux-2.6/include/linux/freezer.h
===================================================================
--- linux-2.6.orig/include/linux/freezer.h
+++ linux-2.6/include/linux/freezer.h
@@ -137,8 +137,9 @@ static inline void set_freezable_with_si
 }
 
 /*
- * Freezer-friendly wrappers around wait_event_interruptible() and
- * wait_event_interruptible_timeout(), originally defined in <linux/wait.h>
+ * Freezer-friendly wrappers around wait_event_interruptible(),
+ * wait_event_interruptible_timeout(), wait_event_killable(),
+ * originally defined in <linux/wait.h>
  */
 
 #define wait_event_freezable(wq, condition)				\
@@ -155,7 +156,6 @@ static inline void set_freezable_with_si
 	__retval;							\
 })
 
-
 #define wait_event_freezable_timeout(wq, condition, timeout)		\
 ({									\
 	long __retval = timeout;					\
@@ -166,6 +166,20 @@ static inline void set_freezable_with_si
 	} while (try_to_freeze());					\
 	__retval;							\
 })
+
+#define wait_event_killable_freezable(wq, condition)				\
+({									\
+	int __retval;							\
+	do {								\
+		__retval = wait_event_killable(wq, 			\
+				(condition) || freezing(current));	\
+		if (__retval && !freezing(current))			\
+			break;						\
+		else if (!(condition))					\
+			__retval = -ERESTARTSYS;			\
+	} while (try_to_freeze());					\
+	__retval;							\
+})
 #else /* !CONFIG_PM_SLEEP */
 static inline int frozen(struct task_struct *p) { return 0; }
 static inline int freezing(struct task_struct *p) { return 0; }
Index: linux-2.6/kernel/mutex.c
===================================================================
--- linux-2.6.orig/kernel/mutex.c
+++ linux-2.6/kernel/mutex.c
@@ -18,6 +18,7 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/debug_locks.h>
+#include <linux/freezer.h>
 
 /*
  * In the DEBUG case we are using the "NULL fastpath" for mutexes,
@@ -182,6 +183,8 @@ __mutex_lock_common(struct mutex *lock, 
 		/* didnt get the lock, go to sleep: */
 		spin_unlock_mutex(&lock->wait_lock, flags);
 		schedule();
+		if (state == TASK_KILLABLE)
+			try_to_freeze();
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}
 
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4769,6 +4769,8 @@ do_wait_for_common(struct completion *x,
 			__set_current_state(state);
 			spin_unlock_irq(&x->wait.lock);
 			timeout = schedule_timeout(timeout);
+			if (state == TASK_KILLABLE)
+				try_to_freeze();
 			spin_lock_irq(&x->wait.lock);
 			if (!timeout) {
 				__remove_wait_queue(&x->wait, &wait);
Index: linux-2.6/net/sunrpc/sched.c
===================================================================
--- linux-2.6.orig/net/sunrpc/sched.c
+++ linux-2.6/net/sunrpc/sched.c
@@ -19,6 +19,7 @@
 #include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
+#include <linux/freezer.h>
 
 #include <linux/sunrpc/clnt.h>
 
@@ -227,6 +228,7 @@ static int rpc_wait_bit_killable(void *w
 	if (fatal_signal_pending(current))
 		return -ERESTARTSYS;
 	schedule();
+	try_to_freeze();
 	return 0;
 }
 
Index: linux-2.6/fs/nfs/inode.c
===================================================================
--- linux-2.6.orig/fs/nfs/inode.c
+++ linux-2.6/fs/nfs/inode.c
@@ -37,6 +37,7 @@
 #include <linux/vfs.h>
 #include <linux/inet.h>
 #include <linux/nfs_xdr.h>
+#include <linux/freezer.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -426,6 +427,7 @@ static int nfs_wait_schedule(void *word)
 	if (signal_pending(current))
 		return -ERESTARTSYS;
 	schedule();
+	try_to_freeze();
 	return 0;
 }
 
Index: linux-2.6/kernel/power/process.c
===================================================================
--- linux-2.6.orig/kernel/power/process.c
+++ linux-2.6/kernel/power/process.c
@@ -77,7 +77,9 @@ static void fake_signal_wake_up(struct t
 	unsigned long flags;
 
 	spin_lock_irqsave(&p->sighand->siglock, flags);
-	signal_wake_up(p, 0);
+	set_tsk_thread_flag(p, TIF_SIGPENDING);
+	if (!wake_up_state(p, TASK_INTERRUPTIBLE | TASK_KILLABLE))
+		kick_process(p);
 	spin_unlock_irqrestore(&p->sighand->siglock, flags);
 }
 
@@ -124,7 +126,7 @@ static bool freeze_task(struct task_stru
 	} else if (sig_only) {
 		return false;
 	} else {
-		wake_up_state(p, TASK_INTERRUPTIBLE);
+		wake_up_state(p, TASK_INTERRUPTIBLE | TASK_KILLABLE);
 	}
 
 	return true;
