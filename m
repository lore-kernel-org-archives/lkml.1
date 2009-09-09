Return-Path: <linux-kernel-owner+w=401wt.eu-S1752320AbZIINMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbZIINMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 09:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbZIINMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 09:12:40 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:42030 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751698AbZIINMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 09:12:39 -0400
X-Greylist: delayed 607 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Sep 2009 09:12:39 EDT
From: Wolfgang =?iso-8859-15?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mmc@vger.kernel.org
Subject: [PATCH] mmc_spi: fail gracefully if host or card do not support the switch command
Date: Wed, 9 Sep 2009 14:02:30 +0100
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200909091502.30345.wolfgang.mues@auerswald.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

Some time ago, I have send a patch to the mmc_spi subsystem changing the error 
codes. This was after a discussion with Pierre about using EINVAL only for 
non-recoverable errors. This patch was accepted as

http://git.kernel.org/linus/fdd858db7113ca64132de390188d7ca00701013d

Unfortunately, several weeks later, I realized that this patch has opened a 
little can of worms because there are SD cards on the market which

a) claim that they support the switch command
AND
b) refuse to execute this command if operating in SPI mode.

So, such a card would get unusuable in an embedded linux system in SPI mode, 
because the init sequence terminates with an error.

This patch adds the missing error codes to the caller of the switch command
and restores the old bahaviour to fail gracefully if these commands can not
execute.

This patch should go into 2.6.31 to show up in embedded systems ASAP.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

---
diff -uprN 2_6_31_rc8/drivers/mmc/core/mmc.c 2_6_31_rc8_switch/drivers/mmc/core/mmc.c
--- 2_6_31_rc8/drivers/mmc/core/mmc.c	2009-08-28 02:59:04.000000000 +0200
+++ 2_6_31_rc8_switch/drivers/mmc/core/mmc.c	2009-09-09 14:44:45.000000000 +0200
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
diff -uprN 2_6_31_rc8/drivers/mmc/core/sd.c 2_6_31_rc8_switch/drivers/mmc/core/sd.c
--- 2_6_31_rc8/drivers/mmc/core/sd.c	2009-08-28 02:59:04.000000000 +0200
+++ 2_6_31_rc8_switch/drivers/mmc/core/sd.c	2009-09-09 14:45:34.000000000 +0200
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
