Return-Path: <linux-kernel-owner+w=401wt.eu-S1760075AbXHHHTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075AbXHHHTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764184AbXHHHNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:13:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764448AbXHHHNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:13:48 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 23/25] [PATCH] paravirt hooks for arch initialization
Date: Wed,  8 Aug 2007 01:19:10 -0300
Message-Id: <11865468431616-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11865468394005-git-send-email-gcosta@redhat.com>
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865467592921-git-send-email-gcosta@redhat.com> <1186546763582-git-send-email-gcosta@redhat.com> <11865467662182-git-send-email-gcosta@redhat.com> <11865467702103-git-send-email-gcosta@redhat.com> <11865467741753-git-send-email-gcosta@redhat.com> <11865467773012-git-send-email-gcosta@redhat.com> <11865467812610-git-send-email-gcosta@redhat.com> <1186546785346-git-send-email-gcosta@redhat.com> <1186546789356-git-send-email-gcosta@redhat.com> <11865467931543-git-send-email-gcosta@redhat.com> <11865467973510-git-send-email-gcosta@redhat.com> <11865468003673-git-send-email-gcosta@redhat.com> <11865468043920-git-send-email-gcosta@redhat.com> <118654680831-git-send-email-gcosta@redhat.com> <11865468122642-git-send-email-gcosta@redhat.com> <11865468162812-git-send-email-gcosta@redhat.com> <1186546820708-git-send-email-gcosta@redhat.com> <11865468243612-git-send-email-gcosta@redhat.com> <11865468281860-git-send-email-gc!
 osta@redhat.com> <11865468321629-git-send-email-gcosta@redhat.com> <11865468362401-git-send-email-gcosta@redhat.com> <11865468394005-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add paravirtualization hooks in the arch initialization
process. paravirt_arch_setup() lets the guest issue any specific
initialization routine, and skip all the rest if it see fits, which
it signals by a proper return value.

In case the initialization continues, we hook at least memory_setup(),
so it can handle it in its own way.

The hypervisor can make its own  ebda mapping visible by providing
its custom ebda_info function.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86_64/kernel/setup.c |   41 ++++++++++++++++++++++++++++++++++++-----
 include/asm-x86_64/e820.h  |    6 ++++++
 2 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/arch/x86_64/kernel/setup.c b/arch/x86_64/kernel/setup.c
index af838f6..8e58a5d 100644
--- a/arch/x86_64/kernel/setup.c
+++ b/arch/x86_64/kernel/setup.c
@@ -65,6 +65,12 @@
 #include <asm/sections.h>
 #include <asm/dmi.h>
 
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define paravirt_arch_setup() 0
+#endif
+
 /*
  * Machine setup..
  */
@@ -201,17 +207,28 @@ static inline void copy_edd(void)
 unsigned __initdata ebda_addr;
 unsigned __initdata ebda_size;
 
-static void discover_ebda(void)
+void native_ebda_info(unsigned *addr, unsigned *size)
 {
 	/*
 	 * there is a real-mode segmented pointer pointing to the 
 	 * 4K EBDA area at 0x40E
 	 */
-	ebda_addr = *(unsigned short *)__va(EBDA_ADDR_POINTER);
-	ebda_addr <<= 4;
+	*addr = *(unsigned short *)__va(EBDA_ADDR_POINTER);
+	*addr <<= 4;
+
+	*size = *(unsigned short *)__va(*addr);
+}
 
-	ebda_size = *(unsigned short *)__va(ebda_addr);
+/* Overriden in paravirt.c if CONFIG_PARAVIRT */
+void __attribute__((weak)) ebda_info(unsigned *addr, unsigned *size)
+{
+	native_ebda_info(addr, size);
+}
 
+static void discover_ebda(void)
+{
+
+	ebda_info(&ebda_addr, &ebda_size);
 	/* Round EBDA up to pages */
 	if (ebda_size == 0)
 		ebda_size = 1;
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
@@ -231,12 +255,19 @@ void __init setup_arch(char **cmdline_p)
 	saved_video_mode = SAVED_VIDEO_MODE;
 	bootloader_type = LOADER_TYPE;
 
+	/*
+	 * By returning non-zero here, a paravirt impl can choose to
+	 * skip the rest of the setup process
+	 */
+	if (paravirt_arch_setup())
+		return;
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
-- 
1.4.4.2

