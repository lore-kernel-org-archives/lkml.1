Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbZGWMxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbZGWMxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 08:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbZGWMxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 08:53:19 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:52288 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbZGWMxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 08:53:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XfvVYn4zJq22EDHEOlMoZtIhUBx1ke07mvBK6zzjNDFaoeN1lgVgaehrCPiQRJ68Pc
         qdxlobzGGwia+Jk/yMmcM3tSBG34nBbpl+eIQezomnQ391eQ5b1r+p/l6RfuKx7FkKnS
         hQLx/GWDUzf5euatDznh/c2bo/dqogGca4IH4=
MIME-Version: 1.0
In-Reply-To: <9ea470500907230221m1664be8ft2aaf63d2550de6f8@mail.gmail.com>
References: <1247672919-13089-1-git-send-email-petkovbb@gmail.com>
	 <cone.1247683003.40459.21332.1000@deskpiie>
	 <20090723082904.GE3997@dtor-d630.eng.vmware.com>
	 <cone.1248339143.133822.15136.1000@arca>
	 <9ea470500907230221m1664be8ft2aaf63d2550de6f8@mail.gmail.com>
Date: Thu, 23 Jul 2009 14:53:17 +0200
Message-ID: <9ea470500907230553h3ae169c0nc6abaeedb08bef1e@mail.gmail.com>
Subject: Re: [PATCH] acerhdf: convert to dev_pm_ops
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Feuerer <peter@piie.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, lenb@kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Dmitry's right, suspend() and resume() are used only for S2R. Since
> the only thing we do when suspending/hibernating is set fan speed to
> auto, we might just as well replicate those functions to .freeze() and
> .thaw().

here's a fix:

--
From: Borislav Petkov <petkovbb@gmail.com>
Date: Wed, 15 Jul 2009 17:33:32 +0200
Subject: [PATCH] acerhdf: convert to dev_pm_ops

v 1.1:
Add .freeze/.thaw func ptrs to support
suspend-to-disk, as suggested by Dmitry Torokhov.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/platform/x86/acerhdf.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index aa298d6..8cd7a7b 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -435,7 +435,7 @@ struct thermal_cooling_device_ops acerhdf_cooling_ops = {
 };

 /* suspend / resume functionality */
-static int acerhdf_suspend(struct platform_device *dev, pm_message_t state)
+static int acerhdf_suspend(struct device *dev)
 {
 	if (kernelmode)
 		acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
@@ -446,7 +446,7 @@ static int acerhdf_suspend(struct platform_device
*dev, pm_message_t state)
 	return 0;
 }

-static int acerhdf_resume(struct platform_device *device)
+static int acerhdf_resume(struct device *dev)
 {
 	if (verbose)
 		pr_notice("resuming\n");
@@ -464,15 +464,21 @@ static int acerhdf_remove(struct platform_device *device)
 	return 0;
 }

+static struct dev_pm_ops acerhdf_pm_ops = {
+	.suspend = acerhdf_suspend,
+	.resume  = acerhdf_resume,
+	.freeze  = acerhdf_suspend,
+	.thaw	 = acerhdf_resume,
+};
+
 static struct platform_driver acerhdf_driver = {
 	.driver = {
-		.name = "acerhdf",
+		.name  = "acerhdf",
 		.owner = THIS_MODULE,
+		.pm    = &acerhdf_pm_ops,
 	},
 	.probe = acerhdf_probe,
 	.remove = acerhdf_remove,
-	.suspend = acerhdf_suspend,
-	.resume = acerhdf_resume,
 };


-- 
1.6.3.3

-- 
Regards/Gruss,
Boris
