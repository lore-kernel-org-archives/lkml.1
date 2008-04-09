Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbYDIJm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbYDIJm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 05:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYDIJms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 05:42:48 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:45951 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYDIJmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 05:42:47 -0400
Message-ID: <47FC8F8F.5050200@tiscali.nl>
Date: Wed, 09 Apr 2008 11:42:39 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: sonic.zhang@analog.com
CC: uclinux-dist-devel@blackfin.uclinux.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] blackfin: bfin_reset_controller() busy flag appears cleared
 when it is not
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When count reaches 0 the postfix decrement still subtracts (to -1), so
bfin_reset_controller() returns as if the busy flag was cleared while it was not.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index 7f87f10..4208c49 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1442,15 +1442,15 @@ static int bfin_reset_controller(struct ata_host *host)
 	ATAPI_SET_CONTROL(base, ATAPI_GET_CONTROL(base) & ~DEV_RST);
 	msleep(2);
 
 	/* Wait on Busy flag to clear */
 	count = 10000000;
 	do {
 		status = read_atapi_register(base, ATA_REG_STATUS);
-	} while (count-- && (status & ATA_BUSY));
+	} while (--count && (status & ATA_BUSY));
 
 	/* Enable only ATAPI Device interrupt */
 	ATAPI_SET_INT_MASK(base, 1);
 	SSYNC();
 
 	return (!count);
 }
