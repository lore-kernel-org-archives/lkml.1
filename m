Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbXGTEWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbXGTEWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 00:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbXGTEWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 00:22:30 -0400
Received: from ozlabs.org ([203.10.76.45]:50470 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbXGTEW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 00:22:29 -0400
Subject: [PATCH] Move KVM, paravirt, lguest, VMI and Xen under arch-level
	Virtualization option
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <ak@muc.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Zachary Amsden <zach@vmware.com>, Avi Kivity <avi@qumranet.com>,
       virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 20 Jul 2007 14:22:22 +1000
Message-Id: <1184905342.10380.263.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Any objections?

Rusty.
===
Having KVM appear in the middle of "drivers" is kinda strange, and
having it alone under a menu called "virtualization" doubly so.

1) Move the "Virtualization" menu into the arch-specific i386 and
   x86-64 Kconfig.
2) Add a help message to the menu.
3) Move CONFIG_PARAVIRT under CONFIG_VIRTUALIZATION
4) Move lguest into same menu.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r decd4a43335a arch/i386/Kconfig
--- a/arch/i386/Kconfig	Fri Jul 20 13:49:20 2007 +1000
+++ b/arch/i386/Kconfig	Fri Jul 20 14:05:56 2007 +1000
@@ -210,17 +210,55 @@ config X86_ES7000
 
 endchoice
 
+config ACPI_SRAT
+	bool
+	default y
+	depends on ACPI && NUMA && (X86_SUMMIT || X86_GENERICARCH)
+	select ACPI_NUMA
+
+config HAVE_ARCH_PARSE_SRAT
+       bool
+       default y
+       depends on ACPI_SRAT
+
+config X86_SUMMIT_NUMA
+	bool
+	default y
+	depends on NUMA && (X86_SUMMIT || X86_GENERICARCH)
+
+config X86_CYCLONE_TIMER
+	bool
+	default y
+	depends on X86_SUMMIT || X86_GENERICARCH
+
+config ES7000_CLUSTERED_APIC
+	bool
+	default y
+	depends on SMP && X86_ES7000 && MPENTIUMIII
+
+source "arch/i386/Kconfig.cpu"
+
+menuconfig VIRTUALIZATION
+	bool "Virtualization"
+	default y
+	help
+	  Virtualization is a way of running multiple Operating Systems on
+	  the same machine.  There are several different virtualization
+	  technologies in i386 Linux, including KVM, lguest, VMI and Xen.
+	  If in doubt say Y and examine the sub-options.
+
+if VIRTUALIZATION
 config PARAVIRT
-	bool "Paravirtualization support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Paravirtualization support"
 	depends on !(X86_VISWS || X86_VOYAGER)
 	help
-	  Paravirtualization is a way of running multiple instances of
-	  Linux on the same machine, under a hypervisor.  This option
-	  changes the kernel so it can modify itself when it is run
-	  under a hypervisor, improving performance significantly.
+	  Paravirtualization enables Linux to detect when it is running
+	  as a guest operating system under a hypervisor: it will
+	  modify itself, improving performance significantly.
 	  However, when run without a hypervisor the kernel is
 	  theoretically slower.  If in doubt, say N.
+
+source "drivers/kvm/Kconfig"
 
 source "arch/i386/xen/Kconfig"
 
@@ -233,33 +271,9 @@ config VMI
 	  at the moment), by linking the kernel to a GPL-ed ROM module
 	  provided by the hypervisor.
 
-config ACPI_SRAT
-	bool
-	default y
-	depends on ACPI && NUMA && (X86_SUMMIT || X86_GENERICARCH)
-	select ACPI_NUMA
-
-config HAVE_ARCH_PARSE_SRAT
-       bool
-       default y
-       depends on ACPI_SRAT
-
-config X86_SUMMIT_NUMA
-	bool
-	default y
-	depends on NUMA && (X86_SUMMIT || X86_GENERICARCH)
-
-config X86_CYCLONE_TIMER
-	bool
-	default y
-	depends on X86_SUMMIT || X86_GENERICARCH
-
-config ES7000_CLUSTERED_APIC
-	bool
-	default y
-	depends on SMP && X86_ES7000 && MPENTIUMIII
-
-source "arch/i386/Kconfig.cpu"
+source "drivers/lguest/Kconfig"
+
+endif # VIRTUALIZATION
 
 config HPET_TIMER
 	bool "HPET Timer Support"
diff -r decd4a43335a arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig	Fri Jul 20 13:49:20 2007 +1000
+++ b/arch/x86_64/Kconfig	Fri Jul 20 13:59:08 2007 +1000
@@ -760,6 +760,19 @@ config SYSVIPC_COMPAT
 
 endmenu
 
+menuconfig VIRTUALIZATION
+	bool "Virtualization"
+	default y
+	help
+	  Virtualization is a way of running multiple Operating Systems on
+	  the same machine.  There are several different virtualization
+	  technologies in Linux, but currently KVM is the only
+	  option for x86_64.  If in doubt say Y and examine the sub-options.
+
+if VIRTUALIZATION
+source "drivers/kvm/Kconfig"
+endif #VIRTUALIZATION
+
 source "net/Kconfig"
 
 source drivers/Kconfig
diff -r decd4a43335a drivers/Kconfig
--- a/drivers/Kconfig	Fri Jul 20 13:49:20 2007 +1000
+++ b/drivers/Kconfig	Fri Jul 20 14:06:03 2007 +1000
@@ -82,9 +82,5 @@ source "drivers/dma/Kconfig"
 
 source "drivers/auxdisplay/Kconfig"
 
-source "drivers/kvm/Kconfig"
-
 source "drivers/uio/Kconfig"
-
-source "drivers/lguest/Kconfig"
 endmenu
diff -r decd4a43335a drivers/kvm/Kconfig
--- a/drivers/kvm/Kconfig	Fri Jul 20 13:49:20 2007 +1000
+++ b/drivers/kvm/Kconfig	Fri Jul 20 13:55:07 2007 +1000
@@ -1,13 +1,6 @@
 #
 # KVM configuration
 #
-menuconfig VIRTUALIZATION
-	bool "Virtualization"
-	depends on X86
-	default y
-
-if VIRTUALIZATION
-
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on X86 && EXPERIMENTAL
@@ -39,5 +32,3 @@ config KVM_AMD
 	---help---
 	  Provides support for KVM on AMD processors equipped with the AMD-V
 	  (SVM) extensions.
-
-endif # VIRTUALIZATION


