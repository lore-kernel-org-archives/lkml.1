Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbZJZSAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbZJZSAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbZJZSAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:00:44 -0400
Received: from vuizook.err.no ([85.19.221.46]:42564 "EHLO vuizook.err.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578AbZJZSAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:00:43 -0400
From: Mike Hommey <mh@glandium.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Fix generic_block_fiemap for files bigger than 4GB
Date: Mon, 26 Oct 2009 18:24:28 +0100
Message-Id: <1256577868-30484-1-git-send-email-mh@glandium.org>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of an integer overflow on start_blk, various kind of wrong results
would be returned by the generic_block_fiemap handler, such as no extents
when there is a 4GB+ hole at the beginning of the file, or wrong fe_logical
when an extent starts after the first 4GB.

Signed-off-by: Mike Hommey <mh@glandium.org>
---
 fs/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 7b17a14..6c75110 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -254,7 +254,7 @@ int __generic_block_fiemap(struct inode *inode,
 			   u64 len, get_block_t *get_block)
 {
 	struct buffer_head tmp;
-	unsigned int start_blk;
+	unsigned long long start_blk;
 	long long length = 0, map_len = 0;
 	u64 logical = 0, phys = 0, size = 0;
 	u32 flags = FIEMAP_EXTENT_MERGED;
-- 
1.6.5

