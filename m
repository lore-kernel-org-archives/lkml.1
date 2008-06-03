Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbYFCCAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbYFCCAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 22:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbYFCB6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 21:58:37 -0400
Received: from saeurebad.de ([85.214.36.134]:39493 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756841AbYFCB6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 21:58:36 -0400
X-Mailbox-Line: From hannes@saeurebad.de Tue Jun  3 02:53:03 2008
Message-Id: <20080603005303.342533989@saeurebad.de>
References: <20080603005017.593345596@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jun 2008 02:50:23 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, Yasunori Goto <y-goto@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 06/14] bootmem: revisit bootmem descriptor list handling
Content-Disposition: inline; filename=bootmem-revisit-bootmem-descriptor-list.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

link_bootmem handles an insertion of a new descriptor into the sorted
list in more or less three explicit branches; empty list, insert in
between and append.  These cases can be expressed implicite.

Also mark the sorted list as initdata as it can be thrown away after
boot as well.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---

 mm/bootmem.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -23,7 +23,6 @@ unsigned long max_low_pfn;
 unsigned long min_low_pfn;
 unsigned long max_pfn;
 
-static LIST_HEAD(bdata_list);
 #ifdef CONFIG_CRASH_DUMP
 /*
  * If we have booted due to a crash, max_pfn will be a very low value. We need
@@ -34,6 +33,8 @@ unsigned long saved_max_pfn;
 
 bootmem_data_t bootmem_node_data[MAX_NUMNODES] __initdata;
 
+static struct list_head bdata_list __initdata = LIST_HEAD_INIT(bdata_list);
+
 static int bootmem_debug;
 
 static int __init bootmem_debug_setup(char *buf)
@@ -73,20 +74,16 @@ unsigned long __init bootmem_bootmap_pag
  */
 static void __init link_bootmem(bootmem_data_t *bdata)
 {
-	bootmem_data_t *ent;
+	struct list_head *iter;
 
-	if (list_empty(&bdata_list)) {
-		list_add(&bdata->list, &bdata_list);
-		return;
-	}
-	/* insert in order */
-	list_for_each_entry(ent, &bdata_list, list) {
-		if (bdata->node_boot_start < ent->node_boot_start) {
-			list_add_tail(&bdata->list, &ent->list);
-			return;
-		}
+	list_for_each(iter, &bdata_list) {
+		bootmem_data_t *ent;
+
+		ent = list_entry(iter, bootmem_data_t, list);
+		if (bdata->node_boot_start < ent->node_boot_start)
+			break;
 	}
-	list_add_tail(&bdata->list, &bdata_list);
+	list_add_tail(&bdata->list, iter);
 }
 
 /*

-- 

