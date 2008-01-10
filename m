Return-Path: <linux-kernel-owner+w=401wt.eu-S1759174AbYAJWG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbYAJWG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbYAJWGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:06:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:33091 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225AbYAJWGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:06:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=nkRTeveFNXzUdDktMALH3NZXhGsEXBWi+X/XEf2mnDLBrw6RUSzSxVsRrqZ1rOkYFnojofXadAszpOXrmq8bISr+s3Ot3jnbwtu50ERUR5OkleHZMukoq3/AQATSHBjh0WsK4CNby2bJen+IO9z5jPbbyMolqXRdGZ37Q3SjGzA=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 04/16] udf: check if udf_load_logicalvol failed
Date: Thu, 10 Jan 2008 23:06:20 +0100
Message-Id: <1200002792-8449-5-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com>
References: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com>
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
 fs/udf/super.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 3f5b632..9257796 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1263,7 +1263,10 @@ static int udf_process_sequence(struct super_block *sb, long block,
 			if (i == VDS_POS_PRIMARY_VOL_DESC) {
 				udf_load_pvoldesc(sb, bh);
 			} else if (i == VDS_POS_LOGICAL_VOL_DESC) {
-				udf_load_logicalvol(sb, bh, fileset); /* TODO: check return value */
+				if (udf_load_logicalvol(sb, bh, fileset)) {
+					brelse(bh);
+					return 1;
+				}
 			} else if (i == VDS_POS_PARTITION_DESC) {
 				struct buffer_head *bh2 = NULL;
 				if (udf_load_partdesc(sb, bh)) {
-- 
1.5.3.7

