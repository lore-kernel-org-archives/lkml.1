Return-Path: <linux-kernel-owner+w=401wt.eu-S1759219AbYBLXI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219AbYBLXI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758716AbYBLXIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:08:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:4852 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758707AbYBLXIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:08:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=YecAY7u2rYqBp59OuKbz4Ypq0teEJGkYwK4GdwAOAfFuZR2RR4sUd1LY2Yo1k3ey/zPY59MsyxJuxr2ipXEU9Y3Sd1/Pk60X/Oab7y/WpOefBFLmu0PsXCR/8aZp1A6gFgJARjDd9oaIoAqZ3yHB1AKCS6RMmfXt1LNOZMWRNTw=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH] affs: be*_add_cpu conversion
Date: Wed, 13 Feb 2008 00:06:09 +0100
Message-Id: <1202857582-15450-5-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
big_endian_variable = cpu_to_beX(beX_to_cpu(big_endian_variable) +
					expression_in_cpu_byteorder);
with:
	beX_add_cpu(&big_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 fs/affs/file.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index 6e0c939..95b48af 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -543,7 +543,7 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
 		if (boff + tmp > bsize || tmp > bsize)
 			BUG();
 		memset(AFFS_DATA(bh) + boff, 0, tmp);
-		AFFS_DATA_HEAD(bh)->size = cpu_to_be32(be32_to_cpu(AFFS_DATA_HEAD(bh)->size) + tmp);
+		be32_add_cpu(&AFFS_DATA_HEAD(bh)->size, tmp);
 		affs_fix_checksum(sb, bh);
 		mark_buffer_dirty_inode(bh, inode);
 		size += tmp;
@@ -686,7 +686,7 @@ static int affs_write_end_ofs(struct file *file, struct address_space *mapping,
 		if (boff + tmp > bsize || tmp > bsize)
 			BUG();
 		memcpy(AFFS_DATA(bh) + boff, data + from, tmp);
-		AFFS_DATA_HEAD(bh)->size = cpu_to_be32(be32_to_cpu(AFFS_DATA_HEAD(bh)->size) + tmp);
+		be32_add_cpu(&AFFS_DATA_HEAD(bh)->size, tmp);
 		affs_fix_checksum(sb, bh);
 		mark_buffer_dirty_inode(bh, inode);
 		written += tmp;
-- 
1.5.3.7

