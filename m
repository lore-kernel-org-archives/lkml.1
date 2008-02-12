Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbYBLXJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbYBLXJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:09:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759533AbYBLXIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:08:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:4852 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269AbYBLXIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:08:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=voRGPli1Hb6OHIyofwJKkDJyfSxj1idhQbyQpjnh0lcTCYXhTP7GT/kEUklzMujAVMTV7+Rq+mySQ4i3r4n5EGPNwFNXCRNj6a4kpRE+h1qGyef3wIBSkCWIo2llrmx0cyfg9eQTOKMW1mKVaX0BrLT4pzUkzrcwu1aBRmq48VE=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH] hfs/hfsplus: be*_add_cpu conversion
Date: Wed, 13 Feb 2008 00:06:11 +0100
Message-Id: <1202857582-15450-7-git-send-email-marcin.slusarz@gmail.com>
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
 fs/hfs/mdb.c       |    2 +-
 fs/hfsplus/super.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/hfs/mdb.c b/fs/hfs/mdb.c
index b4651e1..36ca2e1 100644
--- a/fs/hfs/mdb.c
+++ b/fs/hfs/mdb.c
@@ -215,7 +215,7 @@ int hfs_mdb_get(struct super_block *sb)
 		attrib &= cpu_to_be16(~HFS_SB_ATTRIB_UNMNT);
 		attrib |= cpu_to_be16(HFS_SB_ATTRIB_INCNSTNT);
 		mdb->drAtrb = attrib;
-		mdb->drWrCnt = cpu_to_be32(be32_to_cpu(mdb->drWrCnt) + 1);
+		be32_add_cpu(&mdb->drWrCnt, 1);
 		mdb->drLsMod = hfs_mtime();
 
 		mark_buffer_dirty(HFS_SB(sb)->mdb_bh);
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index b0f9ad3..068523b 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -423,7 +423,7 @@ static int hfsplus_fill_super(struct super_block *sb, void *data, int silent)
 	 */
 	vhdr->last_mount_vers = cpu_to_be32(HFSP_MOUNT_VERSION);
 	vhdr->modify_date = hfsp_now2mt();
-	vhdr->write_count = cpu_to_be32(be32_to_cpu(vhdr->write_count) + 1);
+	be32_add_cpu(&vhdr->write_count, 1);
 	vhdr->attributes &= cpu_to_be32(~HFSPLUS_VOL_UNMNT);
 	vhdr->attributes |= cpu_to_be32(HFSPLUS_VOL_INCNSTNT);
 	mark_buffer_dirty(HFSPLUS_SB(sb).s_vhbh);
-- 
1.5.3.7

