Return-Path: <linux-kernel-owner+w=401wt.eu-S932252AbYCGJWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbYCGJWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762943AbYCGJN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:13:28 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:48545 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762939AbYCGJNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:13:24 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200803071013.837692778@firstfloor.org>
In-Reply-To: <200803071013.837692778@firstfloor.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/7] Convert a few direct bounce_gfp users over to the blk_* wrappers
Message-Id: <20080307091321.EB68F1B419C@basil.firstfloor.org>
Date: Fri,  7 Mar 2008 10:13:21 +0100 (CET)
X-OriginalArrivalTime: 07 Mar 2008 09:06:51.0705 (UTC) FILETIME=[95071A90:01C88032]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 block/scsi_ioctl.c |    6 ++++--
 fs/bio.c           |    2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

Index: linux/block/scsi_ioctl.c
===================================================================
--- linux.orig/block/scsi_ioctl.c
+++ linux/block/scsi_ioctl.c
@@ -433,10 +433,12 @@ int sg_scsi_ioctl(struct file *file, str
 
 	bytes = max(in_len, out_len);
 	if (bytes) {
-		buffer = kzalloc(bytes, q->bounce_gfp | GFP_USER| __GFP_NOWARN);
+		/* RED-PEN GFP_NOIO really needed? */
+		buffer = blk_kmalloc(q, bytes,
+				GFP_NOIO | GFP_USER | __GFP_NOWARN);
 		if (!buffer)
 			return -ENOMEM;
-
+		memset(buffer, 0, bytes);
 	}
 
 	rq = blk_get_request(q, in_len ? WRITE : READ, __GFP_WAIT);
Index: linux/fs/bio.c
===================================================================
--- linux.orig/fs/bio.c
+++ linux/fs/bio.c
@@ -545,7 +545,7 @@ struct bio *bio_copy_user(struct request
 		if (bytes > len)
 			bytes = len;
 
-		page = alloc_page(q->bounce_gfp | GFP_KERNEL);
+		page = blk_alloc_pages(q, GFP_KERNEL, PAGE_SIZE);
 		if (!page) {
 			ret = -ENOMEM;
 			break;
