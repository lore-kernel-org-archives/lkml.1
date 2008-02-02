Return-Path: <linux-kernel-owner+w=401wt.eu-S932524AbYBBAmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524AbYBBAmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760837AbYBBAm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:42:26 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42283 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760070AbYBBAmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:42:25 -0500
Date: Fri, 1 Feb 2008 16:42:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net,
       "Li, Shaohua" <shaohua.li@intel.com>, yanmin.zhang@intel.com
Subject: Re: [GIT PATCH] PCI patches for 2.6.24
Message-Id: <20080201164206.d96c6ee0.akpm@linux-foundation.org>
In-Reply-To: <20080201231147.GA18174@suse.de>
References: <20080201231147.GA18174@suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008 15:11:47 -0800
Greg KH <gregkh@suse.de> wrote:

>       PCI: PCIE ASPM support

drivers/built-in.o: In function `pci_scan_slot':
drivers/pci/probe.c:1016: undefined reference to `pcie_aspm_init_link_state'
drivers/built-in.o: In function `pci_stop_dev':
drivers/pci/remove.c:36: undefined reference to `pcie_aspm_exit_link_state'
drivers/built-in.o: In function `pci_set_power_state':
drivers/pci/pci.c:524: undefined reference to `pcie_aspm_pm_state_change'
make: *** [.tmp_vmlinux1] Error 1

http://userweb.kernel.org/~akpm/config-vmm.txt


Needs this, I guess:


--- a/drivers/pci/pcie/Kconfig~fix-gregkh-pci-pci-pcie-aspm-support
+++ a/drivers/pci/pcie/Kconfig
@@ -32,7 +32,7 @@ source "drivers/pci/pcie/aer/Kconfig"
 #
 config PCIEASPM
 	bool "PCI Express ASPM support(Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL && PCIEPORTBUS
 	default y
 	help
 	  This enables PCI Express ASPM (Active State Power Management) and
_


Also, that ASPM patch unnecessarily adds a pile of macros:

+#ifdef CONFIG_PCIEASPM
+extern void pcie_aspm_init_link_state(struct pci_dev *pdev);
+extern void pcie_aspm_exit_link_state(struct pci_dev *pdev);
+extern void pcie_aspm_pm_state_change(struct pci_dev *pdev);
+extern void pci_disable_link_state(struct pci_dev *pdev, int state);
+#else
+#define pcie_aspm_init_link_state(pdev)                do {} while (0)
+#define pcie_aspm_exit_link_state(pdev)                do {} while (0)
+#define pcie_aspm_pm_state_change(pdev)                do {} while (0)
+#define pci_disable_link_state(pdev, state)    do {} while (0)
+#endif

Please don't do this.  

A static inline function is cleaner and provides typechecking.  It also
provides an access to the caller's argument and can avoid unused-varaiable
warnings.

The only reason to use a macro in this situation is if the caller's
argument is for some reason not defined if !CONFIG_PCIEASPM.

Greg, please check for this in your reviewing - reject macros *by default*.
 They are inferior.

