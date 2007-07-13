Return-Path: <linux-kernel-owner+w=401wt.eu-S1761606AbXGMCqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761606AbXGMCqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 22:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbXGMCqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 22:46:36 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:61159 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbXGMCqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 22:46:36 -0400
Date: Fri, 13 Jul 2007 10:45:07 +0800
From: Joe Jin <joe.jin@oracle.com>
To: akpm@osdl.org, bill.irwin@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Add nid sanity on alloc_pages_node
Message-ID: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add nid sanity check on alloc_pages_node().
While two process change nr_hugepages at a system, alloc_fresh_huge_page()
been called, at this function, nid defined as a static variable, but, there
is not any protection of, if 2 process called at the same time, maybe pass a
invalid nid to alloc_pages_node. 

We have hit it by following scripts:

#!/bin/bash
while : ; do 
	echo 1000000000000 > /proc/sys/vm/nr_hugepages 
	echo 1 > /proc/sys/vm/nr_hugepages 
	echo 10000000000000000000 > /proc/sys/vm/nr_hugepages 
	echo 0 > /proc/sys/vm/nr_hugepages 
done 


Run the script at _two_ difference terminal, after a short time, a kernel panic
info will print.


Signed-off-by: Joe Jin <joe.jin@oracle.com>
---

--- linux-2.6.22/include/linux/gfp.h.orig	2007-07-12 15:06:23.000000000 +0800
+++ linux-2.6.22/include/linux/gfp.h	2007-07-12 15:02:59.000000000 +0800
@@ -133,6 +133,9 @@
 	/* Unknown node is current node */
 	if (nid < 0)
 		nid = numa_node_id();
+	
+	if (unlikely(nid == MAX_NUMNODES))
+		nid = first_node(node_online_map);
 
 	return __alloc_pages(gfp_mask, order,
 		NODE_DATA(nid)->node_zonelists + gfp_zone(gfp_mask));
