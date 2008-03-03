Return-Path: <linux-kernel-owner+w=401wt.eu-S1760441AbYCCSK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760441AbYCCSK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757184AbYCCSJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:09:30 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:35880 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758519AbYCCSJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:09:28 -0500
Date: Mon, 3 Mar 2008 20:07:52 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] mtd/ubi/vtbl.c: fix memory leak
Message-ID: <20080303180752.GK26072@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a memory leak introduced by commit 
4ccf8cffa963c7b5bdc6d455ea9417084ee49aa8 and spotted by the Coverity 
checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/mtd/ubi/vtbl.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6/drivers/mtd/ubi/vtbl.c.orig	2008-03-02 14:06:25.000000000 +0200
+++ linux-2.6/drivers/mtd/ubi/vtbl.c	2008-03-02 14:15:54.000000000 +0200
@@ -502,40 +502,41 @@ static int init_volumes(struct ubi_devic
 		vol = kzalloc(sizeof(struct ubi_volume), GFP_KERNEL);
 		if (!vol)
 			return -ENOMEM;
 
 		vol->reserved_pebs = be32_to_cpu(vtbl[i].reserved_pebs);
 		vol->alignment = be32_to_cpu(vtbl[i].alignment);
 		vol->data_pad = be32_to_cpu(vtbl[i].data_pad);
 		vol->vol_type = vtbl[i].vol_type == UBI_VID_DYNAMIC ?
 					UBI_DYNAMIC_VOLUME : UBI_STATIC_VOLUME;
 		vol->name_len = be16_to_cpu(vtbl[i].name_len);
 		vol->usable_leb_size = ubi->leb_size - vol->data_pad;
 		memcpy(vol->name, vtbl[i].name, vol->name_len);
 		vol->name[vol->name_len] = '\0';
 		vol->vol_id = i;
 
 		if (vtbl[i].flags & UBI_VTBL_AUTORESIZE_FLG) {
 			/* Auto re-size flag may be set only for one volume */
 			if (ubi->autoresize_vol_id != -1) {
 				ubi_err("more then one auto-resize volume (%d "
 					"and %d)", ubi->autoresize_vol_id, i);
+				kfree(vol);
 				return -EINVAL;
 			}
 
 			ubi->autoresize_vol_id = i;
 		}
 
 		ubi_assert(!ubi->volumes[i]);
 		ubi->volumes[i] = vol;
 		ubi->vol_count += 1;
 		vol->ubi = ubi;
 		reserved_pebs += vol->reserved_pebs;
 
 		/*
 		 * In case of dynamic volume UBI knows nothing about how many
 		 * data is stored there. So assume the whole volume is used.
 		 */
 		if (vol->vol_type == UBI_DYNAMIC_VOLUME) {
 			vol->used_ebs = vol->reserved_pebs;
 			vol->last_eb_bytes = vol->usable_leb_size;
 			vol->used_bytes =

