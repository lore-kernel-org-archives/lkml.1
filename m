Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbYBYNg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbYBYNg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 08:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbYBYNgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 08:36:22 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:35726 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbYBYNgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 08:36:22 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/2] Misc: phantom, add compat ioctl
Date: Mon, 25 Feb 2008 14:36:16 +0100
Message-Id: <1203946577-13984-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Openhaptics uses pointers in _IOC() macros, implement compat for them. Also
add _IOC alternatives which are not 32/64 bit dependent (structures
passed through aren't yet) -- libphantom will use them.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/misc/phantom.c  |   24 ++++++++++++++++++++----
 include/linux/phantom.h |    5 ++++-
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index 7fa61e9..5447a60 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -12,6 +12,7 @@
  *  or alternatively, you might use OpenHaptics provided by Sensable.
  */
 
+#include <linux/compat.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/device.h>
@@ -91,11 +92,8 @@ static long phantom_ioctl(struct file *file, unsigned int cmd,
 	unsigned long flags;
 	unsigned int i;
 
-	if (_IOC_TYPE(cmd) != PH_IOC_MAGIC ||
-			_IOC_NR(cmd) > PH_IOC_MAXNR)
-		return -ENOTTY;
-
 	switch (cmd) {
+	case PHN_SETREG:
 	case PHN_SET_REG:
 		if (copy_from_user(&r, argp, sizeof(r)))
 			return -EFAULT;
@@ -126,6 +124,7 @@ static long phantom_ioctl(struct file *file, unsigned int cmd,
 			phantom_status(dev, dev->status & ~PHB_RUNNING);
 		spin_unlock_irqrestore(&dev->regs_lock, flags);
 		break;
+	case PHN_SETREGS:
 	case PHN_SET_REGS:
 		if (copy_from_user(&rs, argp, sizeof(rs)))
 			return -EFAULT;
@@ -143,6 +142,7 @@ static long phantom_ioctl(struct file *file, unsigned int cmd,
 		}
 		spin_unlock_irqrestore(&dev->regs_lock, flags);
 		break;
+	case PHN_GETREG:
 	case PHN_GET_REG:
 		if (copy_from_user(&r, argp, sizeof(r)))
 			return -EFAULT;
@@ -155,6 +155,7 @@ static long phantom_ioctl(struct file *file, unsigned int cmd,
 		if (copy_to_user(argp, &r, sizeof(r)))
 			return -EFAULT;
 		break;
+	case PHN_GETREGS:
 	case PHN_GET_REGS: {
 		u32 m;
 
@@ -191,6 +192,20 @@ static long phantom_ioctl(struct file *file, unsigned int cmd,
 	return 0;
 }
 
+#ifdef CONFIG_COMPAT
+static long phantom_compat_ioctl(struct file *filp, unsigned int cmd,
+		unsigned long arg)
+{
+	if (_IOC_NR(cmd) <= 3 && _IOC_SIZE(cmd) == sizeof(compat_uptr_t)) {
+		cmd &= ~(_IOC_SIZEMASK << _IOC_SIZESHIFT);
+		cmd |= sizeof(void *) << _IOC_SIZESHIFT;
+	}
+	return phantom_ioctl(filp, cmd, (unsigned long)compat_ptr(arg));
+}
+#else
+#define phantom_compat_ioctl NULL
+#endif
+
 static int phantom_open(struct inode *inode, struct file *file)
 {
 	struct phantom_device *dev = container_of(inode->i_cdev,
@@ -253,6 +268,7 @@ static struct file_operations phantom_file_ops = {
 	.open = phantom_open,
 	.release = phantom_release,
 	.unlocked_ioctl = phantom_ioctl,
+	.compat_ioctl = phantom_compat_ioctl,
 	.poll = phantom_poll,
 };
 
diff --git a/include/linux/phantom.h b/include/linux/phantom.h
index 96f4048..fc0a505 100644
--- a/include/linux/phantom.h
+++ b/include/linux/phantom.h
@@ -34,7 +34,10 @@ struct phm_regs {
  * use improved registers update (no more phantom switchoffs when using
  * libphantom) */
 #define PHN_NOT_OH		_IO  (PH_IOC_MAGIC, 4)
-#define PH_IOC_MAXNR		4
+#define PHN_GETREG		_IOWR(PH_IOC_MAGIC, 5, struct phm_reg)
+#define PHN_SETREG		_IOW (PH_IOC_MAGIC, 6, struct phm_reg)
+#define PHN_GETREGS		_IOWR(PH_IOC_MAGIC, 7, struct phm_regs)
+#define PHN_SETREGS		_IOW (PH_IOC_MAGIC, 8, struct phm_regs)
 
 #define PHN_CONTROL		0x6     /* control byte in iaddr space */
 #define PHN_CTL_AMP		0x1     /*   switch after torques change */
-- 
1.5.4.1

