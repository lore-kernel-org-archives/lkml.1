Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbYKLWDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbYKLWDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbYKLWDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:03:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:4514 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbYKLWDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:03:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id:sender;
        b=cMQ4b9KALjEzxOOUxmeaFTgpaFMXWRSW4blltRFVOQecbB90ORxbKKoDsvgB+j1VeA
         XGkxeDPvn7mq8r4YPJ3DVmwgL/QmJBhsoaBKUe3MKAs2Y5iGSei1yQqDqbDCPHFeq7gt
         LMBPkQJBpZ8plPo+JF1kHkskdxVOIu8XsWESs=
From: Alessandro Guido <ag@alessandroguido.name>
To: len.brown@intel.com
Subject: [sony-laptop] Fix regression caused by "sony-laptop: fingers off backlight if video.ko is serving this functionality"
Date: Wed, 12 Nov 2008 23:03:28 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc4-246-g3edac25; KDE/4.1.3; i686; ; )
Cc: trenn@suse.de, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811122303.29372.ag@alessandroguido.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 540b8bb9c33935183ceb5bed466a42ad72b2af56:

  sony-laptop: fingers off backlight if video.ko is serving this functionality

I can't set brightness on my sony laptop (nothing in /sys/class/backlight).
dmesg says "sony-laptop: Sony: Brightness ignored, must be controlled by ACPI
video driver".
The function acpi_video_backlight_support returns 0 if we should use the
vendor-specific backlight support, while non-0 if the ACPI generic should
be used. Because of this, the check introduced by the said commit appears
reversed.

Signed-off-by: Alessandro Guido <ag@alessandroguido.name>
---
diff --git a/drivers/misc/sony-laptop.c b/drivers/misc/sony-laptop.c
index 7bcb810..2a613d4 100644
--- a/drivers/misc/sony-laptop.c
+++ b/drivers/misc/sony-laptop.c
@@ -1038,7 +1038,7 @@ static int sony_nc_add(struct acpi_device *device)
 		goto outinput;
 	}
 
-	if (!acpi_video_backlight_support()) {
+	if (acpi_video_backlight_support()) {
 		printk(KERN_INFO DRV_PFX "Sony: Brightness ignored, must be "
 		       "controlled by ACPI video driver\n");
 	} else if (ACPI_SUCCESS(acpi_get_handle(sony_nc_acpi_handle, "GBRT",

