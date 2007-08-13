Return-Path: <linux-kernel-owner+w=401wt.eu-S934611AbXHMPPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934611AbXHMPPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761968AbXHMM72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 08:59:28 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:58827 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030896AbXHMM7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 08:59:22 -0400
Subject: [kj] is_power_of_2 in ntfs
From: vignesh babu <vignesh.babu@wipro.com>
Reply-To: vigneshbabu@gmail.com
To: aia21@cantab.net
Cc: linux-ntfs-dev@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Janitors List <kernel-janitors@lists.osdl.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: WIPRO Technologies
Date: Mon, 13 Aug 2007 18:28:47 +0530
Message-Id: <1187009927.7273.13.camel@merlin.linuxcoe.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
X-OriginalArrivalTime: 13 Aug 2007 12:59:42.0114 (UTC) FILETIME=[D0881820:01C7DDA9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing n & (n - 1) for power of 2 check by is_power_of_2(n)

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
---
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index b532a73..8152f79 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -27,6 +27,7 @@
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
 #include <linux/slab.h>
+#include <linux/log2.h>
 
 #include "aops.h"
 #include "attrib.h"
@@ -1574,7 +1575,7 @@ static int ntfs_read_locked_index_inode(struct inode *base_vi, struct inode *vi)
 	ntfs_debug("Index collation rule is 0x%x.",
 			le32_to_cpu(ir->collation_rule));
 	ni->itype.index.block_size = le32_to_cpu(ir->index_block_size);
-	if (ni->itype.index.block_size & (ni->itype.index.block_size - 1)) {
+	if (!is_power_of_2(ni->itype.index.block_size)) {
 		ntfs_error(vi->i_sb, "Index block size (%u) is not a power of "
 				"two.", ni->itype.index.block_size);
 		goto unm_err_out;
diff --git a/fs/ntfs/logfile.c b/fs/ntfs/logfile.c
index acfed32..00b2d02 100644
--- a/fs/ntfs/logfile.c
+++ b/fs/ntfs/logfile.c
@@ -26,6 +26,7 @@
 #include <linux/highmem.h>
 #include <linux/buffer_head.h>
 #include <linux/bitops.h>
+#include <linux/log2.h>
 
 #include "attrib.h"
 #include "aops.h"
@@ -63,9 +64,8 @@ static bool ntfs_check_restart_page_header(struct inode *vi,
 	logfile_log_page_size = le32_to_cpu(rp->log_page_size);
 	if (logfile_system_page_size < NTFS_BLOCK_SIZE ||
 			logfile_log_page_size < NTFS_BLOCK_SIZE ||
-			logfile_system_page_size &
-			(logfile_system_page_size - 1) ||
-			logfile_log_page_size & (logfile_log_page_size - 1)) {
+			!is_power_of_2(logfile_system_page_size) ||
+			!is_power_of_2(logfile_log_page_size)) {
 		ntfs_error(vi->i_sb, "$LogFile uses unsupported page size.");
 		return false;
 	}

-- 
Vignesh Babu BM 
_____________________________________________________________ 
"Why is it that every time I'm with you, makes me believe in magic?"

