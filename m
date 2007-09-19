Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbXISDmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbXISDmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 23:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbXISDhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 23:37:16 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54942 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752030AbXISDgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 23:36:43 -0400
Message-Id: <20070919033642.412382143@sgi.com>
From: Christoph Lameter <clameter@sgi.com>
References: <20070919033605.785839297@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 20:36:14 -0700
To: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [09/17] VFALLBACK: Debugging aid
Content-Disposition: inline; filename=vcompound_debuging_aid
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Virtual fallbacks are rare and thus subtle bugs may creep in if we do not
test the fallbacks. CONFIG_VFALLBACK_ALWAYS makes all GFP_VFALLBACK
allocations fall back to virtual mapping.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 lib/Kconfig.debug |   11 +++++++++++
 mm/page_alloc.c   |    9 +++++++++
 2 files changed, 20 insertions(+)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2007-09-18 19:19:34.000000000 -0700
+++ linux-2.6/mm/page_alloc.c	2007-09-18 20:16:26.000000000 -0700
@@ -1205,7 +1205,16 @@ zonelist_scan:
 					goto this_zone_full;
 			}
 		}
+#ifdef CONFIG_VFALLBACK_ALWAYS
+		if ((gfp_mask & __GFP_VFALLBACK) &&
+				system_state == SYSTEM_RUNNING)  {
+			struct page *vcompound_alloc(gfp_t, int,
+					struct zonelist *, unsigned long);
 
+			page = vcompound_alloc(gfp_mask, order,
+						zonelist, alloc_flags);
+		} else
+#endif
 		page = buffered_rmqueue(zonelist, zone, order, gfp_mask);
 		if (page)
 			break;
Index: linux-2.6/lib/Kconfig.debug
===================================================================
--- linux-2.6.orig/lib/Kconfig.debug	2007-09-18 19:19:28.000000000 -0700
+++ linux-2.6/lib/Kconfig.debug	2007-09-18 19:19:34.000000000 -0700
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
