Return-Path: <linux-kernel-owner+w=401wt.eu-S1759403AbZFQRvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403AbZFQRvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbZFQRvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:51:40 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60135 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbZFQRvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:51:39 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 17 Jun 2009 19:50:37 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: What's in linux1394-2.6.git? -- Part II.3/3
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.65016b05e9de7e15@s5r6.in-berlin.de>
Message-ID: <tkrat.1fb1379eb9bb3b67@s5r6.in-berlin.de>
References: <tkrat.70eb865eb2fae29b@s5r6.in-berlin.de>
 <tkrat.c0f2f763744b1215@s5r6.in-berlin.de>
 <tkrat.027908636dd71025@s5r6.in-berlin.de>
 <tkrat.65016b05e9de7e15@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch was actually /not/ yet committed to
linux1394-2.6.git but probably will be committed on Monday.


Date: Tue, 16 Jun 2009 22:36:34 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: firewire: new stack is no longer experimental

The new stack is now recommended over the old one if used for industrial
video (IIDC/DCAM) or for storage devices (SBP-2) due to better
performance, improved compatibility, added features, and security.  It
should also be functionally on par with and is more secure than the old
ieee1394 stack in the use case of consumer video devices.

IP-over-1394 support for the new stack is currently emerging, and a
backend of the firedtv DVB driver to the new stack should be available
soon.

The one remaining area where the old stack is still required are audio
devices, as the new stack is not yet able to support the FFADO FireWire
audio framework.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/Kconfig |   52 ++++++++++++++++++---------------------
 drivers/ieee1394/Kconfig |   19 ++++----------
 2 files changed, 30 insertions(+), 41 deletions(-)

Index: b/drivers/firewire/Kconfig
===================================================================
--- a/drivers/firewire/Kconfig
+++ b/drivers/firewire/Kconfig
@@ -1,28 +1,29 @@
-comment "A new alternative FireWire stack is available with EXPERIMENTAL=y"
-	depends on EXPERIMENTAL=n
-
-comment "Enable only one of the two stacks, unless you know what you are doing"
-	depends on EXPERIMENTAL
+comment "You can enable one or both FireWire driver stacks."
+comment "See the help texts for more information."
 
 config FIREWIRE
-	tristate "New FireWire stack, EXPERIMENTAL"
-	depends on EXPERIMENTAL
+	tristate "FireWire driver stack"
 	select CRC_ITU_T
 	help
-	  This is the "Juju" FireWire stack, a new alternative implementation
-	  designed for robustness and simplicity.  You can build either this
-	  stack, or the old stack (the ieee1394 driver, ohci1394 etc.) or both.
-	  Please read http://ieee1394.wiki.kernel.org/index.php/Juju_Migration
-	  before you enable the new stack.
+	  This is the new-generation IEEE 1394 (FireWire) driver stack
+	  a.k.a. Juju, a new implementation designed for robustness and
+	  simplicity.
+	  See http://ieee1394.wiki.kernel.org/index.php/Juju_Migration
+	  for information about migration from the older Linux 1394 stack
+	  to the new driver stack.
 
 	  To compile this driver as a module, say M here: the module will be
 	  called firewire-core.
 
 	  This module functionally replaces ieee1394, raw1394, and video1394.
 	  To access it from application programs, you generally need at least
-	  libraw1394 version 2.  IIDC/DCAM applications also need libdc1394
-	  version 2.  No libraries are required to access storage devices
-	  through the firewire-sbp2 driver.
+	  libraw1394 v2.  IIDC/DCAM applications need libdc1394 v2.
+	  No libraries are required to access storage devices through the
+	  firewire-sbp2 driver.
+
+	  NOTE:
+	  FireWire audio devices currently require the old drivers (ieee1394,
+	  ohci1394, raw1394).
 
 config FIREWIRE_OHCI
 	tristate "OHCI-1394 controllers"
@@ -37,11 +38,9 @@ config FIREWIRE_OHCI
 	  stack.
 
 	  NOTE:
-
-	  You should only build either firewire-ohci or the old ohci1394 driver,
-	  but not both.  If you nevertheless want to install both, you should
-	  configure them only as modules and blacklist the driver(s) which you
-	  don't want to have auto-loaded.  Add either
+	  If you want to install firewire-ohci and ohci1394 together, you
+	  should configure them only as modules and blacklist the driver(s)
+	  which you don't want to have auto-loaded.  Add either
 
 	      blacklist firewire-ohci
 	  or
@@ -50,12 +49,7 @@ config FIREWIRE_OHCI
 	      blacklist dv1394
 
 	  to /etc/modprobe.conf or /etc/modprobe.d/* and update modprobe.conf
-	  depending on your distribution.  The latter two modules should be
-	  blacklisted together with ohci1394 because they depend on ohci1394.
-
-	  If you have an old modprobe which doesn't implement the blacklist
-	  directive, use "install modulename /bin/true" for the modules to be
-	  blacklisted.
+	  depending on your distribution.
 
 config FIREWIRE_OHCI_DEBUG
 	bool
@@ -79,13 +73,15 @@ config FIREWIRE_SBP2
 	  configuration section.
 
 config FIREWIRE_NET
-	tristate "IP networking over 1394"
-	depends on FIREWIRE && INET
+	tristate "IP networking over 1394 (EXPERIMENTAL)"
+	depends on FIREWIRE && INET && EXPERIMENTAL
 	help
 	  This enables IPv4 over IEEE 1394, providing IP connectivity with
 	  other implementations of RFC 2734 as found on several operating
 	  systems.  Multicast support is currently limited.
 
+	  NOTE, this driver is not stable yet!
+
 	  To compile this driver as a module, say M here:  The module will be
 	  called firewire-net.  It replaces eth1394 of the classic IEEE 1394
 	  stack.
Index: b/drivers/ieee1394/Kconfig
===================================================================
--- a/drivers/ieee1394/Kconfig
+++ b/drivers/ieee1394/Kconfig
@@ -4,7 +4,7 @@ menu "IEEE 1394 (FireWire) support"
 source "drivers/firewire/Kconfig"
 
 config IEEE1394
-	tristate "Stable FireWire stack"
+	tristate "Legacy alternative FireWire driver stack"
 	depends on PCI || BROKEN
 	help
 	  IEEE 1394 describes a high performance serial bus, which is also
@@ -33,11 +33,9 @@ config IEEE1394_OHCI1394
 	  module will be called ohci1394.
 
 	  NOTE:
-
-	  You should only build either ohci1394 or the new firewire-ohci driver,
-	  but not both.  If you nevertheless want to install both, you should
-	  configure them only as modules and blacklist the driver(s) which you
-	  don't want to have auto-loaded.  Add either
+	  If you want to install firewire-ohci and ohci1394 together, you
+	  should configure them only as modules and blacklist the driver(s)
+	  which you don't want to have auto-loaded.  Add either
 
 	      blacklist firewire-ohci
 	  or
@@ -46,12 +44,7 @@ config IEEE1394_OHCI1394
 	      blacklist dv1394
 
 	  to /etc/modprobe.conf or /etc/modprobe.d/* and update modprobe.conf
-	  depending on your distribution.  The latter two modules should be
-	  blacklisted together with ohci1394 because they depend on ohci1394.
-
-	  If you have an old modprobe which doesn't implement the blacklist
-	  directive, use "install modulename /bin/true" for the modules to be
-	  blacklisted.
+	  depending on your distribution.
 
 comment "PCILynx controller requires I2C"
 	depends on IEEE1394 && I2C=n
@@ -105,7 +98,7 @@ config IEEE1394_ETH1394_ROM_ENTRY
 	default n
 
 config IEEE1394_ETH1394
-	tristate "IP networking over 1394"
+	tristate "IP networking over 1394 (experimental)"
 	depends on IEEE1394 && EXPERIMENTAL && INET
 	select IEEE1394_ETH1394_ROM_ENTRY
 	help


-- 
Stefan Richter
-=====-==--= -==- =---=
http://arcgraph.de/sr/

