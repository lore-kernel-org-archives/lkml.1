Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbYJCOwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbYJCOwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 10:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYJCOw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 10:52:26 -0400
Received: from mylar.outflux.net ([69.93.193.226]:55446 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbYJCOwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 10:52:25 -0400
Date: Fri, 3 Oct 2008 07:50:54 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Jakub Jelinek <jakub@redhat.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       libc-alpha@sourceware.org
Subject: [PATCH] ELF: implement AT_RANDOM for glibc PRNG seeding
Message-ID: <20081003145054.GU10632@outflux.net>
References: <20081001201116.GD12527@outflux.net> <48E3EFD6.2010704@redhat.com> <20081001215657.GH12527@outflux.net> <20081001220948.GC32107@sunsite.ms.mff.cuni.cz> <20081001222706.68E7E1544B4@magilla.localdomain> <20081003001616.GN10632@outflux.net> <20081003004340.GF32682@tyan-ft48-01.lab.bos.redhat.com> <20081003052938.GS10632@outflux.net> <20081002225718.6a0d803a@infradead.org> <48E5BAC6.9070007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E5BAC6.9070007@redhat.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While discussing[1] the need for glibc to have access to random bytes
during program load, it seems that an earlier attempt to implement
AT_RANDOM got stalled.  This implements a random 16 byte string, available
to every ELF program via a new auxv AT_RANDOM vector.

[1] http://sourceware.org/ml/libc-alpha/2008-10/msg00006.html

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 fs/binfmt_elf.c        |   27 +++++++++++++++++++++++++++
 include/linux/auxvec.h |    7 ++++---
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 655ed8d..11931f8 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -140,6 +140,14 @@ static int padzero(unsigned long elf_bss)
 #define ELF_BASE_PLATFORM NULL
 #endif
 
+#ifndef ELF_AUXV_RANDOM_SIZE
+/*
+ * AT_RANDOM provides a random byte stream which can be used to seed
+ * userspace PRNGs at program load time.
+ */
+#define ELF_AUXV_RANDOM_SIZE 16
+#endif
+
 static int
 create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 		unsigned long load_addr, unsigned long interp_load_addr)
@@ -152,6 +160,8 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	elf_addr_t __user *sp;
 	elf_addr_t __user *u_platform;
 	elf_addr_t __user *u_base_platform;
+	elf_addr_t __user *u_rand_bytes;
+	unsigned int rand_size;
 	const char *k_platform = ELF_PLATFORM;
 	const char *k_base_platform = ELF_BASE_PLATFORM;
 	int items;
@@ -196,6 +206,17 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 			return -EFAULT;
 	}
 
+	rand_size = ELF_AUXV_RANDOM_SIZE;
+	u_rand_bytes = NULL;
+	if (rand_size) {
+		unsigned char k_rand_bytes[ELF_AUXV_RANDOM_SIZE];
+		get_random_bytes(k_rand_bytes, rand_size);
+
+		u_rand_bytes = (elf_addr_t __user *)STACK_ALLOC(p, rand_size);
+		if (__copy_to_user(u_rand_bytes, k_rand_bytes, rand_size))
+			return -EFAULT;
+	}
+
 	/* Create the ELF interpreter info */
 	elf_info = (elf_addr_t *)current->mm->saved_auxv;
 	/* update AT_VECTOR_SIZE_BASE if the number of NEW_AUX_ENT() changes */
@@ -228,6 +249,12 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	NEW_AUX_ENT(AT_GID, tsk->gid);
 	NEW_AUX_ENT(AT_EGID, tsk->egid);
  	NEW_AUX_ENT(AT_SECURE, security_bprm_secureexec(bprm));
+	if (rand_size) {
+		NEW_AUX_ENT(AT_RANDOM_SIZE,
+			    (elf_addr_t)(unsigned long)rand_size);
+		NEW_AUX_ENT(AT_RANDOM,
+			    (elf_addr_t)(unsigned long)u_rand_bytes);
+	}
 	NEW_AUX_ENT(AT_EXECFN, bprm->exec);
 	if (k_platform) {
 		NEW_AUX_ENT(AT_PLATFORM,
diff --git a/include/linux/auxvec.h b/include/linux/auxvec.h
index d7afa9d..dac7fc2 100644
--- a/include/linux/auxvec.h
+++ b/include/linux/auxvec.h
@@ -23,16 +23,17 @@
 #define AT_PLATFORM 15  /* string identifying CPU for optimizations */
 #define AT_HWCAP  16    /* arch dependent hints at CPU capabilities */
 #define AT_CLKTCK 17	/* frequency at which times() increments */
-
+/* AT_* values 18 through 22 are reserved */
 #define AT_SECURE 23   /* secure mode boolean */
-
 #define AT_BASE_PLATFORM 24	/* string identifying real platform, may
 				 * differ from AT_PLATFORM. */
+#define AT_RANDOM_SIZE   25	/* number of random bytes at AT_RANDOM */
+#define AT_RANDOM 26	/* address of random bytes */
 
 #define AT_EXECFN  31	/* filename of program */
 
 #ifdef __KERNEL__
-#define AT_VECTOR_SIZE_BASE 18 /* NEW_AUX_ENT entries in auxiliary table */
+#define AT_VECTOR_SIZE_BASE 20 /* NEW_AUX_ENT entries in auxiliary table */
   /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTELF} */
 #endif
 
-- 
1.5.6.3

-- 
Kees Cook
Ubuntu Security Team
