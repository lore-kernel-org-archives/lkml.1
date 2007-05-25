Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbXEYE2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbXEYE2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 00:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbXEYE2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 00:28:25 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37672 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbXEYE2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 00:28:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@NineX.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       ninex@o2.pl, <linux-kernel@vger.kernel.org>,
       <linux-pci@atrey.karlin.mff.cuni.cz>,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 2/2] msi:  Add support for the Intel chipsets that support MSI.
References: <200705122146.l4CLkH6q012322@fire-2.osdl.org>
	<20070513014622.c5702928.akpm@linux-foundation.org>
	<46470209.9000502@bellsouth.net> <46470515.50000@NineX.eu.org>
	<464707F7.6080600@bellsouth.net>
	<m1irawpwy2.fsf@ebiederm.dsl.xmission.com>
	<20070513204407.7ba35010@osprey.hogchain.net>
	<4647FA38.3090108@NineX.eu.org> <46480EA5.40400@NineX.eu.org>
	<20070514053406.478bf93f@osprey.hogchain.net>
	<m1d513oddj.fsf@ebiederm.dsl.xmission.com>
	<20070514093829.377e04bc@osprey.hogchain.net>
	<m18xbrnyxi.fsf@ebiederm.dsl.xmission.com>
	<20070514160005.627435e3@osprey.hogchain.net>
	<m1odkmmft4.fsf@ebiederm.dsl.xmission.com>
	<20070515212200.517fcba2@osprey.hogchain.net>
	<m14pmcmz8r.fsf@ebiederm.dsl.xmission.com>
	<20070516185225.3f3ac082@osprey.hogchain.net>
	<m1sl9wl28m.fsf@ebiederm.dsl.xmission.com>
	<20070522204103.134bf5a2@osprey.hogchain.net>
	<m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>
Date: Thu, 24 May 2007 22:26:50 -0600
In-Reply-To: <m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Thu, 24 May 2007 22:19:09 -0600")
Message-ID: <m1r6p5cyut.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch is the result of a quick survey of the Intel chipset
documents.  I took a quick look in the document to see if the chipset
supported MSI and if so I looked through to find the vendor and device
id of device 0 function 0 of the chipset and added a quirk for that
device id if I it was not a duplicate. 

I happen to have one of the systems on the list so the patch is
tested, and seems to work fine.

This patch should be safe.  The anecdotal evidence is that when dealing
with MSI the Intel chipsets just work.  If we find some buggy ones
changing the list won't be hard.

This patch should also serve as an example of how simple it is to
enable MSI on a chipset or platform configuration where it is known
to work.

This patch does not use the defines from pci_ids.h because there are
so many defines and so many duplicate host-bridge device id duplicates
in Intels documentation I could not keep any of it straight without
using the raw device ids.  Which allowed me to order the fixups and
quickly detect duplicates.  Unfortunately the good names were
a confusing layer of abstraction.  I have still updated pci_ids.h
so that it is possible to track the numbers back to their chipset.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/pci/quirks.c    |   27 +++++++++++++++++++++++++++
 include/linux/pci_ids.h |   10 ++++++++++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index f60c6c6..40fb499 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1661,5 +1661,32 @@ static void __devinit quirk_msi_ht_cap(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, quirk_msi_ht_cap);
 
+static void __devinit quirk_msi_chipset(struct pci_dev *dev)
+{
+	dev->bus->bus_flags |= PCI_BUS_FLAGS_MSI;
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x254C, quirk_msi_chipset);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x2550, quirk_msi_chipset);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x2558, quirk_msi_chipset);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x2560, quirk_msi_chipset);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x2570, quirk_msi_chipset);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x2578, quirk_msi_chipset);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x2580, quirk_msi_chipset);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x2581, quirk_msi_chipset);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x2588, quirk_msi_chipset);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x2590, quirk_msi_chipset);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x25C8, quirk_msi_chipset);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x25D0, quirk_msi_chipset);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x25D4, quirk_msi_chipset);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x2600, quirk_msi_chipset);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x2770, quirk_msi_chipset);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x2774, quirk_msi_chipset);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x2778, quirk_msi_chipset);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x277C, quirk_msi_chipset);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x27A0, quirk_msi_chipset);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x2990, quirk_msi_chipset);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x2A00, quirk_msi_chipset);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x359E, quirk_msi_chipset);
+
 
 #endif /* CONFIG_PCI_MSI */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 62b3e00..71df8c0 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2232,11 +2232,20 @@
 #define PCI_DEVICE_ID_INTEL_82865_IG	0x2572
 #define PCI_DEVICE_ID_INTEL_82875_HB	0x2578
 #define PCI_DEVICE_ID_INTEL_82915G_HB	0x2580
+#define PCI_DEVICE_ID_INTEL_82915_HB	0x2581
 #define PCI_DEVICE_ID_INTEL_82915G_IG	0x2582
+#define PCI_DEVICE_ID_INTEL_E7221_HB	0x2588
 #define PCI_DEVICE_ID_INTEL_82915GM_HB	0x2590
 #define PCI_DEVICE_ID_INTEL_82915GM_IG	0x2592
+#define PCI_DEVICE_ID_INTEL_5000P_HB	0x25C8
+#define PCI_DEVICE_ID_INTEL_5000Z_HB	0x25D0
+#define PCI_DEVICE_ID_INTEL_5000V_HB	0x25D4
+#define PCI_DEVICE_ID_INTEL_E8500_HB	0x2600
 #define PCI_DEVICE_ID_INTEL_82945G_HB	0x2770
 #define PCI_DEVICE_ID_INTEL_82945G_IG	0x2772
+#define PCI_DEVICE_ID_INTEL_82955X_HB	0x2774
+#define PCI_DEVICE_ID_INTEL_3000_HB	0x2778
+#define PCI_DEVICE_ID_INTEL_82975X_HB	0x277C
 #define PCI_DEVICE_ID_INTEL_82945GM_HB	0x27A0
 #define PCI_DEVICE_ID_INTEL_82945GM_IG	0x27A2
 #define PCI_DEVICE_ID_INTEL_ICH6_0	0x2640
@@ -2272,6 +2281,7 @@
 #define PCI_DEVICE_ID_INTEL_ICH9_4	0x2914
 #define PCI_DEVICE_ID_INTEL_ICH9_5	0x2915
 #define PCI_DEVICE_ID_INTEL_ICH9_6	0x2930
+#define PCI_DEVICE_ID_INTEL_82946_HB	0x2990
 #define PCI_DEVICE_ID_INTEL_82855PM_HB	0x3340
 #define PCI_DEVICE_ID_INTEL_82830_HB	0x3575
 #define PCI_DEVICE_ID_INTEL_82830_CGC	0x3577
-- 
1.5.1.1.181.g2de0

