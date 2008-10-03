Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763AbYJCFa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbYJCFa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 01:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYJCFat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 01:30:49 -0400
Received: from mylar.outflux.net ([69.93.193.226]:37226 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbYJCFas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 01:30:48 -0400
Date: Thu, 2 Oct 2008 22:29:38 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>, libc-alpha@sourceware.org
Subject: [PATCH] ELF: implement AT_RANDOM for future glibc use
Message-ID: <20081003052938.GS10632@outflux.net>
References: <20081001201116.GD12527@outflux.net> <48E3EFD6.2010704@redhat.com> <20081001215657.GH12527@outflux.net> <20081001220948.GC32107@sunsite.ms.mff.cuni.cz> <20081001222706.68E7E1544B4@magilla.localdomain> <20081003001616.GN10632@outflux.net> <20081003004340.GF32682@tyan-ft48-01.lab.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003004340.GF32682@tyan-ft48-01.lab.bos.redhat.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While discussing[1] the need for glibc to have access to random bytes
during program load, it seems that an earlier attempt to implement
AT_RANDOM got stalled.  This implements a configurable number of random
bytes, as a multiple of userspace pointer size, available to every ELF
program via a new auxv AT_RANDOM vector.

[1] http://sourceware.org/ml/libc-alpha/2008-10/msg00006.html

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 fs/binfmt_elf.c        |   20 ++++++++++++++++++++
 include/linux/auxvec.h |    5 +++--
 security/Kconfig       |    9 +++++++++
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 655ed8d..fbaa665 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -152,6 +152,8 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	elf_addr_t __user *sp;
 	elf_addr_t __user *u_platform;
 	elf_addr_t __user *u_base_platform;
+	elf_addr_t __user *u_rand_bytes;
+	unsigned int rand_size;
 	const char *k_platform = ELF_PLATFORM;
 	const char *k_base_platform = ELF_BASE_PLATFORM;
 	int items;
@@ -196,6 +198,18 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 			return -EFAULT;
 	}
 
+	rand_size = CONFIG_SECURITY_AUXV_RANDOM_SIZE * sizeof(elf_addr_t);
+	u_rand_bytes = NULL;
+	if (rand_size) {
+		unsigned char k_rand_bytes[CONFIG_SECURITY_AUXV_RANDOM_SIZE *
+					   sizeof(elf_addr_t)];
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
@@ -228,6 +242,12 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
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
index d7afa9d..702e506 100644
--- a/include/linux/auxvec.h
+++ b/include/linux/auxvec.h
@@ -25,14 +25,15 @@
 #define AT_CLKTCK 17	/* frequency at which times() increments */
 
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
 
diff --git a/security/Kconfig b/security/Kconfig
index f6c0429..64f0da9 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -114,6 +114,15 @@ config SECURITY_DEFAULT_MMAP_MIN_ADDR
 	  This value can be changed after boot using the
 	  /proc/sys/vm/mmap_min_addr tunable.
 
+config SECURITY_AUXV_RANDOM_SIZE
+	int "Number of pointer-sized random byte strings in AT_RANDOM"
+	default 4
+	help
+	  This value determines how many pointer-sized random byte strings
+	  are provided to programs via the auxv AT_RANDOM vector.  It can
+	  be used to initialize random values needed during program load.
+
+	  If you are unsure how many to use, answer 4.
 
 source security/selinux/Kconfig
 source security/smack/Kconfig
-- 
1.5.6.3

-- 
Kees Cook
Ubuntu Security Team
