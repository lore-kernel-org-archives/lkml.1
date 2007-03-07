Return-Path: <linux-kernel-owner+w=401wt.eu-S1161146AbXCGH1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161146AbXCGH1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 02:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161172AbXCGH1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 02:27:49 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:57027 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161146AbXCGH1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 02:27:48 -0500
Date: Wed, 7 Mar 2007 12:34:49 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       pavel@suse.cz, rjw@sisk.pl
Subject: [PATCH 5/20] x86_64: modify copy_bootdata to use virtual addresses
Message-ID: <20070307070449.GF23412@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070307065703.GA23412@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307065703.GA23412@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Use virtual addresses instead of physical addresses
in copy bootdata.  In addition fix the implementation
of the old bootloader convention.  Everything is
at real_mode_data always.  It is just that sometimes
real_mode_data was relocated by setup.S to not sit at
0x90000.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
---

 arch/x86_64/kernel/head64.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN arch/x86_64/kernel/head64.c~x86_64-modify-copy_bootdata-to-use-virtual-addresses arch/x86_64/kernel/head64.c
--- linux-2.6.21-rc2-reloc/arch/x86_64/kernel/head64.c~x86_64-modify-copy_bootdata-to-use-virtual-addresses	2007-03-07 01:23:55.000000000 +0530
+++ linux-2.6.21-rc2-reloc-root/arch/x86_64/kernel/head64.c	2007-03-07 01:23:55.000000000 +0530
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
_
