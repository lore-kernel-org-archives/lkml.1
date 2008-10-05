Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbYJEQN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbYJEQN7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756403AbYJEQIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:08:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54884 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756054AbYJEQIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:08:15 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 26/76] tty: Add a kref count
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:08:15 +0100
Message-ID: <20081005160811.1997.59217.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a kref to the tty structure and use it to protect the tty->signal
tty references. For now we don't introduce it for anything else.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_io.c |   54 ++++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/tty.h   |   18 ++++++++++++++++
 kernel/fork.c         |    5 ++++-
 kernel/sys.c          |    4 +---
 4 files changed, 71 insertions(+), 10 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 7323168..310e070 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -559,6 +559,7 @@ static void do_tty_hangup(struct work_struct *work)
 	struct tty_ldisc *ld;
 	int    closecount = 0, n;
 	unsigned long flags;
+	int refs = 0;
 
 	if (!tty)
 		return;
@@ -625,8 +626,12 @@ static void do_tty_hangup(struct work_struct *work)
 	if (tty->session) {
 		do_each_pid_task(tty->session, PIDTYPE_SID, p) {
 			spin_lock_irq(&p->sighand->siglock);
-			if (p->signal->tty == tty)
+			if (p->signal->tty == tty) {
 				p->signal->tty = NULL;
+				/* We defer the dereferences outside fo
+				   the tasklist lock */
+				refs++;
+			}
 			if (!p->signal->leader) {
 				spin_unlock_irq(&p->sighand->siglock);
 				continue;
@@ -652,6 +657,10 @@ static void do_tty_hangup(struct work_struct *work)
 	tty->ctrl_status = 0;
 	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 
+	/* Account for the p->signal references we killed */
+	while (refs--)
+		tty_kref_put(tty);
+
 	/*
 	 * If one of the devices matches a console pointer, we
 	 * cannot just call hangup() because that will cause
@@ -1424,6 +1433,7 @@ release_mem_out:
 
 /**
  *	release_one_tty		-	release tty structure memory
+ *	@kref: kref of tty we are obliterating
  *
  *	Releases memory associated with a tty structure, and clears out the
  *	driver table slots. This function is called when a device is no longer
@@ -1433,17 +1443,19 @@ release_mem_out:
  *		tty_mutex - sometimes only
  *		takes the file list lock internally when working on the list
  *	of ttys that the driver keeps.
- *		FIXME: should we require tty_mutex is held here ??
  */
-static void release_one_tty(struct tty_struct *tty, int idx)
+static void release_one_tty(struct kref *kref)
 {
+	struct tty_struct *tty = container_of(kref, struct tty_struct, kref);
 	int devpts = tty->driver->flags & TTY_DRIVER_DEVPTS_MEM;
 	struct ktermios *tp;
+	int idx = tty->index;
 
 	if (!devpts)
 		tty->driver->ttys[idx] = NULL;
 
 	if (tty->driver->flags & TTY_DRIVER_RESET_TERMIOS) {
+		/* FIXME: Locking on ->termios array */
 		tp = tty->termios;
 		if (!devpts)
 			tty->driver->termios[idx] = NULL;
@@ -1457,6 +1469,7 @@ static void release_one_tty(struct tty_struct *tty, int idx)
 
 
 	tty->magic = 0;
+	/* FIXME: locking on tty->driver->refcount */
 	tty->driver->refcount--;
 
 	file_list_lock();
@@ -1467,6 +1480,21 @@ static void release_one_tty(struct tty_struct *tty, int idx)
 }
 
 /**
+ *	tty_kref_put		-	release a tty kref
+ *	@tty: tty device
+ *
+ *	Release a reference to a tty device and if need be let the kref
+ *	layer destruct the object for us
+ */
+
+void tty_kref_put(struct tty_struct *tty)
+{
+	if (tty)
+		kref_put(&tty->kref, release_one_tty);
+}
+EXPORT_SYMBOL(tty_kref_put);
+
+/**
  *	release_tty		-	release tty structure memory
  *
  *	Release both @tty and a possible linked partner (think pty pair),
@@ -1477,14 +1505,20 @@ static void release_one_tty(struct tty_struct *tty, int idx)
  *		takes the file list lock internally when working on the list
  *	of ttys that the driver keeps.
  *		FIXME: should we require tty_mutex is held here ??
+ *
+ *	FIXME: We want to defer the module put of the driver to the
+ *	destructor.
  */
 static void release_tty(struct tty_struct *tty, int idx)
 {
 	struct tty_driver *driver = tty->driver;
 
+	/* This should always be true but check for the moment */
+	WARN_ON(tty->index != idx);
+
 	if (tty->link)
-		release_one_tty(tty->link, idx);
-	release_one_tty(tty, idx);
+		tty_kref_put(tty->link);
+	tty_kref_put(tty);
 	module_put(driver->owner);
 }
 
@@ -2798,6 +2832,7 @@ EXPORT_SYMBOL(do_SAK);
 static void initialize_tty_struct(struct tty_struct *tty)
 {
 	memset(tty, 0, sizeof(struct tty_struct));
+	kref_init(&tty->kref);
 	tty->magic = TTY_MAGIC;
 	tty_ldisc_init(tty);
 	tty->session = NULL;
@@ -3053,9 +3088,12 @@ EXPORT_SYMBOL(tty_devnum);
 
 void proc_clear_tty(struct task_struct *p)
 {
+	struct tty_struct *tty;
 	spin_lock_irq(&p->sighand->siglock);
+	tty = p->signal->tty;
 	p->signal->tty = NULL;
 	spin_unlock_irq(&p->sighand->siglock);
+	tty_kref_put(tty);
 }
 
 /* Called under the sighand lock */
@@ -3071,9 +3109,13 @@ static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
 		tty->pgrp = get_pid(task_pgrp(tsk));
 		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		tty->session = get_pid(task_session(tsk));
+		if (tsk->signal->tty) {
+			printk(KERN_DEBUG "tty not NULL!!\n");
+			tty_kref_put(tsk->signal->tty);
+		}
 	}
 	put_pid(tsk->signal->tty_old_pgrp);
-	tsk->signal->tty = tty;
+	tsk->signal->tty = tty_kref_get(tty);
 	tsk->signal->tty_old_pgrp = NULL;
 }
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index e3612c3..b6e6c26 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -209,6 +209,7 @@ struct tty_operations;
 
 struct tty_struct {
 	int	magic;
+	struct kref kref;
 	struct tty_driver *driver;
 	const struct tty_operations *ops;
 	int index;
@@ -311,6 +312,23 @@ extern int kmsg_redirect;
 extern void console_init(void);
 extern int vcs_init(void);
 
+/**
+ *	tty_kref_get		-	get a tty reference
+ *	@tty: tty device
+ *
+ *	Return a new reference to a tty object. The caller must hold
+ *	sufficient locks/counts to ensure that their existing reference cannot
+ *	go away
+ */
+
+extern inline struct tty_struct *tty_kref_get(struct tty_struct *tty)
+{
+	if (tty)
+		kref_get(&tty->kref);
+	return tty;
+}
+extern void tty_kref_put(struct tty_struct *tty);
+
 extern int tty_paranoia_check(struct tty_struct *tty, struct inode *inode,
 			      const char *routine);
 extern char *tty_name(struct tty_struct *tty, char *buf);
diff --git a/kernel/fork.c b/kernel/fork.c
index 7ce2ebe..30de644 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -802,6 +802,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 
 	sig->leader = 0;	/* session leadership doesn't inherit */
 	sig->tty_old_pgrp = NULL;
+	sig->tty = NULL;
 
 	sig->utime = sig->stime = sig->cutime = sig->cstime = cputime_zero;
 	sig->gtime = cputime_zero;
@@ -838,6 +839,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 void __cleanup_signal(struct signal_struct *sig)
 {
 	exit_thread_group_keys(sig);
+	tty_kref_put(sig->tty);
 	kmem_cache_free(signal_cachep, sig);
 }
 
@@ -1227,7 +1229,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 				p->nsproxy->pid_ns->child_reaper = p;
 
 			p->signal->leader_pid = pid;
-			p->signal->tty = current->signal->tty;
+			tty_kref_put(p->signal->tty);
+			p->signal->tty = tty_kref_get(current->signal->tty);
 			set_task_pgrp(p, task_pgrp_nr(current));
 			set_task_session(p, task_session_nr(current));
 			attach_pid(p, PIDTYPE_PGID, task_pgrp(current));
diff --git a/kernel/sys.c b/kernel/sys.c
index 038a7bc..234d945 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1060,9 +1060,7 @@ asmlinkage long sys_setsid(void)
 	group_leader->signal->leader = 1;
 	__set_special_pids(sid);
 
-	spin_lock(&group_leader->sighand->siglock);
-	group_leader->signal->tty = NULL;
-	spin_unlock(&group_leader->sighand->siglock);
+	proc_clear_tty(group_leader);
 
 	err = session;
 out:

