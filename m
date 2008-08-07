Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbYHGCES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbYHGCES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 22:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbYHGCDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 22:03:43 -0400
Received: from ixia01.ro.gtsce.net ([212.146.94.66]:31984 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753281AbYHGCDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 22:03:42 -0400
From: Octavian Purdila <opurdila@ixiacom.com>
To: linux-kernel@vger.kernel.org
Cc: Octavian Purdila <opurdila@ixiacom.com>
Subject: [RFC] [PATCH] splice: add ->splice_read support for /dev/zero
Date: Thu,  7 Aug 2008 05:00:55 +0300
Message-Id: <1218074455-17901-1-git-send-email-opurdila@ixiacom.com>
X-Mailer: git-send-email 1.5.6.2
X-OriginalArrivalTime: 07 Aug 2008 02:06:09.0851 (UTC) FILETIME=[28E998B0:01C8F832]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Useful for testing.

Preallocating the zero page is simpler and faster with the relatively
small (?) drawback of using an extra page of memory.

Maybe when CONFIG_EMBEDED is selected we can switch to dynamically
allocating the page?

Signed-off-by: Octavian Purdila <opurdila@ixiacom.com>
---
 drivers/char/mem.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 934ffaf..fb33f9a 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -737,6 +737,69 @@ static int mmap_zero(struct file * file, struct vm_area_struct * vma)
 	return 0;
 }
 
+static void zero_pipe_buf_release(struct pipe_inode_info *pipe,
+				  struct pipe_buffer *buf)
+{
+}
+
+static void zero_pipe_buf_get(struct pipe_inode_info *pipe,
+				struct pipe_buffer *buf)
+{
+}
+
+static int zero_pipe_buf_steal(struct pipe_inode_info *pipe,
+			       struct pipe_buffer *buf)
+{
+	return 1;
+}
+
+static struct pipe_buf_operations zero_pipe_buf_ops = {
+	.can_merge = 0,
+	.map = generic_pipe_buf_map,
+	.unmap = generic_pipe_buf_unmap,
+	.confirm = generic_pipe_buf_confirm,
+	.release = zero_pipe_buf_release,
+	.steal = zero_pipe_buf_steal,
+	.get = zero_pipe_buf_get,
+};
+
+static void zero_spd_release(struct splice_pipe_desc *spd, unsigned int nr)
+{
+}
+
+static struct page *zero_page;
+
+ssize_t splice_read_zero(struct file *in, loff_t *ppos,
+			 struct pipe_inode_info *pipe, size_t size,
+			 unsigned int flags)
+{
+	struct partial_page partial[PIPE_BUFFERS];
+	struct page *pages[PIPE_BUFFERS];
+	struct splice_pipe_desc spd = {
+		.pages = pages,
+		.partial = partial,
+		.flags = flags,
+		.ops = &zero_pipe_buf_ops,
+		.spd_release = zero_spd_release
+	};
+	int last_page_len = PAGE_SIZE, i;
+
+	spd.nr_pages = size/PAGE_SIZE;
+	if (spd.nr_pages > PIPE_BUFFERS)
+		spd.nr_pages = PIPE_BUFFERS;
+	if (size < PAGE_SIZE*PIPE_BUFFERS)
+		last_page_len = size % PAGE_SIZE;
+
+	for (i = 0; i < spd.nr_pages; i++) {
+		pages[i] = zero_page;
+		partial[i].len = PAGE_SIZE;
+		partial[i].offset = 0;
+	}
+	partial[spd.nr_pages].len = last_page_len;
+
+	return splice_to_pipe(pipe, &spd);
+}
+
 static ssize_t write_full(struct file * file, const char __user * buf,
 			  size_t count, loff_t *ppos)
 {
@@ -839,6 +902,7 @@ static const struct file_operations zero_fops = {
 	.read		= read_zero,
 	.write		= write_zero,
 	.mmap		= mmap_zero,
+	.splice_read 	= splice_read_zero,
 };
 
 /*
@@ -974,6 +1038,10 @@ static int __init chr_dev_init(void)
 	int i;
 	int err;
 
+	zero_page = alloc_pages(GFP_KERNEL | __GFP_ZERO, 0);
+	if (!zero_page)
+		return -ENOMEM;
+
 	err = bdi_init(&zero_bdi);
 	if (err)
 		return err;
-- 
1.5.6.2

