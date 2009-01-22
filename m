Return-Path: <linux-kernel-owner+w=401wt.eu-S1761925AbZAVR47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761925AbZAVR47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759230AbZAVRuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:50:51 -0500
Received: from relay2.sgi.com ([192.48.179.30]:39036 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760090AbZAVRu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:50:29 -0500
Message-Id: <20090122175028.252109000@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 22 Jan 2009 11:49:25 -0600
From: steiner@sgi.com
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 08/14] Add support for a user to explicitly unload a GRU context
References: <20090122174917.563627000@sgi.com>
Content-Disposition: inline; filename=uv_gru_unload_all_contexts
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Add support for a user to explicitly unload a GRU context.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufault.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2009-01-15 08:18:06.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grufault.c	2009-01-15 08:18:10.000000000 -0600
@@ -32,6 +32,7 @@
 #include <linux/device.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
+#include <linux/security.h>
 #include <asm/pgtable.h>
 #include "gru.h"
 #include "grutables.h"
@@ -575,6 +576,38 @@ int gru_get_exception_detail(unsigned lo
 /*
  * User request to unload a context. Content is saved for possible reload.
  */
+static int gru_unload_all_contexts(void)
+{
+	struct gru_thread_state *gts;
+	struct gru_state *gru;
+	int maxgid, gid, ctxnum;
+	int nodesperblade;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (num_online_nodes() > 1 &&
+			(uv_node_to_blade_id(1) == uv_node_to_blade_id(0)))
+		nodesperblade = 2;
+	else
+		nodesperblade = 1;
+	maxgid = GRU_CHIPLETS_PER_BLADE * num_online_nodes() / nodesperblade;
+	for (gid = 0; gid < maxgid; gid++) {
+		gru = GID_TO_GRU(gid);
+		spin_lock(&gru->gs_lock);
+		for (ctxnum = 0; ctxnum < GRU_NUM_CCH; ctxnum++) {
+			gts = gru->gs_gts[ctxnum];
+			if (gts && mutex_trylock(&gts->ts_ctxlock)) {
+				spin_unlock(&gru->gs_lock);
+				gru_unload_context(gts, 1);
+				gru_unlock_gts(gts);
+				spin_lock(&gru->gs_lock);
+			}
+		}
+		spin_unlock(&gru->gs_lock);
+	}
+	return 0;
+}
+
 int gru_user_unload_context(unsigned long arg)
 {
 	struct gru_thread_state *gts;
@@ -586,6 +619,9 @@ int gru_user_unload_context(unsigned lon
 
 	gru_dbg(grudev, "gseg 0x%lx\n", req.gseg);
 
+	if (!req.gseg)
+		return gru_unload_all_contexts();
+
 	gts = gru_find_lock_gts(req.gseg);
 	if (!gts)
 		return -EINVAL;

