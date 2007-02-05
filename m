Return-Path: <linux-kernel-owner+w=401wt.eu-S932830AbXBEOWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830AbXBEOWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932834AbXBEOWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:22:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932830AbXBEOW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:22:26 -0500
Subject: [GFS2] Add writepages for "data=writeback" mounts [26/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:30:31 +0000
Message-Id: <1170685831.11001.323.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From dd520e32b5028d05bbe034715c82eaf938d13d0a Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Mon, 15 Jan 2007 13:52:17 +0000
Subject: [PATCH] [GFS2] Add writepages for "data=writeback" mounts

It occurred to me that although a gfs2 specific writepages for ordered
writes and journaled data would be tricky, by hooking writepages only
for "data=writeback" mounts we could take advantage of not needing
buffer heads (we don't use them on the read side, nor have we for some
time) and create much larger I/Os for the block layer.

Using blktrace both before and after, its possible to see that for large
I/Os, most of the requests generated through writepages are now 1024
sectors after this patch is applied as opposed to 8 sectors before.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 37bfeb9..9ddf975 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -16,6 +16,7 @@
 #include <linux/pagevec.h>
 #include <linux/mpage.h>
 #include <linux/fs.h>
+#include <linux/writeback.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/lm_interface.h>
 
@@ -157,6 +158,31 @@ out_ignore:
 }
 
 /**
+ * gfs2_writepages - Write a bunch of dirty pages back to disk
+ * @mapping: The mapping to write
+ * @wbc: Write-back control
+ *
+ * For journaled files and/or ordered writes this just falls back to the
+ * kernel's default writepages path for now. We will probably want to change
+ * that eventually (i.e. when we look at allocate on flush).
+ *
+ * For the data=writeback case though we can already ignore buffer heads
+ * and write whole extents at once. This is a big reduction in the
+ * number of I/O requests we send and the bmap calls we make in this case.
+ */
+int gfs2_writepages(struct address_space *mapping, struct writeback_control *wbc)
+{
+	struct inode *inode = mapping->host;
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+
+	if (sdp->sd_args.ar_data == GFS2_DATA_WRITEBACK && !gfs2_is_jdata(ip))
+		return mpage_writepages(mapping, wbc, gfs2_get_block_noalloc);
+
+	return generic_writepages(mapping, wbc);
+}
+
+/**
  * stuffed_readpage - Fill in a Linux page with stuffed file data
  * @ip: the inode
  * @page: the page
@@ -757,6 +783,7 @@ out:
 
 const struct address_space_operations gfs2_file_aops = {
 	.writepage = gfs2_writepage,
+	.writepages = gfs2_writepages,
 	.readpage = gfs2_readpage,
 	.readpages = gfs2_readpages,
 	.sync_page = block_sync_page,
-- 
1.4.4.2



