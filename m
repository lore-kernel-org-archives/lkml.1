Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbZEHHKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbZEHHKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 03:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZEHHKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 03:10:35 -0400
Received: from mail1.asahi-net.or.jp ([202.224.39.197]:17251 "EHLO
	mail1.asahi-net.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbZEHHKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 03:10:34 -0400
X-Greylist: delayed 1522 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 May 2009 03:10:34 EDT
Message-ID: <4A03D4F2.1070904@epsilou.com>
Date: Fri, 08 May 2009 15:45:06 +0900
From: Kazuhisa Ichikawa <ki@epsilou.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: axboe@kernel.dk
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] block: fix the bio_vec array index out-of-bounds test
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kazuhisa Ichikawa <ki@epsilou.com>

Current bio_vec array index out-of-bounds test within 
__end_that_request_first() does not seem correct. 
It checks bio->bi_idx against bio->bi_vcnt, but the subsequent code 
uses idx (which is, bio->bi_idx + next_idx) as the array index into 
bio_vec array. This means that the test really make sense only at 
the first iteration of !(nr_bytes >=bio->bi_size) case (when next_idx 
== zero). Fix this by replacing bio->bi_idx with idx.
(This patch applies to 2.6.30-rc4.)

Signed-off-by: Kazuhisa Ichikawa <ki@epsilou.com>
---

--- linux-2.6.30-rc4/block/blk-core.c.ORIG	2009-05-08 00:00:10.000000000 +0900
+++ linux-2.6.30-rc4/block/blk-core.c	2009-05-08 00:00:10.000000000 +0900
@@ -1768,10 +1768,10 @@ static int __end_that_request_first(stru
 		} else {
 			int idx = bio->bi_idx + next_idx;
 
-			if (unlikely(bio->bi_idx >= bio->bi_vcnt)) {
+			if (unlikely(idx >= bio->bi_vcnt)) {
 				blk_dump_rq_flags(req, "__end_that");
 				printk(KERN_ERR "%s: bio idx %d >= vcnt %d\n",
-				       __func__, bio->bi_idx, bio->bi_vcnt);
+				       __func__, idx, bio->bi_vcnt);
 				break;
 			}
 


