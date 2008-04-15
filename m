Return-Path: <linux-kernel-owner+w=401wt.eu-S1763997AbYDOCG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763997AbYDOCG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 22:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761080AbYDOCGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 22:06:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40577 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761044AbYDOCGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 22:06:19 -0400
Date: Tue, 15 Apr 2008 11:10:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>, lizf@cn.fujitsu.com,
       menage@google.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] use vmalloc for mem_cgroup allocation. v2
Message-Id: <20080415111038.ffac0e12.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080415105434.3044afb6.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080415105434.3044afb6.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ia64, this kmalloc() requires order-4 pages. But this is not
necessary to be phisically contiguous. (and x86-32, which has
small vmalloc area, has small mem_cgroup struct.)

For here, vmalloc is better.

Changelog: v1->v2
 - added memset().

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Index: mm-2.6.25-rc8-mm2/mm/memcontrol.c
===================================================================
--- mm-2.6.25-rc8-mm2.orig/mm/memcontrol.c
+++ mm-2.6.25-rc8-mm2/mm/memcontrol.c
@@ -31,6 +31,7 @@
 #include <linux/spinlock.h>
 #include <linux/fs.h>
 #include <linux/seq_file.h>
+#include <linux/vmalloc.h>
 
 #include <asm/uaccess.h>
 
@@ -992,8 +993,10 @@ mem_cgroup_create(struct cgroup_subsys *
 	if (unlikely((cont->parent) == NULL)) {
 		mem = &init_mem_cgroup;
 		page_cgroup_cache = KMEM_CACHE(page_cgroup, SLAB_PANIC);
-	} else
-		mem = kzalloc(sizeof(struct mem_cgroup), GFP_KERNEL);
+	} else {
+		mem = vmalloc(sizeof(struct mem_cgroup));
+		memset(mem, 0, sizeof(*mem));
+	}
 
 	if (mem == NULL)
 		return ERR_PTR(-ENOMEM);
@@ -1011,7 +1014,7 @@ free_out:
 	for_each_node_state(node, N_POSSIBLE)
 		free_mem_cgroup_per_zone_info(mem, node);
 	if (cont->parent != NULL)
-		kfree(mem);
+		vfree(mem);
 	return ERR_PTR(-ENOMEM);
 }
 
@@ -1031,7 +1034,7 @@ static void mem_cgroup_destroy(struct cg
 	for_each_node_state(node, N_POSSIBLE)
 		free_mem_cgroup_per_zone_info(mem, node);
 
-	kfree(mem_cgroup_from_cont(cont));
+	vfree(mem_cgroup_from_cont(cont));
 }
 
 static int mem_cgroup_populate(struct cgroup_subsys *ss,

