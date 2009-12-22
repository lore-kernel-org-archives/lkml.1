Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbZLVMiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbZLVMiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 07:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbZLVMiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 07:38:06 -0500
Received: from mga10.intel.com ([192.55.52.92]:45021 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750895AbZLVMiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 07:38:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,434,1257148800"; 
   d="scan'208";a="758383806"
Message-ID: <4B30BDA8.1070904@linux.intel.com>
Date: Tue, 22 Dec 2009 20:38:00 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: [PATCH] slab: initialize unused alien cache entry as NULL at alloc_alien_cache().
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory hotplug would online new node in runtime, then reap timer will add this new node as 
a reap node. In such case, for each existing kmem_list, we need to ensure that the alien 
cache entry corresponding to this new added node is NULL. Otherwise, it might cause BUG 
when reap_alien() affecting the new added node.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
  mm/slab.c |    7 +++----
  1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 7dfa481..a9486a0 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -966,18 +966,17 @@ static void *alternate_node_alloc(struct kmem_cache *, gfp_t);
  static struct array_cache **alloc_alien_cache(int node, int limit, gfp_t gfp)
  {
  	struct array_cache **ac_ptr;
-	int memsize = sizeof(void *) * nr_node_ids;
+	int memsize = sizeof(void *) * MAX_NUMNODES;
  	int i;

  	if (limit > 1)
  		limit = 12;
  	ac_ptr = kmalloc_node(memsize, gfp, node);
  	if (ac_ptr) {
+		memset(ac_ptr, 0, memsize);
  		for_each_node(i) {
-			if (i == node || !node_online(i)) {
-				ac_ptr[i] = NULL;
+			if (i == node || !node_online(i))
  				continue;
-			}
  			ac_ptr[i] = alloc_arraycache(node, limit, 0xbaadf00d, gfp);
  			if (!ac_ptr[i]) {
  				for (i--; i >= 0; i--)
-- 
1.6.0.rc1
