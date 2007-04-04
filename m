Return-Path: <linux-kernel-owner+w=401wt.eu-S2992768AbXDDIv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992768AbXDDIv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 04:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992767AbXDDIv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 04:51:29 -0400
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:51041 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992762AbXDDIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 04:51:25 -0400
Subject: [PATCH 1/4] Remove hardcoding of hard_smp_processor_id on UP
	systems
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ak@suse.de, benh@kernel.crashing.org,
       davem@davemloft.net, ebiederm@xmission.com, heiko.carstens@de.ibm.com,
       horms@verge.net.au, ink@jurassic.park.msu.ru, jdike@addtoit.com,
       paulus@samba.org, rth@twiddle.net, schwidefsky@de.ibm.com,
       takata@linux-m32r.org, tony.luck@intel.com, vgoyal@in.ibm.com
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 04 Apr 2007 17:51:24 +0900
Message-Id: <1175676684.26920.129.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With the advent of kdump, the assumption that the boot CPU when booting
an UP
kernel is always the CPU with a particular hardware ID (often 0)
(usually
referred to as BSP on some architectures) is not valid anymore. The
reason being that the dump capture kernel boots on the crashed CPU (the
CPU that invoked crash_kexec), which may be or may not be that
particular CPU.

Move definition of hard_smp_processor_id for the UP case to
architecture-specific code ("asm/smp.h") where it belongs, so that each
architecture can provide its own implementation.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.21-rc5-orig/include/asm-alpha/smp.h linux-2.6.21-rc5/include/asm-alpha/smp.h
--- linux-2.6.21-rc5-orig/include/asm-alpha/smp.h	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.21-rc5/include/asm-alpha/smp.h	2007-04-04 14:35:44.000000000 +0900
@@ -51,6 +51,7 @@ int smp_call_function_on_cpu(void (*func
 
 #else /* CONFIG_SMP */
 
+#define hard_smp_processor_id()		0
 #define smp_call_function_on_cpu(func,info,retry,wait,cpu)    ({ 0; })
 
 #endif /* CONFIG_SMP */
diff -urNp linux-2.6.21-rc5-orig/include/asm-i386/smp.h linux-2.6.21-rc5/include/asm-i386/smp.h
--- linux-2.6.21-rc5-orig/include/asm-i386/smp.h	2007-04-04 14:02:04.000000000 +0900
+++ linux-2.6.21-rc5/include/asm-i386/smp.h	2007-04-04 14:41:01.000000000 +0900
@@ -97,12 +97,13 @@ extern unsigned int num_processors;
 
 #else /* CONFIG_SMP */
 
+#define hard_smp_processor_id()		0
 #define safe_smp_processor_id()		0
 #define cpu_physical_id(cpu)		boot_cpu_physical_apicid
 
 #define NO_PROC_ID		0xFF		/* No processor magic marker */
 
-#endif
+#endif /* CONFIG_SMP */
 
 #ifndef __ASSEMBLY__
 
diff -urNp linux-2.6.21-rc5-orig/include/asm-ia64/smp.h linux-2.6.21-rc5/include/asm-ia64/smp.h
--- linux-2.6.21-rc5-orig/include/asm-ia64/smp.h	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.21-rc5/include/asm-ia64/smp.h	2007-04-04 14:51:31.000000000 +0900
@@ -128,8 +128,9 @@ extern void unlock_ipi_calllock(void);
 extern void identify_siblings (struct cpuinfo_ia64 *);
 extern int is_multithreading_enabled(void);
 
-#else
+#else /* CONFIG_SMP */
 
+#define hard_smp_processor_id()		0
 #define cpu_logical_id(i)		0
 #define cpu_physical_id(i)		ia64_get_lid()
 
diff -urNp linux-2.6.21-rc5-orig/include/asm-m32r/smp.h linux-2.6.21-rc5/include/asm-m32r/smp.h
--- linux-2.6.21-rc5-orig/include/asm-m32r/smp.h	2007-04-04 14:02:04.000000000 +0900
+++ linux-2.6.21-rc5/include/asm-m32r/smp.h	2007-04-04 14:35:44.000000000 +0900
@@ -108,6 +108,10 @@ extern unsigned long send_IPI_mask_phys(
 #define IPI_SHIFT	(0)
 #define NR_IPIS		(8)
 
-#endif	/* CONFIG_SMP */
+#else	/* CONFIG_SMP */
+
+#define hard_smp_processor_id()		0
+
+#endif /* CONFIG_SMP */
 
 #endif	/* _ASM_M32R_SMP_H */
diff -urNp linux-2.6.21-rc5-orig/include/asm-powerpc/smp.h linux-2.6.21-rc5/include/asm-powerpc/smp.h
--- linux-2.6.21-rc5-orig/include/asm-powerpc/smp.h	2007-04-04 14:02:04.000000000 +0900
+++ linux-2.6.21-rc5/include/asm-powerpc/smp.h	2007-04-04 14:35:44.000000000 +0900
@@ -83,6 +83,7 @@ extern void __cpu_die(unsigned int cpu);
 
 #else
 /* for UP */
+#define hard_smp_processor_id()		0
 #define smp_setup_cpu_maps()
 
 #endif /* CONFIG_SMP */
diff -urNp linux-2.6.21-rc5-orig/include/asm-s390/smp.h linux-2.6.21-rc5/include/asm-s390/smp.h
--- linux-2.6.21-rc5-orig/include/asm-s390/smp.h	2007-04-04 14:02:04.000000000 +0900
+++ linux-2.6.21-rc5/include/asm-s390/smp.h	2007-04-04 14:35:44.000000000 +0900
@@ -113,6 +113,7 @@ static inline void smp_send_stop(void)
 	__load_psw_mask(psw_kernel_bits & ~PSW_MASK_MCHECK);
 }
 
+#define hard_smp_processor_id()		0
 #define smp_cpu_not_running(cpu)	1
 #define smp_get_cpu(cpu) ({ 0; })
 #define smp_put_cpu(cpu) ({ 0; })
diff -urNp linux-2.6.21-rc5-orig/include/asm-sparc/smp.h linux-2.6.21-rc5/include/asm-sparc/smp.h
--- linux-2.6.21-rc5-orig/include/asm-sparc/smp.h	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.21-rc5/include/asm-sparc/smp.h	2007-04-04 14:35:44.000000000 +0900
@@ -165,6 +165,7 @@ void smp_setup_cpu_possible_map(void);
 
 #else /* SMP */
 
+#define hard_smp_processor_id()		0
 #define smp_setup_cpu_possible_map() do { } while (0)
 
 #endif /* !(SMP) */
diff -urNp linux-2.6.21-rc5-orig/include/asm-sparc64/smp.h linux-2.6.21-rc5/include/asm-sparc64/smp.h
--- linux-2.6.21-rc5-orig/include/asm-sparc64/smp.h	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.21-rc5/include/asm-sparc64/smp.h	2007-04-04 14:35:44.000000000 +0900
@@ -47,6 +47,7 @@ extern void smp_setup_cpu_possible_map(v
 
 #else
 
+#define hard_smp_processor_id()		0
 #define smp_setup_cpu_possible_map() do { } while (0)
 
 #endif /* !(CONFIG_SMP) */
diff -urNp linux-2.6.21-rc5-orig/include/asm-um/smp.h linux-2.6.21-rc5/include/asm-um/smp.h
--- linux-2.6.21-rc5-orig/include/asm-um/smp.h	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.21-rc5/include/asm-um/smp.h	2007-04-04 14:35:44.000000000 +0900
@@ -24,6 +24,10 @@ extern inline void smp_cpus_done(unsigne
 
 extern struct task_struct *idle_threads[NR_CPUS];
 
+#else
+
+#define hard_smp_processor_id()		0
+
 #endif
 
 #endif
diff -urNp linux-2.6.21-rc5-orig/include/asm-x86_64/smp.h linux-2.6.21-rc5/include/asm-x86_64/smp.h
--- linux-2.6.21-rc5-orig/include/asm-x86_64/smp.h	2007-04-04 14:02:04.000000000 +0900
+++ linux-2.6.21-rc5/include/asm-x86_64/smp.h	2007-04-04 14:48:16.000000000 +0900
@@ -73,7 +73,9 @@ extern unsigned __cpuinitdata disabled_c
 
 #define NO_PROC_ID		0xFF		/* No processor magic marker */
 
-#endif
+#else /* CONFIG_SMP */
+#define hard_smp_processor_id() 0
+#endif /* CONFIG_SMP */
 
 /*
  * Some lowlevel functions might want to know about
diff -urNp linux-2.6.21-rc5-orig/include/linux/smp.h linux-2.6.21-rc5/include/linux/smp.h
--- linux-2.6.21-rc5-orig/include/linux/smp.h	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.21-rc5/include/linux/smp.h	2007-04-04 14:35:02.000000000 +0900
@@ -83,7 +83,6 @@ void smp_prepare_boot_cpu(void);
  *	These macros fold the SMP functionality into a single CPU system
  */
 #define raw_smp_processor_id()			0
-#define hard_smp_processor_id()			0
 static inline int up_smp_call_function(void)
 {
 	return 0;


