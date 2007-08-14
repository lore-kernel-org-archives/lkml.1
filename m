Return-Path: <linux-kernel-owner+w=401wt.eu-S1758883AbXHNXU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbXHNXU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 19:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbXHNXUC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 19:20:02 -0400
Received: from styx.suse.cz ([82.119.242.94]:44245 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752343AbXHNXUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 19:20:00 -0400
Date: Wed, 15 Aug 2007 01:21:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ulrich Kunitz <kune@deine-taler.de>, Bret Towe <magnade@gmail.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] [RESEND] PIE executable randomization
In-Reply-To: <Pine.LNX.4.64.0708142224540.29843@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0708150112120.29843@jikos.suse.cz>
References: <Pine.LNX.4.64.0708081552010.11054@jikos.suse.cz>
 <20070814200647.GN2063@devserv.devel.redhat.com> <Pine.LNX.4.64.0708142224540.29843@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Jiri Kosina wrote:

> It turned out recently that PIE-compiled binaries on x86_64, that 
> perform larger amount of brk-allocations (for example bash) will not 
> work (but they will work on ?86). This is because currently on ?86 the 
> memory layout is as follows:

(Andi added to CC)

The following patch fixes the brk-allocation problems on x86_64 with code 
randomization patch on PIE-compiled binaries. Is anyone aware of any 
potential disaster it might cause somewhere please?

If not -- Andrew, could you apply it on top of 
pie-executable-randomization.patch please? Thanks.



From: Jiri Kosina <jkosina@suse.cz>

X86_64: add flexmmap support

This patch adds flexible-mmap support for x86_64 and brings the address 
space layout closer to the "new" i?86 address space layout. Using the 
legacy layout is still possible by

- ADDR_COMPAT_LAYOUT personality
- having unlimited resource limit for stack
- legacy_va_layout sysctl setting

This corresponds to the ?86 behavior.

Flexible-mmap support is necessary for establishing proper mapping when 
performing executable code randomization for PIE-compiled binaries, 
otherwise non-randomized brk, which is immediately following the code, 
might not have enough free space.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

 arch/x86_64/mm/mmap.c |  107 ++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 92 insertions(+), 15 deletions(-)

diff --git a/arch/x86_64/mm/mmap.c b/arch/x86_64/mm/mmap.c
index 80bba0d..a5e658c 100644
--- a/arch/x86_64/mm/mmap.c
+++ b/arch/x86_64/mm/mmap.c
@@ -1,29 +1,106 @@
-/* Copyright 2005 Andi Kleen, SuSE Labs.
- * Licensed under GPL, v.2
+/*
+ *  linux/arch/x86-64/mm/mmap.c
+ *
+ *  flexible mmap layout support
+ *
+ * Based on code by Ingo Molnar and Andi Kleen, copyrighted
+ * as follows:
+ *
+ * Copyright 2003-2004 Red Hat Inc., Durham, North Carolina.
+ * All Rights Reserved.
+ * Copyright 2005 Andi Kleen, SuSE Labs.
+ * Copyright 2007 Jiri Kosina, SuSE Labs.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
  */
+
+#include <linux/personality.h>
 #include <linux/mm.h>
-#include <linux/sched.h>
 #include <linux/random.h>
+#include <linux/limits.h>
+#include <linux/sched.h>
 #include <asm/ia32.h>
 
-/* Notebook: move the mmap code from sys_x86_64.c over here. */
+/*
+ * Top of mmap area (just below the process stack).
+ *
+ * Leave an at least ~128 MB hole.
+ */
+#define MIN_GAP (128*1024*1024)
+#define MAX_GAP (TASK_SIZE/6*5)
 
-void arch_pick_mmap_layout(struct mm_struct *mm)
+static inline unsigned long mmap_base(void)
+{
+	unsigned long gap = current->signal->rlim[RLIMIT_STACK].rlim_cur;
+
+	if (gap < MIN_GAP)
+		gap = MIN_GAP;
+	else if (gap > MAX_GAP)
+		gap = MAX_GAP;
+
+	return TASK_SIZE - (gap & PAGE_MASK);
+}
+
+static inline int mmap_is_legacy(void)
 {
 #ifdef CONFIG_IA32_EMULATION
-	if (current_thread_info()->flags & _TIF_IA32)
-		return ia32_pick_mmap_layout(mm);
+	if (test_thread_flag(TIF_IA32))
+		return 1;	
 #endif
-	mm->mmap_base = TASK_UNMAPPED_BASE;
+
+	if (current->personality & ADDR_COMPAT_LAYOUT)
+		return 1;
+
+	if (current->signal->rlim[RLIMIT_STACK].rlim_cur == RLIM_INFINITY)
+		return 1;
+
+	return sysctl_legacy_va_layout;
+}
+
+/*
+ * This function, called very early during the creation of a new
+ * process VM image, sets up which VM layout function to use:
+ */
+void arch_pick_mmap_layout(struct mm_struct *mm)
+{
+	int rnd = 0;
 	if (current->flags & PF_RANDOMIZE) {
 		/* Add 28bit randomness which is about 40bits of address space
 		   because mmap base has to be page aligned.
- 		   or ~1/128 of the total user VM
-	   	   (total user address space is 47bits) */
-		unsigned rnd = get_random_int() & 0xfffffff;
-		mm->mmap_base += ((unsigned long)rnd) << PAGE_SHIFT;
+		   or ~1/128 of the total user VM
+		   (total user address space is 47bits) */
+		rnd = get_random_int() & 0xfffffff;
 	}
-	mm->get_unmapped_area = arch_get_unmapped_area;
-	mm->unmap_area = arch_unmap_area;
-}
 
+	/*
+	 * Fall back to the standard layout if the personality
+	 * bit is set, or if the expected stack growth is unlimited:
+	 */
+	if (mmap_is_legacy()) {
+		mm->mmap_base = TASK_UNMAPPED_BASE;
+		mm->get_unmapped_area = arch_get_unmapped_area;
+		mm->unmap_area = arch_unmap_area;
+	} else {
+		mm->mmap_base = mmap_base();
+		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
+		mm->unmap_area = arch_unmap_area_topdown;
+		if (current->flags & PF_RANDOMIZE)
+			rnd = -rnd;
+	}
+	if (current->flags & PF_RANDOMIZE) {
+		mm->mmap_base += ((long)rnd) << PAGE_SHIFT;
+	}
+}
