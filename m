Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbZHDLjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbZHDLjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 07:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbZHDLjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 07:39:42 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:1585 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683AbZHDLjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 07:39:41 -0400
X-SourceIP: 213.93.53.227
Subject: [PATCH 3/2 -v3] fcntl: F_[SG]ETOWN_EX
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eranian@gmail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
In-Reply-To: <20090803190231.GA22313@redhat.com>
References: <1248984003.4164.0.camel@laptop>
	 <20090730202804.GA13675@redhat.com> <1249029320.6391.72.camel@twins>
	 <20090731141122.a1939712.akpm@linux-foundation.org>
	 <20090801012736.GA30259@redhat.com> <1249314498.7924.133.camel@twins>
	 <20090803171619.GA17876@redhat.com> <1249321637.7924.163.camel@twins>
	 <20090803180602.GA19719@redhat.com> <1249324619.4842.1.camel@laptop>
	 <20090803190231.GA22313@redhat.com>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 13:39:26 +0200
Message-Id: <1249385966.7924.204.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-03 at 21:02 +0200, Oleg Nesterov wrote:

> To clarify, I am not really sure this interface is better. Just for
> discussion. Because it will be very painful to change this api later.
> It is better to at least consider all options now.

You're completely right, how about the below?

---
Subject: fcntl: F_[SG]ETOWN_EX
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 31 Jul 2009 10:35:30 +0200

In order to direct the SIGIO signal to a particular thread of a
multi-threaded application we cannot, like suggested by the manpage, put
a TID into the regular fcntl(F_SETOWN) call. It will still be send to
the whole process of which that thread is part.

Since people do want to properly direct SIGIO we introduce F_SETOWN_EX.

The need to direct SIGIO comes from self-monitoring profiling such as
with perf-counters. Perf-counters uses SIGIO to notify that new sample
data is available. If the signal is delivered to the same task that
generated the new sample it can augment that data by inspecting the
task's user-space state right after it returns from the kernel. This
is esp. convenient for interpreted or virtual machine driven
environments.

Both F_SETOWN_EX and F_GETOWN_EX take a pointer to a struct f_owner_ex
as argument:

struct f_owner_ex {
	int   type;
	pid_t pid;
};

Where type is one of F_OWNER_TID, F_OWNER_PID or F_OWNER_GID.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/alpha/include/asm/fcntl.h  |    2 
 arch/parisc/include/asm/fcntl.h |    2 
 fs/fcntl.c                      |   83 +++++++++++++++++++++++++++++++++++++---
 include/asm-generic/fcntl.h     |   13 ++++++
 4 files changed, 95 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/parisc/include/asm/fcntl.h
===================================================================
--- linux-2.6.orig/arch/parisc/include/asm/fcntl.h
+++ linux-2.6/arch/parisc/include/asm/fcntl.h
@@ -28,6 +28,8 @@
 #define F_SETOWN	12	/*  for sockets. */
 #define F_SETSIG	13	/*  for sockets. */
 #define F_GETSIG	14	/*  for sockets. */
+#define F_GETOWN_EX	15
+#define F_SETOWN_EX	16
 
 /* for posix fcntl() and lockf() */
 #define F_RDLCK		01
Index: linux-2.6/fs/fcntl.c
===================================================================
--- linux-2.6.orig/fs/fcntl.c
+++ linux-2.6/fs/fcntl.c
@@ -263,6 +263,67 @@ pid_t f_getown(struct file *filp)
 	return pid;
 }
 
+static int f_setown_ex(struct file *filp, unsigned long arg)
+{
+	struct f_owner_ex * __user owner_p = (void * __user)arg;
+	struct f_owner_ex owner;
+	struct pid *pid;
+	int type;
+	int ret;
+
+	ret = copy_from_user(&owner, owner_p, sizeof(owner));
+	if (ret)
+		return ret;
+
+	switch (owner.type) {
+	case F_OWNER_TID:
+		type = PIDTYPE_MAX;
+		break;
+
+	case F_OWNER_PID:
+		type = PIDTYPE_PID;
+		break;
+
+	case F_OWNER_GID:
+		type = PIDTYPE_PGID;
+		break;
+	}
+
+	rcu_read_lock();
+	pid = find_vpid(owner.pid);
+	ret = __f_setown(filp, pid, type, 1);
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static int f_getown_ex(struct file *filp, unsigned long arg)
+{
+	struct f_owner_ex * __user owner_p = (void * __user)arg;
+	struct f_owner_ex owner;
+	int ret;
+
+	read_lock(&filp->f_owner.lock);
+	owner.pid = pid_vnr(filp->f_owner.pid);
+	switch ((int)filp->f_owner.pid_type) {
+	case PIDTYPE_MAX:
+		owner.type = F_OWNER_TID;
+		break;
+
+	case PIDTYPE_PID:
+		owner.type = F_OWNER_PID;
+		break;
+
+	case PIDTYPE_PGID:
+		owner.type = F_OWNER_GID;
+		break;
+	}
+	read_unlock(&filp->f_owner.lock);
+
+	ret = copy_to_user(owner_p, &owner, sizeof(owner));
+	return ret;
+}
+
 static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 		struct file *filp)
 {
@@ -313,6 +374,12 @@ static long do_fcntl(int fd, unsigned in
 	case F_SETOWN:
 		err = f_setown(filp, arg, 1);
 		break;
+	case F_GETOWN_EX:
+		err = f_getown_ex(filp, arg);
+		break;
+	case F_SETOWN_EX:
+		err = f_setown_ex(filp, arg);
+		break;
 	case F_GETSIG:
 		err = filp->f_owner.signum;
 		break;
@@ -428,8 +495,7 @@ static inline int sigio_perm(struct task
 
 static void send_sigio_to_task(struct task_struct *p,
 			       struct fown_struct *fown,
-			       int fd,
-			       int reason)
+			       int fd, int reason, int group)
 {
 	/*
 	 * F_SETSIG can change ->signum lockless in parallel, make
@@ -461,11 +527,11 @@ static void send_sigio_to_task(struct ta
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
 
@@ -474,16 +540,23 @@ void send_sigio(struct fown_struct *fown
 	struct task_struct *p;
 	enum pid_type type;
 	struct pid *pid;
+	int group = 1;
 	
 	read_lock(&fown->lock);
+
 	type = fown->pid_type;
+	if (type == PIDTYPE_MAX) {
+		group = 0;
+		type = PIDTYPE_PID;
+	}
+
 	pid = fown->pid;
 	if (!pid)
 		goto out_unlock_fown;
 	
 	read_lock(&tasklist_lock);
 	do_each_pid_task(pid, type, p) {
-		send_sigio_to_task(p, fown, fd, band);
+		send_sigio_to_task(p, fown, fd, band, group);
 	} while_each_pid_task(pid, type, p);
 	read_unlock(&tasklist_lock);
  out_unlock_fown:
Index: linux-2.6/include/asm-generic/fcntl.h
===================================================================
--- linux-2.6.orig/include/asm-generic/fcntl.h
+++ linux-2.6/include/asm-generic/fcntl.h
@@ -73,6 +73,19 @@
 #define F_SETSIG	10	/* for sockets. */
 #define F_GETSIG	11	/* for sockets. */
 #endif
+#ifndef F_SETOWN_EX
+#define F_SETOWN_EX	12
+#define F_GETOWN_EX	13
+#endif
+
+#define F_OWNER_TID	0
+#define F_OWNER_PID	1
+#define F_OWNER_GID	2
+
+struct f_owner_ex {
+	int	type;
+	pid_t	pid;
+};
 
 /* for F_[GET|SET]FL */
 #define FD_CLOEXEC	1	/* actually anything with low bit set goes */
Index: linux-2.6/arch/alpha/include/asm/fcntl.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/fcntl.h
+++ linux-2.6/arch/alpha/include/asm/fcntl.h
@@ -26,6 +26,8 @@
 #define F_GETOWN	6	/*  for sockets. */
 #define F_SETSIG	10	/*  for sockets. */
 #define F_GETSIG	11	/*  for sockets. */
+#define F_SETOWN_EX	12
+#define F_GETOWN_EX	13
 
 /* for posix fcntl() and lockf() */
 #define F_RDLCK		1


