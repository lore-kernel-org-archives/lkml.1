Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbZEPKLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbZEPKLW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 06:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755797AbZEPKLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 06:11:06 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:59630 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbZEPKLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 06:11:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sfueBbNAUV8H2HeqcAsmxCCVk2l1v2iaE4i2wYM6ReC3Rw+ulRd77GmcZp50Tj3pxV
         IaqRxErGxwI1WLxeEZrgtj4sraPtlsSo5rw6KeFzQv2H2Tv/+Q1QIRMiakdIqizI+UYH
         Hkl2YQPo0rtKX5TInHo9/wv7frq+TDZWNFkTQ=
MIME-Version: 1.0
Reply-To: Tobias_Mueller@twam.info
In-Reply-To: <17be05570905160252l3ffc1923xf5031702947948a6@mail.gmail.com>
References: <17be05570905130710s1192729cqafa09127f6c34bf9@mail.gmail.com>
	 <20090513151415.6e84fd82.akpm@linux-foundation.org>
	 <17be05570905140208n5fd695aayfad221808f70ac21@mail.gmail.com>
	 <20090515010947.4016ba66.const@mimas.ru>
	 <17be05570905141323l31ee6f9o71698e57aec4b698@mail.gmail.com>
	 <20090515023202.57387cb2.const@mimas.ru>
	 <17be05570905160252l3ffc1923xf5031702947948a6@mail.gmail.com>
Date: Sat, 16 May 2009 12:11:03 +0200
X-Google-Sender-Auth: efa2c579525135b3
Message-ID: <17be05570905160311l3b56bf31q91597eef4050f982@mail.gmail.com>
Subject: [PATCH v3 001/001] [PATCH 001/001] leds: alix-leds2 fixed for Award 
	BIOS
From: =?UTF-8?Q?Tobias_M=C3=BCller?= <Tobias_Mueller@twam.info>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Constantin Baranov <const@mimas.ru>, Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tobias Mueller <Tobias_Mueller@twam.info>

Added initialisation of GPIO ports for compatibility with boards with Award
BIOS (e.g. ALIX.3D3).
Signed-off-by: Tobias Mueller <Tobias_Mueller@twam.info>
---
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 9b60b6b..37e9118 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -75,6 +75,7 @@ config LEDS_ALIX2
 	depends on LEDS_CLASS && X86 && EXPERIMENTAL
 	help
 	  This option enables support for the PCEngines ALIX.2 and ALIX.3 LEDs.
+	  You have to set leds-alix2.force=1 for boards with Award BIOS.

 config LEDS_H1940
 	tristate "LED Support for iPAQ H1940 device"
diff --git a/drivers/leds/leds-alix2.c b/drivers/leds/leds-alix2.c
index ddbd773..731d4ee 100644
--- a/drivers/leds/leds-alix2.c
+++ b/drivers/leds/leds-alix2.c
@@ -14,7 +14,7 @@

 static int force = 0;
 module_param(force, bool, 0444);
-MODULE_PARM_DESC(force, "Assume system has ALIX.2 style LEDs");
+MODULE_PARM_DESC(force, "Assume system has ALIX.2/ALIX.3 style LEDs");

 struct alix_led {
 	struct led_classdev cdev;
@@ -155,6 +155,11 @@ static int __init alix_led_init(void)
 		goto out;
 	}

+	/* enable output on GPIO for LED 1,2,3 */
+	outl(1 << 6, 0x6104);
+	outl(1 << 9, 0x6184);
+	outl(1 << 11, 0x6184);
+
 	pdev = platform_device_register_simple(KBUILD_MODNAME, -1, NULL, 0);
 	if (!IS_ERR(pdev)) {
 		ret = platform_driver_probe(&alix_led_driver, alix_led_probe);
