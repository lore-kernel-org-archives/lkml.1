Return-Path: <linux-kernel-owner+w=401wt.eu-S1757169AbZKRODb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbZKRODb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757155AbZKRODb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:03:31 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51777 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142AbZKRODa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:03:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=Tmtn4lIRp5xzhd+l9MR1oGi2+OaknlQMrql97+cqxC37+KdIA5x9Y7Ka1a98ujIdNR
         gjbhltS4dyLij/KHb2N6kZxaoMDzWK7+uTKOn+f24qcHVb7chDzFLcyEMLn7RaGC2z58
         KfvKvArvSy/XnMAoUTb915nMwXhCJdnD4e2fo=
Date: Wed, 18 Nov 2009 17:08:10 +0300
From: Ilya Loginov <isloginov@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mtd: fix mtd_blkdevs problem with caches on some
 architectures (2.6.31)
Message-Id: <20091118170810.2bb9cd54.isloginov@gmail.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Mtdblock driver doesn't call flush_dcache_page for pages in request.
	This may cause problem on architectures where icache doesn't fill from
dcache or with dcache aliases.
	This patch resolves this issue.

Signed-off-by: Ilya Loginov <isloginov@gmail.com>
---
mtd_blkdevs.c |    7 +++++++
1 file changed, 7 insertions(+)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 7baba40..59d5d25 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -46,6 +46,8 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 {
 	unsigned long block, nsect;
 	char *buf;
+	struct req_iterator iter;
+	struct bio_vec *bvec;
 
 	block = blk_rq_pos(req) << 9 >> tr->blkshift;
 	nsect = blk_rq_cur_bytes(req) >> tr->blkshift;
@@ -68,12 +70,17 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 		for (; nsect > 0; nsect--, block++, buf += tr->blksize)
 			if (tr->readsect(dev, block, buf))
 				return -EIO;
+		rq_for_each_segment(bvec, req, iter)
+			flush_dcache_page(bvec->bv_page);
 		return 0;
 
 	case WRITE:
 		if (!tr->writesect)
 			return -EIO;
 
+		rq_for_each_segment(bvec, req, iter)
+			flush_dcache_page(bvec->bv_page);
+		
 		for (; nsect > 0; nsect--, block++, buf += tr->blksize)
 			if (tr->writesect(dev, block, buf))
 				return -EIO;
