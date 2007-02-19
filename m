Return-Path: <linux-kernel-owner+w=401wt.eu-S932641AbXBSUuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbXBSUuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 15:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932642AbXBSUuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 15:50:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932641AbXBSUuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 15:50:17 -0500
Date: Mon, 19 Feb 2007 15:50:12 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20070219205012.13934.82952.sendpatchset@prarit.boston.redhat.com>
Subject: [PATCH]: Change sysenter_setup to __cpuinit & improve __INIT, __INITDATA
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change sysenter_setup to __cpuinit.
Change __INIT & __INITDATA to be cpu hotplug aware.

Resolve MODPOST warnings similar to:

WARNING: vmlinux - Section mismatch: reference to .init.text:sysenter_setup from
 .text between 'identify_cpu' (at offset 0xc040a380) and 'detect_ht'

and

WARNING: vmlinux - Section mismatch: reference to .init.data:vsyscall_int80_end
from .text between 'sysenter_setup' (at offset 0xc041a269) and 'enable_sep_cpu'
WARNING: vmlinux - Section mismatch: reference to
.init.data:vsyscall_int80_start from .text between 'sysenter_setup' (at offset
0xc041a26e) and 'enable_sep_cpu'
WARNING: vmlinux - Section mismatch: reference to
.init.data:vsyscall_sysenter_end from .text between 'sysenter_setup' (at offset
0xc041a275) and 'enable_sep_cpu'
WARNING: vmlinux - Section mismatch: reference to
.init.data:vsyscall_sysenter_start from .text between 'sysenter_setup' (at
offset 0xc041a27a) and 'enable_sep_cpu'

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/arch/i386/kernel/sysenter.c b/arch/i386/kernel/sysenter.c
index 13ca54a..168f814 100644
--- a/arch/i386/kernel/sysenter.c
+++ b/arch/i386/kernel/sysenter.c
@@ -72,7 +72,7 @@ extern const char vsyscall_int80_start, vsyscall_int80_end;
 extern const char vsyscall_sysenter_start, vsyscall_sysenter_end;
 static struct page *syscall_pages[1];
 
-int __init sysenter_setup(void)
+int __cpuinit sysenter_setup(void)
 {
 	void *syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
 	syscall_pages[0] = virt_to_page(syscall_page);
diff --git a/include/linux/init.h b/include/linux/init.h
index e290a01..9abf120 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -52,9 +52,14 @@
 #endif
 
 /* For assembly routines */
+#ifdef CONFIG_HOTPLUG_CPU
+#define __INIT		.section	".text","ax"
+#define __INITDATA	.section	".data","aw"
+#else
 #define __INIT		.section	".init.text","ax"
-#define __FINIT		.previous
 #define __INITDATA	.section	".init.data","aw"
+#endif
+#define __FINIT		.previous
 
 #ifndef __ASSEMBLY__
 /*
