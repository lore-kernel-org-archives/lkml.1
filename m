Return-Path: <linux-kernel-owner+w=401wt.eu-S1763906AbXGEX1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763906AbXGEX1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763067AbXGEXXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:23:31 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52158 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763058AbXGEXX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:23:29 -0400
Date: Fri, 6 Jul 2007 01:23:58 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/mempolicy.c: cleanups
Message-ID: <20070705232358.GJ3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- every file should include the headers containing the prototypes for
  its global functions
- make the follosing needlessly global functions static:
  - migrate_to_node()
  - do_mbind()
  - sp_alloc()
  - mpol_rebind_policy()

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 include/linux/mempolicy.h |    6 ------
 mm/mempolicy.c            |   25 ++++++++++++++++---------
 2 files changed, 16 insertions(+), 15 deletions(-)

--- linux-2.6.22-rc6-mm1/include/linux/mempolicy.h.old	2007-07-05 17:16:55.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/linux/mempolicy.h	2007-07-05 17:17:05.000000000 +0200
@@ -143,7 +143,6 @@
 
 extern void numa_default_policy(void);
 extern void numa_policy_init(void);
-extern void mpol_rebind_policy(struct mempolicy *pol, const nodemask_t *new);
 extern void mpol_rebind_task(struct task_struct *tsk,
 					const nodemask_t *new);
 extern void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new);
@@ -225,11 +224,6 @@
 {
 }
 
-static inline void mpol_rebind_policy(struct mempolicy *pol,
-					const nodemask_t *new)
-{
-}
-
 static inline void mpol_rebind_task(struct task_struct *tsk,
 					const nodemask_t *new)
 {
--- linux-2.6.22-rc6-mm1/mm/mempolicy.c.old	2007-07-05 17:14:16.000000000 +0200
+++ linux-2.6.22-rc6-mm1/mm/mempolicy.c	2007-07-05 17:22:17.000000000 +0200
@@ -89,6 +89,7 @@
 #include <linux/migrate.h>
 #include <linux/rmap.h>
 #include <linux/security.h>
+#include <linux/syscalls.h>
 
 #include <asm/tlbflush.h>
 #include <asm/uaccess.h>
@@ -110,6 +111,9 @@
 	.policy = MPOL_DEFAULT,
 };
 
+static void mpol_rebind_policy(struct mempolicy *pol,
+                               const nodemask_t *newmask);
+
 /* Do sanity checking on a policy */
 static int mpol_check_policy(int mode, nodemask_t *nodes)
 {
@@ -459,7 +463,7 @@
 }
 
 /* Set the process memory policy */
-long do_set_mempolicy(int mode, nodemask_t *nodes)
+static long do_set_mempolicy(int mode, nodemask_t *nodes)
 {
 	struct mempolicy *new;
 
@@ -519,8 +523,8 @@
 }
 
 /* Retrieve NUMA policy */
-long do_get_mempolicy(int *policy, nodemask_t *nmask,
-			unsigned long addr, unsigned long flags)
+static long do_get_mempolicy(int *policy, nodemask_t *nmask,
+			     unsigned long addr, unsigned long flags)
 {
 	int err;
 	struct mm_struct *mm = current->mm;
@@ -601,7 +605,8 @@
  * Migrate pages from one node to a target node.
  * Returns error or the number of pages not migrated.
  */
-int migrate_to_node(struct mm_struct *mm, int source, int dest, int flags)
+static int migrate_to_node(struct mm_struct *mm, int source, int dest,
+			   int flags)
 {
 	nodemask_t nmask;
 	LIST_HEAD(pagelist);
@@ -732,8 +737,9 @@
 }
 #endif
 
-long do_mbind(unsigned long start, unsigned long len,
-		unsigned long mode, nodemask_t *nmask, unsigned long flags)
+static long do_mbind(unsigned long start, unsigned long len,
+		     unsigned long mode, nodemask_t *nmask,
+		     unsigned long flags)
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
@@ -1466,8 +1472,8 @@
 	kmem_cache_free(sn_cache, n);
 }
 
-struct sp_node *
-sp_alloc(unsigned long start, unsigned long end, struct mempolicy *pol)
+static struct sp_node *sp_alloc(unsigned long start, unsigned long end,
+				struct mempolicy *pol)
 {
 	struct sp_node *n = kmem_cache_alloc(sn_cache, GFP_KERNEL);
 
@@ -1645,7 +1651,8 @@
 }
 
 /* Migrate a policy to a different set of nodes */
-void mpol_rebind_policy(struct mempolicy *pol, const nodemask_t *newmask)
+static void mpol_rebind_policy(struct mempolicy *pol,
+			       const nodemask_t *newmask)
 {
 	nodemask_t *mpolmask;
 	nodemask_t tmp;

