Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbZBQCP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbZBQCP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 21:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbZBQCPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 21:15:14 -0500
Received: from mail-gx0-f222.google.com ([209.85.217.222]:53152 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZBQCPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 21:15:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xLPCUnJx99y6lmBsSzjkwu6Jc6HgiVbTGg5SR03pGsOSVZqPepv9oPA4l78QXYcZow
         qwXO/Adt+C4MBRqEJV+zObc0FEaMxtfjPBHqJCl3n01FHF02j0jiSMHla3T+Ges9YDhv
         NKetoCesL9/w7cdjOO55XvB9DgGLNTYFB9+6c=
Message-ID: <499A1DAC.6090200@gmail.com>
Date: Mon, 16 Feb 2009 20:15:08 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
CC: ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <liml@rtr.ca>, =?UTF-8?B?SGFubm8gQsO2Y2s=?= <hanno@hboeck.de>
Subject: [PATCH v2] libata: Don't trust current capacity values in identify
 words 57-58
References: <4999CA54.1060306@gmail.com> <4999CFEB.3030204@ru.mvista.com>
In-Reply-To: <4999CFEB.3030204@ru.mvista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hanno Böck reported a problem where an old Conner CP30254 240MB hard drive
was reported as 1.1TB in capacity by libata:

http://lkml.org/lkml/2009/2/13/134

This was caused by libata trusting the drive's reported current capacity in 
sectors in identify words 57 and 58 if the drive does not support LBA and the
current CHS translation values appear valid. Unfortunately it seems older
ATA specs were vague about what this field should contain and a number of drives
used values with wrong byte order or that were totally bogus. There's no
unique information that it conveys and so we can just calculate the number
of sectors from the reported current CHS values.

While we're at it, clean up this function to use named constants for the
identify word values.

Signed-off-by: Robert Hancock <hancockrwd@gmail.com>

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 9fbf059..33b5549 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1322,14 +1322,16 @@ static u64 ata_id_n_sectors(const u16 *id)
 {
 	if (ata_id_has_lba(id)) {
 		if (ata_id_has_lba48(id))
-			return ata_id_u64(id, 100);
+			return ata_id_u64(id, ATA_ID_LBA_CAPACITY_2);
 		else
-			return ata_id_u32(id, 60);
+			return ata_id_u32(id, ATA_ID_LBA_CAPACITY);
 	} else {
 		if (ata_id_current_chs_valid(id))
-			return ata_id_u32(id, 57);
+			return id[ATA_ID_CUR_CYLS] * id[ATA_ID_CUR_HEADS] *
+			       id[ATA_ID_CUR_SECTORS];
 		else
-			return id[1] * id[3] * id[6];
+			return id[ATA_ID_CYLS] * id[ATA_ID_HEADS] *
+			       id[ATA_ID_SECTORS];
 	}
 }
 
