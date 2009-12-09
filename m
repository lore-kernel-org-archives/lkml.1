Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbZLISqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbZLISqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757110AbZLISpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:45:39 -0500
Received: from mail.perches.com ([173.55.12.10]:1048 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757045AbZLISpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:45:31 -0500
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] kmmio.c: Add and use pr_fmt(fmt)
Date: Wed,  9 Dec 2009 10:45:36 -0800
Message-Id: <7aa509f8a23933036d39f54bd51e9acc52068049.1260383912.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1260383912.git.joe@perches.com>
References: <20091209072630.GA8187@elte.hu> <cover.1260383912.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
Strip "kmmio: " from pr_<level>s

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/mm/kmmio.c |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 11a4ad4..823168b 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -5,6 +5,8 @@
  *     2008 Pekka Paalanen <pq@iki.fi>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/list.h>
 #include <linux/rculist.h>
 #include <linux/spinlock.h>
@@ -136,7 +138,7 @@ static int clear_page_presence(struct kmmio_fault_page *f, bool clear)
 	pte_t *pte = lookup_address(f->page, &level);
 
 	if (!pte) {
-		pr_err("kmmio: no pte for page 0x%08lx\n", f->page);
+		pr_err("no pte for page 0x%08lx\n", f->page);
 		return -1;
 	}
 
@@ -148,7 +150,7 @@ static int clear_page_presence(struct kmmio_fault_page *f, bool clear)
 		clear_pte_presence(pte, clear, &f->old_presence);
 		break;
 	default:
-		pr_err("kmmio: unexpected page level 0x%x.\n", level);
+		pr_err("unexpected page level 0x%x.\n", level);
 		return -1;
 	}
 
@@ -170,13 +172,14 @@ static int clear_page_presence(struct kmmio_fault_page *f, bool clear)
 static int arm_kmmio_fault_page(struct kmmio_fault_page *f)
 {
 	int ret;
-	WARN_ONCE(f->armed, KERN_ERR "kmmio page already armed.\n");
+	WARN_ONCE(f->armed, KERN_ERR pr_fmt("kmmio page already armed.\n"));
 	if (f->armed) {
-		pr_warning("kmmio double-arm: page 0x%08lx, ref %d, old %d\n",
-					f->page, f->count, !!f->old_presence);
+		pr_warning("double-arm: page 0x%08lx, ref %d, old %d\n",
+			   f->page, f->count, !!f->old_presence);
 	}
 	ret = clear_page_presence(f, true);
-	WARN_ONCE(ret < 0, KERN_ERR "kmmio arming 0x%08lx failed.\n", f->page);
+	WARN_ONCE(ret < 0, KERN_ERR pr_fmt("arming 0x%08lx failed.\n"),
+		  f->page);
 	f->armed = true;
 	return ret;
 }
@@ -240,24 +243,21 @@ int kmmio_handler(struct pt_regs *regs, unsigned long addr)
 			 * condition needs handling by do_page_fault(), the
 			 * page really not being present is the most common.
 			 */
-			pr_debug("kmmio: secondary hit for 0x%08lx CPU %d.\n",
-					addr, smp_processor_id());
+			pr_debug("secondary hit for 0x%08lx CPU %d.\n",
+				 addr, smp_processor_id());
 
 			if (!faultpage->old_presence)
-				pr_info("kmmio: unexpected secondary hit for "
-					"address 0x%08lx on CPU %d.\n", addr,
-					smp_processor_id());
+				pr_info("unexpected secondary hit for address 0x%08lx on CPU %d.\n",
+					addr, smp_processor_id());
 		} else {
 			/*
 			 * Prevent overwriting already in-flight context.
 			 * This should not happen, let's hope disarming at
 			 * least prevents a panic.
 			 */
-			pr_emerg("kmmio: recursive probe hit on CPU %d, "
-					"for address 0x%08lx. Ignoring.\n",
-					smp_processor_id(), addr);
-			pr_emerg("kmmio: previous hit was at 0x%08lx.\n",
-						ctx->addr);
+			pr_emerg("recursive probe hit on CPU %d, for address 0x%08lx. Ignoring.\n",
+				 smp_processor_id(), addr);
+			pr_emerg("previous hit was at 0x%08lx.\n", ctx->addr);
 			disarm_kmmio_fault_page(faultpage);
 		}
 		goto no_kmmio_ctx;
@@ -316,8 +316,8 @@ static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
 		 * something external causing them (f.e. using a debugger while
 		 * mmio tracing enabled), or erroneous behaviour
 		 */
-		pr_warning("kmmio: unexpected debug trap on CPU %d.\n",
-							smp_processor_id());
+		pr_warning("unexpected debug trap on CPU %d.\n",
+			   smp_processor_id());
 		goto out;
 	}
 
@@ -425,7 +425,7 @@ int register_kmmio_probe(struct kmmio_probe *p)
 	list_add_rcu(&p->list, &kmmio_probes);
 	while (size < size_lim) {
 		if (add_kmmio_fault_page(p->addr + size))
-			pr_err("kmmio: Unable to set page fault.\n");
+			pr_err("Unable to set page fault.\n");
 		size += PAGE_SIZE;
 	}
 out:
@@ -511,7 +511,7 @@ void unregister_kmmio_probe(struct kmmio_probe *p)
 
 	drelease = kmalloc(sizeof(*drelease), GFP_ATOMIC);
 	if (!drelease) {
-		pr_crit("kmmio: leaking kmmio_fault_page objects.\n");
+		pr_crit("leaking kmmio_fault_page objects.\n");
 		return;
 	}
 	drelease->release_list = release_list;
-- 
1.6.6.rc0.57.gad7a

