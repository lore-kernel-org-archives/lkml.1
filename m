Return-Path: <linux-kernel-owner+w=401wt.eu-S933237AbZKXPNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237AbZKXPNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933232AbZKXPHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:07:43 -0500
Received: from relay3.sgi.com ([192.48.152.1]:39125 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933223AbZKXPHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:41 -0500
Message-Id: <20091124150747.383549000@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 24 Nov 2009 09:05:58 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 01/29] GRU - Initial GRU based on blade topology
References: <20091124150557.082648000@sgi.com>
Content-Disposition: inline; filename=uv_gru_blade_fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Change the GRU initialization code to initialize
based on blade topology instead of node topology. The result
is the same but blade-based initialization is cleaner.


Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 drivers/misc/sgi-gru/grufile.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufile.c	2009-11-20 09:32:15.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grufile.c	2009-11-20 09:32:26.000000000 -0600
@@ -264,11 +264,9 @@ static int gru_init_tables(unsigned long
 
 	max_user_cbrs = GRU_NUM_CB;
 	max_user_dsr_bytes = GRU_NUM_DSR_BYTES;
-	for_each_online_node(nid) {
-		bid = uv_node_to_blade_id(nid);
-		pnode = uv_node_to_pnode(nid);
-		if (bid < 0 || gru_base[bid])
-			continue;
+	for_each_possible_blade(bid) {
+		pnode = uv_blade_to_pnode(bid);
+		nid = uv_blade_to_memory_nid(bid);
 		page = alloc_pages_exact_node(nid, GFP_KERNEL, order);
 		if (!page)
 			goto fail;
@@ -298,8 +296,8 @@ static int gru_init_tables(unsigned long
 	return 0;
 
 fail:
-	for (nid--; nid >= 0; nid--)
-		free_pages((unsigned long)gru_base[nid], order);
+	for (bid--; bid >= 0; bid--)
+		free_pages((unsigned long)gru_base[bid], order);
 	return -ENOMEM;
 }
 

