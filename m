Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbZDOAnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbZDOAnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 20:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbZDOAnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 20:43:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:34834 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbZDOAnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 20:43:12 -0400
Message-ID: <49E52D3F.1090206@kernel.org>
Date: Tue, 14 Apr 2009 17:41:35 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: [PATCH] x86/pci: make pci_mem_start to be aligned only -v3
References: <bug-11103-13546@http.bugzilla.kernel.org/> <200904101913.n3AJDhMm018684@demeter.kernel.org> <49DFABCC.3070001@kernel.org> <49E00E9F.8030605@kernel.org> <49E4F6D6.6030709@kernel.org> <49E4F71F.10107@kernel.org> <alpine.LFD.2.00.0904141359020.18124@localhost.localdomain> <49E52A7A.4070607@kernel.org>
In-Reply-To: <49E52A7A.4070607@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: make more big space below 4g for assigning to unassigned pci devices

don't need to reserved one round after the gapstart.

v2: Linus said: "
	We've definitely seen ACPI code or integrated graphics stuff 
	that steals a lot of memory at the end, which means that end-of-RAM might 
	be not at 2GB, but at 2GB-16MB-1MB, for example (1MB of "ACPI data", and 
	16MB of "stolen video ram").

	At a minimum, if we do this, I'd like to make sure we round up to a big 
	boundary (eg 32MB or something - exactly because a missing 16MB can easily 
	be some integrated stolen video memory).

	Sure, we do that whole

		while ((gapsize >> 4) > round)
			round += round;

	thing, so that if the gap is large, then we'll certainly get to 32MB too, 
	but I think your patch matters the most exactly when the gap is small. 
	Maybe we could just raise the initial minimum rounding from 1MB to 32MB?
	...
	Alternatively, maybe we can make sure that we round up to at least X bytes
	from the end of RAM, and to at least Y bytes from the end of some RESERVED 
	thing."
v3: take pci_mem_start - low_top_ram bigger than half around, aka 16M at least


Reported-and-tested-by: Yannick <yannick.roehlly@free.fr>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/e820.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -619,6 +619,7 @@ __init void e820_setup_gap(void)
 {
 	unsigned long gapstart, gapsize, round;
 	int found;
+	unsigned long low_top_ram;
 
 	gapstart = 0x10000000;
 	gapsize = 0x400000;
@@ -636,14 +637,32 @@ __init void e820_setup_gap(void)
 
 	/*
 	 * See how much we want to round up: start off with
-	 * rounding to the next 1MB area.
+	 * rounding to the next 32MB area.
 	 */
-	round = 0x100000;
+	round = 0x2000000;
 	while ((gapsize >> 4) > round)
 		round += round;
+
+	pci_mem_start = roundup(gapstart, round);
+
+	low_top_ram = e820_end_of_low_ram_pfn() << PAGE_SHIFT;
+	/* check if there is gap between last RAM below 4g to that start */
+	if (pci_mem_start > low_top_ram) {
+		if (e820_any_mapped(low_top_ram, pci_mem_start, E820_RESERVED))
+			goto out;
+		if (e820_any_mapped(low_top_ram, pci_mem_start, E820_ACPI))
+			goto out;
+		if (e820_any_mapped(low_top_ram, pci_mem_start, E820_NVS))
+			goto out;
+
+		if ((pci_mem_start - low_top_ram) > (round>>1))
+			goto out;
+	}
+
 	/* Fun with two's complement */
 	pci_mem_start = (gapstart + round) & -round;
 
+out:
 	printk(KERN_INFO
 	       "Allocating PCI resources starting at %lx (gap: %lx:%lx)\n",
 	       pci_mem_start, gapstart, gapsize);
