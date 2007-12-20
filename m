Return-Path: <linux-kernel-owner+w=401wt.eu-S1763112AbXLTNht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763112AbXLTNht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760558AbXLTNez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:34:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762424AbXLTNex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:34:53 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 09/16] map_switcher_in_guest() per-vcpu
Date: Thu, 20 Dec 2007 11:33:49 -0200
Message-Id: <11981576833314-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1198157678759-git-send-email-gcosta@redhat.com>
References: <11981576363806-git-send-email-gcosta@redhat.com> <11981576442148-git-send-email-gcosta@redhat.com> <11981576492807-git-send-email-gcosta@redhat.com> <1198157654189-git-send-email-gcosta@redhat.com> <11981576581695-git-send-email-gcosta@redhat.com> <11981576632726-git-send-email-gcosta@redhat.com> <11981576671720-git-send-email-gcosta@redhat.com> <11981576731969-git-send-email-gcosta@redhat.com> <1198157678759-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The switcher needs to be mapped per-vcpu, because different vcpus
will potentially have different page tables (they don't have to,
because threads will share the same).

So our first step is the make the function receive a vcpu struct

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 drivers/lguest/lg.h          |    3 ++-
 drivers/lguest/page_tables.c |    4 +++-
 drivers/lguest/x86/core.c    |    2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index db2edd6..f6e9020 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -173,7 +173,8 @@ void guest_pagetable_clear_all(struct lguest *lg);
 void guest_pagetable_flush_user(struct lguest *lg);
 void guest_set_pte(struct lguest *lg, unsigned long gpgdir,
 		   unsigned long vaddr, pte_t val);
-void map_switcher_in_guest(struct lguest *lg, struct lguest_pages *pages);
+void map_switcher_in_guest(struct lguest_vcpu *vcpu,
+			   struct lguest_pages *pages);
 int demand_page(struct lguest *info, unsigned long cr2, int errcode);
 void pin_page(struct lguest *lg, unsigned long vaddr);
 unsigned long guest_pa(struct lguest *lg, unsigned long vaddr);
diff --git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
index fffabb3..7fb8627 100644
--- a/drivers/lguest/page_tables.c
+++ b/drivers/lguest/page_tables.c
@@ -634,8 +634,10 @@ void free_guest_pagetable(struct lguest *lg)
  * Guest (and not the pages for other CPUs).  We have the appropriate PTE pages
  * for each CPU already set up, we just need to hook them in now we know which
  * Guest is about to run on this CPU. */
-void map_switcher_in_guest(struct lguest *lg, struct lguest_pages *pages)
+void map_switcher_in_guest(struct lguest_vcpu *vcpu,
+			   struct lguest_pages *pages)
 {
+	struct lguest *lg = vcpu->lg;
 	pte_t *switcher_pte_page = __get_cpu_var(switcher_pte_pages);
 	pgd_t switcher_pgd;
 	pte_t regs_pte;
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index 3d21c6d..9bf2213 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -92,7 +92,7 @@ static void copy_in_guest_info(struct lguest_vcpu *vcpu,
 	pages->state.host_cr3 = __pa(current->mm->pgd);
 	/* Set up the Guest's page tables to see this CPU's pages (and no
 	 * other CPU's pages). */
-	map_switcher_in_guest(lg, pages);
+	map_switcher_in_guest(vcpu, pages);
 	/* Set up the two "TSS" members which tell the CPU what stack to use
 	 * for traps which do directly into the Guest (ie. traps at privilege
 	 * level 1). */
-- 
1.5.0.6

