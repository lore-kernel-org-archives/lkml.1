Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbXEBFmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbXEBFmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbXEBFmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:42:51 -0400
Received: from haxent.com ([65.99.219.155]:2163 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784AbXEBFen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:34:43 -0400
Message-Id: <20070502053425.022523000@haxent.com.br>
References: <20070502052235.914764000@haxent.com.br>
User-Agent: quilt/0.45-1
Date: Wed, 02 May 2007 02:22:40 -0300
From: Davi Arnaut <davi@haxent.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 05/22] pollfs: pollable signal compat code
Content-Disposition: inline; filename=pollfs-signal-compat.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Compat handlers for the pollable signal operations. Later the0 compat operations
can operate on a per call basis.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

---
 fs/pollfs/signal.c |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

Index: linux-2.6/fs/pollfs/signal.c
===================================================================
--- linux-2.6.orig/fs/pollfs/signal.c
+++ linux-2.6/fs/pollfs/signal.c
@@ -16,6 +16,7 @@
 #include <linux/poll.h>
 #include <linux/pollfs_fs.h>
 #include <linux/signal.h>
+#include <linux/compat.h>
 
 struct pfs_signal {
 	sigset_t set;
@@ -48,6 +49,24 @@ static ssize_t read(struct pfs_signal *e
 	return 0;
 }
 
+#ifdef CONFIG_COMPAT
+static ssize_t compat_read(struct pfs_signal *evs,
+			   struct compat_siginfo __user *infoup)
+{
+	int signo;
+	siginfo_t info;
+
+	signo = dequeue_signal_lock(evs->task, &evs->set, &info);
+	if (!signo)
+		return -EAGAIN;
+
+	if (copy_siginfo_to_user32(infoup, &info))
+		return -EFAULT;
+
+	return 0;
+}
+#endif
+
 static ssize_t write(struct pfs_signal *evs, const sigset_t __user *uset)
 {
 	sigset_t set;
@@ -65,6 +84,28 @@ static ssize_t write(struct pfs_signal *
 	return 0;
 }
 
+#ifdef CONFIG_COMPAT
+static ssize_t compat_write(struct pfs_signal *evs,
+			    const compat_sigset_t __user *uset)
+{
+	sigset_t set;
+	compat_sigset_t cset;
+
+	if (copy_from_user(&cset, uset, sizeof(compat_sigset_t)))
+		return -EFAULT;
+
+	sigset_from_compat(&set, &cset);
+	sigset_adjust(&set);
+
+	spin_lock_irq(&evs->lock);
+	sigemptyset(&evs->set);
+	sigorsets(&evs->set, &evs->set, &set);
+	spin_unlock_irq(&evs->lock);
+
+	return 0;
+}
+#endif
+
 static int poll(struct pfs_signal *evs)
 {
 	int ret = 0;
@@ -142,3 +183,47 @@ asmlinkage long sys_plsignal(const sigse
 
 	return error;
 }
+
+#ifdef CONFIG_COMPAT
+static const struct pfs_operations compat_signal_ops = {
+	/* .read        = PFS_READ(compat_read, struct pfs_signal, struct compat_siginfo), */
+	.write		= PFS_WRITE(compat_write, struct pfs_signal, compat_sigset_t),
+	.poll		= PFS_POLL(poll, struct pfs_signal),
+	.release	= PFS_RELEASE(release, struct pfs_signal),
+	/* .rsize       = sizeof(compat_siginfo_t), */
+	.wsize		= sizeof(sigset_t)
+};
+
+asmlinkage long compat_plsignal(const compat_sigset_t __user *uset)
+{
+	long error;
+	compat_sigset_t cset;
+	struct pfs_signal *evs;
+
+	if (copy_from_user(&cset, uset, sizeof(compat_sigset_t)))
+		return -EFAULT;
+
+	evs = kmalloc(sizeof(*evs), GFP_KERNEL);
+	if (!evs)
+		return -ENOMEM;
+
+	spin_lock_init(&evs->lock);
+
+	evs->task = current;
+	get_task_struct(current);
+
+	sigset_from_compat(&evs->set, &cset);
+	sigset_adjust(&evs->set);
+
+	evs->file.data = evs;
+	evs->file.fops = &compat_signal_ops;
+	evs->file.wait = &evs->task->sigwait;
+
+	error = pfs_open(&evs->file);
+
+	if (error < 0)
+		release(evs);
+
+	return error;
+}
+#endif

--
