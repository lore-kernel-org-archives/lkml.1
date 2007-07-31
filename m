Return-Path: <linux-kernel-owner+w=401wt.eu-S941093AbXGaC0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941093AbXGaC0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940518AbXGaCR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:17:58 -0400
Received: from ns2.suse.de ([195.135.220.15]:36070 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940510AbXGaCR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:17:56 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:17:43 +1000
Message-Id: <1070731021743.25427@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 022 of 35] Teach dm-crypt to honour bi_offset and bi_size
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/dm-crypt.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff .prev/drivers/md/dm-crypt.c ./drivers/md/dm-crypt.c
--- .prev/drivers/md/dm-crypt.c	2007-07-31 11:21:03.000000000 +1000
+++ ./drivers/md/dm-crypt.c	2007-07-31 11:21:12.000000000 +1000
@@ -49,6 +49,8 @@ struct convert_context {
 	unsigned int offset_out;
 	unsigned int idx_in;
 	unsigned int idx_out;
+	int len_in;
+	int len_out;
 	sector_t sector;
 	int write;
 };
@@ -326,8 +328,10 @@ crypt_convert_init(struct crypt_config *
 {
 	ctx->bio_in = bio_in;
 	ctx->bio_out = bio_out;
-	ctx->offset_in = 0;
-	ctx->offset_out = 0;
+	ctx->offset_in = bio_in->bi_offset;
+	ctx->offset_out = bio_out->bi_offset;
+	ctx->len_in = bio_in->bi_size;
+	ctx->len_out = bio_out->bi_size;
 	ctx->idx_in = 0;
 	ctx->idx_out = 0;
 	ctx->sector = sector + cc->iv_offset;
@@ -362,12 +366,18 @@ static int crypt_convert(struct crypt_co
 			ctx->offset_in = 0;
 			ctx->idx_in++;
 		}
+		ctx->len_in -= sg_in.length;
+		if (ctx->len_in <= 0)
+			ctx->idx_in = ctx->bio_in->bi_vcnt;
 
 		ctx->offset_out += sg_out.length;
 		if (ctx->offset_out >= bv_out->bv_len) {
 			ctx->offset_out = 0;
 			ctx->idx_out++;
 		}
+		ctx->len_out -= sg_in.length;
+		if (ctx->len_out <= 0)
+			ctx->idx_out = ctx->bio_out->bi_vcnt;
 
 		r = crypt_convert_scatterlist(cc, &sg_out, &sg_in, sg_in.length,
 		                              ctx->write, ctx->sector);
@@ -605,6 +615,8 @@ static void process_write(struct dm_cryp
 
 		ctx.bio_out = clone;
 		ctx.idx_out = 0;
+		ctx.offset_out = clone->bi_offset;
+		ctx.len_out = clone->bi_size;
 
 		if (unlikely(crypt_convert(cc, &ctx) < 0)) {
 			crypt_free_buffer_pages(cc, clone, clone->bi_size);
