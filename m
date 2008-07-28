Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbYG1PF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbYG1PF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbYG1PFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:05:12 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:25810 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752463AbYG1PFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:05:10 -0400
Date: Tue, 29 Jul 2008 00:04:30 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] binfmt_elf_fdpic: Support auxvec base platform string.
Message-ID: <20080728150430.GB16555@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080728150359.GA16555@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728150359.GA16555@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 483fad1c3fa1060d7e6710e84a065ad514571739 introduces
AT_BASE_PLATFORM, but only implements it for binfmt_elf. Given that
AT_VECTOR_SIZE_BASE is unconditionally enlarged for us, and it's only
optionally added in for the platforms that set ELF_BASE_PLATFORM, wire
it up for binfmt_elf_fdpic, too.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 fs/binfmt_elf_fdpic.c |   50 ++++++++++++++++++++++++++++++++++++++++++------
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
