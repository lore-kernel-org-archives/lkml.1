Return-Path: <linux-kernel-owner+w=401wt.eu-S1761549AbYBAVLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761549AbYBAVLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 16:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760352AbYBAVL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 16:11:28 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:50560 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759286AbYBAVL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 16:11:27 -0500
Date: Fri, 1 Feb 2008 22:11:25 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove old definition of setup_per_cpu_areas
Message-ID: <20080201211125.GA31779@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20080201201615.GA29187@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080201201615.GA29187@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 09:16:15PM +0100, Bastian Blank wrote:
> Remove old definition of setup_per_cpu_areas.

This was completely wrong. Lets try it again.

Adopt x86 percpu changes for powerpc and ia64.

dd5af90a7f3d79e04b7eace9a98644dbf2038f4d replaced the config variable
ARCH_SETS_UP_PER_CPU_AREA with HAVE_SETUP_PER_CPU_AREA and moved
percpu_modcopy into kernel/module.c.

Do the same for ia64 and powerpc.

| init/main.c:376: error: static declaration of ‘setup_per_cpu_areas’ follows non-static declaration
| include/asm/percpu.h:33: error: previous declaration of ‘setup_per_cpu_areas’ was here

Signed-off-by: Bastian Blank <waldi@debian.org>

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 5a41e75..c9307c9 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -80,7 +80,7 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default y
 
-config ARCH_SETS_UP_PER_CPU_AREA
+config HAVE_SETUP_PER_CPU_AREA
 	def_bool y
 
 config DMI
diff --git a/arch/ia64/kernel/module.c b/arch/ia64/kernel/module.c
index e699eb6..bbcdcfd 100644
--- a/arch/ia64/kernel/module.c
+++ b/arch/ia64/kernel/module.c
@@ -941,13 +941,3 @@ module_arch_cleanup (struct module *mod)
 		unw_remove_unwind_table(mod->arch.core_unw_table);
 }
 
-#ifdef CONFIG_SMP
-void
-percpu_modcopy (void *pcpudst, const void *src, unsigned long size)
-{
-	unsigned int i;
-	for_each_possible_cpu(i) {
-		memcpy(pcpudst + per_cpu_offset(i), src, size);
-	}
-}
-#endif /* CONFIG_SMP */
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index fb85f6b..bb16443 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -42,7 +42,7 @@ config GENERIC_HARDIRQS
 	bool
 	default y
 
-config ARCH_SETS_UP_PER_CPU_AREA
+config HAVE_SETUP_PER_CPU_AREA
 	def_bool PPC64
 
 config IRQ_PER_CPU
diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index 26f5791..73fc05d 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -66,7 +66,7 @@ config AUDIT_ARCH
 	bool
 	default y
 
-config ARCH_SETS_UP_PER_CPU_AREA
+config HAVE_SETUP_PER_CPU_AREA
 	def_bool y
 
 config ARCH_NO_VIRT_TO_BUS
diff --git a/include/asm-ia64/percpu.h b/include/asm-ia64/percpu.h
index 0095bcf..a4af49f 100644
--- a/include/asm-ia64/percpu.h
+++ b/include/asm-ia64/percpu.h
@@ -38,8 +38,9 @@ DECLARE_PER_CPU(unsigned long, local_per_cpu_offset);
 #define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __ia64_per_cpu_var(local_per_cpu_offset)))
 #define __raw_get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __ia64_per_cpu_var(local_per_cpu_offset)))
 
-extern void percpu_modcopy(void *pcpudst, const void *src, unsigned long size);
+#ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 extern void setup_per_cpu_areas (void);
+#endif
 extern void *per_cpu_init(void);
 
 #else /* ! SMP */
diff --git a/include/asm-powerpc/percpu.h b/include/asm-powerpc/percpu.h
index cc1cbf6..ea8cbb7 100644
--- a/include/asm-powerpc/percpu.h
+++ b/include/asm-powerpc/percpu.h
@@ -21,16 +21,9 @@
 #define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __my_cpu_offset()))
 #define __raw_get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, local_paca->data_offset))
 
-/* A macro to avoid #include hell... */
-#define percpu_modcopy(pcpudst, src, size)			\
-do {								\
-	unsigned int __i;					\
-	for_each_possible_cpu(__i)				\
-		memcpy((pcpudst)+__per_cpu_offset(__i),		\
-		       (src), (size));				\
-} while (0)
-
+#ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 extern void setup_per_cpu_areas(void);
+#endif
 
 #else /* ! SMP */
 
