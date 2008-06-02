Return-Path: <linux-kernel-owner+w=401wt.eu-S1757818AbYFBG0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818AbYFBG0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbYFBGYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:24:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:33215 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040AbYFBGYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:24:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,576,1204531200"; 
   d="scan'208";a="287037483"
Subject: [PATCH 5/5] x86_64 boot: linked list of setup_data for i386
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 02 Jun 2008 14:26:25 +0800
Message-Id: <1212387985.301.30.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 02 Jun 2008 06:24:37.0345 (UTC) FILETIME=[54D5E510:01C8C479]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds linked list of struct setup_data supported for i386.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/head.c      |   18 ++++++++++++++++++
 arch/x86/kernel/head64.c    |   18 ------------------
 arch/x86/kernel/setup.c     |   22 ++++++++++++++++++++++
 arch/x86/kernel/setup_32.c  |    3 +++
 arch/x86/kernel/setup_64.c  |   22 ----------------------
 include/asm-x86/bootparam.h |    3 +++
 6 files changed, 46 insertions(+), 40 deletions(-)

--- a/arch/x86/kernel/head.c
+++ b/arch/x86/kernel/head.c
@@ -53,3 +53,21 @@ void __init reserve_ebda_region(void)
 	/* reserve all memory between lowmem and the 1MB mark */
 	reserve_early(lowmem, 0x100000, "BIOS reserved");
 }
+
+void __init reserve_setup_data(void)
+{
+	struct setup_data *data;
+	u64 pa_data;
+	char buf[32];
+
+	if (boot_params.hdr.version < 0x0209)
+		return;
+	pa_data = boot_params.hdr.setup_data;
+	while (pa_data) {
+		data = early_ioremap(pa_data, sizeof(*data));
+		sprintf(buf, "setup data %x", data->type);
+		reserve_early(pa_data, pa_data+sizeof(*data)+data->len, buf);
+		pa_data = data->next;
+		early_iounmap(data, sizeof(*data));
+	}
+}
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -65,24 +65,6 @@ static void __init copy_bootdata(char *r
 	}
 }
 
-static void __init reserve_setup_data(void)
-{
-	struct setup_data *data;
-	unsigned long pa_data;
-	char buf[32];
-
-	if (boot_params.hdr.version < 0x0209)
-		return;
-	pa_data = boot_params.hdr.setup_data;
-	while (pa_data) {
-		data = early_ioremap(pa_data, sizeof(*data));
-		sprintf(buf, "setup data %x", data->type);
-		reserve_early(pa_data, pa_data+sizeof(*data)+data->len, buf);
-		pa_data = data->next;
-		early_iounmap(data, sizeof(*data));
-	}
-}
-
 void __init x86_64_start_kernel(char * real_mode_data)
 {
 	int i;
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -376,3 +376,25 @@ EXPORT_SYMBOL(node_to_cpumask);
 #endif /* CONFIG_DEBUG_PER_CPU_MAPS */
 
 #endif /* X86_64_NUMA */
+
+void __init parse_setup_data(void)
+{
+	struct setup_data *data;
+	u64 pa_data;
+
+	if (boot_params.hdr.version < 0x0209)
+		return;
+	pa_data = boot_params.hdr.setup_data;
+	while (pa_data) {
+		data = early_ioremap(pa_data, PAGE_SIZE);
+		switch (data->type) {
+		default:
+			break;
+		}
+#ifndef CONFIG_DEBUG_BOOT_PARAMS
+		free_early(pa_data, pa_data+sizeof(*data)+data->len);
+#endif
+		pa_data = data->next;
+		early_iounmap(data, PAGE_SIZE);
+	}
+}
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -270,28 +270,6 @@ void __attribute__((weak)) __init memory
        machine_specific_memory_setup();
 }
 
-static void __init parse_setup_data(void)
-{
-	struct setup_data *data;
-	unsigned long pa_data;
-
-	if (boot_params.hdr.version < 0x0209)
-		return;
-	pa_data = boot_params.hdr.setup_data;
-	while (pa_data) {
-		data = early_ioremap(pa_data, PAGE_SIZE);
-		switch (data->type) {
-		default:
-			break;
-		}
-#ifndef CONFIG_DEBUG_BOOT_PARAMS
-		free_early(pa_data, pa_data+sizeof(*data)+data->len);
-#endif
-		pa_data = data->next;
-		early_iounmap(data, PAGE_SIZE);
-	}
-}
-
 /*
  * setup_arch - architecture-specific boot-time initializations
  *
--- a/include/asm-x86/bootparam.h
+++ b/include/asm-x86/bootparam.h
@@ -107,4 +107,7 @@ struct boot_params {
 	__u8  _pad9[276];				/* 0xeec */
 } __attribute__((packed));
 
+void reserve_setup_data(void);
+void parse_setup_data(void);
+
 #endif /* _ASM_BOOTPARAM_H */
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -680,6 +680,7 @@ void __init setup_arch(char **cmdline_p)
 	pre_setup_arch_hook();
 	early_cpu_init();
 	early_ioremap_init();
+	reserve_setup_data();
 
 #ifdef CONFIG_EFI
 	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
@@ -728,6 +729,8 @@ void __init setup_arch(char **cmdline_p)
 	bss_resource.start = virt_to_phys(&__bss_start);
 	bss_resource.end = virt_to_phys(&__bss_stop)-1;
 
+	parse_setup_data();
+
 	parse_early_param();
 
 	finish_e820_parsing();

