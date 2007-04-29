Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbXD2LA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbXD2LA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbXD2Kxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:53:33 -0400
Received: from ns.suse.de ([195.135.220.2]:52143 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755175AbXD2KxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:17 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Ian Campbell <ian.campbell@xensource.com>, Horms <horms@verge.net.au>,
       Magnus Damm <magnus.damm@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [27/48] i386: Allow i386 crash kernels to handle x86_64 dumps
Message-Id: <20070429105316.78A7D15108@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Ian Campbell <ian.campbell@xensource.com>

The specific case I am encountering is kdump under Xen with a 64 bit
hypervisor and 32 bit kernel/userspace.  The dump created is 64 bit due to
the hypervisor but the dump kernel is 32 bit for maximum compatibility.

It's possibly less likely to be useful in a purely native scenario but I
see no reason to disallow it.

[akpm@linux-foundation.org: build fix]
Signed-off-by: Ian Campbell <ian.campbell@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Horms <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c           |    2 +-
 include/asm-i386/kexec.h   |    3 +++
 include/linux/crash_dump.h |    8 ++++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

Index: linux/fs/proc/vmcore.c
===================================================================
--- linux.orig/fs/proc/vmcore.c
+++ linux/fs/proc/vmcore.c
@@ -514,7 +514,7 @@ static int __init parse_crash_elf64_head
 	/* Do some basic Verification. */
 	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) != 0 ||
 		(ehdr.e_type != ET_CORE) ||
-		!elf_check_arch(&ehdr) ||
+		!vmcore_elf_check_arch(&ehdr) ||
 		ehdr.e_ident[EI_CLASS] != ELFCLASS64 ||
 		ehdr.e_ident[EI_VERSION] != EV_CURRENT ||
 		ehdr.e_version != EV_CURRENT ||
Index: linux/include/asm-i386/kexec.h
===================================================================
--- linux.orig/include/asm-i386/kexec.h
+++ linux/include/asm-i386/kexec.h
@@ -42,6 +42,9 @@
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_386
 
+/* We can also handle crash dumps from 64 bit kernel. */
+#define vmcore_elf_check_arch_cross(x) ((x)->e_machine == EM_X86_64)
+
 #define MAX_NOTE_BYTES 1024
 
 /* CPU does not save ss and esp on stack if execution is already
Index: linux/include/linux/crash_dump.h
===================================================================
--- linux.orig/include/linux/crash_dump.h
+++ linux/include/linux/crash_dump.h
@@ -14,5 +14,13 @@ extern ssize_t copy_oldmem_page(unsigned
 extern const struct file_operations proc_vmcore_operations;
 extern struct proc_dir_entry *proc_vmcore;
 
+/* Architecture code defines this if there are other possible ELF
+ * machine types, e.g. on bi-arch capable hardware. */
+#ifndef vmcore_elf_check_arch_cross
+#define vmcore_elf_check_arch_cross(x) 0
+#endif
+
+#define vmcore_elf_check_arch(x) (elf_check_arch(x) || vmcore_elf_check_arch_cross(x))
+
 #endif /* CONFIG_CRASH_DUMP */
 #endif /* LINUX_CRASHDUMP_H */
