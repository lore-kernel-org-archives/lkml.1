Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbYD1FoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbYD1FoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 01:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbYD1Fnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 01:43:51 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:33437 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYD1Fnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 01:43:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=a7Vt/1RvOWKUHCTZxA9UmpmqYnpRcKjd7rlVR+hLshmz6X1/utGRWdWoChY4zIoc3ph2x6iT+u1DUfyrCMf8gPbGkYlQIDHvA9eDKTxE5Af9HWkgQ1WSBqtAimtpQf9qJhym6bSK48TFIfNh5dpUo8ygTAb5/WEiZsIbsz3kigE=
Date: Mon, 28 Apr 2008 02:47:01 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: reinette.chatre@intel.com, linville@tuxdriver.com,
       torvalds@linux-foundation.org
Subject: [PATCH] iwlwifi: Fix build error in v2.6.25-5561-g064922a
Message-ID: <20080428054700.GA16177@Pilar.virtua.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've just tried to compile v2.6.25-5561-g064922a and it failed with
these messages:

drivers/built-in.o: In function `iwl_leds_unregister_led':
iwl-led.c:(.text+0x7f14a): undefined reference to `led_classdev_unregister'
drivers/built-in.o: In function `iwl_leds_register_led':
iwl-led.c:(.text+0x7f220): undefined reference to `led_classdev_register'
make: *** [.tmp_vmlinux1] Error 1

and I checked that it was due to CONFIG_IWL4965_LEDS=y and 
CONFIG_LEDS_CLASS=m in my .config.

If I CONFIG_LEDS_CLASS is also =y then it builds fine.

So I tried to cook up a patch to avoid that. It doesn't look
elegant but it avoids this problem for me :-)


--
>From 7116035343f4d031807aa73c92434eab3863de56 Mon Sep 17 00:00:00 2001
From: Carlos R. Mafra <crmafra@ift.unesp.br>
Date: Mon, 28 Apr 2008 02:12:22 -0300
Subject: [PATCH] iwlwifi: Fix build failure due to CONFIG_LEDS_CLASS=m

The compilation of v2.6.25-5561-g064922a fails with

drivers/built-in.o: In function `iwl_leds_unregister_led':
iwl-led.c:(.text+0x7f14a): undefined reference to `led_classdev_unregister'
drivers/built-in.o: In function `iwl_leds_register_led':
iwl-led.c:(.text+0x7f220): undefined reference to `led_classdev_register'
make: *** [.tmp_vmlinux1] Error 1

and this is the relevant part of .config which caused it

CONFIG_MAC80211_LEDS=y
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWL4965_LEDS=y
CONFIG_LEDS_CLASS=m

The problem was that CONFIG_IWL_4965_LEDS was compiled in and
CONFIG_LEDS_CLASS was modular. To avoid this build failure
make IWL_4965_LEDS depend on LEDS_CLASS=y.

Signed-off-by: Carlos R. Mafra <crmafra@ift.unesp.br>
---
 drivers/net/wireless/iwlwifi/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index c4e631d..6081f92 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -49,9 +49,8 @@ config IWL4965_HT
 
 config IWL4965_LEDS
 	bool "Enable LEDS features in iwl4965 driver"
-	depends on IWL4965
+	depends on IWL4965 && LEDS_CLASS = y
 	select MAC80211_LEDS
-	select LEDS_CLASS
 	select IWLWIFI_LEDS
 	---help---
 	  This option enables LEDS for the iwlwifi drivers
-- 
1.5.4.3.220.g99d8e





