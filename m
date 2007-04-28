Return-Path: <linux-kernel-owner+w=401wt.eu-S1163327AbXD1RxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163327AbXD1RxP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163311AbXD1RxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:53:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163313AbXD1Rwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:54 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [25/35] i386: Change sysenter_setup to __cpuinit & improve __INIT, __INITDATA
Message-Id: <20070428175250.94FE5151D1@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Prarit Bhargava <prarit@redhat.com>
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
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/sysenter.c |    2 +-
 include/linux/init.h        |    7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

Index: linux/arch/i386/kernel/sysenter.c
===================================================================
--- linux.orig/arch/i386/kernel/sysenter.c
+++ linux/arch/i386/kernel/sysenter.c
@@ -72,7 +72,7 @@ extern const char vsyscall_int80_start, 
 extern const char vsyscall_sysenter_start, vsyscall_sysenter_end;
 static struct page *syscall_pages[1];
 
-int __init sysenter_setup(void)
+int __cpuinit sysenter_setup(void)
 {
 	void *syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
 	syscall_pages[0] = virt_to_page(syscall_page);
Index: linux/include/linux/init.h
===================================================================
--- linux.orig/include/linux/init.h
+++ linux/include/linux/init.h
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
