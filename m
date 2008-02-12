Return-Path: <linux-kernel-owner+w=401wt.eu-S1763902AbYBLXM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763902AbYBLXM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762285AbYBLXLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:11:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:8053 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762262AbYBLXLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:11:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=FS80+wPvFQEFT/QtXNFNJQxFvAhbqw7cbPOrrWAaEXLBqatfUF4+/UJR3eOTGHjS7bKxLoIvjYYcpw87zK9ngpIb9ZVbs+7PcfZTPLUsv6cfdFe1x+Hy5fOw82xp3vYj+2iXSZWsaA/QMTbmF54EbUwkAUiXNERZYhJ9L9KlMRs=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH] quota: le*_add_cpu conversion
Date: Wed, 13 Feb 2008 00:06:19 +0100
Message-Id: <1202857582-15450-15-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/quota_v2.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/quota_v2.c b/fs/quota_v2.c
index c519a58..a9f9eef 100644
--- a/fs/quota_v2.c
+++ b/fs/quota_v2.c
@@ -303,7 +303,7 @@ static uint find_free_dqentry(struct dquot *dquot, int *err)
 			printk(KERN_ERR "VFS: find_free_dqentry(): Can't remove block (%u) from entry free list.\n", blk);
 			goto out_buf;
 		}
-	dh->dqdh_entries = cpu_to_le16(le16_to_cpu(dh->dqdh_entries)+1);
+	le16_add_cpu(&dh->dqdh_entries, 1);
 	memset(&fakedquot, 0, sizeof(struct v2_disk_dqblk));
 	/* Find free structure in block */
 	for (i = 0; i < V2_DQSTRINBLK && memcmp(&fakedquot, ddquot+i, sizeof(struct v2_disk_dqblk)); i++);
@@ -445,7 +445,7 @@ static int free_dqentry(struct dquot *dquot, uint blk)
 		goto out_buf;
 	}
 	dh = (struct v2_disk_dqdbheader *)buf;
-	dh->dqdh_entries = cpu_to_le16(le16_to_cpu(dh->dqdh_entries)-1);
+	le16_add_cpu(&dh->dqdh_entries, -1);
 	if (!le16_to_cpu(dh->dqdh_entries)) {	/* Block got free? */
 		if ((ret = remove_free_dqentry(sb, type, buf, blk)) < 0 ||
 		    (ret = put_free_dqblk(sb, type, buf, blk)) < 0) {
-- 
1.5.3.7

