Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbYJ0Ucf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbYJ0Ucf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbYJ0UcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:32:16 -0400
Received: from mail.atheros.com ([12.36.123.2]:25000 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbYJ0UcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:32:13 -0400
Date: Mon, 27 Oct 2008 13:32:10 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Zhang Yanmin <yanmin.zhang@intel.com>, Shaohua Li <shaohua.li@intel.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>, <mcgrof@gmail.com>
Subject: [RFC] ASPM split - read current state / optimizations
Message-ID: <20081027203210.GD6377@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I admit I haven't read pcie spec, but I'm trying to understand
the current code and clarify the Kconfig as such to help others. From what
we discussed on our last thread it seems we *don't* need this code
to enable ASPM but simply work out kinks due to buggy BIOSes (what about
on devices which have no BIOS like arm?). It also helps us disable ASPM,
and if we are intrepid to force enabling it (keep in mind some devices
may behave a bit differently when ASPM is enabled, look at e1000 for an
example). So with this in mind I'm curious if the current code should
be split into two parts, one which just reads the current device's
setting and another part which does the sanity checks and configuring of
the clocks, etc basically any modifications or optimizing *if* that
option is enabled.

The benefit with this approach is you can get link_state on the pdev
safely and separate the bahaviour of doing sanity checks and force
enabling/disabling ASPM support.

Patch below so far is just what I gather from current reading, just
to reflect what I mean.

diff --git a/drivers/pci/pcie/Kconfig b/drivers/pci/pcie/Kconfig
index 5a0c6ad..688a973 100644
--- a/drivers/pci/pcie/Kconfig
+++ b/drivers/pci/pcie/Kconfig
@@ -38,6 +38,28 @@ config PCIEASPM
 	  This enables PCI Express ASPM (Active State Power Management) and
 	  Clock Power Management. ASPM supports state L0/L0s/L1.
 
+	  You don't need this option enabled to get ASPM support, ASPM is
+	  software independent, however, enabling this can help correct the
+	  behaviour for ASPM on buggy BIOSes. You can also use this to test
+	  enabling and disabling ASPM on a system where ASPM may actually
+	  cause issues on devices. You can do this by using the global policy
+	  file for ASPM, a sysfs file,
+
+	  /sys/module/pcie_aspm/parameters/policy
+
+	  The interface can be used as a boot option too. Supported settings are:
+
+	    * follow_bios: follows BIOS default settings
+	    * force: force highest power saving mode, enable all available
+	      ASPM state and clock power management possibly disregarding
+	      the BIOS's settings
+	    * off: can be used for highest performance, disables ASPM and
+	      clock power management
+
+	  By default, the 'follow_bios' policy is used, which is what you
+	  would get even with this option disabled. This policy file should
+	  *only* be used to help debug issues.
+
 	  When in doubt, say N.
 config PCIEASPM_DEBUG
 	bool "Debug PCI Express ASPM"
diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 8f63f4c..de94826 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -1,6 +1,7 @@
 /*
  * File:	drivers/pci/pcie/aspm.c
  * Enabling PCIE link L0s/L1 state and Clock Power Management
+ * This is used to overide the BIOS settings or to disable ASPM
  *
  * Copyright (C) 2007 Intel
  * Copyright (C) Zhang Yanmin (yanmin.zhang@intel.com)
@@ -59,14 +60,14 @@ static int aspm_disabled, aspm_force;
 static DEFINE_MUTEX(aspm_lock);
 static LIST_HEAD(link_list);
 
-#define POLICY_DEFAULT 0	/* BIOS default setting */
-#define POLICY_PERFORMANCE 1	/* high performance */
-#define POLICY_POWERSAVE 2	/* high power saving */
+#define POLICY_FOLLOW_BIOS	0	/* Follow the BIOS default settings */
+#define POLICY_OFF		1	/* Disable ASPM, for high performance */
+#define POLICY_FORCE		2	/* Force enable ASPM L0s|L1 for high power saving */
 static int aspm_policy;
 static const char *policy_str[] = {
-	[POLICY_DEFAULT] = "default",
-	[POLICY_PERFORMANCE] = "performance",
-	[POLICY_POWERSAVE] = "powersave"
+	[POLICY_FOLLOW_BIOS] = "follow_bios",
+	[POLICY_OFF] = "off",
+	[POLICY_FORCE] = "force"
 };
 
 static int policy_to_aspm_state(struct pci_dev *pdev)
@@ -74,13 +75,14 @@ static int policy_to_aspm_state(struct pci_dev *pdev)
 	struct pcie_link_state *link_state = pdev->link_state;
 
 	switch (aspm_policy) {
-	case POLICY_PERFORMANCE:
+	case POLICY_OFF:
 		/* Disable ASPM and Clock PM */
 		return 0;
-	case POLICY_POWERSAVE:
+	case POLICY_FORCE:
 		/* Enable ASPM L0s/L1 */
 		return PCIE_LINK_STATE_L0S|PCIE_LINK_STATE_L1;
-	case POLICY_DEFAULT:
+		/* Lets assume the BIOS decided the right behaviour */
+	case POLICY_FOLLOW_BIOS:
 		return link_state->bios_aspm_state;
 	}
 	return 0;
@@ -91,13 +93,13 @@ static int policy_to_clkpm_state(struct pci_dev *pdev)
 	struct pcie_link_state *link_state = pdev->link_state;
 
 	switch (aspm_policy) {
-	case POLICY_PERFORMANCE:
+	case POLICY_OFF:
 		/* Disable ASPM and Clock PM */
 		return 0;
-	case POLICY_POWERSAVE:
+	case POLICY_FORCE:
 		/* Disable Clock PM */
 		return 1;
-	case POLICY_DEFAULT:
+	case POLICY_FOLLOW_BIOS:
 		return link_state->bios_clk_state;
 	}
 	return 0;
@@ -156,7 +158,7 @@ static void pcie_check_clock_pm(struct pci_dev *pdev)
 
 /*
  * pcie_aspm_configure_common_clock: check if the 2 ends of a link
- *   could use common clock. If they are, configure them to use the
+ *   could use common clock. If they can, configure them to use the
  *   common clock. That will reduce the ASPM state exit latency.
  */
 static void pcie_aspm_configure_common_clock(struct pci_dev *pdev)
