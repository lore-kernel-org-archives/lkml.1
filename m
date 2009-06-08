Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbZFHRVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbZFHRVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbZFHRUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:20:00 -0400
Received: from relay2.sgi.com ([192.48.179.30]:43645 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753661AbZFHRT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:19:59 -0400
Message-Id: <20090608171957.896591000@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 08 Jun 2009 12:16:53 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 05/12] GRU - delete user request for fetching chiplet status
References: <20090608171648.988318000@sgi.com>
Content-Disposition: inline; filename=uv_gru_delete_chiplet_status
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Delete the user request for fetching the status of a GRU chiplet.
This request has been made obsolete by other changes. Note: this
is not a change to a user API - there are no compatibility
issues with this change.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufile.c |   38 --------------------------------------
 drivers/misc/sgi-gru/grulib.h  |    3 ---
 2 files changed, 41 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufile.c	2009-04-29 13:43:42.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grufile.c	2009-04-29 13:44:16.000000000 -0500
@@ -183,41 +183,6 @@ static long gru_get_config_info(unsigned
 }
 
 /*
- * Get GRU chiplet status
- */
-static long gru_get_chiplet_status(unsigned long arg)
-{
-	struct gru_state *gru;
-	struct gru_chiplet_info info;
-
-	if (copy_from_user(&info, (void __user *)arg, sizeof(info)))
-		return -EFAULT;
-
-	if (info.node == -1)
-		info.node = numa_node_id();
-	if (info.node >= num_possible_nodes() ||
-			info.chiplet >= GRU_CHIPLETS_PER_HUB ||
-			info.node < 0 || info.chiplet < 0)
-		return -EINVAL;
-
-	info.blade = uv_node_to_blade_id(info.node);
-	gru = get_gru(info.blade, info.chiplet);
-
-	info.total_dsr_bytes = GRU_NUM_DSR_BYTES;
-	info.total_cbr = GRU_NUM_CB;
-	info.total_user_dsr_bytes = GRU_NUM_DSR_BYTES -
-		gru->gs_reserved_dsr_bytes;
-	info.total_user_cbr = GRU_NUM_CB - gru->gs_reserved_cbrs;
-	info.free_user_dsr_bytes = hweight64(gru->gs_dsr_map) *
-			GRU_DSR_AU_BYTES;
-	info.free_user_cbr = hweight64(gru->gs_cbr_map) * GRU_CBR_AU_SIZE;
-
-	if (copy_to_user((void __user *)arg, &info, sizeof(info)))
-		return -EFAULT;
-	return 0;
-}
-
-/*
  * gru_file_unlocked_ioctl
  *
  * Called to update file attributes via IOCTL calls.
@@ -242,9 +207,6 @@ static long gru_file_unlocked_ioctl(stru
 	case GRU_USER_UNLOAD_CONTEXT:
 		err = gru_user_unload_context(arg);
 		break;
-	case GRU_GET_CHIPLET_STATUS:
-		err = gru_get_chiplet_status(arg);
-		break;
 	case GRU_USER_FLUSH_TLB:
 		err = gru_user_flush_tlb(arg);
 		break;
Index: linux/drivers/misc/sgi-gru/grulib.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grulib.h	2009-04-29 13:43:42.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grulib.h	2009-04-29 13:44:16.000000000 -0500
@@ -44,9 +44,6 @@
 /* For user unload context */
 #define GRU_USER_UNLOAD_CONTEXT		_IOWR(GRU_IOCTL_NUM, 9, void *)
 
-/* For fetching GRU chiplet status */
-#define GRU_GET_CHIPLET_STATUS		_IOWR(GRU_IOCTL_NUM, 10, void *)
-
 /* For dumpping GRU chiplet state */
 #define GRU_DUMP_CHIPLET_STATE		_IOWR(GRU_IOCTL_NUM, 11, void *)
 

