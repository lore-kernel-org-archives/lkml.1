Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbXIYXsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbXIYXsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbXIYXn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:43:27 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:57663 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752736AbXIYXmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:42:52 -0400
Message-Id: <20070925234251.272511860@sgi.com>
References: <20070925234204.546836393@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 25 Sep 2007 16:42:13 -0700
From: Christoph Lameter <clameter@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [09/17] VFALLBACK: Debugging aid
Content-Disposition: inline; filename=vcompound_debugging_aid
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Virtual fallbacks are rare and thus subtle bugs may creep in if we do not
test the fallbacks. CONFIG_VFALLBACK_ALWAYS makes all GFP_VFALLBACK
allocations fall back to virtual mapping.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 lib/Kconfig.debug |   11 +++++++++++
 mm/page_alloc.c   |    6 ++++++
 2 files changed, 17 insertions(+)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2007-09-24 18:48:03.000000000 -0700
+++ linux-2.6/mm/page_alloc.c	2007-09-24 18:58:52.000000000 -0700
@@ -1208,6 +1208,12 @@ zonelist_scan:
 			}
 		}
 
+#ifdef CONFIG_VFALLBACK_ALWAYS
+		if ((gfp_mask & __GFP_VFALLBACK) &&
+				system_state == SYSTEM_RUNNING)
+			return vcompound_alloc(gfp_mask, order,
+					zonelist, alloc_flags);
+#endif
 		page = buffered_rmqueue(zonelist, zone, order, gfp_mask);
 		if (page)
 			break;
Index: linux-2.6/lib/Kconfig.debug
===================================================================
--- linux-2.6.orig/lib/Kconfig.debug	2007-09-24 18:30:45.000000000 -0700
+++ linux-2.6/lib/Kconfig.debug	2007-09-24 18:48:06.000000000 -0700
@@ -105,6 +105,17 @@ config DETECT_SOFTLOCKUP
 	   can be detected via the NMI-watchdog, on platforms that
 	   support it.)
 
+config VFALLBACK_ALWAYS
+	bool "Always fall back to Virtual Compound pages"
+	default y
+	help
+	  Virtual compound pages are only allocated if there is no linear
+	  memory available. They are a fallback and errors created by the
+	  use of virtual mappings instead of linear ones may not surface
+	  because of their infrequent use. This option makes every
+	  allocation that allows a fallback to a virtual mapping use
+	  the virtual mapping. May have a significant performance impact.
+
 config SCHED_DEBUG
 	bool "Collect scheduler debugging info"
 	depends on DEBUG_KERNEL && PROC_FS

-- 
