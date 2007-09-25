Return-Path: <linux-kernel-owner+w=401wt.eu-S1759825AbXIYD67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759825AbXIYD67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 23:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbXIYD6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 23:58:47 -0400
Received: from ozlabs.org ([203.10.76.45]:43538 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506AbXIYD6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 23:58:46 -0400
Subject: [PATCH 1/3] Virtualization config cleanup: Select CONFIG_PARAVIRT
	when required
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: virtualization <virtualization@lists.linux-foundation.org>,
       Andi Kleen <ak@muc.de>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 13:58:08 +1000
Message-Id: <1190692688.27805.276.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Unless there are complaints, I'll push this as part of the lguest
patches for 2.6.24, since there are lguest config changes there too).

Andi points out that PARAVIRT is an option best selected when needed.

We introduce PARAVIRT_GUEST for the menu itself, and select PARAVIRT
if the user turns on anything which needs it.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/i386/Kconfig     |   33 ++++++++++++++++++++-------------
 arch/i386/xen/Kconfig |    1 +
 2 files changed, 21 insertions(+), 13 deletions(-)

===================================================================
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -214,24 +214,30 @@ config X86_ES7000
 
 endchoice
 
-menuconfig PARAVIRT
+config PARAVIRT
+	bool
+	depends on !(X86_VISWS || X86_VOYAGER)
+	help
+	  This changes the kernel so it can modify itself when it is run
+	  under a hypervisor, potentially improving performance significantly
+	  over full virtualization.  However, when run without a hypervisor
+	  the kernel is theoretically slower and slightly larger.
+
+menuconfig PARAVIRT_GUEST
-	bool "Paravirtualized guest support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Paravirtualized guest support"
-	depends on !(X86_VISWS || X86_VOYAGER)
-	help
-	  Paravirtualization is a way of running multiple instances of
-	  Linux on the same machine, under a hypervisor.  This option
-	  changes the kernel so it can modify itself when it is run
-	  under a hypervisor, improving performance significantly.
-	  However, when run without a hypervisor the kernel is
-	  theoretically slower.  If in doubt, say N.
-
-if PARAVIRT
+	help
+	  Say Y here to get to see options related to running Linux under
+	  various hypervisors.  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
+
+if PARAVIRT_GUEST
 
 source "arch/i386/xen/Kconfig"
 
 config VMI
 	bool "VMI Guest support"
+	select PARAVIRT
 	help
 	  VMI provides a paravirtualized interface to the VMware ESX server
 	  (it could be used by other hypervisors in theory too, but is not
@@ -239,6 +246,7 @@ config VMI
 
 config LGUEST_GUEST
 	bool "Lguest guest support"
+	select PARAVIRT
 	depends on !X86_PAE
 	help
 	  Lguest is a tiny in-kernel hypervisor.  Selecting this will
===================================================================
--- a/arch/i386/xen/Kconfig
+++ b/arch/i386/xen/Kconfig
@@ -4,6 +4,7 @@
 
 config XEN
 	bool "Xen guest support"
+	select PARAVIRT
 	depends on X86_CMPXCHG && X86_TSC && !NEED_MULTIPLE_NODES
 	help
 	  This is the Linux Xen port.  Enabling this will allow the


