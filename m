Return-Path: <linux-kernel-owner+w=401wt.eu-S932606AbYBVKkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606AbYBVKkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 05:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbYBVKke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 05:40:34 -0500
Received: from ns.protei.ru ([195.239.28.26]:60472 "EHLO mail.protei.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbYBVKkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 05:40:32 -0500
X-Greylist: delayed 1250 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2008 05:40:32 EST
Message-ID: <47BEAF3B.3080809@protei.ru>
Date: Fri, 22 Feb 2008 14:17:15 +0300
From: Alexey Zaytsev <zaytsev.a@protei.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: bcm43xx regression in 2.6.24 (with patch)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello.

The bcm43xx driver won't work any more, if the b44 Ethernet
driver is enabled. This happens because the b44 driver
needlessly enables the b43_pci_bridge code, which claims
the same pci ids as the bcm43xx driver. The b43_pci_bridge
code is needed for the b43{legacy} drivers, but for the
b44, only the "ssb pci core" is needed.

This patch separates the ssb b43 pci bridge and the ssb pci
core config options and enables only the needed ones.


Greg, how do you think, should this do a -stable material?
If the line number limit really matters, I could remove the
comments in the b43{legacy} Kconfigs. ;)


PS:
Yes, the bcm43xx driver is deprecated, but the b43 driver did
not work for me right out of the box (firmware updated).
Please don't remove the bc43xx driver until there are really no
problems with the new one.

I'll try the new driver once again this weekend, and will send
a bug report when I'll be sure it is not a stupid mistake.

---

Use a separate config option for the b43 pci to ssb bridge.

        The bridge code was unnecessary enabled by the b44
        driver, but it prevents the bcm43xx driver from
        being loaded, as the bridge claims the same pci ids.

        Now we enable the birdge only if the b43{legacy}
        drivers are selected.

Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
---
 drivers/net/wireless/b43/Kconfig       |    4 ++++
 drivers/net/wireless/b43legacy/Kconfig |    4 ++++
 drivers/net/wireless/bcm43xx/Kconfig   |    2 +-
 drivers/ssb/Kconfig                    |    5 +++++
 drivers/ssb/Makefile                   |    2 +-
 drivers/ssb/ssb_private.h              |    4 ++--
 6 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index fdbc351..8b7043a 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -24,6 +24,9 @@ config B43
          This driver uses V4 firmware, which must be installed separately using
          b43-fwcutter.

+         Building this driver prevents the now deprecated bcm43xx driver from being
+         built.
+
          This driver can be built as a module (recommended) that will be called "b43".
          If unsure, say M.

@@ -32,6 +35,7 @@ config B43_PCI_AUTOSELECT
        bool
        depends on B43 && SSB_PCIHOST_POSSIBLE
        select SSB_PCIHOST
+       select SSB_B43_PCI_BRIDGE
        default y

 # Auto-select SSB PCICORE driver, if possible
diff --git a/drivers/net/wireless/b43legacy/Kconfig b/drivers/net/wireless/b43legacy/Kconfig
index 7e23ec2..48f8e7d 100644
--- a/drivers/net/wireless/b43legacy/Kconfig
+++ b/drivers/net/wireless/b43legacy/Kconfig
@@ -17,6 +17,9 @@ config B43LEGACY
          This driver uses V3 firmware, which must be installed separately using
          b43-fwcutter.

+         Building this driver prevents the now deprecated bcm43xx driver from being
+         built.
+
          This driver can be built as a module (recommended) that will be
          called "b43legacy". If unsure, say M.

@@ -25,6 +28,7 @@ config B43LEGACY_PCI_AUTOSELECT
        bool
        depends on B43LEGACY && SSB_PCIHOST_POSSIBLE
        select SSB_PCIHOST
+       select SSB_B43_PCI_BRIDGE
        default y

 # Auto-select SSB PCICORE driver, if possible
diff --git a/drivers/net/wireless/bcm43xx/Kconfig b/drivers/net/wireless/bcm43xx/Kconfig
index ce397e4..32068d8 100644
--- a/drivers/net/wireless/bcm43xx/Kconfig
+++ b/drivers/net/wireless/bcm43xx/Kconfig
@@ -1,6 +1,6 @@
 config BCM43XX
        tristate "Broadcom BCM43xx wireless support"
-       depends on PCI && IEEE80211 && IEEE80211_SOFTMAC && WLAN_80211 && EXPERIMENTAL
+       depends on PCI && IEEE80211 && IEEE80211_SOFTMAC && WLAN_80211 && !SSB_B43_PCI_BRIDGE && EXPERIMENTAL
        select WIRELESS_EXT
        select FW_LOADER
        select HW_RANDOM
diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index d976660..6f627f3 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -35,6 +35,11 @@ config SSB_PCIHOST

          If unsure, say Y

+config SSB_B43_PCI_BRIDGE
+       bool
+       depends on SSB_PCIHOST
+       default n
+
 config SSB_PCMCIAHOST_POSSIBLE
        bool
        depends on SSB && (PCMCIA = y || PCMCIA = SSB) && EXPERIMENTAL
diff --git a/drivers/ssb/Makefile b/drivers/ssb/Makefile
index 7be3975..1bf35f0 100644
--- a/drivers/ssb/Makefile
+++ b/drivers/ssb/Makefile
@@ -13,6 +13,6 @@ ssb-$(CONFIG_SSB_DRIVER_PCICORE)      += driver_pcicore.o

 # b43 pci-ssb-bridge driver
 # Not strictly a part of SSB, but kept here for convenience
-ssb-$(CONFIG_SSB_PCIHOST)              += b43_pci_bridge.o
+ssb-$(CONFIG_SSB_B43_PCI_BRIDGE)       += b43_pci_bridge.o

 obj-$(CONFIG_SSB)                      += ssb.o
diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
index a789364..21eca2b 100644
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -120,10 +120,10 @@ extern int ssb_devices_thaw(struct ssb_bus *bus);
 extern struct ssb_bus *ssb_pci_dev_to_bus(struct pci_dev *pdev);

 /* b43_pci_bridge.c */
-#ifdef CONFIG_SSB_PCIHOST
+#ifdef CONFIG_SSB_B43_PCI_BRIDGE
 extern int __init b43_pci_ssb_bridge_init(void);
 extern void __exit b43_pci_ssb_bridge_exit(void);
-#else /* CONFIG_SSB_PCIHOST */
+#else /* CONFIG_SSB_B43_PCI_BRIDGR */
 static inline int b43_pci_ssb_bridge_init(void)
 {
        return 0;


