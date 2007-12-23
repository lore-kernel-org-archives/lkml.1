Return-Path: <linux-kernel-owner+w=401wt.eu-S1758133AbXLWB4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133AbXLWB4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757803AbXLWB4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:56:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757373AbXLWB4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:56:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=ZJH4wu+hiUNBWCb023C1m3HR5EPWquH9fLWkZHkukXNZ8laZlD+pPD4aBLiPNHd42j30STBtAoM1smSfFHUrATUWDzqdy0hDGDZ01BWQmco9QmpYd86LQet8HVIPYlqBjMS3xylAScp7rqQLDfa1JbpmJyQH6SoFYdqbzt5DtEo=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 19/24] udf: check if udf_load_logicalvol failed
Date: Sun, 23 Dec 2007 02:51:09 +0100
Message-Id: <1198374674-12128-20-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

udf_load_logicalvol may fail eg in out of memory conditions - check it
and propagate error further

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
---
 fs/udf/super.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 4aef612..f8c5794 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1141,6 +1141,7 @@ static int udf_process_sequence(struct super_block *sb, long block,
 	uint32_t vdsn;
 	uint16_t ident;
 	long next_s = 0, next_e = 0;
+	int ret;
 
 	memset(vds, 0, sizeof(struct udf_vds_record) * VDS_POS_LENGTH);
 
@@ -1216,7 +1217,11 @@ static int udf_process_sequence(struct super_block *sb, long block,
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

