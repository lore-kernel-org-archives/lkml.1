Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbYAIGLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbYAIGLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 01:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYAIGKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 01:10:44 -0500
Received: from ns1.suse.de ([195.135.220.2]:42458 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbYAIGKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 01:10:42 -0500
Message-ID: <4785B7BC.5040106@suse.de>
Date: Thu, 10 Jan 2008 11:44:20 +0530
From: Nikanth Karthikesan <knikanth@suse.de>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: grant@torque.net, tim@cyberelk.net
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] Change paride driver to use unlocked_ioctl instead of ioctl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ioctl handler is called with the BKL held. Registering
unlocked_ioctl handler instead of registering ioctl handler.


Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c
b/arch/x86/kernel/cpu/mcheck/mce_64.c
diff --git a/drivers/block/paride/pt.c b/drivers/block/paride/pt.c
index b91accf..d4fa468 100644
--- a/drivers/block/paride/pt.c
+++ b/drivers/block/paride/pt.c
@@ -236,7 +236,7 @@ static const struct file_operations pt_fops = {
 	.owner = THIS_MODULE,
 	.read = pt_read,
 	.write = pt_write,
-	.ioctl = pt_ioctl,
+	.unlocked_ioctl = pt_ioctl,
 	.open = pt_open,
 	.release = pt_release,
 };
@@ -685,36 +685,43 @@ out:
 	return err;
 }

-static int pt_ioctl(struct inode *inode, struct file *file,
-	 unsigned int cmd, unsigned long arg)
+static long pt_ioctl(struct file *file, unsigned int cmd, unsigned long
arg)
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
