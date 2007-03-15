Return-Path: <linux-kernel-owner+w=401wt.eu-S932889AbXCOTUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889AbXCOTUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932980AbXCOTUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:20:40 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:42576 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932889AbXCOTUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:20:39 -0400
From: Eric Dumazet <dada1@cosmosbay.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>, Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/3] FUTEX : NUMA friendly global hashtable
Date: Thu, 15 Mar 2007 20:20:43 +0100
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
References: <20060808070708.GA3931@localhost.localdomain> <200608090826.28249.dada1@cosmosbay.com> <200608090843.52893.dada1@cosmosbay.com>
In-Reply-To: <200608090843.52893.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_LyZ+FDegvNTSVtk"
Message-Id: <200703152020.43707.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_LyZ+FDegvNTSVtk
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

[PATCH 3/3] FUTEX : NUMA friendly global hashtable

On NUMA machines, we should get better performance using a big futex 
hashtable, allocated with vmalloc() so that it is spreaded on several nodes.

I chose a static size of four pages. (Very big NUMA machines have 64k page 
size)

This patch should have a temporary effect, as most futexes are expected to be 
stored in process private tables. We probably can drop it  in five years :)


Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 kernel/futex.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

--Boundary-00=_LyZ+FDegvNTSVtk
Content-Type: text/plain;
  charset="utf-8";
  name="futex_p3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="futex_p3.patch"

--- linux-2.6.21-rc3/kernel/futex.c	2007-03-15 18:54:47.000000000 +0100
+++ linux-2.6.21-rc3-ed/kernel/futex.c	2007-03-15 18:54:47.000000000 +0100
@@ -152,8 +152,13 @@ struct futex_hash_bucket {
 # define FUTEX_HASH_SLOTS	16
 # define FUTEX_NOPRIVHASH	/* no private hashtable, only one global */
 #else
-# define FUTEX_HASH_SLOTS	256
-# define FUTEX_PRIVHASH_SLOTS	64
+# ifdef CONFIG_NUMA
+#  define FUTEX_HASH_SLOTS	((4*PAGE_SIZE)/sizeof(struct futex_hash_bucket))
+#  define FUTEX_PRIVHASH_SLOTS	(4096 / sizeof(struct futex_hash_bucket))
+# else
+#  define FUTEX_HASH_SLOTS	256
+#  define FUTEX_PRIVHASH_SLOTS	64
+# endif
 #endif
 
 #define FUTEX_PRIVHASH_SIZE \
@@ -166,8 +171,14 @@ struct futex_hash_bucket {
  * PTHREAD_PROCESS_PRIVATE futexes may be hashed into this table too if the 
  * owner process failed to allocate its private hashtable (or CONFIG_BASE_SMALL)
  *
+ * On NUMA configs, table is allocated with vmalloc() to spread this hash table
+ * up to 4 nodes (we use 4 pages)
  */
+#ifdef CONFIG_NUMA
+static struct futex_hash_bucket *futex_queues __read_mostly;
+#else
 static struct futex_hash_bucket futex_queues[FUTEX_HASH_SLOTS];
+#endif
 
 /* Futex-fs vfsmount entry: */
 static struct vfsmount *futex_mnt;
@@ -2051,7 +2062,16 @@ static int __init init(void)
 		return PTR_ERR(futex_mnt);
 	}
 
-	for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
+#ifdef CONFIG_NUMA
+	/*
+	 * vmalloc() is supposed to obey mempolicy and spread our 4 pages
+	 * on several nodes
+	 */
+	futex_queues = vmalloc(FUTEX_HASH_SLOTS * sizeof(*futex_queues));
+	if (!futex_queues)
+		panic("Failed to allocate futex hash table\n");
+#endif
+	for (i = 0; i < FUTEX_HASH_SLOTS; i++) {
 		INIT_LIST_HEAD(&futex_queues[i].chain);
 		spin_lock_init(&futex_queues[i].lock);
 	}

--Boundary-00=_LyZ+FDegvNTSVtk--
