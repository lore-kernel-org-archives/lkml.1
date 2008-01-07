Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbYAGNJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbYAGNJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 08:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757832AbYAGNGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 08:06:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757807AbYAGNGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 08:06:43 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 09/16] map_switcher_in_guest() per-vcpu
Date: Mon,  7 Jan 2008 11:05:30 -0200
Message-Id: <11997111801864-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11997111751377-git-send-email-gcosta@redhat.com>
References: 11981576363806-git-send-email-gcosta@redhat.com <1199711137195-git-send-email-gcosta@redhat.com> <11997111432356-git-send-email-gcosta@redhat.com> <11997111481113-git-send-email-gcosta@redhat.com> <11997111523234-git-send-email-gcosta@redhat.com> <1199711157132-git-send-email-gcosta@redhat.com> <11997111623212-git-send-email-gcosta@redhat.com> <11997111661344-git-send-email-gcosta@redhat.com> <11997111711574-git-send-email-gcosta@redhat.com> <11997111751377-git-send-email-gcosta@redhat.com>
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
index 6c794cd..f871737 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -168,7 +168,8 @@ void guest_pagetable_clear_all(struct lguest *lg);
 void guest_pagetable_flush_user(struct lguest *lg);
 void guest_set_pte(struct lguest *lg, unsigned long gpgdir,
 		   unsigned long vaddr, pte_t val);
-void map_switcher_in_guest(struct lguest *lg, struct lguest_pages *pages);
+void map_switcher_in_guest(struct lg_vcpu *vcpu,
+			   struct lguest_pages *pages);
 int demand_page(struct lguest *info, unsigned long cr2, int errcode);
 void pin_page(struct lguest *lg, unsigned long vaddr);
 unsigned long guest_pa(struct lguest *lg, unsigned long vaddr);
diff --git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
index fffabb3..c79fac2 100644
--- a/drivers/lguest/page_tables.c
+++ b/drivers/lguest/page_tables.c
@@ -634,8 +634,10 @@ void free_guest_pagetable(struct lguest *lg)
  * Guest (and not the pages for other CPUs).  We have the appropriate PTE pages
  * for each CPU already set up, we just need to hook them in now we know which
  * Guest is about to run on this CPU. */
-void map_switcher_in_guest(struct lguest *lg, struct lguest_pages *pages)
+void map_switcher_in_guest(struct lg_vcpu *vcpu,
+			   struct lguest_pages *pages)
 {
+	struct lguest *lg = vcpu->lg;
 	pte_t *switcher_pte_page = __get_cpu_var(switcher_pte_pages);
 	pgd_t switcher_pgd;
 	pte_t regs_pte;
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index 8fbb373..125a14b 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -92,7 +92,7 @@ static void copy_in_guest_info(struct lg_vcpu *vcpu,
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

