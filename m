Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbZHCPsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbZHCPsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbZHCPsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:48:32 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:54407 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217AbZHCPsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:48:31 -0400
X-SourceIP: 213.93.53.227
Subject: [PATCH 3/2] fcntl: F_[SG]ETOWN_TID
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eranian@gmail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
In-Reply-To: <20090801012736.GA30259@redhat.com>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com>
	 <1248869948.6987.3083.camel@twins> <20090729221703.GA25368@redhat.com>
	 <1248953485.6391.41.camel@twins> <20090730192040.GA9503@redhat.com>
	 <1248984003.4164.0.camel@laptop> <20090730202804.GA13675@redhat.com>
	 <1249029320.6391.72.camel@twins>
	 <20090731141122.a1939712.akpm@linux-foundation.org>
	 <20090801012736.GA30259@redhat.com>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 17:48:18 +0200
Message-Id: <1249314498.7924.133.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In order to direct the SIGIO signal to a particular thread of a
multi-threaded application we cannot, like suggested by the manpage, put
a TID into the regular fcntl(F_SETOWN) call. It will still be send to
the whole process of which that thread is part.

Since people do want to properly direct SIGIO we introduce F_SETOWN_TID,
which functions similarly to F_SETOWN, except positive arguments are
interpreted as TIDs and negative arguments are interpreted as PIDs.

The need to direct SIGIO comes from self-monitoring profiling such as 
with perf-counters. Perf-counters uses SIGIO to notify that new sample
data is available. If the signal is delivered to the same task that
generated the new sample it can augment that data by inspecting the
task's user-space state right after it returns from the kernel. This 
is esp. convenient for interpreted or virtual machine driven environments.

This extension is fully bug compatible with the old F_GETOWN
implementation in that F_GETOWN_TID will be troubled by the negative
return value for PIDs similarly to F_GETOWN's trouble with process
groups.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: stephane eranian <eranian@googlemail.com>
---
 arch/alpha/include/asm/fcntl.h  |    2 +
 arch/parisc/include/asm/fcntl.h |    2 +
 fs/fcntl.c                      |   62 ++++++++++++++++++++++++++++++++++------
 include/asm-generic/fcntl.h     |    4 ++
 include/linux/fs.h              |   11 +++++--
 net/socket.c                    |    2 -
 6 files changed, 71 insertions(+), 12 deletions(-)

Index: linux-2.6/arch/parisc/include/asm/fcntl.h
===================================================================
--- linux-2.6.orig/arch/parisc/include/asm/fcntl.h
+++ linux-2.6/arch/parisc/include/asm/fcntl.h
@@ -28,6 +28,8 @@
 #define F_SETOWN	12	/*  for sockets. */
 #define F_SETSIG	13	/*  for sockets. */
 #define F_GETSIG	14	/*  for sockets. */
+#define F_GETOWN_TID	15
+#define F_SETOWN_TID	16
 
 /* for posix fcntl() and lockf() */
 #define F_RDLCK		01
Index: linux-2.6/fs/fcntl.c
===================================================================
--- linux-2.6.orig/fs/fcntl.c
+++ linux-2.6/fs/fcntl.c
@@ -197,13 +197,15 @@ static int setfl(int fd, struct file * f
 }
 
 static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
-                     int force)
+		     int flags)
 {
 	write_lock_irq(&filp->f_owner.lock);
-	if (force || !filp->f_owner.pid) {
+	if ((flags & FF_SETOWN_FORCE) || !filp->f_owner.pid) {
 		put_pid(filp->f_owner.pid);
 		filp->f_owner.pid = get_pid(pid);
 		filp->f_owner.pid_type = type;
+		filp->f_owner.task_only =
+			(type == PIDTYPE_PID && (flags & FF_SETOWN_TID));
 
 		if (pid) {
 			const struct cred *cred = current_cred();
@@ -215,7 +217,7 @@ static void f_modown(struct file *filp, 
 }
 
 int __f_setown(struct file *filp, struct pid *pid, enum pid_type type,
-		int force)
+		int flags)
 {
 	int err;
 
@@ -223,12 +225,12 @@ int __f_setown(struct file *filp, struct
 	if (err)
 		return err;
 
-	f_modown(filp, pid, type, force);
+	f_modown(filp, pid, type, flags);
 	return 0;
 }
 EXPORT_SYMBOL(__f_setown);
 
-int f_setown(struct file *filp, unsigned long arg, int force)
+int f_setown(struct file *filp, unsigned long arg, int flags)
 {
 	enum pid_type type;
 	struct pid *pid;
@@ -241,7 +243,7 @@ int f_setown(struct file *filp, unsigned
 	}
 	rcu_read_lock();
 	pid = find_vpid(who);
-	result = __f_setown(filp, pid, type, force);
+	result = __f_setown(filp, pid, type, flags);
 	rcu_read_unlock();
 	return result;
 }
@@ -263,6 +265,40 @@ pid_t f_getown(struct file *filp)
 	return pid;
 }
 
+static int f_setown_tid(struct file *filp, unsigned long arg)
+{
+	int flags = FF_SETOWN_FORCE;
+	struct pid *pid;
+	int who = arg;
+	int ret = 0;
+
+	if (who < 0)
+		who = -who;
+	else
+		flags |= FF_SETOWN_TID;
+
+	rcu_read_lock();
+	pid = find_vpid(who);
+	ret = __f_setown(filp, pid, PIDTYPE_PID, flags);
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static pid_t f_getown_tid(struct file *filp)
+{
+	pid_t tid;
+
+	read_lock(&filp->f_owner.lock);
+	tid = pid_vnr(filp->f_owner.pid);
+	if (filp->f_owner.pid_type == PIDTYPE_PGID)
+		tid = 0;
+	if (!filp->f_owner.task_only)
+		tid = -tid;
+	read_unlock(&filp->f_owner.lock);
+	return tid;
+}
+
 static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 		struct file *filp)
 {
@@ -311,7 +347,14 @@ static long do_fcntl(int fd, unsigned in
 		force_successful_syscall_return();
 		break;
 	case F_SETOWN:
-		err = f_setown(filp, arg, 1);
+		err = f_setown(filp, arg, FF_SETOWN_FORCE);
+		break;
+	case F_GETOWN_TID:
+		err = f_getown_tid(filp);
+		force_successful_syscall_return();
+		break;
+	case F_SETOWN_TID:
+		err = f_setown_tid(filp, arg);
 		break;
 	case F_GETSIG:
 		err = filp->f_owner.signum;
@@ -436,6 +479,7 @@ static void send_sigio_to_task(struct ta
 	 * sure we read it once and use the same value throughout.
 	 */
 	int signum = ACCESS_ONCE(fown->signum);
+	int group = !fown->task_only;
 
 	if (!sigio_perm(p, fown, signum))
 		return;
@@ -461,11 +505,11 @@ static void send_sigio_to_task(struct ta
 			else
 				si.si_band = band_table[reason - POLL_IN];
 			si.si_fd    = fd;
-			if (!do_send_sig_info(signum, &si, p, true))
+			if (!do_send_sig_info(signum, &si, p, group))
 				break;
 		/* fall-through: fall back on the old plain SIGIO signal */
 		case 0:
-			do_send_sig_info(SIGIO, SEND_SIG_PRIV, p, true);
+			do_send_sig_info(SIGIO, SEND_SIG_PRIV, p, group);
 	}
 }
 
Index: linux-2.6/include/asm-generic/fcntl.h
===================================================================
--- linux-2.6.orig/include/asm-generic/fcntl.h
+++ linux-2.6/include/asm-generic/fcntl.h
@@ -73,6 +73,10 @@
 #define F_SETSIG	10	/* for sockets. */
 #define F_GETSIG	11	/* for sockets. */
 #endif
+#ifndef F_SETOWN_TID
+#define F_SETOWN_TID	12
+#define F_GETOWN_TID	13
+#endif
 
 /* for F_[GET|SET]FL */
 #define FD_CLOEXEC	1	/* actually anything with low bit set goes */
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -872,6 +872,7 @@ struct fown_struct {
 	rwlock_t lock;          /* protects pid, uid, euid fields */
 	struct pid *pid;	/* pid or -pgrp where SIGIO should be sent */
 	enum pid_type pid_type;	/* Kind of process group SIGIO should be sent to */
+	bool task_only;		/* task or group signal */
 	uid_t uid, euid;	/* uid/euid of process setting the owner */
 	int signum;		/* posix.1b rt signal to be delivered on IO */
 };
@@ -1291,8 +1292,14 @@ extern void kill_fasync(struct fasync_st
 /* only for net: no internal synchronization */
 extern void __kill_fasync(struct fasync_struct *, int, int);
 
-extern int __f_setown(struct file *filp, struct pid *, enum pid_type, int force);
-extern int f_setown(struct file *filp, unsigned long arg, int force);
+/*
+ * setown flags
+ */
+#define FF_SETOWN_FORCE		1
+#define FF_SETOWN_TID		2
+
+extern int __f_setown(struct file *filp, struct pid *, enum pid_type, int flags);
+extern int f_setown(struct file *filp, unsigned long arg, int flags);
 extern void f_delown(struct file *filp);
 extern pid_t f_getown(struct file *filp);
 extern int send_sigurg(struct fown_struct *fown);
Index: linux-2.6/net/socket.c
===================================================================
--- linux-2.6.orig/net/socket.c
+++ linux-2.6/net/socket.c
@@ -916,7 +916,7 @@ static long sock_ioctl(struct file *file
 			err = -EFAULT;
 			if (get_user(pid, (int __user *)argp))
 				break;
-			err = f_setown(sock->file, pid, 1);
+			err = f_setown(sock->file, pid, FF_SETOWN_FORCE);
 			break;
 		case FIOGETOWN:
 		case SIOCGPGRP:
Index: linux-2.6/arch/alpha/include/asm/fcntl.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/fcntl.h
+++ linux-2.6/arch/alpha/include/asm/fcntl.h
@@ -26,6 +26,8 @@
 #define F_GETOWN	6	/*  for sockets. */
 #define F_SETSIG	10	/*  for sockets. */
 #define F_GETSIG	11	/*  for sockets. */
+#define F_SETOWN_TID	12
+#define F_GETOWN_TID	13
 
 /* for posix fcntl() and lockf() */
 #define F_RDLCK		1


