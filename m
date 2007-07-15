Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbXGOGoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbXGOGoP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 02:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbXGOGnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 02:43:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:2944 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbXGOGnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 02:43:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=MngozzJLTGm3AEZdWTAEZA0lZJ0lW3M6ET5kDWvQQGILBY61Oy8xNicIeQNN6hkdUcJ4mToErTnwbbuLKtBhcKU3CqyDwk3lI6MzCbGtFWMCLIHZThA+p2lzMVuHojZbcDQC5EJFCsADQ5pYvJWT8T2AxK53neosI0M0ZguYigk=
Date: Sun, 15 Jul 2007 16:43:45 +1000
From: Andrew Hendry <andrew.hendry@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, jejb@steeleye.com,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] MCA: setup ifdefs
Message-ID: <20070715164345.41f9beea@jed>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The MCA setup performed is only needed when CONFIG_MCA=y.
This wraps the setup with CONFIG_MCA and removes
EXPORT_SYMBOL(machine_id) as no modules use it. Moved MCA setup
variables from processor.h to mca.h because nothing else uses them.

Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>


diff -uprN -X dontdiff a/arch/i386/boot/main.c b/arch/i386/boot/main.c
--- a/arch/i386/boot/main.c	2007-07-15 12:10:12.000000000 +1000
+++ b/arch/i386/boot/main.c	2007-07-15 13:24:26.000000000 +1000
@@ -137,7 +137,9 @@ void main(void)
 	set_video();
 
 	/* Query MCA information */
+#ifdef CONFIG_MCA
 	query_mca();
+#endif
 
 	/* Voyager */
 #ifdef CONFIG_X86_VOYAGER
diff -uprN -X dontdiff a/arch/i386/boot/mca.c b/arch/i386/boot/mca.c
--- a/arch/i386/boot/mca.c	2007-07-15 12:10:02.000000000 +1000
+++ b/arch/i386/boot/mca.c	2007-07-15 13:25:19.000000000 +1000
@@ -16,6 +16,8 @@
 
 #include "boot.h"
 
+#ifdef CONFIG_MCA
+
 int query_mca(void)
 {
 	u8 err;
@@ -41,3 +43,5 @@ int query_mca(void)
 	copy_from_fs(&boot_params.sys_desc_table, bx, len);
 	return 0;
 }
+
+#endif
diff -uprN -X dontdiff a/arch/i386/kernel/setup.c
b/arch/i386/kernel/setup.c --- a/arch/i386/kernel/setup.c
2007-07-15 12:23:45.000000000 +1000 +++
b/arch/i386/kernel/setup.c	2007-07-15 13:29:06.000000000 +1000
@@ -84,13 +84,11 @@ EXPORT_SYMBOL(boot_cpu_data); 
 unsigned long mmu_cr4_features;
 
-/* for MCA, but anyone else can use it if they want */
-unsigned int machine_id;
 #ifdef CONFIG_MCA
-EXPORT_SYMBOL(machine_id);
-#endif
+unsigned int machine_id;
 unsigned int machine_submodel_id;
 unsigned int BIOS_revision;
+#endif
 
 /* Boot loader ID as an integer, for the benefit of proc_dointvec */
 int bootloader_type;
@@ -480,8 +478,6 @@ static void set_mca_bus(int x)
 {
 	MCA_bus = x;
 }
-#else
-static void set_mca_bus(int x) { }
 #endif
 
 /* Overridden in paravirt.c if CONFIG_PARAVIRT */
@@ -523,12 +519,15 @@ void __init setup_arch(char **cmdline_p)
 	apm_info.bios = APM_BIOS_INFO;
 	ist_info = IST_INFO;
 	saved_videomode = VIDEO_MODE;
+
+#ifdef CONFIG_MCA
 	if( SYS_DESC_TABLE.length != 0 ) {
 		set_mca_bus(SYS_DESC_TABLE.table[3] & 0x2);
 		machine_id = SYS_DESC_TABLE.table[0];
 		machine_submodel_id = SYS_DESC_TABLE.table[1];
 		BIOS_revision = SYS_DESC_TABLE.table[2];
 	}
+#endif
 	bootloader_type = LOADER_TYPE;
 
 #ifdef CONFIG_BLK_DEV_RAM
diff -uprN -X dontdiff a/include/asm-i386/processor.h
b/include/asm-i386/processor.h ---
a/include/asm-i386/processor.h	2007-07-15 12:23:45.000000000
+1000 +++ b/include/asm-i386/processor.h	2007-07-15
13:31:54.000000000 +1000 @@ -206,12 +206,6 @@ static inline void
__mwait(unsigned long extern void mwait_idle_with_hints(unsigned long
eax, unsigned long ecx); 
-/* from system description table in BIOS.  Mostly for MCA use, but
-others may find it useful. */
-extern unsigned int machine_id;
-extern unsigned int machine_submodel_id;
-extern unsigned int BIOS_revision;
-
 /* Boot loader type from the setup header */
 extern int bootloader_type;
 
diff -uprN -X dontdiff a/include/linux/mca.h b/include/linux/mca.h
--- a/include/linux/mca.h	2007-07-15 12:06:06.000000000 +1000
+++ b/include/linux/mca.h	2007-07-15 13:32:40.000000000 +1000
@@ -34,6 +34,11 @@ typedef int (*MCA_ProcFn)(char* buf, int
  */
 extern void mca_handle_nmi(void);
 
+/* From system description table in BIOS */
+extern unsigned int machine_id;
+extern unsigned int machine_submodel_id;
+extern unsigned int BIOS_revision;
+
 enum MCA_AdapterStatus {
 	MCA_ADAPTER_NORMAL = 0,
 	MCA_ADAPTER_NONE = 1,
