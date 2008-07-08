Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbYGHKvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbYGHKvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 06:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbYGHKvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 06:51:08 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:59587 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbYGHKvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 06:51:07 -0400
Subject: [PATCH] Make CONFIG_MIGRATION available w/o NUMA
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <48726158.9010308@linux-foundation.org>
References: <1215354957.9842.19.camel@localhost.localdomain>
	 <4872319B.9040809@linux-foundation.org>
	 <1215451689.8431.80.camel@localhost.localdomain>
	 <48725480.1060808@linux-foundation.org>
	 <1215455148.8431.108.camel@localhost.localdomain>
	 <48726158.9010308@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 12:50:45 +0200
Message-Id: <1215514245.4832.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-07 at 13:32 -0500, Christoph Lameter wrote:
> I think you just need to move the #endif from before migrate_vmas to the
> end (as you already suggested). Then migrate_vmas will no longer be compiled
> for the NUMA case. migrate_vmas() was added later and was not placed correctly
> it seems.

done

> vma_migratable (without policy_zone check!) should be available if
> CONFIG_MIGRATION is on. Not sure if we need such a test. If not then just
> make sure that vma_migratable() is not included for the !NUMA case.

vma_migratable is not needed w/o NUMA, so I just put an '#ifdef CONFIG_NUMA'
around it.


Subject: [PATCH] Make CONFIG_MIGRATION available w/o CONFIG_NUMA

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

We'd like to support CONFIG_MEMORY_HOTREMOVE on s390, which depends on
CONFIG_MIGRATION. So far, CONFIG_MIGRATION is only available with NUMA
support.

This patch makes CONFIG_MIGRATION selectable for architectures that define
ARCH_ENABLE_MEMORY_HOTREMOVE. When MIGRATION is enabled w/o NUMA, the kernel
won't compile because migrate_vmas() does not know about vm_ops->migrate()
and vma_migratable() does not know about policy_zone. To fix this, those
two functions can be restricted to "#ifdef CONFIG_NUMA" because they are
not being used w/o NUMA.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---

 include/linux/migrate.h |    2 ++
 mm/Kconfig              |    2 +-
 mm/migrate.c            |    2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/Kconfig
===================================================================
--- linux-2.6.orig/mm/Kconfig
+++ linux-2.6/mm/Kconfig
@@ -174,7 +174,7 @@ config SPLIT_PTLOCK_CPUS
 config MIGRATION
 	bool "Page migration"
 	def_bool y
-	depends on NUMA
+	depends on NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE
 	help
 	  Allows the migration of the physical location of pages of processes
 	  while the virtual addresses are not changed. This is useful for
Index: linux-2.6/include/linux/migrate.h
===================================================================
--- linux-2.6.orig/include/linux/migrate.h
+++ linux-2.6/include/linux/migrate.h
@@ -8,6 +8,7 @@
 typedef struct page *new_page_t(struct page *, unsigned long private, int **);
 
 #ifdef CONFIG_MIGRATION
+#ifdef CONFIG_NUMA
 /* Check if a vma is migratable */
 static inline int vma_migratable(struct vm_area_struct *vma)
 {
@@ -24,6 +25,7 @@ static inline int vma_migratable(struct 
 			return 0;
 	return 1;
 }
+#endif /* CONFIG_NUMA */
 
 extern int isolate_lru_page(struct page *p, struct list_head *pagelist);
 extern int putback_lru_pages(struct list_head *l);
Index: linux-2.6/mm/migrate.c
===================================================================
--- linux-2.6.orig/mm/migrate.c
+++ linux-2.6/mm/migrate.c
@@ -1070,7 +1070,6 @@ out2:
 	mmput(mm);
 	return err;
 }
-#endif
 
 /*
  * Call migration functions in the vma_ops that may prepare
@@ -1092,3 +1091,4 @@ int migrate_vmas(struct mm_struct *mm, c
  	}
  	return err;
 }
+#endif


