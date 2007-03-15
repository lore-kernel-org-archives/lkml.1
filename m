Return-Path: <linux-kernel-owner+w=401wt.eu-S1422640AbXCOWVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422640AbXCOWVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422975AbXCOWTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:19:33 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33716 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbXCOWP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:28 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 26 of 33] IB/ipath - prevent random program use of diags
	interface
X-Mercurial-Node: 284c34f2adddd16f7cb4fe48a2f6fbe9ad4beea5
Message-Id: <284c34f2adddd16f7cb4.1173995110@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:45:10 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Bryan O'Sullivan <bos@pathscale.com>
# Date 1173994465 25200
# Node ID 284c34f2adddd16f7cb4fe48a2f6fbe9ad4beea5
# Parent  e9895e2ad504a2590b0943c037d1fa5f9568fda3
IB/ipath - prevent random program use of diags interface

To prevent random utility reads and writes of the diag interface to the
chip, we first require a handshake of reading from offset 0 and writing
to offset 0 before any other reads or writes can be done through the
diags device.   Otherwise chip errors can be triggered.

Signed-off-by: Dave Olson <dave.olson@qlogic.com>
Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r e9895e2ad504 -r 284c34f2addd drivers/infiniband/hw/ipath/ipath_diag.c
--- a/drivers/infiniband/hw/ipath/ipath_diag.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_diag.c	Thu Mar 15 14:34:25 2007 -0700
@@ -296,7 +296,7 @@ static int ipath_diag_open(struct inode 
 	}
 
 	fp->private_data = dd;
-	ipath_diag_inuse = 1;
+	ipath_diag_inuse = -2;
 	diag_set_link = 0;
 	ret = 0;
 
@@ -461,6 +461,8 @@ static ssize_t ipath_diag_read(struct fi
 	else if ((count % 4) || (*off % 4))
 		/* address or length is not 32-bit aligned, hence invalid */
 		ret = -EINVAL;
+	else if (ipath_diag_inuse < 1 && (*off || count != 8))
+		ret = -EINVAL;  /* prevent cat /dev/ipath_diag* */
 	else if ((count % 8) || (*off % 8))
 		/* address or length not 64-bit aligned; do 32-bit reads */
 		ret = ipath_read_umem32(dd, data, kreg_base + *off, count);
@@ -470,6 +472,8 @@ static ssize_t ipath_diag_read(struct fi
 	if (ret >= 0) {
 		*off += count;
 		ret = count;
+		if (ipath_diag_inuse == -2)
+			ipath_diag_inuse++;
 	}
 
 	return ret;
@@ -489,6 +493,9 @@ static ssize_t ipath_diag_write(struct f
 	else if ((count % 4) || (*off % 4))
 		/* address or length is not 32-bit aligned, hence invalid */
 		ret = -EINVAL;
+	else if ((ipath_diag_inuse == -1 && (*off || count != 8)) ||
+		 ipath_diag_inuse == -2)  /* read qw off 0, write qw off 0 */
+		ret = -EINVAL;  /* before any other write allowed */
 	else if ((count % 8) || (*off % 8))
 		/* address or length not 64-bit aligned; do 32-bit writes */
 		ret = ipath_write_umem32(dd, kreg_base + *off, data, count);
@@ -498,7 +505,9 @@ static ssize_t ipath_diag_write(struct f
 	if (ret >= 0) {
 		*off += count;
 		ret = count;
-	}
-
-	return ret;
-}
+		if (ipath_diag_inuse == -1)
+			ipath_diag_inuse = 1; /* all read/write OK now */
+	}
+
+	return ret;
+}
