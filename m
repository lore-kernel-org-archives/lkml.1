Return-Path: <linux-kernel-owner+w=401wt.eu-S965692AbYD1U7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965692AbYD1U7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935289AbYD1U7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:59:25 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:40983 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934881AbYD1U7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:59:24 -0400
Date: Mon, 28 Apr 2008 23:58:49 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       reinette.chatre@intel.com, linville@tuxdriver.com,
       torvalds@linux-foundation.org, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [2.6 patch] iwlwifi: move the selects to the tristate drivers
Message-ID: <20080428205849.GB2813@cs181133002.pp.htv.fi>
References: <20080428054700.GA16177@Pilar.virtua.com.br> <20080427.233507.261574307.davem@davemloft.net> <20080428073212.GA7260@Pilar.virtua.com.br> <20080428131552.GI16379@cs181133002.pp.htv.fi> <20080428142129.GA5679@beyonder.ift.unesp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080428142129.GA5679@beyonder.ift.unesp.br>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 11:21:30AM -0300, Carlos R. Mafra wrote:
> On Mon 28.Apr'08 at 16:15:52 +0300, Adrian Bunk wrote:
> > On Mon, Apr 28, 2008 at 04:32:14AM -0300, Carlos R. Mafra wrote:
>...
> > > Hmm, I just tested this patch and it does not solve the problem. 
> > > 
> > > I could create a .config using 'make menuconfig' in which I had
> > > 
> > > CONFIG_MAC80211_LEDS=y
> > > CONFIG_RFKILL_LEDS=y
> > > CONFIG_IWLWIFI_LEDS=y
> > > CONFIG_IWL4965_LEDS=y
> > > CONFIG_NEW_LEDS=y
> > > CONFIG_LEDS_CLASS=m

The actual problem was CONFIG_IWLCORE=y, CONFIG_IWL4965=m.

And this is not the same problem as what Luca's patch solves.

> > > So I recompiled the kernel and got the same error message as before.
> > >...
> > 
> > Please send your .config
> 
> Find it below. It was generated through make menuconfig with Luca's patch
> applied, and the build fails like before.

Thanks, fix is below.

> Is there something wrong with the patch I wrote yesterday? 

It would require users to manually set CONFIG_LEDS_CLASS only for 
getting their net driver, which is an implementation detail we shouldn't 
bother them with.

And it would require a built-in CONFIG_LEDS_CLASS even for modular 
drivers.

> It fixes this issue for me...but I would like to take this 
> opportunity to learn something new (for me) and useful for the future :-)

I'm not sure whether the best opportunity for you to learn something 
useful for the future is to learn about the nastier parts of kconfig...  ;-)

Fellow kernel developers have claimed I was crazy after I told that my 
favorite part of the kernel are the Kconfig files...

> Thanks for taking a look at it!
>...

Thanks for reporting it!

cu
Adrian


<--  snip  -->


This patch moves the following select's:
- RFKILL        : IWLWIFI_RFKILL -> IWLCORE
- RFKILL_INPUT  : IWLWIFI_RFKILL -> IWLCORE
- MAC80211_LEDS : IWL4965_LEDS   -> IWLCORE
- LEDS_CLASS    : IWL4965_LEDS   -> IWLCORE
- MAC80211_LEDS : IWL3945_LEDS   -> IWL3945
- LEDS_CLASS    : IWL3945_LEDS   -> IWL3945

The effects are:
- with IWLCORE=m and/or IWL3945=m RFKILL/RFKILL_INPUT/MAC80211_LEDS/LEDS_CLASS
  are no longer wrongly forced to y
- fixes a build error with IWLCORE=y, IWL4965=m
  might be a bug in kconfig causing it, but doing this change that is 
  anyway the right thing fixes it

Reported-by: Carlos R. Mafra <crmafra2@gmail.com>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

BTW: There's no correlation between IWL3945_LEDS and IWLWIFI_LEDS.
     That seems to be intended?

 drivers/net/wireless/iwlwifi/Kconfig |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

cebeaa10898371bd3bf038e796c832ae71ce5f14 diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 9a25f55..2a18377 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -6,6 +6,10 @@ config IWLCORE
 	tristate "Intel Wireless Wifi Core"
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
 	select IWLWIFI
+	select MAC80211_LEDS if IWLWIFI_LEDS
+	select LEDS_CLASS if IWLWIFI_LEDS
+	select RFKILL if IWLWIFI_RFKILL
+	select RFKILL_INPUT if IWLWIFI_RFKILL
 
 config IWLWIFI_LEDS
 	bool
@@ -14,8 +18,6 @@ config IWLWIFI_LEDS
 config IWLWIFI_RFKILL
 	boolean "IWLWIFI RF kill support"
 	depends on IWLCORE
-	select RFKILL
-	select RFKILL_INPUT
 
 config IWL4965
 	tristate "Intel Wireless WiFi 4965AGN"
@@ -55,8 +57,6 @@ config IWL4965_HT
 config IWL4965_LEDS
 	bool "Enable LEDS features in iwl4965 driver"
 	depends on IWL4965
-	select MAC80211_LEDS
-	select LEDS_CLASS
 	select IWLWIFI_LEDS
 	---help---
 	  This option enables LEDS for the iwlwifi drivers
@@ -112,6 +112,8 @@ config IWL3945
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
 	select FW_LOADER
 	select IWLWIFI
+	select MAC80211_LEDS if IWL3945_LEDS
+	select LEDS_CLASS if IWL3945_LEDS
 	---help---
 	  Select to build the driver supporting the:
 
@@ -143,8 +145,6 @@ config IWL3945_SPECTRUM_MEASUREMENT
 config IWL3945_LEDS
 	bool "Enable LEDS features in iwl3945 driver"
 	depends on IWL3945
-	select MAC80211_LEDS
-	select LEDS_CLASS
 	---help---
 	  This option enables LEDS for the iwl3945 driver.
 

