Return-Path: <linux-kernel-owner+w=401wt.eu-S1760045AbXFFKMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045AbXFFKMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 06:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758645AbXFFKL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 06:11:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757152AbXFFKLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 06:11:55 -0400
Message-ID: <46668814.7080404@redhat.com>
Date: Wed, 06 Jun 2007 12:10:28 +0200
From: Miloslav Trmac <mitr@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: dwmw2@infradead.org
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>,
       Steve Grubb <sgrubb@redhat.com>, Alexander Viro <aviro@redhat.com>
Subject: Re: [PATCH] Audit: Add TTY input auditing
References: <4666832D.8080603@redhat.com>
In-Reply-To: <4666832D.8080603@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------030401000907030900090804"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030401000907030900090804
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

I'm sorry, I forgot the patch...

--------------030401000907030900090804
Content-Type: text/x-patch;
 name="linux.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux.patch"

From: Miloslav Trmac <mitr@redhat.com>

Add TTY input auditing, used to audit system administrator's actions.
TTY input auditing works on a higher level than auditing all system
calls within the session, which would produce an overwhelming amount of
mostly useless audit events.

Add an "audit_tty" attribute, inherited across fork ().  Data read from
TTYs by process with the attribute is sent to the audit subsystem by the
kernel.  The audit netlink interface is extended to allow modifying the
audit_tty attribute, and to allow sending explanatory audit events from
user-space (for example, a shell might send an event containing the
final command, after the interactive command-line editing and history
expansion is performed, which might be difficult to decipher from the
TTY input alone).

Because the "audit_tty" attribute is inherited across fork (), it would
be set e.g. for sshd restarted within an audited session.  To prevent
this, the audit_tty attribute is cleared when a process with no open TTY
file descriptors (e.g. after daemon startup) opens a TTY.

See https://www.redhat.com/archives/linux-audit/2007-June/msg00000.html
for a more detailed rationale document for an older version of this patch.

Signed-off-by: Miloslav Trmac <mitr@redhat.com>
---
 drivers/char/n_tty.c        |  359 +++++++++++++++++++++++++++++++++-
 drivers/char/tty_io.c       |   11 -
 include/linux/audit.h       |   11 +
 include/linux/sched.h       |    2 
 include/linux/tty.h         |   15 +
 kernel/audit.c              |   97 ++++++++-
 kernel/audit.h              |    1 
 kernel/auditsc.c            |    3 
 kernel/exit.c               |    2 
 kernel/fork.c               |    5 
 security/selinux/nlmsgtab.c |    2 
 11 files changed, 488 insertions(+), 20 deletions(-)

diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index 154f422..be92b2d 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -45,6 +45,8 @@
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/bitops.h>
+#include <linux/audit.h>
+#include <linux/file.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -78,6 +80,352 @@ static inline void free_buf(unsigned char *buf)
 		free_page((unsigned long) buf);
 }
 
+#ifdef CONFIG_AUDIT
+struct tty_audit_buf {
+	atomic_t count;
+	struct mutex mutex;	/* Protects all data below */
+	int major, minor;	/* The TTY which the data is from */
+	unsigned icanon:1;
+	size_t valid;
+	unsigned char *data;	/* Allocated size N_TTY_BUF_SIZE */
+};
+
+static struct tty_audit_buf *
+tty_audit_buf_alloc(int major, int minor, int icanon)
+{
+	struct tty_audit_buf *buf;
+
+	buf = kmalloc(sizeof (*buf), GFP_KERNEL);
+	if (!buf)
+		goto err;
+	buf->data = alloc_buf();
+	if (!buf->data)
+		goto err_buf;
+	atomic_set(&buf->count, 1);
+	mutex_init(&buf->mutex);
+	buf->major = major;
+	buf->minor = minor;
+	buf->icanon = icanon;
+	buf->valid = 0;
+	return buf;
+
+err_buf:
+	kfree(buf);
+err:
+	return NULL;
+}
+
+static void
+tty_audit_buf_free(struct tty_audit_buf *buf)
+{
+	WARN_ON(buf->valid != 0);
+	free_buf(buf->data);
+	kfree(buf);
+}
+
+static void
+tty_audit_buf_put(struct tty_audit_buf *buf)
+{
+	if (atomic_dec_and_test(&buf->count))
+		tty_audit_buf_free(buf);
+}
+
+/**
+ *	tty_audit_buf_push	-	Push buffered data out
+ *
+ *	Generate an audit message from the contents of @buf, which is owned by
+ *	@tsk with @loginuid.  @buf->mutex must be locked.
+ */
+static void
+tty_audit_buf_push(struct task_struct *tsk, uid_t loginuid,
+		   struct tty_audit_buf *buf)
+{
+	struct audit_buffer *ab;
+
+	if (buf->valid == 0)
+		return;
+	if (audit_enabled == 0)
+		return;
+	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_TTY);
+	if (ab) {
+		char name[sizeof(tsk->comm)];
+
+		audit_log_format(ab, "tty pid=%u uid=%u auid=%u major=%d "
+				 "minor=%d comm=", tsk->pid, tsk->uid,
+				 loginuid, buf->major, buf->minor);
+		get_task_comm(name, tsk);
+		audit_log_untrustedstring(ab, name);
+		audit_log_format(ab, " data=");
+		audit_log_n_untrustedstring(ab, buf->valid, buf->data);
+		audit_log_end(ab);
+	}
+	buf->valid = 0;
+}
+
+/**
+ *	tty_audit_buf_push_current	-	Push buffered data out
+ *
+ *	Generate an audit message from the contents of @buf, which is owned by
+ *	the current task.  @buf->mutex must be locked.
+ */
+static void
+tty_audit_buf_push_current(struct tty_audit_buf *buf)
+{
+	tty_audit_buf_push(current, audit_get_loginuid(current->audit_context),
+			   buf);
+}
+
+/**
+ *	tty_audit_exit	-	Handle a task exit
+ *
+ *	Make sure all buffered data is written out and deallocate the buffer.
+ *	Only needs to be called if current->signal->tty_audit_buf != %NULL.
+ */
+void
+tty_audit_exit(void)
+{
+	struct tty_audit_buf *buf;
+
+	spin_lock(&current->sighand->siglock);
+	buf = current->signal->tty_audit_buf;
+	current->signal->tty_audit_buf = NULL;
+	spin_unlock(&current->sighand->siglock);
+	if (!buf)
+		return;
+
+	mutex_lock(&buf->mutex);
+	tty_audit_buf_push_current(buf);
+	mutex_unlock(&buf->mutex);
+
+	tty_audit_buf_put(buf);
+}
+
+/**
+ *	tty_audit_push_task	-	Flush task's pending audit data
+ */
+void
+tty_audit_push_task(struct task_struct *tsk, uid_t loginuid)
+{
+	struct tty_audit_buf *buf;
+
+	spin_lock(&tsk->sighand->siglock);
+	buf = tsk->signal->tty_audit_buf;
+	if (buf)
+		atomic_inc(&buf->count);
+	spin_unlock(&tsk->sighand->siglock);
+	if (!buf)
+		return;
+
+	mutex_lock(&buf->mutex);
+	tty_audit_buf_push(tsk, loginuid, buf);
+	mutex_unlock(&buf->mutex);
+
+	tty_audit_buf_put(buf);
+}
+
+/**
+ *	tty_audit_buf_get	-	Get an audit buffer.
+ *
+ *	Get an audit buffer for @tty, allocate it if necessary.  Return %NULL
+ *	if TTY auditing is disabled or out of memory.  Otherwise, return a new
+ *	reference to the buffer.
+ */
+static struct tty_audit_buf *
+tty_audit_buf_get(struct tty_struct *tty)
+{
+	struct tty_audit_buf *buf, *buf2;
+
+	buf = NULL;
+	buf2 = NULL;
+	spin_lock(&current->sighand->siglock);
+	if (likely(!current->signal->audit_tty))
+		goto out;
+	buf = current->signal->tty_audit_buf;
+	if (buf) {
+		atomic_inc(&buf->count);
+		goto out;
+	}
+	spin_unlock(&current->sighand->siglock);
+
+	buf2 = tty_audit_buf_alloc(tty->driver->major,
+				   tty->driver->minor_start + tty->index,
+				   tty->icanon);
+	if (buf2 == NULL) {
+		audit_log_lost("out of memory in TTY auditing");
+		return NULL;
+	}
+
+	spin_lock(&current->sighand->siglock);
+	if (!current->signal->audit_tty)
+		goto out;
+	buf = current->signal->tty_audit_buf;
+	if (!buf) {
+		current->signal->tty_audit_buf = buf2;
+		buf = buf2;
+		buf2 = NULL;
+	}
+	atomic_inc(&buf->count);
+	/* Fall through */
+ out:
+	spin_unlock(&current->sighand->siglock);
+	if (buf2)
+		tty_audit_buf_free(buf2);
+	return buf;
+}
+
+/**
+ *	tty_audit_add_data	-	Add data for TTY auditing.
+ *
+ *	Audit @data of @size from @tty, if necessary.
+ */
+static void
+tty_audit_add_data(struct tty_struct *tty, unsigned char *data, size_t size)
+{
+	struct tty_audit_buf *buf;
+	int major, minor;
+
+	if (unlikely(size == 0))
+		return;
+
+	buf = tty_audit_buf_get(tty);
+	if (!buf)
+		return;
+
+	mutex_lock(&buf->mutex);
+	major = tty->driver->major;
+	minor = tty->driver->minor_start + tty->index;
+	if (buf->major != major || buf->minor != minor
+	    || buf->icanon != tty->icanon) {
+		tty_audit_buf_push_current(buf);
+		buf->major = major;
+		buf->minor = minor;
+		buf->icanon = tty->icanon;
+	}
+	do {
+	  size_t run;
+
+	  run = N_TTY_BUF_SIZE - buf->valid;
+	  if (run > size)
+	    run = size;
+	  memcpy(buf->data + buf->valid, data, run);
+	  buf->valid += run;
+	  data += run;
+	  size -= run;
+	  if (buf->valid == N_TTY_BUF_SIZE)
+		  tty_audit_buf_push_current(buf);
+	} while (size != 0);
+	mutex_unlock(&buf->mutex);
+	tty_audit_buf_put(buf);
+}
+
+/**
+ *	tty_audit_push	-	Push buffered data out
+ *
+ *	Make sure no audit data is pending for @tty on the current process.
+ */
+static void
+tty_audit_push(struct tty_struct *tty)
+{
+	struct tty_audit_buf *buf;
+
+	spin_lock(&current->sighand->siglock);
+	if (likely(!current->signal->audit_tty)) {
+		spin_unlock(&current->sighand->siglock);
+		return;
+	}
+	buf = current->signal->tty_audit_buf;
+	if (buf)
+		atomic_inc(&buf->count);
+	spin_unlock(&current->sighand->siglock);
+
+	if (buf) {
+		int major, minor;
+
+		major = tty->driver->major;
+		minor = tty->driver->minor_start + tty->index;
+		mutex_lock(&buf->mutex);
+		if (buf->major == major && buf->minor == minor)
+			tty_audit_buf_push_current(buf);
+		mutex_unlock(&buf->mutex);
+		tty_audit_buf_put(buf);
+	}
+}
+
+/* For checking whether a file is a TTY */
+extern ssize_t tty_read(struct file * file, char __user * buf, size_t count,
+			loff_t *ppos);
+
+/**
+ *	tty_audit_opening	-	A TTY is being opened.
+ *
+ *	As a special hack, tasks that close all their TTYs and open new ones
+ *	are assumed to be system daemons (e.g. getty) and auditing is
+ *	automatically disabled for them.
+ */
+void
+tty_audit_opening(void)
+{
+	int disable;
+
+	disable = 1;
+	spin_lock(&current->sighand->siglock);
+	if (current->signal->audit_tty == 0)
+		disable = 0;
+	spin_unlock(&current->sighand->siglock);
+	if (!disable)
+		return;
+
+	task_lock(current);
+	if (current->files) {
+		struct fdtable *fdt;
+		unsigned i;
+
+		/*
+		 * We don't take a ref to the file, so we must hold ->file_lock
+		 * instead.
+		 */
+		spin_lock(&current->files->file_lock);
+		fdt = files_fdtable(current->files);
+		for (i = 0; i < fdt->max_fds; i++) {
+			struct file *filp;
+
+			filp = fcheck_files(current->files, i);
+			if (!filp)
+				continue;
+			if (filp->f_op->read == tty_read) {
+				disable = 0;
+				break;
+			}
+		}
+		spin_unlock(&current->files->file_lock);
+	}
+	task_unlock(current);
+	if (!disable)
+		return;
+
+	spin_lock(&current->sighand->siglock);
+	current->signal->audit_tty = 0;
+	spin_unlock(&current->sighand->siglock);
+}
+#else
+inline static void
+tty_audit_add_data(struct tty_struct *tty, unsigned char *data, size_t size)
+{
+}
+
+static void
+tty_audit_push(struct tty_struct *tty)
+{
+}
+#endif
+
+static inline int tty_put_user(struct tty_struct *tty, unsigned char x,
+			       unsigned char __user *ptr)
+{
+	tty_audit_add_data(tty, &x, 1);
+	return put_user(x, ptr);
+}
+
 /**
  *	n_tty_set__room	-	receive space
  *	@tty: terminal
@@ -1153,6 +1501,7 @@ static int copy_from_read_buf(struct tty_struct *tty,
 	if (n) {
 		retval = copy_to_user(*b, &tty->read_buf[tty->read_tail], n);
 		n -= retval;
+		tty_audit_add_data(tty, &tty->read_buf[tty->read_tail], n);
 		spin_lock_irqsave(&tty->read_lock, flags);
 		tty->read_tail = (tty->read_tail + n) & (N_TTY_BUF_SIZE-1);
 		tty->read_cnt -= n;
@@ -1279,7 +1628,7 @@ do_it_again:
 				break;
 			cs = tty->link->ctrl_status;
 			tty->link->ctrl_status = 0;
-			if (put_user(cs, b++)) {
+			if (tty_put_user(tty, cs, b++)) {
 				retval = -EFAULT;
 				b--;
 				break;
@@ -1321,7 +1670,7 @@ do_it_again:
 
 		/* Deal with packet mode. */
 		if (tty->packet && b == buf) {
-			if (put_user(TIOCPKT_DATA, b++)) {
+			if (tty_put_user(tty, TIOCPKT_DATA, b++)) {
 				retval = -EFAULT;
 				b--;
 				break;
@@ -1352,15 +1701,17 @@ do_it_again:
 				spin_unlock_irqrestore(&tty->read_lock, flags);
 
 				if (!eol || (c != __DISABLED_CHAR)) {
-					if (put_user(c, b++)) {
+					if (tty_put_user(tty, c, b++)) {
 						retval = -EFAULT;
 						b--;
 						break;
 					}
 					nr--;
 				}
-				if (eol)
+				if (eol) {
+					tty_audit_push(tty);
 					break;
+				}
 			}
 			if (retval)
 				break;
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 3752edc..9ed2f23 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -143,7 +143,7 @@ static int ptmx_open(struct inode *, struct file *);
 
 static void initialize_tty_struct(struct tty_struct *tty);
 
-static ssize_t tty_read(struct file *, char __user *, size_t, loff_t *);
+ssize_t tty_read(struct file *, char __user *, size_t, loff_t *);
 static ssize_t tty_write(struct file *, const char __user *, size_t, loff_t *);
 ssize_t redirected_tty_write(struct file *, const char __user *, size_t, loff_t *);
 static unsigned int tty_poll(struct file *, poll_table *);
@@ -1690,8 +1690,8 @@ EXPORT_SYMBOL(start_tty);
  *	in new code. Multiple read calls may be outstanding in parallel.
  */
 
-static ssize_t tty_read(struct file * file, char __user * buf, size_t count, 
-			loff_t *ppos)
+ssize_t tty_read(struct file * file, char __user * buf, size_t count,
+		 loff_t *ppos)
 {
 	int i;
 	struct tty_struct * tty;
@@ -2654,6 +2654,7 @@ got_driver:
 		__proc_set_tty(current, tty);
 	spin_unlock_irq(&current->sighand->siglock);
 	mutex_unlock(&tty_mutex);
+	tty_audit_opening();
 	return 0;
 }
 
@@ -2716,8 +2717,10 @@ static int ptmx_open(struct inode * inode, struct file * filp)
 
 	check_tty_count(tty, "tty_open");
 	retval = ptm_driver->open(tty, filp);
-	if (!retval)
+	if (!retval) {
+		tty_audit_opening();
 		return 0;
+	}
 out1:
 	release_dev(filp);
 	return retval;
diff --git a/include/linux/audit.h b/include/linux/audit.h
index fccc6e5..dbf2125 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -63,9 +63,12 @@
 #define AUDIT_ADD_RULE		1011	/* Add syscall filtering rule */
 #define AUDIT_DEL_RULE		1012	/* Delete syscall filtering rule */
 #define AUDIT_LIST_RULES	1013	/* List syscall filtering rules */
+#define AUDIT_TTY_GET		1014	/* Get TTY auditing status */
+#define AUDIT_TTY_SET		1015	/* Set TTY auditing status */
 
 #define AUDIT_FIRST_USER_MSG	1100	/* Userspace messages mostly uninteresting to kernel */
 #define AUDIT_USER_AVC		1107	/* We filter this differently */
+#define AUDIT_USER_TTY		1124	/* Non-ICANON TTY input meaning */
 #define AUDIT_LAST_USER_MSG	1199
 #define AUDIT_FIRST_USER_MSG2	2100	/* More user space messages */
 #define AUDIT_LAST_USER_MSG2	2999
@@ -92,6 +95,7 @@
 #define AUDIT_KERNEL_OTHER	1316	/* For use by 3rd party modules */
 #define AUDIT_FD_PAIR		1317    /* audit record for pipe/socketpair */
 #define AUDIT_OBJ_PID		1318	/* ptrace target */
+#define AUDIT_TTY		1319	/* Input on an administrative TTY */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
@@ -289,6 +293,10 @@ struct audit_status {
 	__u32		backlog;	/* messages waiting in queue */
 };
 
+struct audit_tty_status {
+	__u32		enabled; /* 1 = enabled, 0 = disabled */
+};
+
 /* audit_rule_data supports filter rules with both integer and string
  * fields.  It corresponds with AUDIT_ADD_RULE, AUDIT_DEL_RULE and
  * AUDIT_LIST_RULES requests.
@@ -455,6 +463,7 @@ static inline int audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat)
 		return __audit_mq_getsetattr(mqdes, mqstat);
 	return 0;
 }
+extern int audit_enabled;
 extern int audit_n_rules;
 extern int audit_signals;
 #else
@@ -487,6 +496,7 @@ extern int audit_signals;
 #define audit_mq_notify(d,n) ({ 0; })
 #define audit_mq_getsetattr(d,s) ({ 0; })
 #define audit_ptrace(t) ((void)0)
+#define audit_enabled 0
 #define audit_n_rules 0
 #define audit_signals 0
 #endif
@@ -515,6 +525,7 @@ extern void		    audit_log_d_path(struct audit_buffer *ab,
 					     const char *prefix,
 					     struct dentry *dentry,
 					     struct vfsmount *vfsmnt);
+extern void		    audit_log_lost(const char *message);
 				/* Private API (for audit.c only) */
 extern int audit_filter_user(struct netlink_skb_parms *cb, int type);
 extern int audit_filter_type(int type);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d58e74b..3ae4904 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -506,6 +506,8 @@ struct signal_struct {
 #ifdef CONFIG_TASKSTATS
 	struct taskstats *stats;
 #endif
+	unsigned audit_tty:1;
+	struct tty_audit_buf *tty_audit_buf;
 };
 
 /* Context switch must be unlocked if interrupts are to be enabled */
diff --git a/include/linux/tty.h b/include/linux/tty.h
index bb45760..d33f8dd 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -340,6 +340,21 @@ extern struct mutex tty_mutex;
 
 /* n_tty.c */
 extern struct tty_ldisc tty_ldisc_N_TTY;
+#ifdef CONFIG_AUDIT
+extern void tty_audit_exit(void);
+extern void tty_audit_push_task(struct task_struct *tsk, uid_t loginuid);
+extern void tty_audit_opening(void);
+#else
+static inline void tty_audit_exit(void)
+{
+}
+static inline void tty_audit_push_task(struct task_struct *tsk, uid_t loginuid)
+{
+}
+static inline void tty_audit_opening(void)
+{
+}
+#endif
 
 /* tty_ioctl.c */
 extern int n_tty_ioctl(struct tty_struct * tty, struct file * file,
diff --git a/kernel/audit.c b/kernel/audit.c
index d13276d..a071a96 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -58,6 +58,7 @@
 #include <linux/selinux.h>
 #include <linux/inotify.h>
 #include <linux/freezer.h>
+#include <linux/tty.h>
 
 #include "audit.h"
 
@@ -423,6 +424,32 @@ static int kauditd_thread(void *dummy)
 	return 0;
 }
 
+static int
+audit_prepare_user_tty(pid_t pid, uid_t loginuid)
+{
+	struct task_struct *tsk;
+	int err;
+
+	read_lock(&tasklist_lock);
+	tsk = find_task_by_pid(pid);
+	err = -ESRCH;
+	if (!tsk)
+		goto out;
+	err = 0;
+
+	spin_lock(&tsk->sighand->siglock);
+	if (!tsk->signal->audit_tty)
+		err = -EPERM;
+	spin_unlock(&tsk->sighand->siglock);
+	if (err)
+		goto out;
+
+	tty_audit_push_task(tsk, loginuid);
+out:
+	read_unlock(&tasklist_lock);
+	return err;
+}
+
 int audit_send_list(void *_dest)
 {
 	struct audit_netlink_list *dest = _dest;
@@ -511,6 +538,8 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 	case AUDIT_DEL:
 	case AUDIT_DEL_RULE:
 	case AUDIT_SIGNAL_INFO:
+	case AUDIT_TTY_GET:
+	case AUDIT_TTY_SET:
 		if (security_netlink_recv(skb, CAP_AUDIT_CONTROL))
 			err = -EPERM;
 		break;
@@ -622,6 +651,11 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		err = audit_filter_user(&NETLINK_CB(skb), msg_type);
 		if (err == 1) {
 			err = 0;
+			if (msg_type == AUDIT_USER_TTY) {
+				err = audit_prepare_user_tty(pid, loginuid);
+				if (err)
+					break;
+			}
 			ab = audit_log_start(NULL, GFP_KERNEL, msg_type);
 			if (ab) {
 				audit_log_format(ab,
@@ -638,8 +672,17 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 							" subj=%s", ctx);
 					kfree(ctx);
 				}
-				audit_log_format(ab, " msg='%.1024s'",
-					 (char *)data);
+				if (msg_type != AUDIT_USER_TTY)
+					audit_log_format(ab, " msg='%.1024s'",
+							 (char *)data);
+				else {
+					int size;
+
+					audit_log_format(ab, " msg=");
+					size = nlmsg_len(nlh);
+					audit_log_n_untrustedstring(ab, size,
+								    data);
+				}
 				audit_set_pid(ab, pid);
 				audit_log_end(ab);
 			}
@@ -730,6 +773,45 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				0, 0, sig_data, sizeof(*sig_data) + len);
 		kfree(sig_data);
 		break;
+	case AUDIT_TTY_GET: {
+		struct audit_tty_status s;
+		struct task_struct *tsk;
+
+		read_lock(&tasklist_lock);
+		tsk = find_task_by_pid(pid);
+		if (!tsk)
+			err = -ESRCH;
+		else {
+			spin_lock(&tsk->sighand->siglock);
+			s.enabled = tsk->signal->audit_tty != 0;
+			spin_unlock(&tsk->sighand->siglock);
+		}
+		read_unlock(&tasklist_lock);
+		audit_send_reply(NETLINK_CB(skb).pid, seq, AUDIT_TTY_GET, 0, 0,
+				 &s, sizeof(s));
+		break;
+	}
+	case AUDIT_TTY_SET: {
+		struct audit_tty_status *s;
+		struct task_struct *tsk;
+
+		if (nlh->nlmsg_len < sizeof(struct audit_tty_status))
+			return -EINVAL;
+		s = data;
+		if (s->enabled != 0 && s->enabled != 1)
+			return -EINVAL;
+		read_lock(&tasklist_lock);
+		tsk = find_task_by_pid(pid);
+		if (!tsk)
+			err = -ESRCH;
+		else {
+			spin_lock(&tsk->sighand->siglock);
+			tsk->signal->audit_tty = s->enabled != 0;
+			spin_unlock(&tsk->sighand->siglock);
+		}
+		read_unlock(&tasklist_lock);
+		break;
+	}
 	default:
 		err = -EINVAL;
 		break;
@@ -1185,7 +1267,7 @@ static void audit_log_n_string(struct audit_buffer *ab, size_t slen,
 }
 
 /**
- * audit_log_n_unstrustedstring - log a string that may contain random characters
+ * audit_log_n_untrustedstring - log a string that may contain random characters
  * @ab: audit_buffer
  * @len: lenth of string (not including trailing null)
  * @string: string to be logged
@@ -1201,25 +1283,24 @@ static void audit_log_n_string(struct audit_buffer *ab, size_t slen,
 const char *audit_log_n_untrustedstring(struct audit_buffer *ab, size_t len,
 					const char *string)
 {
-	const unsigned char *p = string;
+	const unsigned char *p;
 
-	while (*p) {
+	for (p = string; p < (const unsigned char *)string + len && *p; p++) {
 		if (*p == '"' || *p < 0x21 || *p > 0x7f) {
 			audit_log_hex(ab, string, len);
 			return string + len + 1;
 		}
-		p++;
 	}
 	audit_log_n_string(ab, len, string);
 	return p + 1;
 }
 
 /**
- * audit_log_unstrustedstring - log a string that may contain random characters
+ * audit_log_untrustedstring - log a string that may contain random characters
  * @ab: audit_buffer
  * @string: string to be logged
  *
- * Same as audit_log_n_unstrustedstring(), except that strlen is used to
+ * Same as audit_log_n_untrustedstring(), except that strlen is used to
  * determine string length.
  */
 const char *audit_log_untrustedstring(struct audit_buffer *ab, const char *string)
diff --git a/kernel/audit.h b/kernel/audit.h
index 815d6f5..9587743 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -115,7 +115,6 @@ extern struct sk_buff *	    audit_make_reply(int pid, int seq, int type,
 extern void		    audit_send_reply(int pid, int seq, int type,
 					     int done, int multi,
 					     void *payload, int size);
-extern void		    audit_log_lost(const char *message);
 extern void		    audit_panic(const char *message);
 
 struct audit_netlink_list {
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index e36481e..7ccc3da 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -71,9 +71,6 @@
 
 extern struct list_head audit_filter_list[];
 
-/* No syscall auditing will take place unless audit_enabled != 0. */
-extern int audit_enabled;
-
 /* AUDIT_NAMES is the number of slots we reserve in the audit_context
  * for saving names from getname(). */
 #define AUDIT_NAMES    20
diff --git a/kernel/exit.c b/kernel/exit.c
index 5b888c2..413f6df 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -922,6 +922,8 @@ fastcall NORET_TYPE void do_exit(long code)
 	if (unlikely(tsk->compat_robust_list))
 		compat_exit_robust_list(tsk);
 #endif
+	if (group_dead && unlikely(tsk->signal->tty_audit_buf))
+		tty_audit_exit();
 	if (unlikely(tsk->audit_context))
 		audit_free(tsk);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 73ad5cd..52c449f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -897,6 +897,11 @@ static inline int copy_signal(unsigned long clone_flags, struct task_struct * ts
 	}
 	acct_init_pacct(&sig->pacct);
 
+	spin_lock(&current->sighand->siglock);
+	sig->audit_tty = current->signal->audit_tty;
+	spin_unlock(&current->sighand->siglock);
+	sig->tty_audit_buf = NULL;
+
 	return 0;
 }
 
diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index ccfe875..eddc7b4 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -110,6 +110,8 @@ static struct nlmsg_perm nlmsg_audit_perms[] =
 	{ AUDIT_DEL_RULE,	NETLINK_AUDIT_SOCKET__NLMSG_WRITE    },
 	{ AUDIT_USER,		NETLINK_AUDIT_SOCKET__NLMSG_RELAY    },
 	{ AUDIT_SIGNAL_INFO,	NETLINK_AUDIT_SOCKET__NLMSG_READ     },
+	{ AUDIT_TTY_GET,	NETLINK_AUDIT_SOCKET__NLMSG_READ     },
+	{ AUDIT_TTY_SET,	NETLINK_AUDIT_SOCKET__NLMSG_WRITE    },
 };
 
 

--------------030401000907030900090804--
