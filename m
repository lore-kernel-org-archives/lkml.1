Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbYFYWbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbYFYWbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 18:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbYFYWaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 18:30:55 -0400
Received: from vena.lwn.net ([206.168.112.25]:33170 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798AbYFYWay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 18:30:54 -0400
Date: Wed, 25 Jun 2008 16:30:52 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH, RFC] fasync() BKL pushdown (take 2)
Message-ID: <20080625163052.344a2957@bike.lwn.net>
In-Reply-To: <485C0133.3020708@firstfloor.org>
References: <20080620112914.783be428@bike.lwn.net>
	<485BEEF7.2020404@firstfloor.org>
	<20080620130905.6694a7be@bike.lwn.net>
	<485C0133.3020708@firstfloor.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008 21:12:51 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Some devices do state change even when the reference count is > 0.
> Would need to double check it's all ok with the fasync list.

OK, I've gone over all of the fasync() definitions again with an eye
toward convincing myself that the fasync list would not get cleared,
freed, or otherwise molested if fasync() runs without BKL protection.
I focused especially on other code (open(), ioctl()) which might still
run with the BKL.  The result was two more pushdowns in spots where I
wasn't sure; chance are both are unnecessary.

The new fasync pushdown tree contains:

Jonathan Corbet (9):
      mpt: fasync BKL pushdown
      i2o: fasync BKL pushdown
      tun: fasync BKL pushdown
      tty_io: fasync BKL pushdown
      Bluetooth VHCI: fasync BKL pushdown
      ecryptfs: fasync BKL pushdown
      ipmi: fasync BKL pushdown
      snd/PCM: fasync BKL pushdown
      Call fasync() functions without the BKL

 drivers/bluetooth/hci_vhci.c     |    9 ++++++---
 drivers/char/ipmi/ipmi_devintf.c |    2 ++
 drivers/char/tty_io.c            |   14 +++++++++-----
 drivers/message/fusion/mptctl.c  |    6 +++++-
 drivers/message/i2o/i2o_config.c |   10 ++++++----
 drivers/net/tun.c                |   11 +++++++----
 fs/ecryptfs/file.c               |    3 +++
 fs/fcntl.c                       |    3 ---
 sound/core/pcm_native.c          |    8 ++++++--
 9 files changed, 44 insertions(+), 22 deletions(-)

Once again, the combined patch is small, so I'll just attach it.
Anybody have a reason why I should not fold this work into the
bkl-removal tree?

Thanks,

jon


diff --git a/drivers/bluetooth/hci_vhci.c b/drivers/bluetooth/hci_vhci.c
index 7734bc9..d97700a 100644
--- a/drivers/bluetooth/hci_vhci.c
+++ b/drivers/bluetooth/hci_vhci.c
@@ -318,18 +318,21 @@ static int vhci_release(struct inode *inode,
struct file *file) static int vhci_fasync(int fd, struct file *file,
int on) {
 	struct vhci_data *data = file->private_data;
-	int err;
+	int err = 0;
 
+	lock_kernel();
 	err = fasync_helper(fd, file, on, &data->fasync);
 	if (err < 0)
-		return err;
+		goto out;
 
 	if (on)
 		data->flags |= VHCI_FASYNC;
 	else
 		data->flags &= ~VHCI_FASYNC;
 
-	return 0;
+out:
+	unlock_kernel();
+	return err;
 }
 
 static const struct file_operations vhci_fops = {
diff --git a/drivers/char/ipmi/ipmi_devintf.c
b/drivers/char/ipmi/ipmi_devintf.c index c816656..c11a404 100644
--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -101,7 +101,9 @@ static int ipmi_fasync(int fd, struct file *file,
int on) struct ipmi_file_private *priv = file->private_data;
 	int                      result;
 
+	lock_kernel(); /* could race against open() otherwise */
 	result = fasync_helper(fd, file, on, &priv->fasync_queue);
+	unlock_kernel();
 
 	return (result);
 }
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index fd182f2..eda2789 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2909,15 +2909,16 @@ static int tty_fasync(int fd, struct file
*filp, int on) {
 	struct tty_struct *tty;
 	unsigned long flags;
-	int retval;
+	int retval = 0;
 
+	lock_kernel();
 	tty = (struct tty_struct *)filp->private_data;
 	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode,
"tty_fasync"))
-		return 0;
+		goto out;
 
 	retval = fasync_helper(fd, filp, on, &tty->fasync);
 	if (retval <= 0)
-		return retval;
+		goto out;
 
 	if (on) {
 		enum pid_type type;
@@ -2935,12 +2936,15 @@ static int tty_fasync(int fd, struct file
*filp, int on) spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		retval = __f_setown(filp, pid, type, 0);
 		if (retval)
-			return retval;
+			goto out;
 	} else {
 		if (!tty->fasync && !waitqueue_active(&tty->read_wait))
 			tty->minimum_to_wake = N_TTY_BUF_SIZE;
 	}
-	return 0;
+	retval = 0;
+out:
+	unlock_kernel();
+	return retval;
 }
 
 /**
diff --git a/drivers/message/fusion/mptctl.c
b/drivers/message/fusion/mptctl.c index e630b50..c594656 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -548,11 +548,15 @@ static int
 mptctl_fasync(int fd, struct file *filep, int mode)
 {
 	MPT_ADAPTER	*ioc;
+	int ret;
 
+	lock_kernel();
 	list_for_each_entry(ioc, &ioc_list, list)
 		ioc->aen_event_read_flag=0;
 
-	return fasync_helper(fd, filep, mode, &async_queue);
+	ret = fasync_helper(fd, filep, mode, &async_queue);
+	unlock_kernel();
+	return ret;
 }
 
 static int
diff --git a/drivers/message/i2o/i2o_config.c
b/drivers/message/i2o/i2o_config.c index 95b4c10..4238de9 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -1084,15 +1084,17 @@ static int cfg_fasync(int fd, struct file *fp,
int on) {
 	ulong id = (ulong) fp->private_data;
 	struct i2o_cfg_info *p;
+	int ret = -EBADF;
 
+	lock_kernel();
 	for (p = open_files; p; p = p->next)
 		if (p->q_id == id)
 			break;
 
-	if (!p)
-		return -EBADF;
-
-	return fasync_helper(fd, fp, on, &p->fasync);
+	if (p)
+		ret = fasync_helper(fd, fp, on, &p->fasync);
+	unlock_kernel();
+	return ret;
 }
 
 static int cfg_release(struct inode *inode, struct file *file)
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index ce5af2a..4c0c597 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -782,18 +782,21 @@ static int tun_chr_fasync(int fd, struct file
*file, int on) 
 	DBG(KERN_INFO "%s: tun_chr_fasync %d\n", tun->dev->name, on);
 
+	lock_kernel();
 	if ((ret = fasync_helper(fd, file, on, &tun->fasync)) < 0)
-		return ret;
+		goto out;
 
 	if (on) {
 		ret = __f_setown(file, task_pid(current), PIDTYPE_PID,
0); if (ret)
-			return ret;
+			goto out;
 		tun->flags |= TUN_FASYNC;
 	} else
 		tun->flags &= ~TUN_FASYNC;
-
-	return 0;
+	ret = 0;
+out:
+	unlock_kernel();
+	return ret;
 }
 
 static int tun_chr_open(struct inode *inode, struct file * file)
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 2258b8f..24749bf 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -30,6 +30,7 @@
 #include <linux/security.h>
 #include <linux/compat.h>
 #include <linux/fs_stack.h>
+#include <linux/smp_lock.h>
 #include "ecryptfs_kernel.h"
 
 /**
@@ -277,9 +278,11 @@ static int ecryptfs_fasync(int fd, struct file
*file, int flag) int rc = 0;
 	struct file *lower_file = NULL;
 
+	lock_kernel();
 	lower_file = ecryptfs_file_to_lower(file);
 	if (lower_file->f_op && lower_file->f_op->fasync)
 		rc = lower_file->f_op->fasync(fd, lower_file, flag);
+	unlock_kernel();
 	return rc;
 }
 
diff --git a/fs/fcntl.c b/fs/fcntl.c
index bfd7765..330a7d7 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -12,7 +12,6 @@
 #include <linux/fdtable.h>
 #include <linux/capability.h>
 #include <linux/dnotify.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/security.h>
@@ -227,7 +226,6 @@ static int setfl(int fd, struct file * filp,
unsigned long arg) if (error)
 		return error;
 
-	lock_kernel();
 	if ((arg ^ filp->f_flags) & FASYNC) {
 		if (filp->f_op && filp->f_op->fasync) {
 			error = filp->f_op->fasync(fd, filp, (arg &
FASYNC) != 0); @@ -238,7 +236,6 @@ static int setfl(int fd, struct file
* filp, unsigned long arg) 
 	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags &
~SETFL_MASK); out:
-	unlock_kernel();
 	return error;
 }
 
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 61f5d42..c49b9d9 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -22,6 +22,7 @@
 #include <linux/mm.h>
 #include <linux/file.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/time.h>
 #include <linux/pm_qos_params.h>
 #include <linux/uio.h>
@@ -3249,14 +3250,17 @@ static int snd_pcm_fasync(int fd, struct file *
file, int on) struct snd_pcm_file * pcm_file;
 	struct snd_pcm_substream *substream;
 	struct snd_pcm_runtime *runtime;
-	int err;
+	int err = -ENXIO;
 
+	lock_kernel();
 	pcm_file = file->private_data;
 	substream = pcm_file->substream;
-	snd_assert(substream != NULL, return -ENXIO);
+	snd_assert(substream != NULL, goto out);
 	runtime = substream->runtime;
 
 	err = fasync_helper(fd, file, on, &runtime->fasync);
+out:
+	unlock_kernel();
 	if (err < 0)
 		return err;
 	return 0;
