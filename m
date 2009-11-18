Return-Path: <linux-kernel-owner+w=401wt.eu-S1756491AbZKRATd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbZKRATd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 19:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756439AbZKRATd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 19:19:33 -0500
Received: from smtp-out.google.com ([216.239.33.17]:62769 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426AbZKRATc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 19:19:32 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=Vi6Pd34uoZ19x77UeBH4V8/xoKqBaDBQXK9W0LAwBL1STol6l6pOKG7W5V4uACmTJ
	SiKcYJx85BPyPn3qZPXMg==
Date: Tue, 17 Nov 2009 16:19:30 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Gary Hade <garyhade@us.ibm.com>, Badari Pulavarty <pbadari@us.ibm.com>,
       Alex Chiang <achiang@hp.com>, linux-kernel@vger.kernel.org
Subject: [patch -mm] mm: slab allocate memory section nodemask for large
 systems
Message-ID: <alpine.DEB.2.00.0911171618430.25821@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nodemasks should not be allocated on the stack for large systems (when it
is larger than 256 bytes) since there is a threat of overflow.

This patch causes the unregister_mem_sect_under_nodes() nodemask to be
allocated on the stack for smaller systems and be allocated by slab for
larger systems.

GFP_KERNEL is used since remove_memory_block() can block.

Cc: Gary Hade <garyhade@us.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Alex Chiang <achiang@hp.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/base/node.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -363,12 +363,16 @@ int register_mem_sect_under_node(struct memory_block *mem_blk, int nid)
 /* unregister memory section under all nodes that it spans */
 int unregister_mem_sect_under_nodes(struct memory_block *mem_blk)
 {
-	nodemask_t unlinked_nodes;
+	NODEMASK_ALLOC(nodemask_t, unlinked_nodes, GFP_KERNEL);
 	unsigned long pfn, sect_start_pfn, sect_end_pfn;
 
-	if (!mem_blk)
+	if (!mem_blk) {
+		NODEMASK_FREE(unlinked_nodes);
 		return -EFAULT;
-	nodes_clear(unlinked_nodes);
+	}
+	if (!unlinked_nodes)
+		return -ENOMEM;
+	nodes_clear(*unlinked_nodes);
 	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
 	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
 	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
@@ -379,13 +383,14 @@ int unregister_mem_sect_under_nodes(struct memory_block *mem_blk)
 			continue;
 		if (!node_online(nid))
 			continue;
-		if (node_test_and_set(nid, unlinked_nodes))
+		if (node_test_and_set(nid, *unlinked_nodes))
 			continue;
 		sysfs_remove_link(&node_devices[nid].sysdev.kobj,
 			 kobject_name(&mem_blk->sysdev.kobj));
 		sysfs_remove_link(&mem_blk->sysdev.kobj,
 			 kobject_name(&node_devices[nid].sysdev.kobj));
 	}
+	NODEMASK_FREE(unlinked_nodes);
 	return 0;
 }
 
