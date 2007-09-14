Return-Path: <linux-kernel-owner+w=401wt.eu-S1761639AbXINFS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761639AbXINFS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 01:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXINFSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 01:18:18 -0400
Received: from ozlabs.org ([203.10.76.45]:48516 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbXINFSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 01:18:17 -0400
Subject: [PATCH 1/3] Normalize config options for guest support
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: virtualization <virtualization@lists.linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
       Anthony Liguori <aliguori@us.ibm.com>
Content-Type: text/plain
Date: Fri, 14 Sep 2007 15:17:34 +1000
Message-Id: <1189747054.7262.34.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Group all the "guest OS" support options together, under
CONFIG_PARAVIRT.  Make this a proper menu item so it looks neater on
menuconfig etc, and make the wording for each prompt uniform.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 3d3ac181380b arch/i386/Kconfig
--- a/arch/i386/Kconfig	Fri Sep 14 12:24:15 2007 +1000
+++ b/arch/i386/Kconfig	Fri Sep 14 12:45:09 2007 +1000
@@ -214,28 +214,38 @@ config X86_ES7000
 
 endchoice
 
-config PARAVIRT
-	bool "Paravirtualization support (EXPERIMENTAL)"
+menuconfig PARAVIRT
+	bool "Paravirtualized guest support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
 	depends on !(X86_VISWS || X86_VOYAGER)
 	help
 	  Paravirtualization is a way of running multiple instances of
 	  Linux on the same machine, under a hypervisor.  This option
 	  changes the kernel so it can modify itself when it is run
 	  under a hypervisor, improving performance significantly.
 	  However, when run without a hypervisor the kernel is
 	  theoretically slower.  If in doubt, say N.
+
+if PARAVIRT
 
 source "arch/i386/xen/Kconfig"
 
 config VMI
-	bool "VMI Paravirt-ops support"
-	depends on PARAVIRT
+	bool "VMI Guest support"
 	help
 	  VMI provides a paravirtualized interface to the VMware ESX server
 	  (it could be used by other hypervisors in theory too, but is not
 	  at the moment), by linking the kernel to a GPL-ed ROM module
 	  provided by the hypervisor.
+
+config LGUEST_GUEST
+	bool "Lguest guest support"
+	depends on !X86_PAE
+	help
+	  Lguest is a tiny in-kernel hypervisor.  Selecting this will
+	  allow your kernel to boot under lguest.  This option will increase
+	  your kernel size by about 6k.  If in doubt, say N.
+endif
 
 config ACPI_SRAT
 	bool
diff -r 3d3ac181380b arch/i386/xen/Kconfig
--- a/arch/i386/xen/Kconfig	Fri Sep 14 12:24:15 2007 +1000
+++ b/arch/i386/xen/Kconfig	Fri Sep 14 12:37:38 2007 +1000
@@ -3,8 +3,8 @@
 #
 
 config XEN
-	bool "Enable support for Xen hypervisor"
-	depends on PARAVIRT && X86_CMPXCHG && X86_TSC && !NEED_MULTIPLE_NODES
+	bool "Xen guest support"
+	depends on X86_CMPXCHG && X86_TSC && !NEED_MULTIPLE_NODES
 	help
 	  This is the Linux Xen port.  Enabling this will allow the
 	  kernel to boot in a paravirtualized environment under the
diff -r 3d3ac181380b drivers/lguest/Kconfig
--- a/drivers/lguest/Kconfig	Fri Sep 14 12:24:15 2007 +1000
+++ b/drivers/lguest/Kconfig	Fri Sep 14 12:31:44 2007 +1000
@@ -1,23 +1,18 @@ config LGUEST
 config LGUEST
 	tristate "Linux hypervisor example code"
-	depends on X86 && PARAVIRT && EXPERIMENTAL && !X86_PAE && FUTEX
-	select LGUEST_GUEST
+	depends on X86 && EXPERIMENTAL && !X86_PAE && FUTEX
 	select HVC_DRIVER
 	---help---
-	  This is a very simple module which allows you to run
-	  multiple instances of the same Linux kernel, using the
+	  This is a very simple module called lg.ko which allows you to run
+	  multiple instances of the Linux kernel, using the
 	  "lguest" command found in the Documentation/lguest directory.
 	  Note that "lguest" is pronounced to rhyme with "fell quest",
 	  not "rustyvisor".  See Documentation/lguest/lguest.txt.
 
+	  Usually you would also turn on "Lguest guest support", to create a
+	  kernel which can also boot under lguest.
+
 	  If unsure, say N.  If curious, say M.  If masochistic, say Y.
-
-config LGUEST_GUEST
-	bool
-	help
-	  The guest needs code built-in, even if the host has lguest
-	  support as a module.  The drivers are tiny, so we build them
-	  in too.
 
 config LGUEST_NET
 	tristate


