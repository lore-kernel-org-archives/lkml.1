Return-Path: <linux-kernel-owner+w=401wt.eu-S1761762AbZATP7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761762AbZATP7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 10:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756258AbZATP7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 10:59:35 -0500
Received: from ns2.suse.de ([195.135.220.15]:57838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbZATP7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 10:59:35 -0500
Message-ID: <4975F653.2000109@suse.de>
Date: Wed, 21 Jan 2009 00:05:39 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Subject: [PATCH 11/20] fs/jfs: return f_fsid for statfs(2), v3
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes jfs return f_fsid info for statfs(2). By Andreas' suggestion, this patch populates
a persistent f_fsid between boots/mounts with help of on-disk uuid record.

Signed-off-by: Coly Li <coly.li@suse.de>
Acked-By: Dave Kleikamp <shaggy@austin.ibm.com>
---
 fs/jfs/super.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index b37d1f7..6ce1aac 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -29,6 +29,7 @@
 #include <linux/posix_acl.h>
 #include <linux/buffer_head.h>
 #include <linux/exportfs.h>
+#include <linux/crc32.h>
 #include <asm/uaccess.h>
 #include <linux/seq_file.h>

@@ -168,7 +169,10 @@ static int jfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_files = maxinodes;
 	buf->f_ffree = maxinodes - (atomic_read(&imap->im_numinos) -
 				    atomic_read(&imap->im_numfree));
-
+	buf->f_fsid.val[0] = (u32)crc32_le(0, sbi->uuid, sizeof(sbi->uuid)/2);
+	buf->f_fsid.val[1] = (u32)crc32_le(0, sbi->uuid + sizeof(sbi->uuid)/2,
+					sizeof(sbi->uuid)/2);
+
 	buf->f_namelen = JFS_NAME_MAX;
 	return 0;
 }

-- 
Coly Li
SuSE Labs





