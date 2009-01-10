Return-Path: <linux-kernel-owner+w=401wt.eu-S1758774AbZAJByg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774AbZAJByg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 20:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbZAJBy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 20:54:27 -0500
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:23734 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750907AbZAJBy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 20:54:26 -0500
X-Greylist: delayed 651 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jan 2009 20:54:26 EST
Date: Fri, 09 Jan 2009 18:43:34 -0700
From: dougthompson@xmission.com
To: h.mitake@gmail.com, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/1] edac: add more verbose debug info
Message-ID: <4967fd46.3sEWAxygH6AQ2REb%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hitoshi Mitake <h.mitake@gmail.com>

I wrote a patch for making a debugging information more verbose
for use in development debugging.

If this patch applied and enabled new option "More verbose debugging",
information about source file and line number will be added to debugging message.

This is sample output,

EDAC MC0: Giving out device to 'e7xxx_edac' 'E7205': DEV 0000:00:00.0
EDAC DEBUG: in drivers/edac/edac_pci.c, line at 48: edac_pci_alloc_ctl_info()
EDAC DEBUG: in drivers/edac/edac_pci.c, line at 334: edac_pci_add_device()
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I think this patch is comfortable for EDAC developers.
This is patch, please use.

Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
---
 Kconfig     |    8 ++++++++
 edac_core.h |   15 ++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

Index: linux-2.6.28/drivers/edac/Kconfig
===================================================================
--- linux-2.6.28.orig/drivers/edac/Kconfig
+++ linux-2.6.28/drivers/edac/Kconfig
@@ -40,6 +40,14 @@ config EDAC_DEBUG
 	  there're four debug levels (x=0,1,2,3 from low to high).
 	  Usually you should select 'N'.
 
+config EDAC_DEBUG_VERBOSE
+	bool "More verbose debugging"
+	depends on EDAC_DEBUG
+	help
+	  This option makes debugging information more verbose.
+	  Source file name and line number where debugging message
+	  printed will be added to debugging message.
+
 config EDAC_MM_EDAC
 	tristate "Main Memory EDAC (Error Detection And Correction) reporting"
 	default y
Index: linux-2.6.28/drivers/edac/edac_core.h
===================================================================
--- linux-2.6.28.orig/drivers/edac/edac_core.h
+++ linux-2.6.28/drivers/edac/edac_core.h
@@ -49,6 +49,10 @@
 #define edac_printk(level, prefix, fmt, arg...) \
 	printk(level "EDAC " prefix ": " fmt, ##arg)
 
+#define edac_printk_verbose(level, prefix, fmt, arg...) \
+	printk(level "EDAC " prefix ": " "in %s, line at %d: " fmt,	\
+	       __FILE__, __LINE__, ##arg)
+
 #define edac_mc_printk(mci, level, fmt, arg...) \
 	printk(level "EDAC MC%d: " fmt, mci->mc_idx, ##arg)
 
@@ -71,11 +75,20 @@
 #ifdef CONFIG_EDAC_DEBUG
 extern int edac_debug_level;
 
+#ifndef CONFIG_EDAC_DEBUG_VERBOSE
 #define edac_debug_printk(level, fmt, arg...)                            \
 	do {                                                             \
 		if (level <= edac_debug_level)                           \
 			edac_printk(KERN_DEBUG, EDAC_DEBUG, fmt, ##arg); \
-	} while(0)
+	} while (0)
+#else  /* CONFIG_EDAC_DEBUG_VERBOSE */
+#define edac_debug_printk(level, fmt, arg...)                            \
+	do {                                                             \
+		if (level <= edac_debug_level)                           \
+			edac_printk_verbose(KERN_DEBUG, EDAC_DEBUG, fmt, \
+					    ##arg);			\
+	} while (0)
+#endif
 
 #define debugf0( ... ) edac_debug_printk(0, __VA_ARGS__ )
 #define debugf1( ... ) edac_debug_printk(1, __VA_ARGS__ )
