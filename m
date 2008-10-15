Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYJOPw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYJOPw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 11:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYJOPvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 11:51:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46709 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459AbYJOPvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 11:51:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/7] binfmt_elf_fdpic: Support auxvec base platform string.
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       David Howells <dhowells@redhat.com>
Date: Wed, 15 Oct 2008 16:51:09 +0100
Message-ID: <20081015155109.2158.28298.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081015155048.2158.35981.stgit@warthog.procyon.org.uk>
References: <20081015155048.2158.35981.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mundt <lethal@linux-sh.org>

Commit 483fad1c3fa1060d7e6710e84a065ad514571739 introduces
AT_BASE_PLATFORM, but only implements it for binfmt_elf. Given that
AT_VECTOR_SIZE_BASE is unconditionally enlarged for us, and it's only
optionally added in for the platforms that set ELF_BASE_PLATFORM, wire
it up for binfmt_elf_fdpic, too.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/binfmt_elf_fdpic.c |   50 ++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 43 insertions(+), 7 deletions(-)


diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 80c1f95..0955d03 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -455,6 +455,16 @@ error_kill:
 }
 
 /*****************************************************************************/
+
+#ifndef ELF_BASE_PLATFORM
+/*
+ * AT_BASE_PLATFORM indicates the "real" hardware/microarchitecture.
+ * If the arch defines ELF_BASE_PLATFORM (in asm/elf.h), the value
+ * will be copied to the user stack in the same manner as AT_PLATFORM.
+ */
+#define ELF_BASE_PLATFORM NULL
+#endif
+
 /*
  * present useful information to the program
  */
@@ -466,8 +476,8 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	unsigned long sp, csp, nitems;
 	elf_caddr_t __user *argv, *envp;
 	size_t platform_len = 0, len;
-	char *k_platform;
-	char __user *u_platform, *p;
+	char *k_platform, *k_base_platform;
+	char __user *u_platform, *u_base_platform, *p;
 	long hwcap;
 	int loop;
 	int nr;	/* reset for each csp adjustment */
@@ -483,11 +493,14 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 		return -EFAULT;
 #endif
 
-	/* get hold of platform and hardware capabilities masks for the machine
-	 * we are running on.  In some cases (Sparc), this info is impossible
-	 * to get, in others (i386) it is merely difficult.
-	 */
 	hwcap = ELF_HWCAP;
+
+	/*
+	 * If this architecture has a platform capability string, copy it
+	 * to userspace.  In some cases (Sparc), this info is impossible
+	 * for userspace to get any other way, in others (i386) it is
+	 * merely difficult.
+	 */
 	k_platform = ELF_PLATFORM;
 	u_platform = NULL;
 
@@ -499,6 +512,21 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 			return -EFAULT;
 	}
 
+	/*
+	 * If this architecture has a "base" platform capability
+	 * string, copy it to userspace.
+	 */
+	k_base_platform = ELF_BASE_PLATFORM;
+	u_base_platform = NULL;
+
+	if (k_base_platform) {
+		platform_len = strlen(k_base_platform) + 1;
+		sp -= platform_len;
+		u_base_platform = (char __user *) sp;
+		if (__copy_to_user(u_base_platform, k_base_platform, platform_len) != 0)
+			return -EFAULT;
+	}
+
 #if defined(__i386__) && defined(CONFIG_SMP)
 	/* in some cases (e.g. Hyper-Threading), we want to avoid L1 evictions
 	 * by the processes running on the same package. One thing we can do is
@@ -543,7 +571,8 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	/* force 16 byte _final_ alignment here for generality */
 #define DLINFO_ITEMS 13
 
-	nitems = 1 + DLINFO_ITEMS + (k_platform ? 1 : 0) + AT_VECTOR_SIZE_ARCH;
+	nitems = 1 + DLINFO_ITEMS + (k_platform ? 1 : 0) + \
+		(k_base_platform ? 1 : 0) + AT_VECTOR_SIZE_ARCH;
 
 	csp = sp;
 	sp -= nitems * 2 * sizeof(unsigned long);
@@ -575,6 +604,13 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 			    (elf_addr_t) (unsigned long) u_platform);
 	}
 
+	if (k_base_platform) {
+		nr = 0;
+		csp -= 2 * sizeof(unsigned long);
+		NEW_AUX_ENT(AT_BASE_PLATFORM,
+			    (elf_addr_t) (unsigned long) u_base_platform);
+	}
+
 	nr = 0;
 	csp -= DLINFO_ITEMS * 2 * sizeof(unsigned long);
 	NEW_AUX_ENT(AT_HWCAP,	hwcap);

