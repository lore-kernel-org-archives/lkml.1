Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbZAHH1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbZAHH1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 02:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbZAHH1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 02:27:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49548 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbZAHH1h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 02:27:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: [Regression] hald segfaults at startup on Toshiba Portege R500 x86_64 (bisected)
Date: Thu, 8 Jan 2009 08:27:02 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-2?q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901080827.02882.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Unfortunately the following commit:

commit 35ff8554d12ecc80a46ea0d9bce34fe28733ff38
Author: Éric Piel <eric.piel@tremplin-utc.net>
Date:   Sat Nov 22 19:29:29 2008 +0100

    sdhci: activate led support also when module

    CONFIG_LEDS_CLASS is defined only if led-class is built-in, otherwise
    when it is a module the option is called CONFIG_LEDS_CLASS_MODULE. Led
    support should also be activated in this case.

    Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
    Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>

causes hald to segfault at startup (not always, but sufficiently often for
bisection) on my Toshiba Portege R500 w/ x86_64 kernel/userland.

While it doesn't revert cleanly, I have applied the appended patch (which is
a revert of the commit above) and hald doesn't segfault any more here.

Thanks,
Rafael

---
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 6b2d1f9..8ce6250 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -154,7 +154,7 @@ static void sdhci_deactivate_led(struct sdhci_host *host)
 	writeb(ctrl, host->ioaddr + SDHCI_HOST_CONTROL);
 }
 
-#ifdef SDHCI_USE_LEDS_CLASS
+#ifdef CONFIG_LEDS_CLASS
 static void sdhci_led_control(struct led_classdev *led,
 	enum led_brightness brightness)
 {
@@ -999,7 +999,7 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 
 	WARN_ON(host->mrq != NULL);
 
-#ifndef SDHCI_USE_LEDS_CLASS
+#ifndef CONFIG_LEDS_CLASS
 	sdhci_activate_led(host);
 #endif
 
@@ -1206,7 +1206,7 @@ static void sdhci_tasklet_finish(unsigned long param)
 	host->cmd = NULL;
 	host->data = NULL;
 
-#ifndef SDHCI_USE_LEDS_CLASS
+#ifndef CONFIG_LEDS_CLASS
 	sdhci_deactivate_led(host);
 #endif
 
@@ -1722,7 +1722,7 @@ int sdhci_add_host(struct sdhci_host *host)
 	sdhci_dumpregs(host);
 #endif
 
-#ifdef SDHCI_USE_LEDS_CLASS
+#ifdef CONFIG_LEDS_CLASS
 	host->led.name = mmc_hostname(mmc);
 	host->led.brightness = LED_OFF;
 	host->led.default_trigger = mmc_hostname(mmc);
@@ -1744,7 +1744,7 @@ int sdhci_add_host(struct sdhci_host *host)
 
 	return 0;
 
-#ifdef SDHCI_USE_LEDS_CLASS
+#ifdef CONFIG_LEDS_CLASS
 reset:
 	sdhci_reset(host, SDHCI_RESET_ALL);
 	free_irq(host->irq, host);
@@ -1780,7 +1780,7 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
 
 	mmc_remove_host(host->mmc);
 
-#ifdef SDHCI_USE_LEDS_CLASS
+#ifdef CONFIG_LEDS_CLASS
 	led_classdev_unregister(&host->led);
 #endif
 
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 3efba23..31f4b15 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -220,7 +220,7 @@ struct sdhci_host {
 	struct mmc_host		*mmc;		/* MMC structure */
 	u64			dma_mask;	/* custom DMA mask */
 
-#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+#ifdef CONFIG_LEDS_CLASS
 	struct led_classdev	led;		/* LED control */
 #endif
 

