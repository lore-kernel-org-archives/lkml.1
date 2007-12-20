Return-Path: <linux-kernel-owner+w=401wt.eu-S932168AbXLTMJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbXLTMJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760400AbXLTMBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:01:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761045AbXLTMAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 33/43] x86 TLS desc_struct cleanup
Message-Id: <20071220115957.0BE5526F98B@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:59:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up the TLS code to use struct desc_struct and to separate the
encoding and installation magic from the interface wrappers.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/tls.c  |   89 ++++++++++++++++++++++++-----------------------
 include/asm-x86/desc.h |   11 +++++-
 2 files changed, 54 insertions(+), 46 deletions(-)

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
@@ -31,10 +54,7 @@ int do_set_thread_area(struct task_struct *p, int idx,
 		       struct user_desc __user *u_info,
 		       int can_allocate)
 {
-	struct thread_struct *t = &p->thread;
 	struct user_desc info;
-	u32 *desc;
-	int cpu;
 
 	if (copy_from_user(&info, u_info, sizeof(info)))
 		return -EFAULT;
@@ -57,23 +77,8 @@ int do_set_thread_area(struct task_struct *p, int idx,
 	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
 		return -EINVAL;
 
-	desc = (u32 *) &t->tls_array[idx - GDT_ENTRY_TLS_MIN];
+	set_tls_desc(p, idx, &info);
 
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
-
-	if (t == &current->thread)
-		load_TLS(t, cpu);
-
-	put_cpu();
 	return 0;
 }
 
@@ -87,42 +92,38 @@ asmlinkage int sys_set_thread_area(struct user_desc __user *u_info)
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
+
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
index 6c781bf..df28de6 100644
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
@@ -275,10 +276,16 @@ static inline void load_LDT(mm_context_t *pc)
 	preempt_enable();
 }
 
-static inline unsigned long get_desc_base(struct desc_struct *desc)
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
-- 
1.5.3.6

