Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbYHYHb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbYHYHb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 03:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbYHYHbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 03:31:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58299 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338AbYHYHbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 03:31:43 -0400
Date: Mon, 25 Aug 2008 09:31:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: David Witbrodt <dawitbro@sbcglobal.net>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user
	with the same regression
Message-ID: <20080825073125.GA27950@elte.hu>
References: <914225.91320.qm@web82104.mail.mud.yahoo.com> <86802c440808242141j716b5875s709dc56c1163a7d5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808242141j716b5875s709dc56c1163a7d5@mail.gmail.com>
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

> this one should work. please apply this one only.
> 
> YH
>
> [PATCH] x86: check hpet with BAR v2

great. I've cleaned it up a bit (see the final commit below) and queued 
it up in tip/x86/urgent for some testing. But there are a few open 
questions, and an Ack/feedback from Jesse/Linus would be nice as well:

- the forced insertion and the embedded knowledge about iomem_resource
  and ioport_resource looks ugly to me.

- we should also extend this to other platform resource types that we 
  know about: ioapic address(es) might be a prime candidate. (local 
  APICs are CPU entities and should never show up as PCI devices) The 
  mmconfig range is already properly accounted for by the PCI code 
  itself, right?

- plus a more highlevel approach would be nice as well i think - making 
  sure that the hpet driver runs before any of the PCI code, and 
  inserting a special "sticky" resource there which would keep any 
  potential followup generic PCI resource that overlaps this resource 
  untouched. (with a proper kernel warning emitted as well - such 
  situations are likely BIOS bugs.)

Possibly not for v2.6.27 though.

	Ingo

----------->
>From f3865e9710bd4ac5750feae628469f998e49d0b4 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yhlu.kernel@gmail.com>
Date: Sun, 24 Aug 2008 21:41:28 -0700
Subject: [PATCH] x86: fix HPET regression in 2.6.26 versus 2.6.25, check hpet against BAR v2

David Witbrodt tracked down (and bisected) a bootup hang on his system
to the following problem: a BIOS bug made the hpet device visible as a
generic PCI device. If e820 reserved entries happen to be registered
first in the resource tree [which v2.6.26 started doing - to fix other
bugs], then the PCI code will reallocate that device's BAR to some other
address - breaking timer IRQs and hanging the system.

( Normally hpet devices are hidden by the BIOS from the OS's PCI discovery
  via chipset magic. Sometimes the hpet is not a PCI device at all. )

Solve this fundamental fragility by making the non-PCI platform driver
insert resources into the resource tree even if it overlaps the e820
reserved entry, to keep the resource manager from updating the BAR.

NOTE: this is an RFC for now, there might be other, better approaches
      as well:

 - introduce a new resource type that is 'sticky': it would keep BARs
   that are embedded in it from being reallocated.

or

 - update the hpet_address from the PCI code. This is risky though: these
   PCI devices are often non-generic and might break if we change their
   BAR.

or

 - do not insert e820 reserved entries at all. This would have
   disadvantages as well: if there's some special non-RAM ACPI or SMM
   area known to the system and enumerated in the e820 map, we must not
   allow the PCI code from possibly allocating a resource into that
   region.

[ mingo@elte.hu: cleanups ]

Bisected-by: David Witbrodt <dawitbro@sbcglobal.net>
Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Tested-by: David Witbrodt <dawitbro@sbcglobal.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/pci/i386.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 5807d1b..562ec4d 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -33,6 +33,7 @@
 #include <linux/bootmem.h>
 
 #include <asm/pat.h>
+#include <asm/hpet.h>
 
 #include "pci.h"
 
@@ -78,6 +79,47 @@ pcibios_align_resource(void *data, struct resource *res,
 EXPORT_SYMBOL(pcibios_align_resource);
 
 /*
+ * Make sure we protect magic platform devices such as hpet,
+ * even if they show up in PCI discovery. (which should really
+ * not happen, but it does on some broken BIOSen)
+ */
+static int check_platform(struct pci_dev *dev, struct resource *res)
+{
+	unsigned long base;
+	unsigned long size;
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
+		struct resource *root = NULL;
+
+		WARN("BAR has HPET at %08lx-%08lx\n", base, base + size - 1);
+		/*
+		 * forcibly insert it into the
+		 * resource tree
+		 */
+		if (res->flags & IORESOURCE_MEM)
+			root = &iomem_resource;
+		else if (res->flags & IORESOURCE_IO)
+			root = &ioport_resource;
+
+		if (root)
+			insert_resource(root, res);
+		return 1;
+	}
+#endif
+
+	return 0;
+}
+
+/*
  *  Handle resources of PCI devices.  If the world were perfect, we could
  *  just allocate all the resource regions and do nothing more.  It isn't.
  *  On the other hand, we cannot just re-allocate all devices, as it would
@@ -171,6 +213,8 @@ static void __init pcibios_allocate_resources(int pass)
 					r->flags, disabled, pass);
 				pr = pci_find_parent_resource(dev, r);
 				if (!pr || request_resource(pr, r) < 0) {
+					if (check_platform(dev, r))
+						continue;
 					dev_err(&dev->dev, "BAR %d: can't "
 						"allocate resource\n", idx);
 					/* We'll assign a new address later */
