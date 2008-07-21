Return-Path: <linux-kernel-owner+w=401wt.eu-S1760794AbYGUGmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794AbYGUGmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 02:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756300AbYGUGmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 02:42:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:1416 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbYGUGmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 02:42:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,221,1215414000"; 
   d="scan'208";a="419874825"
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
From: Shaohua Li <shaohua.li@intel.com>
To: Jack Howarth <howarth@bromo.msbb.uc.edu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080719191438.GA19759@bromo.msbb.uc.edu>
References: <200807180941.09779.yhlu.kernel@gmail.com>
	 <200807191026.03172.jbarnes@virtuousgeek.org>
	 <20080719184011.GA19548@bromo.msbb.uc.edu>
	 <200807191204.48428.jbarnes@virtuousgeek.org>
	 <20080719191438.GA19759@bromo.msbb.uc.edu>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 14:49:59 +0800
Message-Id: <1216622999.838.1.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-07-19 at 15:14 -0400, Jack Howarth wrote:
> On Sat, Jul 19, 2008 at 12:04:48PM -0700, Jesse Barnes wrote:
> > On Saturday, July 19, 2008 11:40 am Jack Howarth wrote:
> > > Jesse,
> > >     It seems that MacBook Pro users aren't the only ones suffering from
> > > PCIE_ASPM...
> > >
> > > http://groups.google.com/group/linux.kernel/browse_thread/thread/cc1b8b3ef6
> > >4e3257/dd4e427510bde7f0?lnk=raot
> > >
> > > I also discovered the pcie_noaspm kernel option from that thread which
> > > allows me to boot the kernels built with PCIE_ASPM support by disabling
> > > that feature.
> > 
> > Yeah, that's a good data point.  Thanks.  Sounds like there may also be some 
> > ACPI interaction going on...
> > 
> > Jesse
> 
> Jesse,
>    For what its worth, acpi=off alone is insufficent to inhibit the
> kernel freezes when PCIE aspm is in use.
As Jesse suggested, maybe we should blacklist all pcie pre-1.1 devices.
please try.

Thanks,
Shaohua
---
 drivers/pci/pcie/aspm.c  |   10 ++++++++++
 include/linux/pci_regs.h |    1 +
 2 files changed, 11 insertions(+)

Index: linux/drivers/pci/pcie/aspm.c
===================================================================
--- linux.orig/drivers/pci/pcie/aspm.c	2008-07-21 14:12:16.000000000 +0800
+++ linux/drivers/pci/pcie/aspm.c	2008-07-21 14:46:24.000000000 +0800
@@ -510,6 +510,7 @@ static int pcie_aspm_sanity_check(struct
 {
 	struct pci_dev *child_dev;
 	int child_pos;
+	u32 reg32;
 
 	/*
 	 * Some functions in a slot might not all be PCIE functions, very
@@ -519,6 +520,15 @@ static int pcie_aspm_sanity_check(struct
 		child_pos = pci_find_capability(child_dev, PCI_CAP_ID_EXP);
 		if (!child_pos)
 			return -EINVAL;
+
+		/*
+		 * Disable ASPM for pre-1.1 PCIe device, we follow MS to use
+		 * RBER bit to determine if a function is 1.1 version device
+		 */
+		pci_read_config_dword(child_dev, child_pos + PCI_EXP_DEVCAP,
+			&reg32);
+		if (!(reg32 & PCI_EXP_DEVCAP_RBER))
+			return -EINVAL;
 	}
 	return 0;
 }
Index: linux/include/linux/pci_regs.h
===================================================================
--- linux.orig/include/linux/pci_regs.h	2008-07-21 14:25:05.000000000 +0800
+++ linux/include/linux/pci_regs.h	2008-07-21 14:27:00.000000000 +0800
@@ -374,6 +374,7 @@
 #define  PCI_EXP_DEVCAP_ATN_BUT	0x1000	/* Attention Button Present */
 #define  PCI_EXP_DEVCAP_ATN_IND	0x2000	/* Attention Indicator Present */
 #define  PCI_EXP_DEVCAP_PWR_IND	0x4000	/* Power Indicator Present */
+#define  PCI_EXP_DEVCAP_RBER	0x8000	/* Role-Based Error Reporting */
 #define  PCI_EXP_DEVCAP_PWR_VAL	0x3fc0000 /* Slot Power Limit Value */
 #define  PCI_EXP_DEVCAP_PWR_SCL	0xc000000 /* Slot Power Limit Scale */
 #define PCI_EXP_DEVCTL		8	/* Device Control */


