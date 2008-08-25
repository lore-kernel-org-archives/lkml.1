Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbYHYIMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbYHYIMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 04:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYHYIMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 04:12:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55498 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711AbYHYIMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 04:12:06 -0400
Date: Mon, 25 Aug 2008 10:11:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: check hpet with BAR v3
Message-ID: <20080825081148.GA5033@elte.hu>
References: <1219650968-3534-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219650968-3534-1-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> insert some resources to resource tree forcily, so could avoid kernel 
> update the resources in pci device.
> 
> should check in device too.
> 
> add check for ioapic and mmconfig

ok - this one is even nicer, as the mmconfig angle is i suspect a real 
issue too. I've queued up the commit below in x86/urgent.

Barring any test failures this looks like something that might be doable 
for v2.6.27.

The enumeration of various PC resources looks a bit ugly - but those 
_are_ ugly because they are really non-PCI ad-hoc details of the PC 
platform, with no single coherent driver framework around them.

I think the impact of the commit is narrow and to the point: it will 
only affect generic PCI devices that have an existing BAR overlap with 
any of the known PC platform resources, and causes them to not be 
reallocated. Not touching that devices is the most prudent thing to do 
in such a situation, and no non-platform device can accidentally be at 
that address anyway. (as the system would very likely not work at all in 
that case)

Jesse, Linus, what do you think?

David: i've optimistically inserted your Tested-by line into the commit. 
Could you please double-check that this commit too solves your hang (it 
really is expected to), out of box? (You can try tip/master, it has this 
integrated already.)

	Ingo

------------->
>From a2bd7274b47124d2fc4dfdb8c0591f545ba749dd Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yhlu.kernel@gmail.com>
Date: Mon, 25 Aug 2008 00:56:08 -0700
Subject: [PATCH] x86: fix HPET regression in 2.6.26 versus 2.6.25, check hpet against BAR, v3

David Witbrodt tracked down (and bisected) a hpet bootup hang on his
system to the following problem: a BIOS bug made the hpet device
visible as a generic PCI device. If e820 reserved entries happen to
be registered first in the resource tree [which v2.6.26 started doing],
then the PCI code will reallocate that device's BAR to some other
address - breaking timer IRQs and hanging the system.

( Normally hpet devices are hidden by the BIOS from the OS's PCI
  discovery via chipset magic. Sometimes the hpet is not a PCI device
  at all. )

Solve this fundamental fragility by making non-PCI platform drivers
insert resources into the resource tree even if it overlaps the e820
reserved entry, to keep the resource manager from updating the BAR.

Also do these checks for the ioapic and mmconfig addresses, and emit
a warning if this happens.

Bisected-by: David Witbrodt <dawitbro@sbcglobal.net>
Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Tested-by: David Witbrodt <dawitbro@sbcglobal.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/pci/i386.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 5807d1b..d765da9 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -31,8 +31,11 @@
 #include <linux/ioport.h>
 #include <linux/errno.h>
 #include <linux/bootmem.h>
+#include <linux/acpi.h>
 
 #include <asm/pat.h>
+#include <asm/hpet.h>
+#include <asm/io_apic.h>
 
 #include "pci.h"
 
@@ -77,6 +80,77 @@ pcibios_align_resource(void *data, struct resource *res,
 }
 EXPORT_SYMBOL(pcibios_align_resource);
 
+static int check_res_with_valid(struct pci_dev *dev, struct resource *res)
+{
+	unsigned long base;
+	unsigned long size;
+	int i;
+
+	base = res->start;
+	size = (res->start == 0 && res->end == res->start) ? 0 :
+		 (res->end - res->start + 1);
+
+	if (!base || !size)
+		return 0;
+
+#ifdef CONFIG_HPET_TIMER
+	/* for hpet */
+	if (base == hpet_address && (res->flags & IORESOURCE_MEM)) {
+		dev_info(&dev->dev, "BAR has HPET at %08lx-%08lx\n",
+				 base, base + size - 1);
+		return 1;
+	}
+#endif
+
+#ifdef CONFIG_X86_IO_APIC
+	for (i = 0; i < nr_ioapics; i++) {
+		unsigned long ioapic_phys = mp_ioapics[i].mp_apicaddr;
+
+		if (base == ioapic_phys && (res->flags & IORESOURCE_MEM)) {
+			dev_info(&dev->dev, "BAR has ioapic at %08lx-%08lx\n",
+					 base, base + size - 1);
+			return 1;
+		}
+	}
+#endif
+
+#ifdef CONFIG_PCI_MMCONFIG
+	for (i = 0; i < pci_mmcfg_config_num; i++) {
+		unsigned long addr;
+
+		addr = pci_mmcfg_config[i].address;
+		if (base == addr && (res->flags & IORESOURCE_MEM)) {
+			dev_info(&dev->dev, "BAR has MMCONFIG at %08lx-%08lx\n",
+					 base, base + size - 1);
+			return 1;
+		}
+	}
+#endif
+
+	return 0;
+}
+
+static int check_platform(struct pci_dev *dev, struct resource *res)
+{
+	struct resource *root = NULL;
+
+	/*
+	 * forcibly insert it into the
+	 * resource tree
+	 */
+	if (res->flags & IORESOURCE_MEM)
+		root = &iomem_resource;
+	else if (res->flags & IORESOURCE_IO)
+		root = &ioport_resource;
+
+	if (root && check_res_with_valid(dev, res)) {
+		insert_resource(root, res);
+
+		return 1;
+	}
+
+	return 0;
+}
 /*
  *  Handle resources of PCI devices.  If the world were perfect, we could
  *  just allocate all the resource regions and do nothing more.  It isn't.
@@ -128,6 +202,8 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
 				pr = pci_find_parent_resource(dev, r);
 				if (!r->start || !pr ||
 				    request_resource(pr, r) < 0) {
+					if (check_platform(dev, r))
+						continue;
 					dev_err(&dev->dev, "BAR %d: can't "
 						"allocate resource\n", idx);
 					/*
@@ -171,6 +247,8 @@ static void __init pcibios_allocate_resources(int pass)
 					r->flags, disabled, pass);
 				pr = pci_find_parent_resource(dev, r);
 				if (!pr || request_resource(pr, r) < 0) {
+					if (check_platform(dev, r))
+						continue;
 					dev_err(&dev->dev, "BAR %d: can't "
 						"allocate resource\n", idx);
 					/* We'll assign a new address later */
