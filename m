Return-Path: <linux-kernel-owner+w=401wt.eu-S1763236AbZFKPN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763236AbZFKPN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbZFKPNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:13:51 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:61022 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753307AbZFKPNu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:13:50 -0400
From: Wolfgang =?iso-8859-15?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: [PATCH] mmc_spi: fail gracefully if host or card do not support the switch command
Date: Thu, 11 Jun 2009 16:13:27 +0100
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906111713.27504.wolfgang.mues@auerswald.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

The switch command (typically speed switching from 25 to 50 MHz clock)
can be rejected by _both_ the host controller/driver and by the card.
Elder revisions of the SD card do not support speed switching.
Fail gracefully if the reject is comming from the card.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

---
diff -uprN 2_6_29_rc7_patch_retries/drivers/mmc/core/mmc.c 2_6_29_rc7_patch_switch/drivers/mmc/core/mmc.c
--- 2_6_29_rc7_patch_retries/drivers/mmc/core/mmc.c	2009-03-04 02:05:22.000000000 +0100
+++ 2_6_29_rc7_patch_switch/drivers/mmc/core/mmc.c	2009-06-11 17:09:48.000000000 +0200
@@ -180,11 +180,11 @@ static int mmc_read_ext_csd(struct mmc_c
 
 	err = mmc_send_ext_csd(card, ext_csd);
 	if (err) {
-		/*
-		 * We all hosts that cannot perform the command
-		 * to fail more gracefully
-		 */
-		if (err != -EINVAL)
+		/* If the host or the card can't do the switch,
+		 * fail more gracefully. */
+		if ((err != -EINVAL)
+		 && (err != -ENOSYS)
+		 && (err != -EFAULT))
 			goto out;
 
 		/*
diff -uprN 2_6_29_rc7_patch_retries/drivers/mmc/core/sd.c 2_6_29_rc7_patch_switch/drivers/mmc/core/sd.c
--- 2_6_29_rc7_patch_retries/drivers/mmc/core/sd.c	2009-04-07 15:39:22.000000000 +0200
+++ 2_6_29_rc7_patch_switch/drivers/mmc/core/sd.c	2009-06-11 17:09:43.000000000 +0200
@@ -210,11 +210,11 @@ static int mmc_read_switch(struct mmc_ca
 
 	err = mmc_sd_switch(card, 0, 0, 1, status);
 	if (err) {
-		/*
-		 * We all hosts that cannot perform the command
-		 * to fail more gracefully
-		 */
-		if (err != -EINVAL)
+		/* If the host or the card can't do the switch,
+		 * fail more gracefully. */
+		if ((err != -EINVAL)
+		 && (err != -ENOSYS)
+		 && (err != -EFAULT))
 			goto out;
 
 		printk(KERN_WARNING "%s: problem reading switch "
---
regards

i. A. Wolfgang Mües
-- 
Auerswald GmbH & Co. KG
Hardware Development
Telefon: +49 (0)5306 9219 0
Telefax: +49 (0)5306 9219 94 
E-Mail: Wolfgang.Mues@Auerswald.de
Web: http://www.auerswald.de
 
--------------------------------------------------------------
Auerswald GmbH & Co. KG, Vor den Grashöfen 1, 38162 Cremlingen
Registriert beim AG Braunschweig HRA 13289
p.h.G Auerswald Geschäftsführungsges. mbH
Registriert beim AG Braunschweig HRB 7463
Geschäftsführer: Dipl-Ing. Gerhard Auerswald
