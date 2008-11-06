Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbYKFJRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbYKFJRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 04:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbYKFJR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 04:17:28 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:54051 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbYKFJR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 04:17:27 -0500
X-IronPort-AV: E=Sophos;i="4.33,556,1220241600"; 
   d="scan'208";a="62142918"
From: Bryan Wu <cooloney@kernel.org>
To: laurent.pinchart@skynet.be, linux-uvc-devel@lists.berlios.de,
       video4linux-list@redhat.com
Cc: linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] Video/UVC: Port mainlined uvc video driver to NOMMU
Date: Thu,  6 Nov 2008 17:18:50 +0800
Message-Id: <1225963130-6784-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Add NOMMU mmap support.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/media/video/uvc/uvc_v4l2.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 758dfef..2237f5e 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -1050,6 +1050,7 @@ static int uvc_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
 			break;
 	}
 
+#ifdef CONFIG_MMU
 	if (i == video->queue.count || size != video->queue.buf_size) {
 		ret = -EINVAL;
 		goto done;
@@ -1071,7 +1072,20 @@ static int uvc_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
 		addr += PAGE_SIZE;
 		size -= PAGE_SIZE;
 	}
+#else
+	if (i == video->queue.count ||
+		PAGE_ALIGN(size) != video->queue.buf_size) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	vma->vm_flags |= VM_IO | VM_MAYSHARE; /* documentation/nommu-mmap.txt */
+
+	addr = (unsigned long)video->queue.mem + buffer->buf.m.offset;
 
+	vma->vm_start = addr;
+	vma->vm_end = addr +  video->queue.buf_size;
+#endif
 	vma->vm_ops = &uvc_vm_ops;
 	vma->vm_private_data = buffer;
 	uvc_vm_open(vma);
-- 
1.5.6.3
