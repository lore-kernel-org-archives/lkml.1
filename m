Return-Path: <linux-kernel-owner+w=401wt.eu-S1758963AbXEMMKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963AbXEMMKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 08:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757337AbXEMMKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 08:10:03 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:33931 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758482AbXEMMJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 08:09:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=RlYrbKzbx3n1mc736FmTcEGS+ExVK0shqTH2qY/Rw989Jz/NPfb4WZPEAgAcnSi7b1CZePeTdgaQ497CwPRKOQWuEBpMOHISXbbOguAQE1Lef6n8HS/jz5kKQFYgjXhbn+xPzt+xwwYBFQe5QA4FKJbB2IK9Goi6RuRZ9+fmDfQ=
Date: Sun, 13 May 2007 22:09:50 +1000
From: Andrew Hendry <andrew.hendry@gmail.com>
To: James.Bottomley@steeleye.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mca: Wrap MCA code with CONFIG_MCA
Message-Id: <20070513220950.1fc41571.andrew.hendry@gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cumulative on previous patch 1/2.
The MCA setup performed in setup.[Sc] is only needed when CONFIG_MCA=y.
This wraps the setup with CONFIG_MCA and removes EXPORT_SYMBOL(machine_id) as no modules use it.
Moved MCA setup variables from processor.h to mca.h as nothing else uses them.

Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com >

diff -uprN -X dontdiff linux-2.6.21-vanilla/arch/i386/boot/setup.S linux-2.6.21/arch/i386/boot/setup.S
--- linux-2.6.21-vanilla/arch/i386/boot/setup.S	2007-05-06 13:05:15.000000000 +1000
+++ linux-2.6.21/arch/i386/boot/setup.S	2007-05-06 17:39:22.000000000 +1000
@@ -453,6 +453,7 @@ no_disk1:
 	rep
 	stosb
 is_disk1:
+#ifdef CONFIG_MCA
 # check for Micro Channel (MCA) bus
 	movw	%cs, %ax			# aka SETUPSEG
 	subw	$DELTA_INITSEG, %ax		# aka INITSEG
@@ -483,6 +484,7 @@ sysdesc_ok:
 	movsb
 	popw	%ds
 no_mca:
+#endif
 #ifdef CONFIG_X86_VOYAGER
 	movb	$0xff, 0x40	# flag on config found
 	movb	$0xc0, %al
diff -uprN -X dontdiff linux-2.6.21-vanilla/arch/i386/kernel/setup.c linux-2.6.21/arch/i386/kernel/setup.c
--- linux-2.6.21-vanilla/arch/i386/kernel/setup.c	2007-05-06 13:05:18.000000000 +1000
+++ linux-2.6.21/arch/i386/kernel/setup.c	2007-05-06 17:42:29.000000000 +1000
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
@@ -489,8 +487,6 @@ static void set_mca_bus(int x)
 {
 	MCA_bus = x;
 }
-#else
-static void set_mca_bus(int x) { }
 #endif
 
 /* Overridden in paravirt.c if CONFIG_PARAVIRT */
@@ -533,12 +529,15 @@ void __init setup_arch(char **cmdline_p)
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
diff -uprN -X dontdiff linux-2.6.21-vanilla/include/asm-i386/processor.h linux-2.6.21/include/asm-i386/processor.h
--- linux-2.6.21-vanilla/include/asm-i386/processor.h	2007-05-06 13:09:29.000000000 +1000
+++ linux-2.6.21/include/asm-i386/processor.h	2007-05-07 21:01:10.000000000 +1000
@@ -259,12 +259,6 @@ static inline void __mwait(unsigned long
 
 extern void mwait_idle_with_hints(unsigned long eax, unsigned long ecx);
 
-/* from system description table in BIOS.  Mostly for MCA use, but
-others may find it useful. */
-extern unsigned int machine_id;
-extern unsigned int machine_submodel_id;
-extern unsigned int BIOS_revision;
-
 /* Boot loader type from the setup header */
 extern int bootloader_type;
 
diff -uprN -X dontdiff linux-2.6.21-vanilla/include/linux/mca.h linux-2.6.21/include/linux/mca.h
--- linux-2.6.21-vanilla/include/linux/mca.h	2007-05-06 13:09:31.000000000 +1000
+++ linux-2.6.21/include/linux/mca.h	2007-05-07 21:01:01.000000000 +1000
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
