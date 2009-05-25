Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbZEYVsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbZEYVsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 17:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZEYVsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 17:48:14 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:43125 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbZEYVsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 17:48:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=dG8oIw9ohWMTTN2dunvJ5L0+JihJ+C2X0fOiC4NaHdUbk7Hw7MGeEUs52zOyEOcdEn
         NdkmvNZmDbq6fCiriBrJXdaqERaHyJVKH098XVta69NznbNkaLZ/sIN447wUomqR+doC
         P+FngCzK5+8cj2VGtauTRv7An7ydAj0hGs6pE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] libata: add warning about possible HPA compatibility issue
Date: Mon, 25 May 2009 23:48:08 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6-next-20090522-05935-g4d19128; KDE/4.2.3; i686; ; )
Cc: Jacob <fun2program8@yahoo.com>,
       Christopher Hogan <chris.c.hogan@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Robert Hancock <hancockrwd@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905252348.08970.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document "ignore_hpa" module parameter and add a warning about
possible HPA compatibility issue.

This should fix bug #13365:

	http://bugzilla.kernel.org/show_bug.cgi?id=13365

To: Jeff Garzik <jgarzik@pobox.com>
Reported-by: Jacob <fun2program8@yahoo.com>
Reported-by: Christopher Hogan <chris.c.hogan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Robert Hancock <hancockrwd@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
If people are fine with the patch I can push it together with
ide fixes for 2.6.30-rc8.

 Documentation/kernel-parameters.txt |    6 ++++++
 drivers/ata/libata-core.c           |   15 +++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

Index: b/Documentation/kernel-parameters.txt
===================================================================
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1101,6 +1101,12 @@ and is between 256 and 4096 characters. 
 			If there are multiple matching configurations changing
 			the same attribute, the last one is used.
 
+	libata.ignore_hpa=
+			[LIBATA] Ignore HPA limit
+			Format: { "0" | "1" }
+			0 -- keep BIOS limits (default)
+			1 -- ignore limits, using full disk
+
 	lmb=debug	[KNL] Enable lmb debug messages.
 
 	load_ramdisk=	[RAM] List of ramdisks to load from floppy
Index: b/drivers/ata/libata-core.c
===================================================================
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1472,6 +1472,16 @@ static int ata_set_max_sectors(struct at
 	return 0;
 }
 
+static inline void ata_hpa_warn(unsigned long long first_sector,
+				unsigned long long last_sector)
+{
+	printk(KERN_WARNING "*** possible compatibility issue:\n"
+		"*** sectors %llu-%llu may be inaccessible\n"
+		"*** if Host Protected Area is used for filesystem data\n"
+		"*** (please refer to \"ignore_hpa\" module parameter)\n",
+		first_sector, last_sector);
+}
+
 /**
  *	ata_hpa_resize		-	Resize a device with an HPA set
  *	@dev: Device to resize
@@ -1521,12 +1531,13 @@ static int ata_hpa_resize(struct ata_dev
 		if (!print_info || native_sectors == sectors)
 			return 0;
 
-		if (native_sectors > sectors)
+		if (native_sectors > sectors) {
 			ata_dev_printk(dev, KERN_INFO,
 				"HPA detected: current %llu, native %llu\n",
 				(unsigned long long)sectors,
 				(unsigned long long)native_sectors);
-		else if (native_sectors < sectors)
+			ata_hpa_warn(sectors, native_sectors - 1);
+		} else if (native_sectors < sectors)
 			ata_dev_printk(dev, KERN_WARNING,
 				"native sectors (%llu) is smaller than "
 				"sectors (%llu)\n",
