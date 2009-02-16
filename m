Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbZBPUUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbZBPUUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZBPUUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:20:06 -0500
Received: from el-out-1112.google.com ([209.85.162.180]:52581 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbZBPUUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:20:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=cLbaKS8fG3K+Jrz7yBp6Th0Qg6qRNdaahCBNCViyLh8i2vScps31NPI+BpEifONw82
         h05qRW1cmHKVIOwrjC6TILYR5Ofw1oCxnvcKvr6TgJ32Sa23GPZIHFpYl9Xc4dlixqTr
         cOai7IDBv8+xgvSLbScRUaGbf+pOOiJMXaMbA=
Message-ID: <4999CA54.1060306@gmail.com>
Date: Mon, 16 Feb 2009 14:19:32 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>
CC: Jeff Garzik <jeff@garzik.org>, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Mark Lord <liml@rtr.ca>, =?UTF-8?B?SGFubm8gQsO2Y2s=?= <hanno@hboeck.de>
Subject: [PATCH] libata: Don't trust current capacity values in identify words
 57-58
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

Signed-off-by: Robert Hancock <hancockrwd@gmail.com>

---

Should likely go into -next for testing for a while. Of course, the fact that
this problem showed up in the first place shows that the number of people
that test libata with such boat anchors is fairly small :-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 9fbf059..5389cbc 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1327,7 +1327,7 @@ static u64 ata_id_n_sectors(const u16 *id)
 			return ata_id_u32(id, 60);
 	} else {
 		if (ata_id_current_chs_valid(id))
-			return ata_id_u32(id, 57);
+			return id[54] * id[55] * id[56];
 		else
 			return id[1] * id[3] * id[6];
 	}


