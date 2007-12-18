Return-Path: <linux-kernel-owner+w=401wt.eu-S1764638AbXLRGA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764638AbXLRGA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 01:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbXLRGAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 01:00:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbXLRGAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 01:00:12 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH x86/mm] x86: TLS desc_struct cleanup
In-Reply-To: Roland McGrath's message of  Monday, 17 December 2007 21:35:08 -0800 <20071218053508.BB73526F98A@magilla.localdomain>
X-Fcc: ~/Mail/linus
References: <11979319641796-git-send-email-gcosta@redhat.com>
	<11979319763641-git-send-email-gcosta@redhat.com>
	<11979319811234-git-send-email-gcosta@redhat.com>
	<200712181614.37890.rusty@rustcorp.com.au>
	<20071218053508.BB73526F98A@magilla.localdomain>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20071218060005.810A926F98A@magilla.localdomain>
Date: Mon, 17 Dec 2007 21:59:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up the x86 TLS code to use desc_struct in place of hand-coded
bit-twiddling, and cleans up a few of the inlines for the type too.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/tls.c          |   89 ++++++++++++++++++++--------------------
 include/asm-x86/desc.h         |   16 ++++++-
 include/asm-x86/processor_32.h |   18 +++-----
 include/asm-x86/processor_64.h |   48 +++++++++------------
 4 files changed, 86 insertions(+), 85 deletions(-)

diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index 98f428b..f11c92a 100644  
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -24,6 +24,29 @@ static int get_free_idx(void)
 	return -ESRCH;
 }
 
+static void set_tls_desc(struct task_struct *p, int idx,
+			 const struct user_desc *info)
+{
+	struct thread_struct *t = &p->thread;
+	struct desc_struct *desc = &t->tls_array[idx - GDT_ENTRY_TLS_MIN];
+	int cpu;
+
+	/*
+	 * We must not get preempted while modifying the TLS.
+	 */
+	cpu = get_cpu();
+
+	if (LDT_empty(info))
+		desc->a = desc->b = 0;
+	else
+		fill_ldt(desc, info);
+
+	if (t == &current->thread)
+		load_TLS(t, cpu);
+
+	put_cpu();
+}
+
 /*
  * Set a given TLS descriptor:
  */
@@ -31,10 +54,7 @@ int do_set_thread_area(struct task_struc
 		       struct user_desc __user *u_info,
 		       int can_allocate)
 {
-	struct thread_struct *t = &p->thread;
 	struct user_desc info;
-	u32 *desc;
-	int cpu;
 
 	if (copy_from_user(&info, u_info, sizeof(info)))
 		return -EFAULT;
@@ -57,23 +77,8 @@ int do_set_thread_area(struct task_struc
 	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
 		return -EINVAL;
 
-	desc = (u32 *) &t->tls_array[idx - GDT_ENTRY_TLS_MIN];
-
-	/*
-	 * We must not get preempted while modifying the TLS.
-	 */
-	cpu = get_cpu();
-
-	if (LDT_empty(&info)) {
-		desc[0] = 0;
-		desc[1] = 0;
-	} else
-		fill_ldt((struct desc_struct *)desc, &info);
+	set_tls_desc(p, idx, &info);
 
-	if (t == &current->thread)
-		load_TLS(t, cpu);
-
-	put_cpu();
 	return 0;
 }
 
@@ -87,21 +92,29 @@ asmlinkage int sys_set_thread_area(struc
  * Get the current Thread-Local Storage area:
  */
 
-#define GET_LIMIT(desc)		(((desc)[0] & 0x0ffff) | ((desc)[1] & 0xf0000))
-#define GET_32BIT(desc)		(((desc)[1] >> 22) & 1)
-#define GET_CONTENTS(desc)	(((desc)[1] >> 10) & 3)
-#define GET_WRITABLE(desc)	(((desc)[1] >>  9) & 1)
-#define GET_LIMIT_PAGES(desc)	(((desc)[1] >> 23) & 1)
-#define GET_PRESENT(desc)	(((desc)[1] >> 15) & 1)
-#define GET_USEABLE(desc)	(((desc)[1] >> 20) & 1)
-#define GET_LONGMODE(desc)	(((desc)[1] >> 21) & 1)
+static void fill_user_desc(struct user_desc *info, int idx,
+			   const struct desc_struct *desc)
+
+{
+	memset(info, 0, sizeof(*info));
+	info->entry_number = idx;
+	info->base_addr = get_desc_base(desc);
+	info->limit = get_desc_limit(desc);
+	info->seg_32bit = desc->d;
+	info->contents = desc->type >> 2;
+	info->read_exec_only = !(desc->type & 2);
+	info->limit_in_pages = desc->g;
+	info->seg_not_present = !desc->p;
+	info->useable = desc->avl;
+#ifdef CONFIG_X86_64
+	info->lm = desc->l;
+#endif
+}
 
 int do_get_thread_area(struct task_struct *p, int idx,
 		       struct user_desc __user *u_info)
 {
-	struct thread_struct *t = &p->thread;
 	struct user_desc info;
-	u32 *desc;
 
 	if (idx == -1 && get_user(idx, &u_info->entry_number))
 		return -EFAULT;
@@ -108,21 +122,8 @@ int do_get_thread_area(struct task_struc
 	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
 		return -EINVAL;
 
-	desc = (u32 *) &t->tls_array[idx - GDT_ENTRY_TLS_MIN];
-
-	memset(&info, 0, sizeof(struct user_desc));
-	info.entry_number = idx;
-	info.base_addr = get_desc_base((struct desc_struct *)desc);
-	info.limit = GET_LIMIT(desc);
-	info.seg_32bit = GET_32BIT(desc);
-	info.contents = GET_CONTENTS(desc);
-	info.read_exec_only = !GET_WRITABLE(desc);
-	info.limit_in_pages = GET_LIMIT_PAGES(desc);
-	info.seg_not_present = !GET_PRESENT(desc);
-	info.useable = GET_USEABLE(desc);
-#ifdef CONFIG_X86_64
-	info.lm = GET_LONGMODE(desc);
-#endif
+	fill_user_desc(&info, idx,
+		       &p->thread.tls_array[idx - GDT_ENTRY_TLS_MIN]);
 
 	if (copy_to_user(u_info, &info, sizeof(info)))
 		return -EFAULT;
diff --git a/include/asm-x86/desc.h b/include/asm-x86/desc.h
index 161a6d6..0000000 100644  
--- a/include/asm-x86/desc.h
+++ b/include/asm-x86/desc.h
@@ -7,7 +7,8 @@
 #include <asm/mmu.h>
 #include <linux/smp.h>
 
-static inline void fill_ldt(struct desc_struct *desc, struct user_desc *info)
+static inline void fill_ldt(struct desc_struct *desc,
+			    const struct user_desc *info)
 {
 	desc->limit0 = info->limit & 0x0ffff;
 	desc->base0 = info->base_addr & 0x0000ffff;
@@ -269,10 +270,21 @@ static inline void load_LDT(mm_context_t
 	preempt_enable();
 }
 
-static inline unsigned long get_desc_base(struct desc_struct *desc)
+static inline int desc_empty(const struct desc_struct *desc)
+{
+	return !(desc->a | desc->b);
+}
+
+static inline unsigned long get_desc_base(const struct desc_struct *desc)
 {
 	return desc->base0 | ((desc->base1) << 16) | ((desc->base2) << 24);
 }
+
+static inline unsigned long get_desc_limit(const struct desc_struct *desc)
+{
+	return desc->limit0 | (desc->limit << 16);
+}
+
 static inline void _set_gate(int gate, unsigned type, void *addr,
 			      unsigned dpl, unsigned ist, unsigned seg)
 {
diff --git a/include/asm-x86/processor_32.h b/include/asm-x86/processor_32.h
index a5560a3..0000000 100644  
--- a/include/asm-x86/processor_32.h
+++ b/include/asm-x86/processor_32.h
@@ -25,12 +25,6 @@
 /* flag for disabling the tsc */
 extern int tsc_disable;
 
-static inline int desc_empty(const void *ptr)
-{
-	const u32 *desc = ptr;
-	return !(desc[0] | desc[1]);
-}
-
 /*
  * Default implementation of macro that returns current
  * instruction pointer ("program counter").
diff --git a/include/asm-x86/processor_64.h b/include/asm-x86/processor_64.h
index 51f1970..0000000 100644  
--- a/include/asm-x86/processor_64.h
+++ b/include/asm-x86/processor_64.h
@@ -31,12 +31,6 @@
 #define VIP_MASK	0x00100000	/* virtual interrupt pending */
 #define ID_MASK		0x00200000
 
-static inline int desc_empty(const void *ptr)
-{
-	const u32 *desc = ptr;
-	return !(desc[0] | desc[1]);
-}
-
 /*
  * Default implementation of macro that returns current
  * instruction pointer ("program counter").
