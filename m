Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbYGYK3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbYGYK3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 06:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbYGYK3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 06:29:22 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:62859 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbYGYK3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 06:29:21 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: righi.andrea@gmail.com, kernel <kernel@avr32linux.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] Uninline arch_pick_mmap_layout
Date: Fri, 25 Jul 2008 12:28:02 +0200
Message-Id: <1216981682-32026-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1216946517.4004.306.camel@moss.renham>
References: <1216946517.4004.306.camel@moss.renham>
X-OriginalArrivalTime: 25 Jul 2008 10:28:47.0230 (UTC) FILETIME=[38BDB1E0:01C8EE41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported by Ben Nizette:

> We no longer have PAGE_ALIGN in asm-avr32/page.h so the AVR32 build dies
> quite quickly:
>
>   CC      init/main.o
> In file included from include/linux/utsname.h:35,
>                  from init/main.c:20:
> include/linux/sched.h: In function 'arch_pick_mmap_layout':
> include/linux/sched.h:2149: error: implicit declaration of function 'PAGE_ALIGN'
> make[1]: *** [init/main.o] Error 1
> make: *** [init] Error 2
>
> This looks a relatively simple fix, just include linux/mm.h from
> asm-avr32/processor.h from where sched.h gets the dodgy macro.
> Unfortunately this, and every other placement of an #include
> <linux/mm.h> I've tried, ends up in Massive Include Armageddon

So instead of shuffling includes around, just move the definition of
arch_pick_mmap_layout() into fs/exec.c. Some architectures, e.g. x86,
already define it out-of-line.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 fs/exec.c             |    9 +++++++++
 include/linux/sched.h |    9 ---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 190ed1f..b6e7c9a 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -74,6 +74,15 @@ int suid_dumpable = 0;
 static LIST_HEAD(formats);
 static DEFINE_RWLOCK(binfmt_lock);
 
+#ifndef HAVE_ARCH_PICK_MMAP_LAYOUT
+void arch_pick_mmap_layout(struct mm_struct *mm)
+{
+	mm->mmap_base = TASK_UNMAPPED_BASE;
+	mm->get_unmapped_area = arch_get_unmapped_area;
+	mm->unmap_area = arch_unmap_area;
+}
+#endif
+
 int register_binfmt(struct linux_binfmt * fmt)
 {
 	if (!fmt)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6aca4a1..9584278 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2141,16 +2141,7 @@ static inline void set_task_cpu(struct task_struct *p, unsigned int cpu)
 
 #endif /* CONFIG_SMP */
 
-#ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
 extern void arch_pick_mmap_layout(struct mm_struct *mm);
-#else
-static inline void arch_pick_mmap_layout(struct mm_struct *mm)
-{
-	mm->mmap_base = TASK_UNMAPPED_BASE;
-	mm->get_unmapped_area = arch_get_unmapped_area;
-	mm->unmap_area = arch_unmap_area;
-}
-#endif
 
 #ifdef CONFIG_TRACING
 extern void
-- 
1.5.6.2

