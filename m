Return-Path: <linux-kernel-owner+w=401wt.eu-S1751767AbZEXEXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbZEXEXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 00:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbZEXEXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 00:23:39 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:4276 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbZEXEXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 00:23:39 -0400
Date: Sun, 24 May 2009 01:20:35 -0300
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [RFC PATCH] bio-integrity: Copy bip_buf and bip_size in
	bio_integrity_clone()
Message-ID: <20090524042035.GF1376@blitiri.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2008-03-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

I'm trying to add bio-integrity support to a device-mapper target I posted
a couple of days ago (http://lkml.org/lkml/2009/5/21/235).

While at it, I found that bio_integrity_clone() does not clone neither bip_buf
nor bip_size, which already copies the bvec, which should have the same data
because it's allocated in bio_integrity_prep().


>From a quick grep, it seems they're only used inside fs/bio-integrity.c, and
through there they get passed to the functions each block device registered
for integrity verification and generation, and used in bio_integrity_tag().

Also, bio_integrity_free() already takes into account that and does not free
bip_buf if it's freeing a cloned bio.


Is there any reason I'm missing why they shouldn't be copied in
bio_integrity_clone(), as illustrated in the following patch?

Thanks a lot,
		Alberto


------- 8< ------- 8< ------- 8< ------- 8< ------- 8< ------- 8< -------

From: Alberto Bertogli <albertito@blitiri.com.ar>
Date: Sun, 24 May 2009 01:02:08 -0300
Subject: [PATCH] bio-integrity: Copy bip_buf and bip_size in bio_integrity_clone()

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
---
 fs/bio-integrity.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 31c46a2..fa9457d 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -682,6 +682,9 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp_mask)
 	if (bip == NULL)
 		return -EIO;
 
+	bip->bip_buf = bip_src->bip_buf;
+	bip->bip_size = bip_src->bip_size;
+
 	memcpy(bip->bip_vec, bip_src->bip_vec,
 	       bip_src->bip_vcnt * sizeof(struct bio_vec));
 
-- 
1.6.2.2.646.gb214

