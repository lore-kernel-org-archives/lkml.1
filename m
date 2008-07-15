Return-Path: <linux-kernel-owner+w=401wt.eu-S1754948AbYGOX7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbYGOX7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755091AbYGOX7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:59:08 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:33842 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbYGOX7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:59:06 -0400
From: Nathan Lynch <ntl@pobox.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, roland@redhat.com
Subject: [PATCH] enable AT_BASE_PLATFORM aux vector for powerpc
Date: Tue, 15 Jul 2008 18:58:51 -0500
Message-Id: <1216166331-14810-3-git-send-email-ntl@pobox.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1216166331-14810-1-git-send-email-ntl@pobox.com>
References: <1216166331-14810-1-git-send-email-ntl@pobox.com>
X-Pobox-Relay-ID: 0227017A-52CA-11DD-9C36-CE28B26B55AE-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stash the first platform string matched by identify_cpu() in
powerpc_base_platform, and supply that to the ELF loader for the value
of AT_BASE_PLATFORM.

Signed-off-by: Nathan Lynch <ntl@pobox.com>
---
 arch/powerpc/kernel/cputable.c |   11 +++++++++++
 include/asm-powerpc/cputable.h |    2 ++
 include/asm-powerpc/elf.h      |    8 ++++++++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/cputable.c b/arch/powerpc/kernel/cputable.c
index f7f3c21..89d8731 100644
--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -23,6 +23,9 @@
 struct cpu_spec* cur_cpu_spec = NULL;
 EXPORT_SYMBOL(cur_cpu_spec);
 
+/* The platform string corresponding to the real PVR */
+const char *powerpc_base_platform;
+
 /* NOTE:
  * Unlike ppc32, ppc64 will only call this once for the boot CPU, it's
  * the responsibility of the appropriate CPU save/restore functions to
@@ -1632,6 +1635,14 @@ struct cpu_spec * __init identify_cpu(unsigned long offset, unsigned int pvr)
 			} else
 				*t = *s;
 			*PTRRELOC(&cur_cpu_spec) = &the_cpu_spec;
+
+			/*
+			 * Set the base platform string once; assumes
+			 * we're called with real pvr first.
+			 */
+			if (powerpc_base_platform == NULL)
+				powerpc_base_platform = t->platform;
+
 #if defined(CONFIG_PPC64) || defined(CONFIG_BOOKE)
 			/* ppc64 and booke expect identify_cpu to also call
 			 * setup_cpu for that processor. I will consolidate
diff --git a/include/asm-powerpc/cputable.h b/include/asm-powerpc/cputable.h
index 2a3e907..ef8a248 100644
--- a/include/asm-powerpc/cputable.h
+++ b/include/asm-powerpc/cputable.h
@@ -127,6 +127,8 @@ extern struct cpu_spec *identify_cpu(unsigned long offset, unsigned int pvr);
 extern void do_feature_fixups(unsigned long value, void *fixup_start,
 			      void *fixup_end);
 
+extern const char *powerpc_base_platform;
+
 #endif /* __ASSEMBLY__ */
 
 /* CPU kernel features */
diff --git a/include/asm-powerpc/elf.h b/include/asm-powerpc/elf.h
index 8966467..80d1f39 100644
--- a/include/asm-powerpc/elf.h
+++ b/include/asm-powerpc/elf.h
@@ -217,6 +217,14 @@ typedef elf_vrregset_t elf_fpxregset_t;
 
 #define ELF_PLATFORM	(cur_cpu_spec->platform)
 
+/* While ELF_PLATFORM indicates the ISA supported by the platform, it
+ * may not accurately reflect the underlying behavior of the hardware
+ * (as in the case of running in Power5+ compatibility mode on a
+ * Power6 machine).  ELF_BASE_PLATFORM allows ld.so to load libraries
+ * that are tuned for the real hardware.
+ */
+#define ELF_BASE_PLATFORM (powerpc_base_platform)
+
 #ifdef __powerpc64__
 # define ELF_PLAT_INIT(_r, load_addr)	do {	\
 	_r->gpr[2] = load_addr; 		\
-- 
1.5.6.2

