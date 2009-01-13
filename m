Return-Path: <linux-kernel-owner+w=401wt.eu-S1760183AbZAMKmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183AbZAMKmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 05:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757041AbZAMKjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 05:39:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:51171 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756933AbZAMKjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 05:39:23 -0500
From: Tejun Heo <tj@kernel.org>
To: ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       mingo@elte.hu, travis@sgi.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, akpm@linux-foundation.org, steiner@sgi.com,
       hugh@veritas.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/13] x86_64: misc clean up after the percpu update
Date: Tue, 13 Jan 2009 19:38:16 +0900
Message-Id: <1231843097-18003-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1231843097-18003-1-git-send-email-tj@kernel.org>
References: <1231843097-18003-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Jan 2009 10:38:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do the following cleanups.

* kill x86_64_init_pda() which now is equivalent to pda_init()

* use per_cpu_offset() instead of cpu_pda() when initializing
  initial_gs

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mike Travis <travis@sgi.com>
---
 arch/x86/include/asm/setup.h |    1 -
 arch/x86/kernel/acpi/sleep.c |    2 +-
 arch/x86/kernel/head64.c     |    7 +------
 arch/x86/kernel/smpboot.c    |    2 +-
 arch/x86/xen/enlighten.c     |    2 +-
 5 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 4fcd53f..2f3e50e 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -100,7 +100,6 @@ extern unsigned long init_pg_tables_start;
 extern unsigned long init_pg_tables_end;
 
 #else
-void __init x86_64_init_pda(void);
 void __init x86_64_start_kernel(char *real_mode);
 void __init x86_64_start_reservations(char *real_mode_data);
 
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index fe23ff8..94c9b75 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -101,7 +101,7 @@ int acpi_save_state_mem(void)
 	stack_start.sp = temp_stack + sizeof(temp_stack);
 	early_gdt_descr.address =
 			(unsigned long)get_cpu_gdt_table(smp_processor_id());
-	initial_gs = (unsigned long)cpu_pda(smp_processor_id());
+	initial_gs = per_cpu_offset(smp_processor_id());
 #endif
 	initial_code = (unsigned long)wakeup_long64;
 	saved_magic = 0x123456789abcdef0;
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 71b6f6e..af67d32 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -26,11 +26,6 @@
 #include <asm/bios_ebda.h>
 #include <asm/trampoline.h>
 
-void __init x86_64_init_pda(void)
-{
-	pda_init(0);
-}
-
 static void __init zap_identity_mappings(void)
 {
 	pgd_t *pgd = pgd_offset_k(0UL);
@@ -96,7 +91,7 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	if (console_loglevel == 10)
 		early_printk("Kernel alive\n");
 
-	x86_64_init_pda();
+	pda_init(0);
 
 	x86_64_start_reservations(real_mode_data);
 }
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3a0fec6..3179bb9 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -804,7 +804,7 @@ do_rest:
 #else
 	cpu_pda(cpu)->pcurrent = c_idle.idle;
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
-	initial_gs = (unsigned long)cpu_pda(cpu);
+	initial_gs = per_cpu_offset(cpu);
 #endif
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	initial_code = (unsigned long)start_secondary;
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index bea2152..76e092d 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1652,7 +1652,7 @@ asmlinkage void __init xen_start_kernel(void)
 #ifdef CONFIG_X86_64
 	/* Disable until direct per-cpu data access. */
 	have_vcpu_info_placement = 0;
-	x86_64_init_pda();
+	pda_init(0);
 #endif
 
 	xen_smp_init();
-- 
1.5.6

