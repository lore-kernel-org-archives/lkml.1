Return-Path: <linux-kernel-owner+w=401wt.eu-S1751205AbXBULZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205AbXBULZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 06:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbXBULZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 06:25:14 -0500
Received: from wx-out-0506.google.com ([66.249.82.238]:35407 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbXBULZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 06:25:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Rk7dB9eu2TrFgrJgBYiydjs0AD6cqD+IVGH/jwcCE2nLzEmg7FMjCKZWtLPzdFR4jkDmCQFR79zmtbm/sWDYAvpC/FOlEaBuj74ABphTiOJWRL0aZ6eHBzjRa60wkx0UvDFLoc+NvA3JRs0DcQmp4eg/nZD6kZpDALe7etbvTM4=
Date: Wed, 21 Feb 2007 20:25:08 +0900
From: Tejun Heo <htejun@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] libata: test major version in ata_id_is_sata()
Message-ID: <20070221112508.GX1625@htj.dyndns.org>
References: <20070215233411.GA10782@havoc.gtf.org> <45D4F03E.6040208@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D4F03E.6040208@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Test major version in ata_id_is_sata() not separately.

Signed-off-by: Tejun Heo <htejun@gmail.com>

diff --git a/include/linux/ata.h b/include/linux/ata.h
index 272736e..c331da2 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -282,7 +282,6 @@ struct ata_taskfile {
 };
 
 #define ata_id_is_ata(id)	(((id)[0] & (1 << 15)) == 0)
-#define ata_id_is_sata(id)	((id)[93] == 0)
 #define ata_id_rahead_enabled(id) ((id)[85] & (1 << 6))
 #define ata_id_wcache_enabled(id) ((id)[85] & (1 << 5))
 #define ata_id_hpa_enabled(id)	((id)[85] & (1 << 10))
@@ -324,6 +323,11 @@ static inline unsigned int ata_id_major_version(const u16 *id)
 	return mver;
 }
 
+static inline int ata_id_is_sata(const u16 *id)
+{
+	return ata_id_major_version(id) >= 5 && id[93] == 0;
+}
+
 static inline int ata_id_current_chs_valid(const u16 *id)
 {
 	/* For ATA-1 devices, if the INITIALIZE DEVICE PARAMETERS command
@@ -350,7 +354,7 @@ static inline int ata_id_is_cfa(const u16 *id)
 
 static inline int ata_drive_40wire(const u16 *dev_id)
 {
-	if (ata_id_major_version(dev_id) >= 5 && ata_id_is_sata(dev_id))
+	if (ata_id_is_sata(dev_id))
 		return 0;	/* SATA */
 	if ((dev_id[93] & 0xE000) == 0x6000)
 		return 0;	/* 80 wire */
