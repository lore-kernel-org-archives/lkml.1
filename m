Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbYJ0WdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbYJ0WdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 18:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYJ0Wcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 18:32:53 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51362 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbYJ0Wcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 18:32:52 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 27 Oct 2008 23:28:14 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 2.6.27.y 4/6] firewire: fix struct fw_node memory leak
To: stable@kernel.org
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.df6e0a4afb92ef6e@s5r6.in-berlin.de>
Message-ID: <tkrat.e499a05eaa0ec529@s5r6.in-berlin.de>
References: <tkrat.df6e0a4afb92ef6e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Thu, 16 Oct 2008 18:00:15 -0400
From: Jay Fenlason <fenlason@redhat.com>

With the bus_resets patch applied, it is easy to see this memory leak
by repeatedly resetting the firewire bus while running slabtop in
another window.  Just watch kmalloc-32 grow and grow...

Same as commit 77e557191701afa55ae7320d42ad6458a2ad292e.

Signed-off-by: Jay Fenlason <fenlason@redhat.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-topology.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux/drivers/firewire/fw-topology.c
===================================================================
--- linux.orig/drivers/firewire/fw-topology.c
+++ linux/drivers/firewire/fw-topology.c
@@ -413,7 +413,7 @@ static void
 update_tree(struct fw_card *card, struct fw_node *root)
 {
 	struct list_head list0, list1;
-	struct fw_node *node0, *node1;
+	struct fw_node *node0, *node1, *next1;
 	int i, event;
 
 	INIT_LIST_HEAD(&list0);
@@ -485,7 +485,9 @@ update_tree(struct fw_card *card, struct
 		}
 
 		node0 = fw_node(node0->link.next);
-		node1 = fw_node(node1->link.next);
+		next1 = fw_node(node1->link.next);
+		fw_node_put(node1);
+		node1 = next1;
 	}
 }
 

-- 
Stefan Richter
-=====-==--- =-=- ==-==
http://arcgraph.de/sr/

