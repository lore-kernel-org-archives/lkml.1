Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYADUJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYADUJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 15:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYADUJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 15:09:09 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:42618 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbYADUJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 15:09:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M2EcIAMm5fHDT7cBo0qePS4dNBS6idoIWANVcc97Xi5VfvSPcDj04Mms7H3xMgCnbH5wFcaJnsVv58e6L4YvwHvGLjT6aS3Sg+tK7rxLEi6zJ6Gb6HECnXwewmaQjtUPaaP+px8HwuqGqAd6/lFpnYwnxedEY/9Lda/nPN9gIIk=
Message-ID: <499d6ed30801041209o4da54b3bw39335f3342e528f0@mail.gmail.com>
Date: Fri, 4 Jan 2008 14:09:01 -0600
From: "Kent Yoder" <shpedoikal@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [tpmdd-devel] [PATCH] - TPM save state before suspending to ram
Cc: "Marcel Selhorst" <tpm@selhorst.net>, "Andrew Morton" <akpm@osdl.org>,
       "TPM Device Driver List" <tpmdd-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, "David Smith" <davidsmith@acm.org>
In-Reply-To: <20080104163917.GB27447@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <477D491F.1060001@selhorst.net> <20080104163917.GB27447@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 4, 2008 10:39 AM, Pavel Machek <pavel@ucw.cz> wrote:
>
> On Thu 2008-01-03 21:44:15, Marcel Selhorst wrote:
> > Dear list,
> >
> > this patch fixes a bug, that prevents the TPM chip to resume correctly from a
> > suspended state.
> >
> > Signed-off-by: Marcel Selhorst <tpm@selhorst.net>
[cut]
>
> I'm not sure if we want to use variable-size array on stack. What
> hacks are you doing with max_t/max?
>                                                                         Pavel

Hi Pavel,

  Here's an alternate solution from David, signoffs pending --

commit 058f1e3c4d4e2de5a7188608a1c2e0722498fd4b
Author: David Smith <davidsmith@acm.org>
Date:   Fri Jan 4 03:33:11 2008 +0900

    Fix for TPM suspend/resume failure

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 9bb5429..79d2fd5 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1046,12 +1046,6 @@ void tpm_remove_hardware(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(tpm_remove_hardware);

-static u8 savestate[] = {
-	0, 193,			/* TPM_TAG_RQU_COMMAND */
-	0, 0, 0, 10,		/* blob length (in bytes) */
-	0, 0, 0, 152		/* TPM_ORD_SaveState */
-};
-
 /*
  * We are about to suspend. Save the TPM state
  * so that it can be restored.
@@ -1059,8 +1053,14 @@ static u8 savestate[] = {
 int tpm_pm_suspend(struct device *dev, pm_message_t pm_state)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
+        u8 savestate[] = {
+          0, 193,		/* TPM_TAG_RQU_COMMAND */
+          0, 0, 0, 10,		/* blob length (in bytes) */
+          0, 0, 0, 152		/* TPM_ORD_SaveState */
+        };
+
 	if (chip == NULL)
-		return -ENODEV;
+          return -ENODEV;

 	tpm_transmit(chip, savestate, sizeof(savestate));
 	return 0;


Kent

-- 
Kent Yoder
IBM LTC Security Dev.
