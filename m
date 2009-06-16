Return-Path: <linux-kernel-owner+w=401wt.eu-S1760214AbZFPRsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214AbZFPRsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 13:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758050AbZFPRs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 13:48:29 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:19482 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995AbZFPRs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 13:48:28 -0400
Message-ID: <4A37DA1A.8020800@oracle.com>
Date: Tue, 16 Jun 2009 10:44:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>, Len Brown <len.brown@intel.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [PATCH -next] eeepc: fix selects (third time)
References: <20090616165923.8ca4ddcb.sfr@canb.auug.org.au>
In-Reply-To: <20090616165923.8ca4ddcb.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.4A37DAE2.0143:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-next still fails with various pci_*() undefined references, like:


ERROR: "pci_scan_slot" [drivers/pci/hotplug/cpqphp.ko] undefined!
ERROR: "pci_add_new_bus" [drivers/pci/hotplug/cpqphp.ko] undefined!
and
drivers/pci/hotplug/fakephp.c:55: error:implicit declaration of function 'pci_rescan_bus'

These are due to the eeepc driver's Kconfig selects.  Patch below
fixes them.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

EEEPC_LAPTOP selects HOTPLUG_PCI.  This causes failures (build error below)
when CONFIG_HOTPLUG is not enabled, so additionally select HOTPLUG since
kconfig 'select' doesn't follow its dependency chain.
Also, only select HOTPLUG_PCI if PCI is already enabled.

drivers/pci/hotplug/fakephp.c:55: error: implicit declaration of function 'pci_rescan_bus'
ERROR: "pci_scan_slot" [drivers/pci/hotplug/pciehp.ko] undefined!
ERROR: "pci_scan_bridge" [drivers/pci/hotplug/pciehp.ko] undefined!
ERROR: "pci_scan_slot" [drivers/pci/hotplug/pci_hotplug.ko] undefined!
ERROR: "pci_add_new_bus" [drivers/pci/hotplug/pci_hotplug.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20090604.orig/drivers/platform/x86/Kconfig
+++ linux-next-20090604/drivers/platform/x86/Kconfig
@@ -340,7 +340,8 @@ config EEEPC_LAPTOP
 	depends on RFKILL || RFKILL = n
 	select BACKLIGHT_CLASS_DEVICE
 	select HWMON
-	select HOTPLUG_PCI
+	select HOTPLUG
+	select HOTPLUG_PCI if PCI
 	---help---
 	  This driver supports the Fn-Fx keys on Eee PC laptops.
 	  It also adds the ability to switch camera/wlan on/off.
