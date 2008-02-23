Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbYBWNR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbYBWNR0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 08:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYBWNRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 08:17:18 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:9855 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbYBWNRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 08:17:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type;
        b=u/4rycJGlfapWrtYXH80LOMyuNgJjdmzGpuLBHafLBCcgnP1/ZN7Dhw/A99lK7OgRH3auidCeqJCnsYEtx3JAnAke2HTd2BhsDBcGC3J7X6kFpjgDWVwDJWVXu+lD8l+FvQ6b64H2+mviw43ZfUnWXwJk7vgWY/OJfuHttcLpZQ=
Message-ID: <47C01D03.9030601@gmail.com>
Date: Sat, 23 Feb 2008 16:17:55 +0300
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Stefano Brivio <stefano.brivio@polimi.it>, Jeff Garzik <jgarzik@pobox.com>,
       Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Ingo Molnar <mingo@elte.hu>, Michael Buesch <mb@bu3sch.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Fix the bcm43xx driver breakage in 2.6.24/25.
Content-Type: multipart/mixed;
 boundary="------------070401090301080108070703"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070401090301080108070703
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


[resent with lkml added to cc, sorry]

Hello, gentlemen.

Theese two patches fix a problem instroduced in Linux 2.6.24, and
still present in the current Linus' 2.6.25 tree.

The bcm43xx Wifi driver won't work any more, if the b44 Ethernet
driver is enabled. This happens because the b44 driver
needlessly enables the b43_pci_bridge code, which claims
the same pci ids as the bcm43xx driver. The b43_pci_bridge
code is needed for the b43{legacy} drivers, but for the
b44, only the "ssb pci core" is needed.

The first patch separates the ssb b43 pci bridge and the ssb pci
core config options and enables only the needed ones.

A similar patch was once sent to Michael Buesch, but he rejected
it, fearing that changing the config autoselects cold introduce
some unexpected bugs.
If you are intrested, a rather emotional thread may be found
e.g. here:
http://thread.gmane.org/gmane.linux.kernel/644266

That said, I believe the patch may introduce no more bugs,
but fixes a critical regression, which left some users
without a working wifi driver on the 2.6.24 kernel.

If you doubt its correctness, I may write a longer description
on the changes introduced, but I hope they should be obvoius.

This patch is againts the current Linus' tree. I'd like it
to be added to both 2.6.25 and the 2.6.24-stable trees.

The second patch disables the bcm43xx driver if it can't
work due to the b43/b43legacy drivers inclusion, so no
users should be confused.

PS: 
Sorry, I'm a bit tierd of trying to get git-send-patch to work
with the gmail smtp server, so the patches were went with
the thunderbird. If they end up being correpted, I've added
them as attachments.


-----

From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Date: Sat, 23 Feb 2008 12:59:26 +0300
Subject: [PATCH] Use a separate config option for the b43 pci to ssb bridge.

       The bridge code was unnecessary enabled by the b44
       driver, but it prevents the bcm43xx driver from
       being loaded, as the bridge claims the same pci ids.

       Now we enable the birdge only if the b43{legacy}
       drivers are selected.

Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
---
 drivers/net/wireless/b43/Kconfig       |    1 +
 drivers/net/wireless/b43legacy/Kconfig |    1 +
 drivers/ssb/Kconfig                    |    5 +++++
 drivers/ssb/Makefile                   |    2 +-
 drivers/ssb/ssb_private.h              |    4 ++--
 5 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 1a2141d..8bc4bc4 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -32,6 +32,7 @@ config B43_PCI_AUTOSELECT
 	bool
 	depends on B43 && SSB_PCIHOST_POSSIBLE
 	select SSB_PCIHOST
+	select SSB_B43_PCI_BRIDGE
 	default y
 
 # Auto-select SSB PCICORE driver, if possible
diff --git a/drivers/net/wireless/b43legacy/Kconfig b/drivers/net/wireless/b43legacy/Kconfig
index 6745579..13c65fa 100644
--- a/drivers/net/wireless/b43legacy/Kconfig
+++ b/drivers/net/wireless/b43legacy/Kconfig
@@ -25,6 +25,7 @@ config B43LEGACY_PCI_AUTOSELECT
 	bool
 	depends on B43LEGACY && SSB_PCIHOST_POSSIBLE
 	select SSB_PCIHOST
+	select SSB_B43_PCI_BRIDGE
 	default y
 
 # Auto-select SSB PCICORE driver, if possible
diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index d976660..6f627f3 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -35,6 +35,11 @@ config SSB_PCIHOST
 
 	  If unsure, say Y
 
+config SSB_B43_PCI_BRIDGE
+	bool
+	depends on SSB_PCIHOST
+	default n
+
 config SSB_PCMCIAHOST_POSSIBLE
 	bool
 	depends on SSB && (PCMCIA = y || PCMCIA = SSB) && EXPERIMENTAL
diff --git a/drivers/ssb/Makefile b/drivers/ssb/Makefile
index 7be3975..1bf35f0 100644
--- a/drivers/ssb/Makefile
+++ b/drivers/ssb/Makefile
@@ -13,6 +13,6 @@ ssb-$(CONFIG_SSB_DRIVER_PCICORE)	+= driver_pcicore.o
 
 # b43 pci-ssb-bridge driver
 # Not strictly a part of SSB, but kept here for convenience
-ssb-$(CONFIG_SSB_PCIHOST)		+= b43_pci_bridge.o
+ssb-$(CONFIG_SSB_B43_PCI_BRIDGE)	+= b43_pci_bridge.o
 
 obj-$(CONFIG_SSB)			+= ssb.o
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
-- 
1.5.2.GIT


From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Date: Sat, 23 Feb 2008 13:33:07 +0300
Subject: [PATCH] Don't build the bcm43xx driver if SSB is static and the b43 PCI-SSB bridge code is enabled.

This may happen e.g. when the ssb is statically enables by the b44 driver,
and the b43 pci-ssb bridge is enbled by the b43/b43legacy drivers, or the
b43/b43legacy drivers abe built statically.

Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
---
 drivers/net/wireless/bcm43xx/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/bcm43xx/Kconfig b/drivers/net/wireless/bcm43xx/Kconfig
index 0159701..afb8f43 100644
--- a/drivers/net/wireless/bcm43xx/Kconfig
+++ b/drivers/net/wireless/bcm43xx/Kconfig
@@ -1,6 +1,6 @@
 config BCM43XX
 	tristate "Broadcom BCM43xx wireless support (DEPRECATED)"
-	depends on PCI && IEEE80211 && IEEE80211_SOFTMAC && WLAN_80211 && EXPERIMENTAL
+	depends on PCI && IEEE80211 && IEEE80211_SOFTMAC && WLAN_80211 && (!SSB_B43_PCI_BRIDGE || SSB != y) && EXPERIMENTAL
 	select WIRELESS_EXT
 	select FW_LOADER
 	select HW_RANDOM
-- 
1.5.2.GIT





--------------070401090301080108070703
Content-Type: text/x-patch;
 name="0001-Use-a-separate-config-option-for-the-b43-pci-to-ssb.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Use-a-separate-config-option-for-the-b43-pci-to-ssb.pat";
 filename*1="ch"

>From edddbb1a3fdd60eba64869a2866031817d183b7d Mon Sep 17 00:00:00 2001
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Date: Sat, 23 Feb 2008 12:59:26 +0300
Subject: [PATCH] Use a separate config option for the b43 pci to ssb bridge.

       The bridge code was unnecessary enabled by the b44
       driver, but it prevents the bcm43xx driver from
       being loaded, as the bridge claims the same pci ids.

       Now we enable the birdge only if the b43{legacy}
       drivers are selected.

Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
---
 drivers/net/wireless/b43/Kconfig       |    1 +
 drivers/net/wireless/b43legacy/Kconfig |    1 +
 drivers/ssb/Kconfig                    |    5 +++++
 drivers/ssb/Makefile                   |    2 +-
 drivers/ssb/ssb_private.h              |    4 ++--
 5 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 1a2141d..8bc4bc4 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -32,6 +32,7 @@ config B43_PCI_AUTOSELECT
 	bool
 	depends on B43 && SSB_PCIHOST_POSSIBLE
 	select SSB_PCIHOST
+	select SSB_B43_PCI_BRIDGE
 	default y
 
 # Auto-select SSB PCICORE driver, if possible
diff --git a/drivers/net/wireless/b43legacy/Kconfig b/drivers/net/wireless/b43legacy/Kconfig
index 6745579..13c65fa 100644
--- a/drivers/net/wireless/b43legacy/Kconfig
+++ b/drivers/net/wireless/b43legacy/Kconfig
@@ -25,6 +25,7 @@ config B43LEGACY_PCI_AUTOSELECT
 	bool
 	depends on B43LEGACY && SSB_PCIHOST_POSSIBLE
 	select SSB_PCIHOST
+	select SSB_B43_PCI_BRIDGE
 	default y
 
 # Auto-select SSB PCICORE driver, if possible
diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index d976660..6f627f3 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -35,6 +35,11 @@ config SSB_PCIHOST
 
 	  If unsure, say Y
 
+config SSB_B43_PCI_BRIDGE
+	bool
+	depends on SSB_PCIHOST
+	default n
+
 config SSB_PCMCIAHOST_POSSIBLE
 	bool
 	depends on SSB && (PCMCIA = y || PCMCIA = SSB) && EXPERIMENTAL
diff --git a/drivers/ssb/Makefile b/drivers/ssb/Makefile
index 7be3975..1bf35f0 100644
--- a/drivers/ssb/Makefile
+++ b/drivers/ssb/Makefile
@@ -13,6 +13,6 @@ ssb-$(CONFIG_SSB_DRIVER_PCICORE)	+= driver_pcicore.o
 
 # b43 pci-ssb-bridge driver
 # Not strictly a part of SSB, but kept here for convenience
-ssb-$(CONFIG_SSB_PCIHOST)		+= b43_pci_bridge.o
+ssb-$(CONFIG_SSB_B43_PCI_BRIDGE)	+= b43_pci_bridge.o
 
 obj-$(CONFIG_SSB)			+= ssb.o
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
-- 
1.5.2.GIT



--------------070401090301080108070703
Content-Type: text/x-patch;
 name="0002-Don-t-build-the-bcm43xx-driver-if-SSB-is-static-and.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0002-Don-t-build-the-bcm43xx-driver-if-SSB-is-static-and.pat";
 filename*1="ch"

>From c62c389961166fc0813a54ee5ae0e2cc0d61cd0e Mon Sep 17 00:00:00 2001
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Date: Sat, 23 Feb 2008 13:33:07 +0300
Subject: [PATCH] Don't build the bcm43xx driver if SSB is static and the b43 PCI-SSB bridge code is enabled.

This may happen e.g. when the ssb is statically enables by the b44 driver,
and the b43 pci-ssb bridge is enbled by the b43/b43legacy drivers, or the
b43/b43legacy drivers abe built statically.

Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
---
 drivers/net/wireless/bcm43xx/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/bcm43xx/Kconfig b/drivers/net/wireless/bcm43xx/Kconfig
index 0159701..afb8f43 100644
--- a/drivers/net/wireless/bcm43xx/Kconfig
+++ b/drivers/net/wireless/bcm43xx/Kconfig
@@ -1,6 +1,6 @@
 config BCM43XX
 	tristate "Broadcom BCM43xx wireless support (DEPRECATED)"
-	depends on PCI && IEEE80211 && IEEE80211_SOFTMAC && WLAN_80211 && EXPERIMENTAL
+	depends on PCI && IEEE80211 && IEEE80211_SOFTMAC && WLAN_80211 && (!SSB_B43_PCI_BRIDGE || SSB != y) && EXPERIMENTAL
 	select WIRELESS_EXT
 	select FW_LOADER
 	select HW_RANDOM
-- 
1.5.2.GIT



--------------070401090301080108070703--
