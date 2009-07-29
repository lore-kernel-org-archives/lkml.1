Return-Path: <linux-kernel-owner+w=401wt.eu-S1754423AbZG2Lzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbZG2Lzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 07:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbZG2Lzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 07:55:53 -0400
Received: from mail-bw0-f221.google.com ([209.85.218.221]:32947 "EHLO
	mail-bw0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406AbZG2Lzw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 07:55:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Eh8WP9+pwbM7Lihp5rNYkbysKQ/IcN5eHQSgCivu5yDfluCrWtHV/2rPqb0xcCu4iY
         6pbiTwbmjjTBNERgzPM5BQRDApXL42W16qMzTlezg+ubJXi9WpWV7T2zIjejghWbhn+9
         oWMEk4Yu5zh8LAhBLAWgkfWyqz9R/3bpg9qX0=
MIME-Version: 1.0
In-Reply-To: <cone.1248852351.306728.15136.1000@arca>
References: <1247672919-13089-1-git-send-email-petkovbb@gmail.com>
	 <9ea470500907230221m1664be8ft2aaf63d2550de6f8@mail.gmail.com>
	 <9ea470500907230553h3ae169c0nc6abaeedb08bef1e@mail.gmail.com>
	 <20090727162940.DA90C526EC9@mailhub.coreip.homeip.net>
	 <20090727183733.GB3044@liondog.tnic>
	 <cone.1248765902.464745.15136.1000@arca>
	 <9ea470500907280208v1d8140b5v9d7d7f09df8f060f@mail.gmail.com>
	 <cone.1248787508.386883.15136.1000@arca>
	 <9ea470500907280659m5a65ac2et67651247bf6925c7@mail.gmail.com>
	 <cone.1248852351.306728.15136.1000@arca>
Date: Wed, 29 Jul 2009 13:55:51 +0200
Message-ID: <9ea470500907290455i75971e96y187f7c441274ff74@mail.gmail.com>
Subject: Re: [PATCH] acerhdf: convert to dev_pm_ops
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Feuerer <peter@piie.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, lenb@kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 29, 2009 at 9:25 AM, Peter Feuerer<peter@piie.net> wrote:
> Ok, I think you are right. So we will remove the resume functionality and
> keep just the suspend + freeze calls?

Yep, see below.

> Btw, should I resend the 0.5.13 → 0.5.16 patch splitted up, so that Len can
> apply them?

No need for that - just add my S-O-B to it and make sure all changes are
properly documented in the commit message.

Thanks.

--
From: Borislav Petkov <petkovbb@gmail.com>
Date: Wed, 15 Jul 2009 17:33:32 +0200
Subject: [PATCH] acerhdf: convert to dev_pm_ops

v 1.1:
Add .freeze func ptr to support suspend-to-disk,
as suggested by Dmitry Torokhov.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/platform/x86/acerhdf.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index aa298d6..97e473c 100644
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
@@ -446,14 +446,6 @@ static int acerhdf_suspend(struct platform_device
*dev, pm_message_t state)
 	return 0;
 }

-static int acerhdf_resume(struct platform_device *device)
-{
-	if (verbose)
-		pr_notice("resuming\n");
-
-	return 0;
-}
-
 static int __devinit acerhdf_probe(struct platform_device *device)
 {
 	return 0;
@@ -464,15 +456,19 @@ static int acerhdf_remove(struct platform_device *device)
 	return 0;
 }

+static struct dev_pm_ops acerhdf_pm_ops = {
+	.suspend = acerhdf_suspend,
+	.freeze  = acerhdf_suspend,
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
