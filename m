Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbYAIHTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbYAIHTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 02:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbYAIHT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 02:19:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:53355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbYAIHT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 02:19:27 -0500
Message-ID: <4785C7D8.2020808@suse.de>
Date: Thu, 10 Jan 2008 12:53:04 +0530
From: Nikanth Karthikesan <knikanth@suse.de>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: grant@torque.net, tim@cyberelk.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Change paride driver to use unlocked_ioctl instead of
 ioctl
References: <4785B7BC.5040106@suse.de>
In-Reply-To: <4785B7BC.5040106@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry missed the function prototype and includes earlier.
Here is the corrected patch. Build tested.

The ioctl handler is called with the BKL held. Registering
unlocked_ioctl handler instead of registering ioctl handler.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/drivers/block/paride/pt.c b/drivers/block/paride/pt.c
index b91accf..860b946 100644
--- a/drivers/block/paride/pt.c
+++ b/drivers/block/paride/pt.c
@@ -146,6 +146,7 @@ static int (*drives[4])[6] = {&drive0, &drive1, &drive2,
&drive3};
 #include <linux/mtio.h>
 #include <linux/device.h>
 #include <linux/sched.h>	/* current, TASK_*, schedule_timeout() */
+#include <linux/smp_lock.h>

 #include <asm/uaccess.h>

@@ -189,8 +190,8 @@ module_param_array(drive3, int, NULL, 0);
 #define ATAPI_LOG_SENSE		0x4d

 static int pt_open(struct inode *inode, struct file *file);
-static int pt_ioctl(struct inode *inode, struct file *file,
-		    unsigned int cmd, unsigned long arg);
+static long pt_ioctl(struct file *file, unsigned int cmd,
+		unsigned long arg);
 static int pt_release(struct inode *inode, struct file *file);
 static ssize_t pt_read(struct file *filp, char __user *buf,
 		       size_t count, loff_t * ppos);
@@ -236,7 +237,7 @@ static const struct file_operations pt_fops = {
 	.owner = THIS_MODULE,
 	.read = pt_read,
 	.write = pt_write,
-	.ioctl = pt_ioctl,
+	.unlocked_ioctl = pt_ioctl,
 	.open = pt_open,
 	.release = pt_release,
 };
@@ -685,36 +686,44 @@ out:
 	return err;
 }

-static int pt_ioctl(struct inode *inode, struct file *file,
-	 unsigned int cmd, unsigned long arg)
+static long pt_ioctl(struct file *file, unsigned int cmd,
+		unsigned long arg)
 {
 	struct pt_unit *tape = file->private_data;
 	struct mtop __user *p = (void __user *)arg;
 	struct mtop mtop;

+	lock_kernel();
+
 	switch (cmd) {
 	case MTIOCTOP:
-		if (copy_from_user(&mtop, p, sizeof(struct mtop)))
+		if (copy_from_user(&mtop, p, sizeof(struct mtop))) {
+			unlock_kernel();
 			return -EFAULT;
+		}

 		switch (mtop.mt_op) {

 		case MTREW:
 			pt_rewind(tape);
+			unlock_kernel();
 			return 0;

 		case MTWEOF:
 			pt_write_fm(tape);
+			unlock_kernel();
 			return 0;

 		default:
 			printk("%s: Unimplemented mt_op %d\n", tape->name,
 			       mtop.mt_op);
+			unlock_kernel();
 			return -EINVAL;
 		}

 	default:
 		printk("%s: Unimplemented ioctl 0x%x\n", tape->name, cmd);
+		unlock_kernel();
 		return -EINVAL;

 	}
