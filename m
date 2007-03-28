Return-Path: <linux-kernel-owner+w=401wt.eu-S965746AbXC1ULt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965746AbXC1ULt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 16:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965747AbXC1ULt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 16:11:49 -0400
Received: from gw.goop.org ([64.81.55.164]:43339 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965746AbXC1ULs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 16:11:48 -0400
Message-ID: <460ACC05.4020401@goop.org>
Date: Wed, 28 Mar 2007 13:11:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Stephane Eranian <eranian@hpl.hp.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Jan Beulich <jbeulich@novell.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Clean up mach_reboot_fixups
References: <46099709.2000304@goop.org> <200703282143.53037.ak@suse.de>	<460AC665.2090705@goop.org> <200703282154.04245.ak@suse.de>
In-Reply-To: <200703282154.04245.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Two cleanups:
 - reboot_fixups.h is entirely i386-dependent, so put it in asm-i386
 - use a weak version rather than ifdeffery

[ Andi - the machine_ops probably depends on this, but only in a minor
  context-clash way. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Jaya Kumar <jayalk@intworks.biz>

---
 arch/i386/kernel/reboot.c        |    6 +++++-
 arch/i386/kernel/reboot_fixups.c |    2 +-
 include/asm-i386/reboot_fixups.h |    6 ++++++
 include/linux/reboot_fixups.h    |   10 ----------
 4 files changed, 12 insertions(+), 12 deletions(-)

===================================================================
--- a/arch/i386/kernel/reboot.c
+++ b/arch/i386/kernel/reboot.c
@@ -17,7 +17,7 @@
 #include <asm/apic.h>
 #include <asm/desc.h>
 #include "mach_reboot.h"
-#include <linux/reboot_fixups.h>
+#include <asm/reboot_fixups.h>
 
 /*
  * Power off function, if any
@@ -314,6 +314,10 @@ void machine_shutdown(void)
 #ifdef CONFIG_X86_IO_APIC
 	disable_IO_APIC();
 #endif
+}
+
+void __attribute__((weak)) mach_reboot_fixups(void)
+{
 }
 
 void machine_emergency_restart(void)
===================================================================
--- a/arch/i386/kernel/reboot_fixups.c
+++ b/arch/i386/kernel/reboot_fixups.c
@@ -10,7 +10,7 @@
 
 #include <asm/delay.h>
 #include <linux/pci.h>
-#include <linux/reboot_fixups.h>
+#include <asm/reboot_fixups.h>
 
 static void cs5530a_warm_reset(struct pci_dev *dev)
 {
===================================================================
--- /dev/null
+++ b/include/asm-i386/reboot_fixups.h
@@ -0,0 +1,6 @@
+#ifndef _LINUX_REBOOT_FIXUPS_H
+#define _LINUX_REBOOT_FIXUPS_H
+
+extern void mach_reboot_fixups(void);
+
+#endif /* _LINUX_REBOOT_FIXUPS_H */
===================================================================
--- a/include/linux/reboot_fixups.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef _LINUX_REBOOT_FIXUPS_H
-#define _LINUX_REBOOT_FIXUPS_H
-
-#ifdef CONFIG_X86_REBOOTFIXUPS
-extern void mach_reboot_fixups(void);
-#else
-#define mach_reboot_fixups() ((void)(0))
-#endif
-
-#endif /* _LINUX_REBOOT_FIXUPS_H */

