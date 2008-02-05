Return-Path: <linux-kernel-owner+w=401wt.eu-S932352AbYBEUod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbYBEUod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932092AbYBEUna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:43:30 -0500
Received: from wx-out-0506.google.com ([66.249.82.229]:21269 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbYBEUn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:43:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Sibcyfuxhk7r1CCwoDEHINahQGwNxnYN6Ua8fVkKp+H96WTjfN9ArKzSESedI6pbPwK5xuU2hkUaHK22Zx8D4waMum7bcmbpleqQ97Sqp/cajdbwduh0St9bV8c7P76uAcJRd/Cq0ZX0kpwsrXoMfBeMV2zQBoi+QQHPYK4pXNA=
Subject: [PATCH 8/8] x86: fix sparse warnings in acpi/bus.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 12:42:51 -0800
Message-Id: <1202244172.18081.43.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add function definition and extern variables to asm-x86/acpi.h.

All of these are used in bus.c in ifdef(CONFIG_X86) sections, so are
only added to the x86 include headers.  boot.c already includes acpi.h
so no changes are needed there.

Fixes the following:
arch/x86/kernel/acpi/boot.c:83:4: warning: symbol 'acpi_sci_flags' was not declared. Should it be static?
arch/x86/kernel/acpi/boot.c:84:5: warning: symbol 'acpi_sci_override_gsi' was not declared. Should it be static?
arch/x86/kernel/acpi/boot.c:421:13: warning: symbol 'acpi_pic_sci_set_trigger' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/acpi/bus.c     |    7 +------
 include/asm-x86/acpi.h |    4 ++++
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 1b4cf98..9bbde6d 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -31,6 +31,7 @@
 #include <linux/pm.h>
 #include <linux/device.h>
 #include <linux/proc_fs.h>
+#include <linux/acpi.h>
 #ifdef CONFIG_X86
 #include <asm/mpspec.h>
 #endif
@@ -39,9 +40,6 @@
 
 #define _COMPONENT		ACPI_BUS_COMPONENT
 ACPI_MODULE_NAME("bus");
-#ifdef	CONFIG_X86
-extern void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger);
-#endif
 
 struct acpi_device *acpi_root;
 struct proc_dir_entry *acpi_root_dir;
@@ -629,8 +627,6 @@ void __init acpi_early_init(void)
 
 #ifdef CONFIG_X86
 	if (!acpi_ioapic) {
-		extern u8 acpi_sci_flags;
-
 		/* compatible (0) means level (3) */
 		if (!(acpi_sci_flags & ACPI_MADT_TRIGGER_MASK)) {
 			acpi_sci_flags &= ~ACPI_MADT_TRIGGER_MASK;
@@ -640,7 +636,6 @@ void __init acpi_early_init(void)
 		acpi_pic_sci_set_trigger(acpi_gbl_FADT.sci_interrupt,
 					 (acpi_sci_flags & ACPI_MADT_TRIGGER_MASK) >> 2);
 	} else {
-		extern int acpi_sci_override_gsi;
 		/*
 		 * now that acpi_gbl_FADT is initialized,
 		 * update it with result from INT_SRC_OVR parsing
diff --git a/include/asm-x86/acpi.h b/include/asm-x86/acpi.h
index 98a9ca2..7a72d6a 100644
--- a/include/asm-x86/acpi.h
+++ b/include/asm-x86/acpi.h
@@ -89,6 +89,10 @@ extern int acpi_pci_disabled;
 extern int acpi_skip_timer_override;
 extern int acpi_use_timer_override;
 
+extern u8 acpi_sci_flags;
+extern int acpi_sci_override_gsi;
+void acpi_pic_sci_set_trigger(unsigned int, u16);
+
 static inline void disable_acpi(void)
 {
 	acpi_disabled = 1;
-- 
1.5.4.rc5.1138.g2602

