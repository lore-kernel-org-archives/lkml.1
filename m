Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbXLXALB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbXLXALB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 19:11:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbXLXAKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 19:10:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:36145 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757673AbXLXAKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 19:10:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=qz6/5P+VmxyA4cFNDvkHIH3utiT+aZNMDt/YVOaWtCfmnmJdZB0SytPh3pc+YCHWUDCtYLJ+Skmmb3jHwxLFBh9TdQz7c2+XPnDS0v/igfiM3oQ/IGrqJGI2MsgGVJnFH6DuPtr+hro26fZivYO082XSIOBhhUWZOvLCH7lMs2A=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 4/6] udf: check if udf_load_logicalvol failed
Date: Mon, 24 Dec 2007 01:10:20 +0100
Message-Id: <1198455022-27674-5-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198455022-27674-1-git-send-email-marcin.slusarz@gmail.com>
References: <1198455022-27674-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

udf_load_logicalvol may fail eg in out of memory conditions - check it
and propagate error further

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
CC: Christoph Hellwig <hch@infradead.org>
---
 fs/udf/super.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 0ea34c5..f138309 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1183,6 +1183,7 @@ static int udf_process_sequence(struct super_block *sb, long block,
 	uint32_t vdsn;
 	uint16_t ident;
 	long next_s = 0, next_e = 0;
+	int ret;
 
 	memset(vds, 0, sizeof(struct udf_vds_record) * VDS_POS_LENGTH);
 
@@ -1258,7 +1259,11 @@ static int udf_process_sequence(struct super_block *sb, long block,
 			if (i == VDS_POS_PRIMARY_VOL_DESC) {
 				udf_load_pvoldesc(sb, bh);
 			} else if (i == VDS_POS_LOGICAL_VOL_DESC) {
-				udf_load_logicalvol(sb, bh, fileset); /* TODO: check return value */
+				ret = udf_load_logicalvol(sb, bh, fileset);
+				if (ret != 0) {
+					brelse(bh);
+					return ret;
+				}
 			} else if (i == VDS_POS_PARTITION_DESC) {
 				struct buffer_head *bh2 = NULL;
 				if (udf_load_partdesc(sb, bh)) {
-- 
1.5.3.4

