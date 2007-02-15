Return-Path: <linux-kernel-owner+w=401wt.eu-S964975AbXBOHca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964975AbXBOHca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 02:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964977AbXBOHc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 02:32:29 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38783 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964975AbXBOHc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 02:32:28 -0500
Date: Thu, 15 Feb 2007 16:32:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: AKPM <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH] fix mempolicy's check on a system with memory-less-node
 take4
Message-Id: <20070215163200.143928fe.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


please ack if O.K.....
-Kame
--
bind_zonelist() can create zero-length zonelist if there is a 
memory-less-node. This patch checks the length of zonelist.
If length is 0, returns -EINVAL.

Changelog: v3 -> v4:
- changes a name of a temporal void* variable as "error_code"
Changelog: v2 -> v3
- removed ambiguous void *pointer usage.
- fixed warnings...misuse of PTR_ERR.
Changelog: v1 -> v2
- avoid extra pgdat scanning....it is not necessary.

tested on ia64/NUMA with memory-less-node.

Signed-Off-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


Index: linux-2.6.20/mm/mempolicy.c
===================================================================
--- linux-2.6.20.orig/mm/mempolicy.c	2007-02-13 15:14:13.000000000 +0900
+++ linux-2.6.20/mm/mempolicy.c	2007-02-15 16:11:17.000000000 +0900
@@ -144,7 +144,7 @@
 	max++;			/* space for zlcache_ptr (see mmzone.h) */
 	zl = kmalloc(sizeof(struct zone *) * max, GFP_KERNEL);
 	if (!zl)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	zl->zlcache_ptr = NULL;
 	num = 0;
 	/* First put in the highest zones from all nodes, then all the next 
@@ -162,6 +162,10 @@
 			break;
 		k--;
 	}
+	if (num == 0) {
+		kfree(zl);
+		return ERR_PTR(-EINVAL);
+	}
 	zl->zones[num] = NULL;
 	return zl;
 }
@@ -193,9 +197,10 @@
 		break;
 	case MPOL_BIND:
 		policy->v.zonelist = bind_zonelist(nodes);
-		if (policy->v.zonelist == NULL) {
+		if (IS_ERR(policy->v.zonelist)) {
+			void *error_code = policy->v.zonelist;
 			kmem_cache_free(policy_cache, policy);
-			return ERR_PTR(-ENOMEM);
+			return error_code;
 		}
 		break;
 	}
@@ -1667,7 +1672,7 @@
 		 * then zonelist_policy() will "FALL THROUGH" to MPOL_DEFAULT.
 		 */
 
-		if (zonelist) {
+		if (!IS_ERR(zonelist)) {
 			/* Good - got mem - substitute new zonelist */
 			kfree(pol->v.zonelist);
 			pol->v.zonelist = zonelist;

