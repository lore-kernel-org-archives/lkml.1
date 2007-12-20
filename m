Return-Path: <linux-kernel-owner+w=401wt.eu-S1762844AbXLTMJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762844AbXLTMJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbXLTMBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:01:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761083AbXLTMAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:47 -0500
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
Subject: [PATCH -mm 34/43] x86 user_regset TLS
Message-Id: <20071220115958.D1E0A26F98D@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:59:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds accessor functions in the user_regset style for the TLS data.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/tls.c |   89 +++++++++++++++++++++++++++++++++++++++++++++---
 arch/x86/kernel/tls.h |   21 +++++++++++
 2 files changed, 104 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index f11c92a..6dfd4e7 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -2,6 +2,7 @@
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/user.h>
+#include <linux/regset.h>
 
 #include <asm/uaccess.h>
 #include <asm/desc.h>
@@ -10,6 +11,8 @@
 #include <asm/processor.h>
 #include <asm/proto.h>
 
+#include "tls.h"
+
 /*
  * sys_alloc_thread_area: get a yet unused TLS descriptor index.
  */
@@ -25,7 +28,7 @@ static int get_free_idx(void)
 }
 
 static void set_tls_desc(struct task_struct *p, int idx,
-			 const struct user_desc *info)
+			 const struct user_desc *info, int n)
 {
 	struct thread_struct *t = &p->thread;
 	struct desc_struct *desc = &t->tls_array[idx - GDT_ENTRY_TLS_MIN];
@@ -36,10 +39,14 @@ static void set_tls_desc(struct task_struct *p, int idx,
 	 */
 	cpu = get_cpu();
 
-	if (LDT_empty(info))
-		desc->a = desc->b = 0;
-	else
-		fill_ldt(desc, info);
+	while (n-- > 0) {
+		if (LDT_empty(info))
+			desc->a = desc->b = 0;
+		else
+			fill_ldt(desc, info);
+		++info;
+		++desc;
+	}
 
 	if (t == &current->thread)
 		load_TLS(t, cpu);
@@ -77,7 +84,7 @@ int do_set_thread_area(struct task_struct *p, int idx,
 	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
 		return -EINVAL;
 
-	set_tls_desc(p, idx, &info);
+	set_tls_desc(p, idx, &info, 1);
 
 	return 0;
 }
@@ -134,3 +141,73 @@ asmlinkage int sys_get_thread_area(struct user_desc __user *u_info)
 {
 	return do_get_thread_area(current, -1, u_info);
 }
+
+int regset_tls_active(struct task_struct *target,
+		      const struct user_regset *regset)
+{
+	struct thread_struct *t = &target->thread;
+	int n = GDT_ENTRY_TLS_ENTRIES;
+	while (n > 0 && desc_empty(&t->tls_array[n - 1]))
+		--n;
+	return n;
+}
+
+int regset_tls_get(struct task_struct *target, const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   void *kbuf, void __user *ubuf)
+{
+	const struct desc_struct *tls;
+
+	if (pos > GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
+	    (pos % sizeof(struct user_desc)) != 0 ||
+	    (count % sizeof(struct user_desc)) != 0)
+		return -EINVAL;
+
+	pos /= sizeof(struct user_desc);
+	count /= sizeof(struct user_desc);
+
+	tls = &target->thread.tls_array[pos];
+
+	if (kbuf) {
+		struct user_desc *info = kbuf;
+		while (count-- > 0)
+			fill_user_desc(info++, GDT_ENTRY_TLS_MIN + pos++,
+				       tls++);
+	} else {
+		struct user_desc __user *u_info = ubuf;
+		while (count-- > 0) {
+			struct user_desc info;
+			fill_user_desc(&info, GDT_ENTRY_TLS_MIN + pos++, tls++);
+			if (__copy_to_user(u_info++, &info, sizeof(info)))
+				return -EFAULT;
+		}
+	}
+
+	return 0;
+}
+
+int regset_tls_set(struct task_struct *target, const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   const void *kbuf, const void __user *ubuf)
+{
+	struct user_desc infobuf[GDT_ENTRY_TLS_ENTRIES];
+	const struct user_desc *info;
+
+	if (pos > GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
+	    (pos % sizeof(struct user_desc)) != 0 ||
+	    (count % sizeof(struct user_desc)) != 0)
+		return -EINVAL;
+
+	if (kbuf)
+		info = kbuf;
+	else if (__copy_from_user(infobuf, ubuf, count))
+		return -EFAULT;
+	else
+		info = infobuf;
+
+	set_tls_desc(target,
+		     GDT_ENTRY_TLS_MIN + (pos / sizeof(struct user_desc)),
+		     info, count / sizeof(struct user_desc));
+
+	return 0;
+}
diff --git a/arch/x86/kernel/tls.h b/arch/x86/kernel/tls.h
new file mode 100644
index 0000000..2f083a2
--- /dev/null
+++ b/arch/x86/kernel/tls.h
@@ -0,0 +1,21 @@
+/*
+ * Internal declarations for x86 TLS implementation functions.
+ *
+ * Copyright (C) 2007 Red Hat, Inc.  All rights reserved.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * Red Hat Author: Roland McGrath.
+ */
+
+#ifndef _ARCH_X86_KERNEL_TLS_H
+
+#include <linux/regset.h>
+
+extern user_regset_active_fn regset_tls_active;
+extern user_regset_get_fn regset_tls_get;
+extern user_regset_set_fn regset_tls_set;
+
+#endif	/* _ARCH_X86_KERNEL_TLS_H */
-- 
1.5.3.6

