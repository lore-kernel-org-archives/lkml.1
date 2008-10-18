Return-Path: <linux-kernel-owner+w=401wt.eu-S1752310AbYJRU0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbYJRU0d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 16:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbYJRU0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 16:26:22 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:27589 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbYJRU0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 16:26:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=fbD895668Eb/vUjkJzsY7l0rKYZlECbEyuJwmKSSrPJNr38Ws4a7u5sRPNVRfs7MYf
         +oawMfNRAlyZLbCuQmDWgkhi5KoSvJQNKre8fRRFEqn2gGbfG3690EwQuCDvYzfGE5O2
         eHXXxLNZ2lUYTYn68pWHxj74YlAlCg3LYkucM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ata: ata_id_is_ssd() bugfix
Date: Sat, 18 Oct 2008 22:22:12 +0200
User-Agent: KMail/1.9.10
Cc: linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810182222.13281.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to explicitly check for major and minor version
of supported ATA spec as earlier revisions used word 217
for different purposes.

[ The issue was originally spotted by Alan Cox. ]

This patch fixes regression introduced by:
commit 8bff7c6b0f63c7ee9c5e3a076338d74125b8debb
("libata: set queue SSD flag for SSD devices").

Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
somebody owe me one for going through all these spec drafts... ;)

 include/linux/ata.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: b/include/linux/ata.h
===================================================================
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -75,6 +75,7 @@ enum {
 	ATA_ID_EIDE_PIO_IORDY	= 68,
 	ATA_ID_QUEUE_DEPTH	= 75,
 	ATA_ID_MAJOR_VER	= 80,
+	ATA_ID_MINOR_VER	= 81,
 	ATA_ID_COMMAND_SET_1	= 82,
 	ATA_ID_COMMAND_SET_2	= 83,
 	ATA_ID_CFSSE		= 84,
@@ -743,7 +744,12 @@ static inline int ata_id_is_cfa(const u1
 
 static inline int ata_id_is_ssd(const u16 *id)
 {
-	return id[ATA_ID_ROT_SPEED] == 0x01;
+	/* ATA8-ACS version 4c or higher (=> 4c or 6 at the moment) */
+	if (ata_id_major_version(id) >= 8 &&
+	    (id[ATA_ID_MINOR_VER] == 0x39 || id[ATA_ID_MINOR_VER] == 0x28) &&
+	    id[ATA_ID_ROT_SPEED] == 0x01)
+		return 1;
+	return 0;
 }
 
 static inline int ata_drive_40wire(const u16 *dev_id)
