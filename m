Return-Path: <linux-kernel-owner+w=401wt.eu-S1757531AbZCCNry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbZCCNry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 08:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbZCCNqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 08:46:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57420 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755380AbZCCNqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 08:46:21 -0500
Message-ID: <49AD344C.704@cn.fujitsu.com>
Date: Tue, 03 Mar 2009 21:44:44 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 6/6] rcu: introduce kfree_rcu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


__kfree_rcu() in slab layer(slab.c, slob.c, slub.c, slqb.c) is provided.
This patch introduce the final kfree_rcu().

Thank Manfred Spraul designed kfree_rcu()'s API.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 24c5602..2a8d5a4 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -130,6 +130,20 @@ void kfree(const void *);
 void kzfree(const void *);
 size_t ksize(const void *);
 
+struct rcu_head;
+void __kfree_rcu(const void *, struct rcu_head *);
+
+/**
+ * kfree_rcu - kfree after a grace period
+ * @ptr: pointer to kfree
+ * @rcu_member: name of the struct rcu_head member.
+ *
+ * Many rcu callbacks just call kfree() on the base structure. This helper
+ * function calls kfree internally. The rcu_head structure must be embedded
+ * in the to be freed structure.
+ */
+#define kfree_rcu(ptr, rcu_member)	__kfree_rcu((ptr), &(ptr)->rcu_member)
+
 /*
  * Allocator specific definitions. These are mainly used to establish optimized
  * ways to convert kmalloc() calls to kmem_cache_alloc() invocations by








