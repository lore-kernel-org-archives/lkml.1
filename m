Return-Path: <linux-kernel-owner+w=401wt.eu-S1759648AbXHJWNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759648AbXHJWNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 18:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760739AbXHJWBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 18:01:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756966AbXHJWB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 18:01:29 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 24/25 -v2] paravirt hooks for arch initialization
Date: Fri, 10 Aug 2007 16:12:36 -0300
Message-Id: <11867732763070-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11867732713519-git-send-email-gcosta@redhat.com>
References: <1186773157329-git-send-email-gcosta@redhat.com> <11867731633002-git-send-email-gcosta@redhat.com> <11867731681763-git-send-email-gcosta@redhat.com> <11867731732274-git-send-email-gcosta@redhat.com> <11867731781610-git-send-email-gcosta@redhat.com> <11867731831138-git-send-email-gcosta@redhat.com> <11867731882768-git-send-email-gcosta@redhat.com> <11867731932688-git-send-email-gcosta@redhat.com> <11867731981891-git-send-email-gcosta@redhat.com> <1186773203887-git-send-email-gcosta@redhat.com> <11867732082735-git-send-email-gcosta@redhat.com> <11867732121974-git-send-email-gcosta@redhat.com> <1186773217875-git-send-email-gcosta@redhat.com> <11867732221652-git-send-email-gcosta@redhat.com> <11867732273108-git-send-email-gcosta@redhat.com> <11867732323106-git-send-email-gcosta@redhat.com> <11867732373232-git-send-email-gcosta@redhat.com> <11867732424024-git-send-email-gcosta@redhat.com> <11867732461037-git-send-email-gcosta@redhat.com> <11867732511513-git-send-email!
 -gcosta@redhat.com> <11867732562020-git-send-email-gcosta@redhat.com> <1186773261537-git-send-email-gcosta@redhat.com> <11867732661840-git-send-email-gcosta@redhat.com> <11867732713519-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add paravirtualization hooks in the arch initialization
process. paravirt_arch_setup() lets the guest issue any specific
initialization routine

Also, there is memory_setup(), so guests can handle it their way.

[  updates from v1
   * Don't use a separate ebda pv hook (Jeremy/Andi)
   * Make paravirt_setup_arch() void (Andi)
]

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86_64/kernel/setup.c |   32 +++++++++++++++++++++++++++++++-
 include/asm-x86_64/e820.h  |    6 ++++++
 include/asm-x86_64/page.h  |    1 +
 3 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/arch/x86_64/kernel/setup.c b/arch/x86_64/kernel/setup.c
index af838f6..19e0d90 100644
--- a/arch/x86_64/kernel/setup.c
+++ b/arch/x86_64/kernel/setup.c
@@ -44,6 +44,7 @@
 #include <linux/dmi.h>
 #include <linux/dma-mapping.h>
 #include <linux/ctype.h>
+#include <linux/uaccess.h>
 
 #include <asm/mtrr.h>
 #include <asm/uaccess.h>
@@ -65,6 +66,12 @@
 #include <asm/sections.h>
 #include <asm/dmi.h>
 
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define paravirt_arch_setup()  do {} while (0)
+#endif
+
 /*
  * Machine setup..
  */
@@ -208,6 +215,16 @@ static void discover_ebda(void)
 	 * 4K EBDA area at 0x40E
 	 */
 	ebda_addr = *(unsigned short *)__va(EBDA_ADDR_POINTER);
+	/*
+	 * There can be some situations, like paravirtualized guests,
+	 * in which there is no available ebda information. In such
+	 * case, just skip it
+	 */
+	if (!ebda_addr) {
+		ebda_size = 0;
+		return;
+	}
+
 	ebda_addr <<= 4;
 
 	ebda_size = *(unsigned short *)__va(ebda_addr);
@@ -221,6 +238,13 @@ static void discover_ebda(void)
 		ebda_size = 64*1024;
 }
 
+/* Overridden in paravirt.c if CONFIG_PARAVIRT */
+void __attribute__((weak)) memory_setup(void)
+{
+       return setup_memory_region();
+}
+
+
 void __init setup_arch(char **cmdline_p)
 {
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
@@ -231,12 +255,18 @@ void __init setup_arch(char **cmdline_p)
 	saved_video_mode = SAVED_VIDEO_MODE;
 	bootloader_type = LOADER_TYPE;
 
+	/*
+	 * By returning non-zero here, a paravirt impl can choose to
+	 * skip the rest of the setup process
+	 */
+	paravirt_arch_setup();
+
 #ifdef CONFIG_BLK_DEV_RAM
 	rd_image_start = RAMDISK_FLAGS & RAMDISK_IMAGE_START_MASK;
 	rd_prompt = ((RAMDISK_FLAGS & RAMDISK_PROMPT_FLAG) != 0);
 	rd_doload = ((RAMDISK_FLAGS & RAMDISK_LOAD_FLAG) != 0);
 #endif
-	setup_memory_region();
+	memory_setup();
 	copy_edd();
 
 	if (!MOUNT_ROOT_RDONLY)
diff --git a/include/asm-x86_64/e820.h b/include/asm-x86_64/e820.h
index 3486e70..2ced3ba 100644
--- a/include/asm-x86_64/e820.h
+++ b/include/asm-x86_64/e820.h
@@ -20,7 +20,12 @@
 #define E820_ACPI	3
 #define E820_NVS	4
 
+#define MAP_TYPE_STR	"BIOS-e820"
+
 #ifndef __ASSEMBLY__
+
+void native_ebda_info(unsigned *addr, unsigned *size);
+
 struct e820entry {
 	u64 addr;	/* start of memory segment */
 	u64 size;	/* size of memory segment */
@@ -56,6 +61,7 @@ extern struct e820map e820;
 
 extern unsigned ebda_addr, ebda_size;
 extern unsigned long nodemap_addr, nodemap_size;
+
 #endif/*!__ASSEMBLY__*/
 
 #endif/*__E820_HEADER*/
diff --git a/include/asm-x86_64/page.h b/include/asm-x86_64/page.h
index ec8b245..8c40fb2 100644
--- a/include/asm-x86_64/page.h
+++ b/include/asm-x86_64/page.h
@@ -149,6 +149,7 @@ extern unsigned long __phys_addr(unsigned long);
 #define __boot_pa(x)		__pa(x)
 #ifdef CONFIG_FLATMEM
 #define pfn_valid(pfn)		((pfn) < end_pfn)
+
 #endif
 
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
-- 
1.4.4.2

