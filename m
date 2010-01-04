Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552Ab0ADQnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab0ADQnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 11:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397Ab0ADQnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 11:43:11 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58003 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753346Ab0ADQnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 11:43:10 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] tosh: Use non bkl ioctl
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 04 Jan 2010 16:19:55 +0000
Message-ID: <20100104161918.16766.43340.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another one thats been sent several times over the past months but ignored so
can go directly


We wrap the smm calls and other bits with the BKL push down as a precaution
but they can probably go

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/toshiba.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)


diff --git a/drivers/char/toshiba.c b/drivers/char/toshiba.c
index 663cd15..f8bc79f 100644
--- a/drivers/char/toshiba.c
+++ b/drivers/char/toshiba.c
@@ -68,7 +68,7 @@
 #include <linux/stat.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-
+#include <linux/smp_lock.h>
 #include <linux/toshiba.h>
 
 #define TOSH_MINOR_DEV 181
@@ -88,13 +88,13 @@ static int tosh_date;
 static int tosh_sci;
 static int tosh_fan;
 
-static int tosh_ioctl(struct inode *, struct file *, unsigned int,
+static long tosh_ioctl(struct file *, unsigned int,
 	unsigned long);
 
 
 static const struct file_operations tosh_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= tosh_ioctl,
+	.unlocked_ioctl	= tosh_ioctl,
 };
 
 static struct miscdevice tosh_device = {
@@ -252,8 +252,7 @@ int tosh_smm(SMMRegisters *regs)
 EXPORT_SYMBOL(tosh_smm);
 
 
-static int tosh_ioctl(struct inode *ip, struct file *fp, unsigned int cmd,
-	unsigned long arg)
+static long tosh_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 {
 	SMMRegisters regs;
 	SMMRegisters __user *argp = (SMMRegisters __user *)arg;
@@ -275,13 +274,16 @@ static int tosh_ioctl(struct inode *ip, struct file *fp, unsigned int cmd,
 				return -EINVAL;
 
 			/* do we need to emulate the fan ? */
+			lock_kernel();
 			if (tosh_fan==1) {
 				if (((ax==0xf300) || (ax==0xf400)) && (bx==0x0004)) {
 					err = tosh_emulate_fan(&regs);
+					unlock_kernel();
 					break;
 				}
 			}
 			err = tosh_smm(&regs);
+			unlock_kernel();
 			break;
 		default:
 			return -EINVAL;

