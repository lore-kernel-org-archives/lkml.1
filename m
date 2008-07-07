Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbYGGQmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbYGGQmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbYGGQmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:42:11 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:34105 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbYGGQmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:42:10 -0400
Subject: [PATCH] Make CONFIG_MIGRATION available for s390
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, Yasunori Goto <y-goto@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>
In-Reply-To: <20080707185433.5A5D.E1E9C6FF@jp.fujitsu.com>
References: <1215354957.9842.19.camel@localhost.localdomain>
	 <20080707090635.GA6797@shadowen.org>
	 <20080707185433.5A5D.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 18:41:46 +0200
Message-Id: <1215448906.8431.52.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-07 at 19:24 +0900, Yasunori Goto wrote:
> > include/linux/mempolicy.h already has a !NUMA section could we not just
> > define policy_zone as 0 in that and leave this code unconditionally
> > compiled?  Perhaps also adding a NUMA_BUILD && to this 'if' should that
> > be clearer.
> > 
> Ah, yes. It's better. :-)

ok, the new patch below defines policy_zone as 0 in the !NUMA section. The
compiler will automatically omit the if statement w/o NUMA in this case.

> > But this does make me feel uneasy.  Are we really saying all memory on
> > an s390 is migratable.  That seems unlikely. As I understand the NUMA
> > case, we only allow migration of memory in the last zone (last two if we
> > have a MOVABLE zone) why are things different just because we have a
> > single 'node'.  Hmmm.  I suspect strongly that something is missnamed
> > more than there is a problem.
> 
> If my understanding is correct, even if this policy_zone check is removed,
> page isolation will just fail due to some busy pages.
> In hotplug case, it means giving up of hotremoving,
> and kernel must be rollback to make same condition of previous
> starting offline_pages().
> This check means just "early" check, but not so effective for hotremoving,
> I think....

It seems to me that this policy_zone check in vma_migratable() is not
called at all for the offline_pages() case, only for some NUMA system calls
that we don't support on s390. As Yasunori Goto said, page isolation checks
should do the job for memory hotremove via offline_pages(), independent from
any policy_zone setting. Any more thoughts on this?

Thanks,
Gerald
---

Subject: [PATCH] Make CONFIG_MIGRATION available for s390

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

We'd like to support CONFIG_MEMORY_HOTREMOVE on s390, which depends on
CONFIG_MIGRATION. So far, CONFIG_MIGRATION is only available with NUMA
support.

This patch makes CONFIG_MIGRATION selectable for architectures that define
ARCH_ENABLE_MEMORY_HOTREMOVE. When MIGRATION is enabled w/o NUMA, the kernel
won't compile because of a missing migrate() function in vm_operations_struct
and a missing policy_zone reference in vma_migratable(). To avoid this,
policy_zone is defined as 0 for !NUMA, and the vm_ops migrate() definition
is moved from '#ifdef CONFIG_NUMA' to '#ifdef CONFIG_MIGRATION'.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---

 include/linux/mempolicy.h |    1 +
 include/linux/mm.h        |    2 ++
 mm/Kconfig                |    2 +-
 3 files changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h
+++ linux-2.6/include/linux/mm.h
@@ -193,6 +193,8 @@ struct vm_operations_struct {
 	 */
 	struct mempolicy *(*get_policy)(struct vm_area_struct *vma,
 					unsigned long addr);
+#endif
+#ifdef CONFIG_MIGRATION
 	int (*migrate)(struct vm_area_struct *vma, const nodemask_t *from,
 		const nodemask_t *to, unsigned long flags);
 #endif
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
Index: linux-2.6/include/linux/mempolicy.h
===================================================================
--- linux-2.6.orig/include/linux/mempolicy.h
+++ linux-2.6/include/linux/mempolicy.h
@@ -222,6 +222,7 @@ extern int mpol_to_str(char *buffer, int
 #endif
 #else
 
+#define policy_zone	0
 struct mempolicy {};
 
 static inline int mpol_equal(struct mempolicy *a, struct mempolicy *b)


