Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbYGCXmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbYGCXmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 19:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756848AbYGCXmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 19:42:36 -0400
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:49549 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807AbYGCXmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 19:42:35 -0400
Date: Thu, 3 Jul 2008 18:42:28 -0500
From: Nathan Lynch <ntl@pobox.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       Roland McGrath <roland@redhat.com>
Subject: [PATCH 2/2] enable AT_BASE_PLATFORM aux vector for powerpc
Message-ID: <20080703234228.GD9594@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Pobox-Relay-ID: B59BAC12-4959-11DD-8A60-3113EBD4C077-04752483!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stash the first platform string matched by identify_cpu() in
powerpc_base_platform, and supply that to the ELF loader for the value
of AT_BASE_PLATFORM.

Signed-off-by: Nathan Lynch <ntl@pobox.com>
---

Note: I wasn't sure how to pick the index value for AT_BASE_PLATFORM;
I simply searched include/ for all AT_ values and added 1 to the
highest value found.

 arch/powerpc/kernel/cputable.c |   11 +++++++++++
 include/asm-powerpc/auxvec.h   |    3 +++
 include/asm-powerpc/cputable.h |    2 ++
 include/asm-powerpc/elf.h      |    8 ++++++++
 4 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/cputable.c b/arch/powerpc/kernel/cputable.c
index a9c90be..f1eb632 100644
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
@@ -1620,6 +1623,14 @@ struct cpu_spec * __init identify_cpu(unsigned long offset, unsigned int pvr)
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
diff --git a/include/asm-powerpc/auxvec.h b/include/asm-powerpc/auxvec.h
index 19a099b..507f081 100644
--- a/include/asm-powerpc/auxvec.h
+++ b/include/asm-powerpc/auxvec.h
@@ -16,4 +16,7 @@
  */
 #define AT_SYSINFO_EHDR		33
 
+/* The actual hardware platform; may differ from AT_PLATFORM */
+#define AT_BASE_PLATFORM	38
+
 #endif
diff --git a/include/asm-powerpc/cputable.h b/include/asm-powerpc/cputable.h
index a9c1de3..527152f 100644
--- a/include/asm-powerpc/cputable.h
+++ b/include/asm-powerpc/cputable.h
@@ -125,6 +125,8 @@ extern struct cpu_spec *identify_cpu(unsigned long offset, unsigned int pvr);
 extern void do_feature_fixups(unsigned long value, void *fixup_start,
 			      void *fixup_end);
 
+extern const char *powerpc_base_platform;
+
 #endif /* __ASSEMBLY__ */
 
 /* CPU kernel features */
diff --git a/include/asm-powerpc/elf.h b/include/asm-powerpc/elf.h
index 38a5172..ff0c947 100644
--- a/include/asm-powerpc/elf.h
+++ b/include/asm-powerpc/elf.h
@@ -237,6 +237,14 @@ extern int dump_task_altivec(struct task_struct *, elf_vrregset_t *vrregs);
 
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
1.5.5.1

