Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbYAFAoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbYAFAoz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 19:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbYAFAop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 19:44:45 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:60007 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256AbYAFAoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 19:44:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=sdhpGyDcgQs6s37FJ0SE2GCk7P3E7KD7RfQcei9VsMvmnE9OkLvZe8/DvQDiyMghiAh2NNuIYWVtrJ7/y7eLZwXrMnqeSZ5ENNkoU56VvRZYOgJ4Z2xPKlu5yUTOKC8gcOiQBQGZ0in4DJPYW/aHvlv+14SvcfbojuEZWTFPLNM=
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH] udf: check if udf_load_logicalvol failed
Date: Sun,  6 Jan 2008 01:44:33 +0100
Message-Id: <1199580275-2487-5-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199580275-2487-1-git-send-email-marcin.slusarz@gmail.com>
References: <1199580275-2487-1-git-send-email-marcin.slusarz@gmail.com>
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
index 3f5b632..c09e968 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1188,6 +1188,7 @@ static int udf_process_sequence(struct super_block *sb, long block,
 	uint32_t vdsn;
 	uint16_t ident;
 	long next_s = 0, next_e = 0;
+	int ret;
 
 	memset(vds, 0, sizeof(struct udf_vds_record) * VDS_POS_LENGTH);
 
@@ -1263,7 +1264,11 @@ static int udf_process_sequence(struct super_block *sb, long block,
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
1.5.3.7

