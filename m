Return-Path: <linux-kernel-owner+w=401wt.eu-S1758878AbXFLHC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbXFLHC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756238AbXFLHAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:00:37 -0400
Received: from brick.kernel.dk ([80.160.20.94]:13575 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbXFLHAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:00:32 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 12/18] pipe: allow passing around of ops private pointer
Date: Tue, 12 Jun 2007 08:58:08 +0200
Message-Id: <11816314952438-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.1.174.gcd03
In-Reply-To: <11816314942627-git-send-email-jens.axboe@oracle.com>
References: <11816314942627-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

relay needs this for proper consumption handling, and the network
receive support needs it as well to lookup the sk_buff on pipe
release.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/splice.c               |    1 +
 include/linux/pipe_fs_i.h |    1 +
 include/linux/splice.h    |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 15d3f4b..ff62ac9 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -184,6 +184,7 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
 			buf->page = spd->pages[page_nr];
 			buf->offset = spd->partial[page_nr].offset;
 			buf->len = spd->partial[page_nr].len;
+			buf->private = spd->partial[page_nr].private;
 			buf->ops = spd->ops;
 			if (spd->flags & SPLICE_F_GIFT)
 				buf->flags |= PIPE_BUF_FLAG_GIFT;
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 7ba228d..4409167 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -14,6 +14,7 @@ struct pipe_buffer {
 	unsigned int offset, len;
 	const struct pipe_buf_operations *ops;
 	unsigned int flags;
+	unsigned long private;
 };
 
 struct pipe_inode_info {
diff --git a/include/linux/splice.h b/include/linux/splice.h
index b3f1528..1a1182b 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -41,6 +41,7 @@ struct splice_desc {
 struct partial_page {
 	unsigned int offset;
 	unsigned int len;
+	unsigned long private;
 };
 
 /*
-- 
1.5.2.1.174.gcd03

