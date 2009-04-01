Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbZDALFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbZDALFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbZDALE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:04:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:35188 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbZDALE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:04:57 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/8] block: fix SG_IO vector request data length handling
Date: Wed,  1 Apr 2009 20:04:38 +0900
Message-Id: <1238583884-13517-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1238583884-13517-1-git-send-email-tj@kernel.org>
References: <1238583884-13517-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 11:04:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix SG_IO behavior such that it matches the documentation

SG_IO howto says that if ->dxfer_len and sum of iovec disagress, the
shorter one wins.  However, the current implementation returns -EINVAL
for such cases.  Trim iovc if it's longer than ->dxfer_len.

This patch uses iov_*() helpers which take struct iovec * by casting
struct sg_iovec * to it.  sg_iovec is always identical to iovec and
this will be further cleaned up with later patches.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/scsi_ioctl.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 626ee27..c8e8868 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -288,6 +288,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 
 	if (hdr->iovec_count) {
 		const int size = sizeof(struct sg_iovec) * hdr->iovec_count;
+		size_t iov_data_len;
 		struct sg_iovec *iov;
 
 		iov = kmalloc(size, GFP_KERNEL);
@@ -302,8 +303,18 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 			goto out;
 		}
 
+		/* SG_IO howto says that the shorter of the two wins */
+		iov_data_len = iov_length((struct iovec *)iov,
+					  hdr->iovec_count);
+		if (hdr->dxfer_len < iov_data_len) {
+			hdr->iovec_count = iov_shorten((struct iovec *)iov,
+						       hdr->iovec_count,
+						       hdr->dxfer_len);
+			iov_data_len = hdr->dxfer_len;
+		}
+
 		ret = blk_rq_map_user_iov(q, rq, NULL, iov, hdr->iovec_count,
-					  hdr->dxfer_len, GFP_KERNEL);
+					  iov_data_len, GFP_KERNEL);
 		kfree(iov);
 	} else if (hdr->dxfer_len)
 		ret = blk_rq_map_user(q, rq, NULL, hdr->dxferp, hdr->dxfer_len,
-- 
1.6.0.2

