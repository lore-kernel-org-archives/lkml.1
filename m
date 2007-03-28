Return-Path: <linux-kernel-owner+w=401wt.eu-S933224AbXC1TcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224AbXC1TcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 15:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933264AbXC1TcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 15:32:20 -0400
Received: from gw.goop.org ([64.81.55.164]:44785 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933224AbXC1TcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 15:32:19 -0400
Message-ID: <460AC2C6.9040406@goop.org>
Date: Wed, 28 Mar 2007 12:32:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Stephane Eranian <eranian@hpl.hp.com>, Ingo Molnar <mingo@elte.hu>,
       "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: [PATCH] Add machine_ops interface  to abstract halting and rebooting
References: <46099709.2000304@goop.org> <200703282103.50191.ak@suse.de> <460ABF84.5060201@goop.org> <200703282122.22869.ak@suse.de>
In-Reply-To: <200703282122.22869.ak@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

machine_ops is an interface for the machine_* functions defined in
<linux/reboot.h>.  This is intended to allow hypervisors to intercept
the reboot process, but it could be used to implement other x86
subarchtecture reboots.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/kernel/apm.c    |    3 --
 arch/i386/kernel/reboot.c |   49 +++++++++++++++++++++++++++++++++++++--------
 include/asm-i386/reboot.h |   20 ++++++++++++++++++
 3 files changed, 62 insertions(+), 10 deletions(-)

===================================================================
--- a/arch/i386/kernel/apm.c
+++ b/arch/i386/kernel/apm.c
@@ -233,10 +233,9 @@
 #include <asm/desc.h>
 #include <asm/i8253.h>
 #include <asm/paravirt.h>
+#include <asm/reboot.h>
 
 #include "io_ports.h"
-
-extern void machine_real_restart(unsigned char *, int);
 
 #if defined(CONFIG_APM_DISPLAY_BLANK) && defined(CONFIG_VT)
 extern int (*console_blank_hook)(int);
===================================================================
--- a/arch/i386/kernel/reboot.c
+++ b/arch/i386/kernel/reboot.c
@@ -18,6 +18,7 @@
 #include <asm/desc.h>
 #include "mach_reboot.h"
 #include <asm/reboot_fixups.h>
+#include <asm/reboot.h>
 
 /*
  * Power off function, if any
@@ -280,7 +281,7 @@ EXPORT_SYMBOL(machine_real_restart);
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
-{
-}
-
-void machine_power_off(void)
+static void native_machine_halt(void)
+{
+}
+
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
===================================================================
--- /dev/null
+++ b/include/asm-i386/reboot.h
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

