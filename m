Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbYKQVM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbYKQVM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbYKQVMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:12:16 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:28119 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751468AbYKQVMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:12:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:Reply-To:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=uX2JAOKqsGIP8/x1dPu7A9SreCeqlq+efwYK6PugZT1tMiL39lPsLiQWy+EU8vc1iajgH+jpOh3lHQpaDUifMvSD6tuCI/kMnFQSswHPgFR8qEk8asobDvJ5W4j5eaHdXbza579HymsoexNyM00zWJx9wN0HASwwKHlLo0ggqEc=  ;
X-YMail-OSG: jBJrFMMVM1mry3IgY6LixHnvqs9bVDb4mweWAuOKxdmeI4X8_NVcr.PlOb66DKZKh31grtPf9hbCpBNfZTJQKSzdW1wMpSNtRqskcPHU7rRlC.lQu.4.xhoGMRzi2XnyZdZg91EKeea4pxfAIVf1Rk_e
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
Reply-To: dbrownell@users.sourceforge.net
To: Linux MTD <linux-mtd@lists.infradead.org>
Subject: [patch 2.6.28-rc5] mtd m25p80: regression fix for chip detection
Date: Mon, 17 Nov 2008 11:37:17 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>, Chen Gong <g.chen@freescale.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811171137.17431.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

The "m25p80.c extended jedec support" patch introduced a regression
whereby every chip ended up matching the first entry in the list
of chips, since it parenthesized a test incorrectly.

This bug could cause MTD filesystem corruption, and all sorts crazy
stuff since all chips would appear to be small (128KB) Atmel chips
instead of what they really were.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Chen Gong <g.chen@freescale.com>
---
 drivers/mtd/devices/m25p80.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -574,10 +574,11 @@ static struct flash_info *__devinit jede
 	for (tmp = 0, info = m25p_data;
 			tmp < ARRAY_SIZE(m25p_data);
 			tmp++, info++) {
-		if (info->jedec_id == jedec)
+		if (info->jedec_id == jedec) {
 			if (ext_jedec != 0 && info->ext_id != ext_jedec)
 				continue;
 			return info;
+		}
 	}
 	dev_err(&spi->dev, "unrecognized JEDEC id %06x\n", jedec);
 	return NULL;
