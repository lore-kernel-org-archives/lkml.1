Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbZCHQuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbZCHQuY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 12:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbZCHQsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 12:48:45 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37630 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753173AbZCHQsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 12:48:43 -0400
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 05/13] [VOYAGER] x86/voyager: Move voyager detection to a new bootparam area
Date: Sun,  8 Mar 2009 11:48:18 -0500
Message-Id: <1236530906-7175-6-git-send-email-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236530906-7175-5-git-send-email-James.Bottomley@HansenPartnership.com>
References: <1236530906-7175-1-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-2-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-3-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-4-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-5-git-send-email-James.Bottomley@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For voyager to be detected in arbitrary configurations, it can no
longer hijack the apm_bios area and must have a bios area of its own,
which this patch implements.

Since the a20 test can't be done on voyager because of VIC
incompatibilities, the voyager detection must come first so the a20
test can do a runtime check of voyager presence.  The runtime check in
is_voyager() relies on boot_params, so move this outside of the _SETUP
include guard in asm/setup.h and remove the separate definition from
boot/boot.h.

Also added is an early printk if voyager is detected to aid in
debugging problems as they arise.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/boot/Makefile                |    4 +++-
 arch/x86/boot/a20.c                   |   13 +++++++------
 arch/x86/boot/boot.h                  |    2 +-
 arch/x86/boot/voyager.c               |    5 +++--
 arch/x86/include/asm/bootparam.h      |    5 ++++-
 arch/x86/include/asm/setup.h          |    4 ++--
 arch/x86/include/asm/voyager.h        |   13 +++----------
 arch/x86/include/asm/voyager_bios.h   |   21 +++++++++++++++++++++
 arch/x86/include/asm/voyager_boot.h   |   27 +++++++++++++++++++++++++++
 arch/x86/mach-voyager/voyager_basic.c |    2 +-
 10 files changed, 72 insertions(+), 24 deletions(-)
 create mode 100644 arch/x86/include/asm/voyager_bios.h
 create mode 100644 arch/x86/include/asm/voyager_boot.h

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index cd48c72..7bc64fa 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -28,11 +28,13 @@ SVGA_MODE := -DSVGA_MODE=NORMAL_VGA
 targets		:= vmlinux.bin setup.bin setup.elf zImage bzImage
 subdir-		:= compressed
 
+# Voyager must come first because there's a condition in a20.c
+# that depends on voyager detection
+setup-$(CONFIG_X86_VOYAGER) += voyager.o
 setup-y		+= a20.o cmdline.o copy.o cpu.o cpucheck.o edd.o
 setup-y		+= header.o main.o mca.o memory.o pm.o pmjump.o
 setup-y		+= printf.o string.o tty.o video.o video-mode.o version.o
 setup-$(CONFIG_X86_APM_BOOT) += apm.o
-setup-$(CONFIG_X86_VOYAGER) += voyager.o
 
 # The link order of the video-*.o modules can matter.  In particular,
 # video-vga.o *must* be listed first, followed by video-vesa.o.
diff --git a/arch/x86/boot/a20.c b/arch/x86/boot/a20.c
index fba8e9c..ecd9561 100644
--- a/arch/x86/boot/a20.c
+++ b/arch/x86/boot/a20.c
@@ -126,11 +126,13 @@ static void enable_a20_fast(void)
 
 int enable_a20(void)
 {
-#ifdef CONFIG_X86_VOYAGER
-	/* On Voyager, a20_test() is unsafe? */
-	enable_a20_kbc();
-	return 0;
-#else
+	if (is_voyager()) {
+		/* On Voyager, a20_test() is unsafe becuase it pokes
+		 * about in areas that are VIC specific and causes
+		 * a crash */
+		enable_a20_kbc();
+		return 0;
+	}
        int loops = A20_ENABLE_LOOPS;
        int kbc_err;
 
@@ -164,5 +166,4 @@ int enable_a20(void)
        }
        
        return -1;
-#endif
 }
diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index cc0ef13..d70323d 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -24,6 +24,7 @@
 #include <linux/edd.h>
 #include <asm/boot.h>
 #include <asm/setup.h>
+#include <asm/voyager_boot.h>
 #include "bitops.h"
 #include <asm/cpufeature.h>
 
@@ -33,7 +34,6 @@
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
 
 extern struct setup_header hdr;
-extern struct boot_params boot_params;
 
 /* Basic port I/O */
 static inline void outb(u8 v, u16 port)
diff --git a/arch/x86/boot/voyager.c b/arch/x86/boot/voyager.c
index 433909d..c599ff7 100644
--- a/arch/x86/boot/voyager.c
+++ b/arch/x86/boot/voyager.c
@@ -19,9 +19,9 @@ int query_voyager(void)
 	u8 err;
 	u16 es, di;
 	/* Abuse the apm_bios_info area for this */
-	u8 *data_ptr = (u8 *)&boot_params.apm_bios_info;
+	u8 *data_ptr = (u8 *)&boot_params.voyager_bios_info;
 
-	data_ptr[0] = 0xff;	/* Flag on config not found(?) */
+	data_ptr[0] = NOT_VOYAGER_BIOS_SIG;
 
 	asm("pushw %%es ; "
 	    "int $0x15 ; "
@@ -33,6 +33,7 @@ int query_voyager(void)
 
 	if (err)
 		return -1;	/* Not Voyager */
+	printf("Voyager detected\n");
 
 	set_fs(es);
 	copy_from_fs(data_ptr, di, 7);	/* Table is 7 bytes apparently */
diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
index 433adae..2a388a5 100644
--- a/arch/x86/include/asm/bootparam.h
+++ b/arch/x86/include/asm/bootparam.h
@@ -7,6 +7,7 @@
 #include <linux/edd.h>
 #include <asm/e820.h>
 #include <asm/ist.h>
+#include <asm/voyager_bios.h>
 #include <video/edid.h>
 
 /* setup data types */
@@ -105,7 +106,9 @@ struct boot_params {
 	struct e820entry e820_map[E820MAX];		/* 0x2d0 */
 	__u8  _pad8[48];				/* 0xcd0 */
 	struct edd_info eddbuf[EDDMAXNR];		/* 0xd00 */
-	__u8  _pad9[276];				/* 0xeec */
+	__u8  _pad9[20];				/* 0xeec */
+	struct voyager_bios_info voyager_bios_info;	/* 0xf00 */
+	__u8  _pad10[249];				/* 0xf07 */
 } __attribute__((packed));
 
 #endif /* _ASM_X86_BOOTPARAM_H */
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 7782327..8bbaffa 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -88,13 +88,13 @@ extern unsigned long saved_video_mode;
 #define paravirt_post_allocator_init()	do {} while (0)
 #endif
 
-#ifndef _SETUP
-
 /*
  * This is set up by the setup-routine at boot-time
  */
 extern struct boot_params boot_params;
 
+#ifndef _SETUP
+
 /*
  * Do NOT EVER look at the BIOS memory size location.
  * It does not work on many machines.
diff --git a/arch/x86/include/asm/voyager.h b/arch/x86/include/asm/voyager.h
index c1635d4..04fd0c9 100644
--- a/arch/x86/include/asm/voyager.h
+++ b/arch/x86/include/asm/voyager.h
@@ -4,6 +4,9 @@
  *
  * Standard include definitions for the NCR Voyager system */
 
+#include <asm/voyager_bios.h>
+#include <asm/voyager_boot.h>
+
 #undef	VOYAGER_DEBUG
 #undef	VOYAGER_CAT_DEBUG
 
@@ -305,16 +308,6 @@ typedef struct voyager_asic_data_table {
 
 
 
-struct voyager_bios_info {
-	__u8	len;
-	__u8	major;
-	__u8	minor;
-	__u8	debug;
-	__u8	num_classes;
-	__u8	class_1;
-	__u8	class_2;
-};
-
 /* The following structures and definitions are for the Kernel/SUS
  * interface these are needed to find out how SUS initialised any Quad
  * boards in the system */
diff --git a/arch/x86/include/asm/voyager_bios.h b/arch/x86/include/asm/voyager_bios.h
new file mode 100644
index 0000000..37b18ec
--- /dev/null
+++ b/arch/x86/include/asm/voyager_bios.h
@@ -0,0 +1,21 @@
+/*
+ * This file is designed to be included in the boot system
+ * so must be as minimal as possible
+ */
+#ifndef _ASM_VOYAGER_BIOS_H
+#define _ASM_VOYAGER_BIOS_H
+
+/* non voyager signature in the len field (voyager bios length is small) */
+#define NOT_VOYAGER_BIOS_SIG	0xff
+
+struct voyager_bios_info {
+	__u8	len;
+	__u8	major;
+	__u8	minor;
+	__u8	debug;
+	__u8	num_classes;
+	__u8	class_1;
+	__u8	class_2;
+};
+
+#endif /* _ASM_VOYAGER_BIOS_H */
diff --git a/arch/x86/include/asm/voyager_boot.h b/arch/x86/include/asm/voyager_boot.h
new file mode 100644
index 0000000..20656b7
--- /dev/null
+++ b/arch/x86/include/asm/voyager_boot.h
@@ -0,0 +1,27 @@
+/*
+ * This file is designed to be included in the boot system
+ * so must be as minimal as possible
+ */
+#ifndef _ASM_VOYAGER_BOOT_H
+#define _ASM_VOYAGER_BOOT_H
+
+#include <asm/setup.h>
+#include <asm/voyager_bios.h>
+
+#ifdef CONFIG_X86_VOYAGER
+
+static inline int is_voyager(void)
+{
+	return boot_params.voyager_bios_info.len != NOT_VOYAGER_BIOS_SIG;
+}
+
+#else
+
+static inline int is_voyager(void)
+{
+	return 0;
+}
+
+#endif /* CONFIG_X86_VOYAGER */
+
+#endif
diff --git a/arch/x86/mach-voyager/voyager_basic.c b/arch/x86/mach-voyager/voyager_basic.c
index 46d6f80..7581b5f 100644
--- a/arch/x86/mach-voyager/voyager_basic.c
+++ b/arch/x86/mach-voyager/voyager_basic.c
@@ -56,7 +56,7 @@ static struct sysrq_key_op sysrq_voyager_dump_op = {
 
 void voyager_detect(struct voyager_bios_info *bios)
 {
-	if (bios->len != 0xff) {
+	if (bios->len != NOT_VOYAGER_BIOS_SIG) {
 		int class = (bios->class_1 << 8)
 		    | (bios->class_2 & 0xff);
 
-- 
1.6.1.3

