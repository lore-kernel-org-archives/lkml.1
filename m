Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbYACUvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbYACUvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 15:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYACUuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 15:50:51 -0500
Received: from smtprelay12.ispgateway.de ([80.67.29.29]:53890 "EHLO
	smtprelay12.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbYACUuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 15:50:51 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2008 15:50:50 EST
Message-ID: <477D491F.1060001@selhorst.net>
Date: Thu, 03 Jan 2008 21:44:15 +0100
From: Marcel Selhorst <tpm@selhorst.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071117)
MIME-Version: 1.0
To: TPM Device Driver List <tpmdd-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] - TPM save state before suspending to ram
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.1-5; AVE: 7.6.0.46; VDF: 7.0.1.191; host: mail)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear list,

this patch fixes a bug, that prevents the TPM chip to resume correctly from a
suspended state.

Signed-off-by: Marcel Selhorst <tpm@selhorst.net>
---
--- linux-tpm/drivers/char/tpm/tpm.c	2008-01-03 20:44:43.000000000 +0100
+++ linux/drivers/char/tpm/tpm.c	2008-01-03 21:08:13.000000000 +0100
@@ -1041,7 +1041,7 @@ void tpm_remove_hardware(struct device *
 }
 EXPORT_SYMBOL_GPL(tpm_remove_hardware);

-static u8 savestate[] = {
+static const u8 savestate[] = {
 	0, 193,			/* TPM_TAG_RQU_COMMAND */
 	0, 0, 0, 10,		/* blob length (in bytes) */
 	0, 0, 0, 152		/* TPM_ORD_SaveState */
@@ -1053,11 +1053,13 @@ static u8 savestate[] = {
  */
 int tpm_pm_suspend(struct device *dev, pm_message_t pm_state)
 {
+	u8 data[max_t(int, max(ARRAY_SIZE(savestate), ARRAY_SIZE(savestate)), 10)];
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 	if (chip == NULL)
 		return -ENODEV;

-	tpm_transmit(chip, savestate, sizeof(savestate));
+	memcpy(data, savestate, sizeof(savestate));
+	tpm_transmit(chip, data, sizeof(data));
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_pm_suspend);


