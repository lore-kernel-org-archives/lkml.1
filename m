Return-Path: <linux-kernel-owner+w=401wt.eu-S1161622AbXD2Xss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161622AbXD2Xss (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161590AbXD2XrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:47:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38460 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161584AbXD2XqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:46:22 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430146.588463000@suse.de>
In-Reply-To: <20070430146.588463000@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [2/26] i386: Add machine_ops interface  to abstract halting and rebooting
Message-Id: <20070429234610.CF5C8151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 01:46:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
machine_ops is an interface for the machine_* functions defined in
<linux/reboot.h>.  This is intended to allow hypervisors to intercept
the reboot process, but it could be used to implement other x86
subarchtecture reboots.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/apm.c    |    3 +--
 arch/i386/kernel/reboot.c |   43 ++++++++++++++++++++++++++++++++++++++-----
 include/asm-i386/reboot.h |   20 ++++++++++++++++++++
 3 files changed, 59 insertions(+), 7 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/apm.c
===================================================================
--- linux.orig/arch/i386/kernel/apm.c
+++ linux/arch/i386/kernel/apm.c
@@ -233,11 +233,10 @@
 #include <asm/desc.h>
 #include <asm/i8253.h>
 #include <asm/paravirt.h>
+#include <asm/reboot.h>
 
 #include "io_ports.h"
 
-extern void machine_real_restart(unsigned char *, int);
-
 #if defined(CONFIG_APM_DISPLAY_BLANK) && defined(CONFIG_VT)
 extern int (*console_blank_hook)(int);
 #endif
Index: linux/arch/i386/kernel/reboot.c
===================================================================
--- linux.orig/arch/i386/kernel/reboot.c
+++ linux/arch/i386/kernel/reboot.c
@@ -18,6 +18,7 @@
 #include <asm/desc.h>
 #include "mach_reboot.h"
 #include <asm/reboot_fixups.h>
+#include <asm/reboot.h>
 
 /*
  * Power off function, if any
@@ -280,7 +281,7 @@ void machine_real_restart(unsigned char 
 EXPORT_SYMBOL(machine_real_restart);
 #endif
 
-void machine_shutdown(void)
+static void native_machine_shutdown(void)
 {
 #ifdef CONFIG_SMP
 	int reboot_cpu_id;
@@ -320,7 +321,7 @@ void __attribute__((weak)) mach_reboot_f
 {
 }
 
-void machine_emergency_restart(void)
+static void native_machine_emergency_restart(void)
 {
 	if (!reboot_thru_bios) {
 		if (efi_enabled) {
@@ -344,17 +345,17 @@ void machine_emergency_restart(void)
 	machine_real_restart(jump_to_bios, sizeof(jump_to_bios));
 }
 
-void machine_restart(char * __unused)
+static void native_machine_restart(char * __unused)
 {
 	machine_shutdown();
 	machine_emergency_restart();
 }
 
-void machine_halt(void)
+static void native_machine_halt(void)
 {
 }
 
-void machine_power_off(void)
+static void native_machine_power_off(void)
 {
 	if (pm_power_off) {
 		machine_shutdown();
@@ -363,3 +364,35 @@ void machine_power_off(void)
 }
 
 
+struct machine_ops machine_ops = {
+	.power_off = native_machine_power_off,
+	.shutdown = native_machine_shutdown,
+	.emergency_restart = native_machine_emergency_restart,
+	.restart = native_machine_restart,
+	.halt = native_machine_halt,
+};
+
+void machine_power_off(void)
+{
+	machine_ops.power_off();
+}
+
+void machine_shutdown(void)
+{
+	machine_ops.shutdown();
+}
+
+void machine_emergency_restart(void)
+{
+	machine_ops.emergency_restart();
+}
+
+void machine_restart(char *cmd)
+{
+	machine_ops.restart(cmd);
+}
+
+void machine_halt(void)
+{
+	machine_ops.halt();
+}
Index: linux/include/asm-i386/reboot.h
===================================================================
--- /dev/null
+++ linux/include/asm-i386/reboot.h
@@ -0,0 +1,20 @@
+#ifndef _ASM_REBOOT_H
+#define _ASM_REBOOT_H
+
+struct pt_regs;
+
+struct machine_ops
+{
+	void (*restart)(char *cmd);
+	void (*halt)(void);
+	void (*power_off)(void);
+	void (*shutdown)(void);
+	void (*crash_shutdown)(struct pt_regs *);
+	void (*emergency_restart)(void);
+};
+
+extern struct machine_ops machine_ops;
+
+void machine_real_restart(unsigned char *code, int length);
+
+#endif	/* _ASM_REBOOT_H */
