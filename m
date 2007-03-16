Return-Path: <linux-kernel-owner+w=401wt.eu-S932881AbXCPJ2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881AbXCPJ2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 05:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932840AbXCPJ2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 05:28:16 -0400
Received: from 207.47.60.147.static.nextweb.net ([207.47.60.147]:36344 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932881AbXCPJ2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 05:28:15 -0400
From: Ian Campbell <ian.campbell@xensource.com>
Subject: [PATCH] Allow i386 crash kernels to handle x86_64 dumps.
Date: Fri, 16 Mar 2007 09:28:10 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Horms <horms@verge.net.au>,
       Magnus Damm <magnus.damm@gmail.com>, fastboot@lists.osdl.org,
       linux-kernel@vger.kernel.org
Message-Id: <20070316092810.9044.68034.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
X-OriginalArrivalTime: 16 Mar 2007 09:28:14.0159 (UTC) FILETIME=[6BF54DF0:01C767AD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@xensource.com>

The specific case I am encountering is kdump under Xen with a 64 bit
hypervisor and 32 bit kernel/userspace. The dump created is 64 bit due to
the hypervisor but the dump kernel is 32 bit for maximum compatibility.

It's possibly less likely to be useful in a purely native scenario but
I see no reason to disallow it.

Signed-off-by: Ian Campbell <ian.campbell@xensource.com>
Acked-by: Vivek Goyal <vgoyal@in.ibm.com>
---

 fs/proc/vmcore.c           |    2 +-
 include/asm-i386/kexec.h   |    3 +++
 include/linux/crash_dump.h |    8 ++++++++
 3 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index d960507..523e109 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -514,7 +514,7 @@ static int __init parse_crash_elf64_headers(void)
 	/* Do some basic Verification. */
 	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) != 0 ||
 		(ehdr.e_type != ET_CORE) ||
-		!elf_check_arch(&ehdr) ||
+		!vmcore_elf_check_arch(&ehdr) ||
 		ehdr.e_ident[EI_CLASS] != ELFCLASS64 ||
 		ehdr.e_ident[EI_VERSION] != EV_CURRENT ||
 		ehdr.e_version != EV_CURRENT ||
diff --git a/include/asm-i386/kexec.h b/include/asm-i386/kexec.h
index 4dfc9f5..c76737e 100644
--- a/include/asm-i386/kexec.h
+++ b/include/asm-i386/kexec.h
@@ -47,6 +47,9 @@
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_386
 
+/* We can also handle crash dumps from 64 bit kernel. */
+#define vmcore_elf_check_arch_cross(x) ((x)->e_machine == EM_X86_64)
+
 #define MAX_NOTE_BYTES 1024
 
 /* CPU does not save ss and esp on stack if execution is already
diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 3250365..db60dac 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -14,5 +14,13 @@ extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 extern const struct file_operations proc_vmcore_operations;
 extern struct proc_dir_entry *proc_vmcore;
 
+/* Architecture code defines this if there are other possible ELF
+ * machine types, e.g. on bi-arch capable hardware. */
+#ifndef vmcore_elf_check_arch_cross(x)
+#define vmcore_elf_check_arch_cross(x) 0
+#endif
+
+#define vmcore_elf_check_arch(x) (elf_check_arch(x) || vmcore_elf_check_arch_cross(x))
+
 #endif /* CONFIG_CRASH_DUMP */
 #endif /* LINUX_CRASHDUMP_H */
