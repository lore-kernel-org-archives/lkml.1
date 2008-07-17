Return-Path: <linux-kernel-owner+w=401wt.eu-S1760426AbYGQWTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760426AbYGQWTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbYGQWTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:19:42 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:55482 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbYGQWTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:19:41 -0400
Date: Thu, 17 Jul 2008 17:19:32 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: benh@kernel.crashing.org, Linus Torvalds <torvalds@linux-foundation.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       roland@redhat.com
Subject: [PATCH v3] elf loader support for auxvec base platform string
Message-ID: <20080717221932.GL9594@localdomain>
References: <1216166331-14810-1-git-send-email-ntl@pobox.com>
 <1216166331-14810-2-git-send-email-ntl@pobox.com>
 <1216276539.7740.309.camel@pasglop>
 <20080717000951.5f8cab37.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717000951.5f8cab37.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Pobox-Relay-ID: 721BB234-544E-11DD-8BE0-CE28B26B55AE-04752483!a-sasl-fastnet.pobox.com
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

Added comment explaining ELF_BASE_PLATFORM.

 fs/binfmt_elf.c        |   28 ++++++++++++++++++++++++++++
 include/linux/auxvec.h |    5 ++++-
 2 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index d48ff5f..d8a7cc0 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -131,6 +131,15 @@ static int padzero(unsigned long elf_bss)
 #define STACK_ALLOC(sp, len) ({ sp -= len ; sp; })
 #endif
 
+#ifndef ELF_BASE_PLATFORM
+/*
+ * AT_BASE_PLATFORM indicates the "real" hardware/microarchitecture.
+ * If the arch defines ELF_BASE_PLATFORM (in asm/elf.h), the value
+ * will be copied to the user stack in the same manner as AT_PLATFORM.
+ */
+#define ELF_BASE_PLATFORM NULL
+#endif
+
 static int
 create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 		unsigned long load_addr, unsigned long interp_load_addr)
@@ -142,7 +151,9 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	elf_addr_t __user *envp;
 	elf_addr_t __user *sp;
 	elf_addr_t __user *u_platform;
+	elf_addr_t __user *u_base_platform;
 	const char *k_platform = ELF_PLATFORM;
+	const char *k_base_platform = ELF_BASE_PLATFORM;
 	int items;
 	elf_addr_t *elf_info;
 	int ei_index = 0;
@@ -172,6 +183,19 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
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
@@ -208,6 +232,10 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
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

