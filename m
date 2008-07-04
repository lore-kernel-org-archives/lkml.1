Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbYGDO7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbYGDO7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 10:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbYGDO7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 10:59:24 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:19321 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbYGDO7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 10:59:23 -0400
Subject: [PATCH] Make CONFIG_MIGRATION available for s390
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>
Content-Type: text/plain
Date: Fri, 04 Jul 2008 16:58:59 +0200
Message-Id: <1215183539.4834.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] Make CONFIG_MIGRATION available for s390

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

We'd like to support CONFIG_MEMORY_HOTREMOVE on s390, which depends on
CONFIG_MIGRATION. So far, CONFIG_MIGRATION is only available with NUMA
support.

This patch makes CONFIG_MIGRATION selectable for s390. When MIGRATION
is enabled w/o NUMA, the kernel won't compile because of a missing
"migrate" member in vm_operations_struct and a missing "policy_zone"
definition. To avoid this, those are moved from an "#ifdef CONFIG_NUMA"
section to "#ifdef CONFIG_MIGRATION".

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---

 include/linux/mempolicy.h |    6 ++++--
 include/linux/mm.h        |    2 ++
 mm/Kconfig                |    2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

Index: mylinux-git/include/linux/mempolicy.h
===================================================================
--- mylinux-git.orig/include/linux/mempolicy.h
+++ mylinux-git/include/linux/mempolicy.h
@@ -62,6 +62,10 @@ enum {
 
 struct mm_struct;
 
+#ifdef CONFIG_MIGRATION
+extern enum zone_type policy_zone;
+#endif
+
 #ifdef CONFIG_NUMA
 
 /*
@@ -202,8 +206,6 @@ extern struct zonelist *huge_zonelist(st
 				struct mempolicy **mpol, nodemask_t **nodemask);
 extern unsigned slab_node(struct mempolicy *policy);
 
-extern enum zone_type policy_zone;
-
 static inline void check_highest_zone(enum zone_type k)
 {
 	if (k > policy_zone && k != ZONE_MOVABLE)
Index: mylinux-git/include/linux/mm.h
===================================================================
--- mylinux-git.orig/include/linux/mm.h
+++ mylinux-git/include/linux/mm.h
@@ -193,6 +193,8 @@ struct vm_operations_struct {
 	 */
 	struct mempolicy *(*get_policy)(struct vm_area_struct *vma,
 					unsigned long addr);
+#endif
+#ifdef CONFIG_MIGRATION
 	int (*migrate)(struct vm_area_struct *vma, const nodemask_t *from,
 		const nodemask_t *to, unsigned long flags);
 #endif
Index: mylinux-git/mm/Kconfig
===================================================================
--- mylinux-git.orig/mm/Kconfig
+++ mylinux-git/mm/Kconfig
@@ -174,7 +174,7 @@ config SPLIT_PTLOCK_CPUS
 config MIGRATION
 	bool "Page migration"
 	def_bool y
-	depends on NUMA
+	depends on NUMA || S390
 	help
 	  Allows the migration of the physical location of pages of processes
 	  while the virtual addresses are not changed. This is useful for


