Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363Ab0BDRW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:22:26 -0500
Received: from kroah.org ([198.145.64.141]:34735 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932875Ab0BDRV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:56 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:08 2010
Message-Id: <20100204171507.618707929@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       <venkatesh.pallipadi@intel.com>, Mark Hounschell <markh@compro.net>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [34/74] x86: Disable HPET MSI on ATI SB700/SB800
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

commit 73472a46b5b28116b145fb5fc05242c1aa8e1461 upstream

HPET MSI on platforms with ATI SB700/SB800 as they seem to have some
side-effects on floppy DMA. Do not use HPET MSI on such platforms.

Original problem report from Mark Hounschell
http://lkml.indiana.edu/hypermail/linux/kernel/0912.2/01118.html

Tested-by: Mark Hounschell <markh@compro.net>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: <stable@kernel.org>
LKML-Reference: <20100121190952.GA32523@linux-os.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>

---
 arch/x86/include/asm/hpet.h |    1 +
 arch/x86/kernel/hpet.c      |    8 ++++++++
 arch/x86/kernel/quirks.c    |   13 +++++++++++++
 3 files changed, 22 insertions(+)

--- a/arch/x86/include/asm/hpet.h
+++ b/arch/x86/include/asm/hpet.h
@@ -66,6 +66,7 @@
 extern unsigned long hpet_address;
 extern unsigned long force_hpet_address;
 extern int hpet_force_user;
+extern u8 hpet_msi_disable;
 extern int is_hpet_enabled(void);
 extern int hpet_enable(void);
 extern void hpet_disable(void);
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -33,6 +33,8 @@
  * HPET address is set in acpi/boot.c, when an ACPI entry exists
  */
 unsigned long				hpet_address;
+u8					hpet_msi_disable;
+
 #ifdef CONFIG_PCI_MSI
 static unsigned long			hpet_num_timers;
 #endif
@@ -584,6 +586,9 @@ static void hpet_msi_capability_lookup(u
 	unsigned int num_timers_used = 0;
 	int i;
 
+	if (hpet_msi_disable)
+		return;
+
 	id = hpet_readl(HPET_ID);
 
 	num_timers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT);
@@ -911,6 +916,9 @@ static __init int hpet_late_init(void)
 	hpet_reserve_platform_timers(hpet_readl(HPET_ID));
 	hpet_print_config();
 
+	if (hpet_msi_disable)
+		return 0;
+
 	for_each_online_cpu(cpu) {
 		hpet_cpuhp_notify(NULL, CPU_ONLINE, (void *)(long)cpu);
 	}
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -491,6 +491,19 @@ void force_hpet_resume(void)
 		break;
 	}
 }
+
+/*
+ * HPET MSI on some boards (ATI SB700/SB800) has side effect on
+ * floppy DMA. Disable HPET MSI on such platforms.
+ */
+static void force_disable_hpet_msi(struct pci_dev *unused)
+{
+	hpet_msi_disable = 1;
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
+			 force_disable_hpet_msi);
+
 #endif
 
 #if defined(CONFIG_PCI) && defined(CONFIG_NUMA)


