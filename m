Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbXC0N4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbXC0N4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 09:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbXC0N4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 09:56:06 -0400
Received: from andromeda.dapyr.net ([69.45.6.100]:47274 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbXC0N4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 09:56:05 -0400
X-Greylist: delayed 644 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Mar 2007 09:56:04 EDT
Date: Tue, 27 Mar 2007 09:45:08 -0400
From: Konrad Rzeszutek <konrad@darnok.org>
To: linux-kernel@vger.kernel.org
Cc: konradr@redhat.com, konradr@us.ibm.com
Subject: [PATCH] Inhibit machine from asserting an NMI when doing Alt-SysRq-M operation.
Message-ID: <20070327134508.GA21548@andromeda.dapyr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch touches the NMI watchdog every MAX_ORDER_NR_PAGES
to inhibit the machine from triggering an NMI while the CPUs
are locked. This situation is happening on boxes with more 
than 64CPUs and 128GB of RAM when Alt-SysRq-m is performed.

It has been succesfully tested for regression on uni, 2, 4, 8 
32, and 64 CPU boxes with various memory configuration.

diff --git a/arch/x86_64/mm/init.c b/arch/x86_64/mm/init.c
index ec31534..fd7f8a6 100644
--- a/arch/x86_64/mm/init.c
+++ b/arch/x86_64/mm/init.c
@@ -26,6 +26,7 @@ #include <linux/poison.h>
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/memory_hotplug.h>
+#include <linux/nmi.h>
 
 #include <asm/processor.h>
 #include <asm/system.h>
@@ -72,6 +73,11 @@ void show_mem(void)
 
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
