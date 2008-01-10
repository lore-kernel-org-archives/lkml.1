Return-Path: <linux-kernel-owner+w=401wt.eu-S1752887AbYAIIw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbYAIIw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 03:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbYAIIwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 03:52:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:35026 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbYAIIwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 03:52:17 -0500
Subject: Re: [PATCH] Change paride driver to use unlocked_ioctl instead of
	ioctl
From: Nikanth Karthikesan <knikanth@suse.de>
To: grant@torque.net, tim@cyberelk.net
Cc: Christoph Hellwig <hch@infradead.org>, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <4784D3E0.BANGALORE.BLR.100.174746A.1.EABB.1@1:7.BANGALORE.BLR.100.0.1.0.1@16>
References: <4785B7BC.5040106@suse.de>
	 <20080109080620.GE32560@infradead.org>
	 <4784D3E0.BANGALORE.BLR.100.174746A.1.EABB.1@1:7.BANGALORE.BLR.100.0.1.0.1@16>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 14:25:47 +0530
Message-Id: <1199955347.6203.6.camel@nikanth-laptop.blr.novell.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-09 at 03:23 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 09 Jan 2008 08:06:20 GMT, Christoph Hellwig said:
> 
> > It's generally considered good style to only have as few as possible
> > return values.  And this is especially important when returning from
> > a section that's under a lock.  So in this case it would be much better
> > if you changes this function to have a local 'int error' variable
> > and then just do
> > 
> > 	error = -EFOO;
> > 	goto out_unlock;

agreed. resending the patch


> I think Christoph meant to say "as few as possible return locations".  One
> should write the code to have as many different return values as are
> meaningful, but return them from as few places as possible - which is what the
> "assign error and goto end" paradigm does...
> 

Is this following coding style, fine?

The ioctl handler is called with the BKL held. Registering
unlocked_ioctl handler instead of registering ioctl handler.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/drivers/block/paride/pt.c b/drivers/block/paride/pt.c
index b91accf..17f32f0 100644
--- a/drivers/block/paride/pt.c
+++ b/drivers/block/paride/pt.c
@@ -146,6 +146,7 @@ static int (*drives[4])[6] = {&drive0, &drive1, &drive2, &drive3};
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
@@ -685,39 +686,47 @@ out:
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
+	long err = 0;
+
+	lock_kernel();
 
 	switch (cmd) {
 	case MTIOCTOP:
-		if (copy_from_user(&mtop, p, sizeof(struct mtop)))
-			return -EFAULT;
+		if (copy_from_user(&mtop, p, sizeof(struct mtop))) {
+			err = -EFAULT;
+			break;
+		}
 
 		switch (mtop.mt_op) {
 
 		case MTREW:
 			pt_rewind(tape);
-			return 0;
+			break;
 
 		case MTWEOF:
 			pt_write_fm(tape);
-			return 0;
+			break;
 
 		default:
 			printk("%s: Unimplemented mt_op %d\n", tape->name,
 			       mtop.mt_op);
-			return -EINVAL;
+			err = -EINVAL;
 		}
+		break;
 
 	default:
 		printk("%s: Unimplemented ioctl 0x%x\n", tape->name, cmd);
-		return -EINVAL;
-
+		err = -EINVAL;
+		
 	}
+	unlock_kernel();
+	return err;
 }
 
 static int




