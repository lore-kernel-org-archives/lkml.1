Return-Path: <linux-kernel-owner+w=401wt.eu-S933920AbXCOWYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933920AbXCOWYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933927AbXCOWXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:23:33 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33702 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbXCOWP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:27 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 21 of 33] IB/ipath - force PIOAvail update entry point
X-Mercurial-Node: 68302e9dbd8803f937af9f02ca26a63ff43e9afa
Message-Id: <68302e9dbd8803f937af.1173995105@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:45:05 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Arthur Jones <arthur.jones@qlogic.com>
# Date 1173994465 25200
# Node ID 68302e9dbd8803f937af9f02ca26a63ff43e9afa
# Parent  8a013b707785accfd71589334bbf8e4029ffa892
IB/ipath - force PIOAvail update entry point.

Due to a chip bug, the PIOAvail register is not always updated to memory.
This patch allows userspace to force an update.

Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r 8a013b707785 -r 68302e9dbd88 drivers/infiniband/hw/ipath/ipath_common.h
--- a/drivers/infiniband/hw/ipath/ipath_common.h	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_common.h	Thu Mar 15 14:34:25 2007 -0700
@@ -352,7 +352,7 @@ struct ipath_base_info {
  * may not be implemented; the user code must deal with this if it
  * cares, or it must abort after initialization reports the difference.
  */
-#define IPATH_USER_SWMINOR 4
+#define IPATH_USER_SWMINOR 5
 
 #define IPATH_USER_SWVERSION ((IPATH_USER_SWMAJOR<<16) | IPATH_USER_SWMINOR)
 
@@ -429,8 +429,11 @@ struct ipath_user_info {
 #define __IPATH_CMD_SLAVE_INFO	22	/* return info on slave processes (for old user code) */
 #define IPATH_CMD_ASSIGN_PORT	23	/* allocate HCA and port */
 #define IPATH_CMD_USER_INIT 	24	/* set up userspace */
-
-#define IPATH_CMD_MAX		24
+#define IPATH_CMD_UNUSED_1	25
+#define IPATH_CMD_UNUSED_2	26
+#define IPATH_CMD_PIOAVAILUPD	27	/* force an update of PIOAvail reg */
+
+#define IPATH_CMD_MAX		27
 
 struct ipath_port_info {
 	__u32 num_active;	/* number of active units */
diff -r 8a013b707785 -r 68302e9dbd88 drivers/infiniband/hw/ipath/ipath_file_ops.c
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c	Thu Mar 15 14:34:25 2007 -0700
@@ -2047,6 +2047,17 @@ static int ipath_get_slave_info(struct i
 	return ret;
 }
 
+static int ipath_force_pio_avail_update(struct ipath_devdata *dd)
+{
+	u64 reg = dd->ipath_sendctrl;
+
+	clear_bit(IPATH_S_PIOBUFAVAILUPD, &reg);
+	ipath_write_kreg(dd, dd->ipath_kregs->kr_sendctrl, reg);
+	ipath_write_kreg(dd, dd->ipath_kregs->kr_sendctrl, dd->ipath_sendctrl);
+
+	return 0;
+}
+
 static ssize_t ipath_write(struct file *fp, const char __user *data,
 			   size_t count, loff_t *off)
 {
@@ -2106,22 +2117,30 @@ static ssize_t ipath_write(struct file *
 		dest = &cmd.cmd.slave_mask_addr;
 		src = &ucmd->cmd.slave_mask_addr;
 		break;
+	case IPATH_CMD_PIOAVAILUPD:	// force an update of PIOAvail reg
+		copy = 0;
+		src = NULL;
+		dest = NULL;
+		break;
 	default:
 		ret = -EINVAL;
 		goto bail;
 	}
 
-	if ((count - consumed) < copy) {
-		ret = -EINVAL;
-		goto bail;
-	}
-
-	if (copy_from_user(dest, src, copy)) {
-		ret = -EFAULT;
-		goto bail;
-	}
-
-	consumed += copy;
+	if (copy) {
+		if ((count - consumed) < copy) {
+			ret = -EINVAL;
+			goto bail;
+		}
+
+		if (copy_from_user(dest, src, copy)) {
+			ret = -EFAULT;
+			goto bail;
+		}
+
+		consumed += copy;
+	}
+
 	pd = port_fp(fp);
 	if (!pd && cmd.type != __IPATH_CMD_USER_INIT &&
 		cmd.type != IPATH_CMD_ASSIGN_PORT) {
@@ -2172,6 +2191,9 @@ static ssize_t ipath_write(struct file *
 					   (void __user *) (unsigned long)
 					   cmd.cmd.slave_mask_addr);
 		break;
+	case IPATH_CMD_PIOAVAILUPD:
+		ret = ipath_force_pio_avail_update(pd->port_dd);
+		break;
 	}
 
 	if (ret >= 0)
