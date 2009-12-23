Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbZLWJ6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbZLWJ6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 04:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbZLWJ6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 04:58:30 -0500
Received: from mga10.intel.com ([192.55.52.92]:53733 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753157AbZLWJ63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 04:58:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,438,1257148800"; 
   d="scan'208";a="758655487"
Message-ID: <4B31E9C3.6010109@linux.intel.com>
Date: Wed, 23 Dec 2009 17:58:27 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: linux-mm@kvack.org
CC: Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2] slab: initialize unused alien cache entry as NULL at alloc_alien_cache().
References: <4B30BDA8.1070904@linux.intel.com> <1261521485.3000.1692.camel@calx>
In-Reply-To: <1261521485.3000.1692.camel@calx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory hotplug would online new node in runtime, then reap timer will add
this new node as a reap node. In such case, for each existing kmem_list,
we need to ensure that the alien cache entry corresponding to this new
added node is NULL.

Otherwise, it might cause BUG when reap_alien() affecting the new added node.

V2: use kzalloc_node() to ensure zeroed memory.

CC: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
  mm/slab.c |    8 +++-----
  1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 7dfa481..000e9ed 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -966,18 +966,16 @@ static void *alternate_node_alloc(struct kmem_cache *, gfp_t);
  static struct array_cache **alloc_alien_cache(int node, int limit, gfp_t gfp)
  {
  	struct array_cache **ac_ptr;
-	int memsize = sizeof(void *) * nr_node_ids;
+	int memsize = sizeof(void *) * MAX_NUMNODES;
  	int i;

  	if (limit > 1)
  		limit = 12;
-	ac_ptr = kmalloc_node(memsize, gfp, node);
+	ac_ptr = kzalloc_node(memsize, gfp, node);
  	if (ac_ptr) {
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
1.5.3.8



