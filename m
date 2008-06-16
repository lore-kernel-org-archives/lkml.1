Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbYFPVzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbYFPVzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 17:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757362AbYFPVzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 17:55:31 -0400
Received: from gw.goop.org ([64.81.55.164]:38038 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757023AbYFPVza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 17:55:30 -0400
Message-ID: <4856E129.2000608@goop.org>
Date: Mon, 16 Jun 2008 14:54:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: the arch/x86 maintainers <x86@kernel.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] xen: reserve ISA space in e820 map
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though the ISA space is perfectly normal, usable RAM under
Xen, too many random pieces of code want to poke in there for stuff.
Previously we added the memory on either side to the e820 map as RAM,
leaving the ISA hole completely absent.  However, now that we're using
sanitize_e820_map() to clean things up, it's a bit neater to claim all
of memory as RAM, and then mark E820_RESERVED ranges within it.

[ TODO: release the underlying memory back to Xen. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ian Campbell <ian.campbell@citrix.com>
---
 arch/x86/xen/setup.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

===================================================================
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -13,6 +13,7 @@
 #include <asm/vdso.h>
 #include <asm/e820.h>
 #include <asm/setup.h>
+#include <asm/acpi.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 
@@ -41,8 +42,15 @@
 
 	e820.nr_map = 0;
 
-	e820_add_region(0, LOWMEMSIZE(), E820_RAM);
-	e820_add_region(HIGH_MEMORY, PFN_PHYS(max_pfn)-HIGH_MEMORY, E820_RAM);
+	e820_add_region(0, PFN_PHYS(max_pfn), E820_RAM);
+
+	/*
+	 * Even though this is normal, usable memory under Xen, reserve
+	 * ISA memory anyway because too many things think they can poke
+	 * about in there.
+	 */
+	e820_add_region(ISA_START_ADDRESS, ISA_END_ADDRESS - ISA_START_ADDRESS,
+			E820_RESERVED);
 
 	/*
 	 * Reserve Xen bits:


