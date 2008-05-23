Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbYEWFNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbYEWFNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 01:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760785AbYEWFMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 01:12:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50624 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168AbYEWFM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 01:12:26 -0400
Date: Fri, 23 May 2008 15:12:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: paulus@samba.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       ppc-dev <linuxppc-dev@ozlabs.org>
Subject: [PATCH] [POWERPC] viotape: use unlocked_ioctl
Message-Id: <20080523151223.387c4c0a.sfr@canb.auug.org.au>
In-Reply-To: <20080523130442.54034a2f.sfr@au1.ibm.com>
References: <20080522222012.3a07bd57@core>
	<20080523130442.54034a2f.sfr@au1.ibm.com>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pushes the BKL down into the driver.  Based on a patch by Alan Cox.

We need to do it this way for now as the inode parameter of viotap_ioctl
is used internally as a flag.  We should do a further cleanup patch.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/char/viotape.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/char/viotape.c b/drivers/char/viotape.c
index 58aad63..0dda915 100644
--- a/drivers/char/viotape.c
+++ b/drivers/char/viotape.c
@@ -46,6 +46,7 @@
 #include <linux/completion.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
@@ -677,6 +678,17 @@ free_op:
 	return ret;
 }
 
+static long viotap_unlocked_ioctl(struct file *file,
+		unsigned int cmd, unsigned long arg)
+{
+	long rc;
+
+	lock_kernel();
+	rc = viotap_ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
+	unlock_kernel();
+	return rc;
+}
+
 static int viotap_open(struct inode *inode, struct file *file)
 {
 	HvLpEvent_Rc hvrc;
@@ -783,12 +795,12 @@ free_op:
 }
 
 const struct file_operations viotap_fops = {
-	.owner =	THIS_MODULE,
-	.read =		viotap_read,
-	.write =	viotap_write,
-	.ioctl =	viotap_ioctl,
-	.open =		viotap_open,
-	.release =	viotap_release,
+	.owner =		THIS_MODULE,
+	.read =			viotap_read,
+	.write =		viotap_write,
+	.unlocked_ioctl =	viotap_unlocked_ioctl,
+	.open =			viotap_open,
+	.release =		viotap_release,
 };
 
 /* Handle interrupt events for tape */
-- 
1.5.5.1


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
