Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbYKZAes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbYKZAes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 19:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYKZAei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 19:34:38 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:38997 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYKZAeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 19:34:37 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 26 Nov 2008 01:34:25 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: fix list corruption (reported at module removal)
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.f8f7746d95c4ceee@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is more than one FireWire controller present, dummy_zero_addr
and dummy_max_addr were added multiple times to different lists, thus
corrupting the lists.  Fix this by allocating them dynamically per host
instead of just once globally.

(Perhaps a better address space allocation algorithm could rid us of the
two dummy address spaces.)

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=10129 .

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/highlevel.c |   25 ++++++++++++-------------
 drivers/ieee1394/hosts.h     |    4 ++++
 2 files changed, 16 insertions(+), 13 deletions(-)

Index: linux/drivers/ieee1394/highlevel.c
===================================================================
--- linux.orig/drivers/ieee1394/highlevel.c
+++ linux/drivers/ieee1394/highlevel.c
@@ -46,10 +46,6 @@ static DEFINE_RWLOCK(hl_irqs_lock);
 
 static DEFINE_RWLOCK(addr_space_lock);
 
-/* addr_space list will have zero and max already included as bounds */
-static struct hpsb_address_ops dummy_ops = { NULL, NULL, NULL, NULL };
-static struct hpsb_address_serve dummy_zero_addr, dummy_max_addr;
-
 
 static struct hl_host_info *hl_get_hostinfo(struct hpsb_highlevel *hl,
 					    struct hpsb_host *host)
@@ -481,20 +477,23 @@ int hpsb_unregister_addrspace(struct hps
 	return retval;
 }
 
+static struct hpsb_address_ops dummy_ops;
+
+/* dummy address spaces as lower and upper bounds of the host's a.s. list */
 static void init_hpsb_highlevel(struct hpsb_host *host)
 {
-	INIT_LIST_HEAD(&dummy_zero_addr.host_list);
-	INIT_LIST_HEAD(&dummy_zero_addr.hl_list);
-	INIT_LIST_HEAD(&dummy_max_addr.host_list);
-	INIT_LIST_HEAD(&dummy_max_addr.hl_list);
+	INIT_LIST_HEAD(&host->dummy_zero_addr.host_list);
+	INIT_LIST_HEAD(&host->dummy_zero_addr.hl_list);
+	INIT_LIST_HEAD(&host->dummy_max_addr.host_list);
+	INIT_LIST_HEAD(&host->dummy_max_addr.hl_list);
 
-	dummy_zero_addr.op = dummy_max_addr.op = &dummy_ops;
+	host->dummy_zero_addr.op = host->dummy_max_addr.op = &dummy_ops;
 
-	dummy_zero_addr.start = dummy_zero_addr.end = 0;
-	dummy_max_addr.start = dummy_max_addr.end = ((u64) 1) << 48;
+	host->dummy_zero_addr.start = host->dummy_zero_addr.end = 0;
+	host->dummy_max_addr.start = host->dummy_max_addr.end = ((u64) 1) << 48;
 
-	list_add_tail(&dummy_zero_addr.host_list, &host->addr_space);
-	list_add_tail(&dummy_max_addr.host_list, &host->addr_space);
+	list_add_tail(&host->dummy_zero_addr.host_list, &host->addr_space);
+	list_add_tail(&host->dummy_max_addr.host_list, &host->addr_space);
 }
 
 void highlevel_add_host(struct hpsb_host *host)
Index: linux/drivers/ieee1394/hosts.h
===================================================================
--- linux.orig/drivers/ieee1394/hosts.h
+++ linux/drivers/ieee1394/hosts.h
@@ -13,6 +13,7 @@ struct module;
 
 #include "ieee1394_types.h"
 #include "csr.h"
+#include "highlevel.h"
 
 struct hpsb_packet;
 struct hpsb_iso;
@@ -72,6 +73,9 @@ struct hpsb_host {
 	struct { DECLARE_BITMAP(map, 64); } tl_pool[ALL_NODES];
 
 	struct csr_control csr;
+
+	struct hpsb_address_serve dummy_zero_addr;
+	struct hpsb_address_serve dummy_max_addr;
 };
 
 enum devctl_cmd {

-- 
Stefan Richter
-=====-==--- =-== ==-=-
http://arcgraph.de/sr/

