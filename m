Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbXD2KyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbXD2KyN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085AbXD2KyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:54:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756326AbXD2Kxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:51 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Konrad Rzeszutek <konrad@darnok.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [45/48] x86_64: Inhibit machine from asserting an NMI when doing Alt-SysRq-M operation.
Message-Id: <20070429105335.BEF8A151CA@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Konrad Rzeszutek <konrad@darnok.org>
This patch touches the NMI watchdog every MAX_ORDER_NR_PAGES
to inhibit the machine from triggering an NMI while the CPUs
are locked. This situation is happening on boxes with more 
than 64CPUs and 128GB of RAM when Alt-SysRq-m is performed.

It has been succesfully tested for regression on uni, 2, 4, 8 
32, and 64 CPU boxes with various memory configuration.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/mm/init.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux/arch/x86_64/mm/init.c
===================================================================
--- linux.orig/arch/x86_64/mm/init.c
+++ linux/arch/x86_64/mm/init.c
@@ -27,6 +27,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/memory_hotplug.h>
+#include <linux/nmi.h>
 
 #include <asm/processor.h>
 #include <asm/system.h>
@@ -73,6 +74,11 @@ void show_mem(void)
 
 	for_each_online_pgdat(pgdat) {
                for (i = 0; i < pgdat->node_spanned_pages; ++i) {
+			/* this loop can take a while with 256 GB and 4k pages
+			   so update the NMI watchdog */
+			if (unlikely(i % MAX_ORDER_NR_PAGES == 0)) {
+				touch_nmi_watchdog();
+			}
 			page = pfn_to_page(pgdat->node_start_pfn + i);
 			total++;
 			if (PageReserved(page))
