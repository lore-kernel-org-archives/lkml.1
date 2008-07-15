Return-Path: <linux-kernel-owner+w=401wt.eu-S1757680AbYGOX72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680AbYGOX72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbYGOX7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:59:04 -0400
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:59151 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbYGOX7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:59:03 -0400
From: Nathan Lynch <ntl@pobox.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, roland@redhat.com
Subject: [PATCH] elf loader support for auxvec base platform string
Date: Tue, 15 Jul 2008 18:58:50 -0500
Message-Id: <1216166331-14810-2-git-send-email-ntl@pobox.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1216166331-14810-1-git-send-email-ntl@pobox.com>
References: <1216166331-14810-1-git-send-email-ntl@pobox.com>
X-Pobox-Relay-ID: FFC65E6C-52C9-11DD-9547-3113EBD4C077-04752483!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some IBM POWER-based platforms have the ability to run in a
mode which mostly appears to the OS as a different processor from the
actual hardware.  For example, a Power6 system may appear to be a
Power5+, which makes the AT_PLATFORM value "power5+".  This means that
programs are restricted to the ISA supported by Power5+;
Power6-specific instructions are treated as illegal.

However, some applications (virtual machines, optimized libraries) can
benefit from knowledge of the underlying CPU model.  A new aux vector
entry, AT_BASE_PLATFORM, will denote the actual hardware.  For
example, on a Power6 system in Power5+ compatibility mode, AT_PLATFORM
will be "power5+" and AT_BASE_PLATFORM will be "power6".  The idea is
that AT_PLATFORM indicates the instruction set supported, while
AT_BASE_PLATFORM indicates the underlying microarchitecture.

If the architecture has defined ELF_BASE_PLATFORM, copy that value to
the user stack in the same manner as ELF_PLATFORM.

Signed-off-by: Nathan Lynch <ntl@pobox.com>
---
 fs/binfmt_elf.c        |   23 +++++++++++++++++++++++
 include/linux/auxvec.h |    5 ++++-
 2 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index d48ff5f..834c2c4 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -131,6 +131,10 @@ static int padzero(unsigned long elf_bss)
 #define STACK_ALLOC(sp, len) ({ sp -= len ; sp; })
 #endif
 
+#ifndef ELF_BASE_PLATFORM
+#define ELF_BASE_PLATFORM NULL
+#endif
+
 static int
 create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 		unsigned long load_addr, unsigned long interp_load_addr)
@@ -142,7 +146,9 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	elf_addr_t __user *envp;
 	elf_addr_t __user *sp;
 	elf_addr_t __user *u_platform;
+	elf_addr_t __user *u_base_platform;
 	const char *k_platform = ELF_PLATFORM;
+	const char *k_base_platform = ELF_BASE_PLATFORM;
 	int items;
 	elf_addr_t *elf_info;
 	int ei_index = 0;
@@ -172,6 +178,19 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 			return -EFAULT;
 	}
 
+	/*
+	 * If this architecture has a "base" platform capability
+	 * string, copy it to userspace.
+	 */
+	u_base_platform = NULL;
+	if (k_base_platform) {
+		size_t len = strlen(k_base_platform) + 1;
+
+		u_base_platform = (elf_addr_t __user *)STACK_ALLOC(p, len);
+		if (__copy_to_user(u_base_platform, k_base_platform, len))
+			return -EFAULT;
+	}
+
 	/* Create the ELF interpreter info */
 	elf_info = (elf_addr_t *)current->mm->saved_auxv;
 	/* update AT_VECTOR_SIZE_BASE if the number of NEW_AUX_ENT() changes */
@@ -208,6 +227,10 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 		NEW_AUX_ENT(AT_PLATFORM,
 			    (elf_addr_t)(unsigned long)u_platform);
 	}
+	if (k_base_platform) {
+		NEW_AUX_ENT(AT_BASE_PLATFORM,
+			    (elf_addr_t)(unsigned long)u_base_platform);
+	}
 	if (bprm->interp_flags & BINPRM_FLAGS_EXECFD) {
 		NEW_AUX_ENT(AT_EXECFD, bprm->interp_data);
 	}
diff --git a/include/linux/auxvec.h b/include/linux/auxvec.h
index ad89545..1adc61d 100644
--- a/include/linux/auxvec.h
+++ b/include/linux/auxvec.h
@@ -26,8 +26,11 @@
 
 #define AT_SECURE 23   /* secure mode boolean */
 
+#define AT_BASE_PLATFORM 38	/* string identifying real platform, may
+				 * differ from AT_PLATFORM. */
+
 #ifdef __KERNEL__
-#define AT_VECTOR_SIZE_BASE (14 + 2) /* NEW_AUX_ENT entries in auxiliary table */
+#define AT_VECTOR_SIZE_BASE (14 + 3) /* NEW_AUX_ENT entries in auxiliary table */
 #endif
 
 #endif /* _LINUX_AUXVEC_H */
-- 
1.5.6.2

