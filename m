Return-Path: <linux-kernel-owner+w=401wt.eu-S1163338AbXD1SAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163338AbXD1SAy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163353AbXD1R7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:59:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031935AbXD1R6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:58:53 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428758.455116000@suse.de>
In-Reply-To: <20070428758.455116000@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [6/22] x86_64: modify copy_bootdata to use virtual addresses
Message-Id: <20070428175852.DDAD1151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:58:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Vivek Goyal <vgoyal@in.ibm.com>

Use virtual addresses instead of physical addresses
in copy bootdata.  In addition fix the implementation
of the old bootloader convention.  Everything is
at real_mode_data always.  It is just that sometimes
real_mode_data was relocated by setup.S to not sit at
0x90000.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/head64.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

Index: linux/arch/x86_64/kernel/head64.c
===================================================================
--- linux.orig/arch/x86_64/kernel/head64.c
+++ linux/arch/x86_64/kernel/head64.c
@@ -29,25 +29,24 @@ static void __init clear_bss(void)
 }
 
 #define NEW_CL_POINTER		0x228	/* Relative to real mode data */
-#define OLD_CL_MAGIC_ADDR	0x90020
+#define OLD_CL_MAGIC_ADDR	0x20
 #define OLD_CL_MAGIC            0xA33F
-#define OLD_CL_BASE_ADDR        0x90000
-#define OLD_CL_OFFSET           0x90022
+#define OLD_CL_OFFSET           0x22
 
 static void __init copy_bootdata(char *real_mode_data)
 {
-	int new_data;
+	unsigned long new_data;
 	char * command_line;
 
 	memcpy(x86_boot_params, real_mode_data, BOOT_PARAM_SIZE);
-	new_data = *(int *) (x86_boot_params + NEW_CL_POINTER);
+	new_data = *(u32 *) (x86_boot_params + NEW_CL_POINTER);
 	if (!new_data) {
-		if (OLD_CL_MAGIC != * (u16 *) OLD_CL_MAGIC_ADDR) {
+		if (OLD_CL_MAGIC != *(u16 *)(real_mode_data + OLD_CL_MAGIC_ADDR)) {
 			return;
 		}
-		new_data = OLD_CL_BASE_ADDR + * (u16 *) OLD_CL_OFFSET;
+		new_data = __pa(real_mode_data) + *(u16 *)(real_mode_data + OLD_CL_OFFSET);
 	}
-	command_line = (char *) ((u64)(new_data));
+	command_line = __va(new_data);
 	memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
 }
 
@@ -74,7 +73,7 @@ void __init x86_64_start_kernel(char * r
  		cpu_pda(i) = &boot_cpu_pda[i];
 
 	pda_init(0);
-	copy_bootdata(real_mode_data);
+	copy_bootdata(__va(real_mode_data));
 #ifdef CONFIG_SMP
 	cpu_set(0, cpu_online_map);
 #endif
