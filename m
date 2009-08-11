Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbZHKBQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbZHKBQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 21:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZHKBQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 21:16:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:49681 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZHKBQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 21:16:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=gECMc4Kwm3sRcGxJWkXa7S6gGO5+zJrgGa8jU1iSLvId73nxChM6awrK/OTLjPfBw/
         dXHefZPrJmNjfVcNaC5KhwB1/clyS08JzcF1Csuo+oIQFqsZN6MTI/bnBAmuVN9StbYa
         s8K7xMOgVLSZfVCJASocLzCqfVBrOlsFXCTsk=
Date: Tue, 11 Aug 2009 09:25:24 +0800
From: JiSheng Zhang <jszhang3@gmail.com>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Artem.Bityutskiy@nokia.com,
       adrian.hunter@nokia.com, rmk@arm.linux.org.uk, dwmw2@infradead.org
Subject: [PATCH] UBI: Fix allocation of volume table
Message-ID: <20090811092524.12e4494b@ustc>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We can't use vmalloc for the buffer used for volume table for some NAND
or NOR drivers may pass the buffer to DMA. And the volume table size
a.k.a vtbl_size is small so we can use kmalloc or kzalloc for it instead.

Signed-off-by: JiSheng Zhang <jszhang3@gmail.com>
---
 drivers/mtd/ubi/vtbl.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/ubi/vtbl.c b/drivers/mtd/ubi/vtbl.c
index 1afc61e..9dcc7ba 100644
--- a/drivers/mtd/ubi/vtbl.c
+++ b/drivers/mtd/ubi/vtbl.c
@@ -424,12 +424,11 @@ static struct ubi_vtbl_record *process_lvol(struct ubi_device *ubi,
 
 	/* Read both LEB 0 and LEB 1 into memory */
 	ubi_rb_for_each_entry(rb, seb, &sv->root, u.rb) {
-		leb[seb->lnum] = vmalloc(ubi->vtbl_size);
+		leb[seb->lnum] = kzalloc(ubi->vtbl_size, GFP_KERNEL);
 		if (!leb[seb->lnum]) {
 			err = -ENOMEM;
 			goto out_free;
 		}
-		memset(leb[seb->lnum], 0, ubi->vtbl_size);
 
 		err = ubi_io_read_data(ubi, leb[seb->lnum], seb->pnum, 0,
 				       ubi->vtbl_size);
@@ -515,10 +514,9 @@ static struct ubi_vtbl_record *create_empty_lvol(struct ubi_device *ubi,
 	int i;
 	struct ubi_vtbl_record *vtbl;
 
-	vtbl = vmalloc(ubi->vtbl_size);
+	vtbl = kzalloc(ubi->vtbl_size, GFP_KERNEL);
 	if (!vtbl)
 		return ERR_PTR(-ENOMEM);
-	memset(vtbl, 0, ubi->vtbl_size);
 
 	for (i = 0; i < ubi->vtbl_slots; i++)
 		memcpy(&vtbl[i], &empty_vtbl_record, UBI_VTBL_RECORD_SIZE);
-- 
1.6.3.3




