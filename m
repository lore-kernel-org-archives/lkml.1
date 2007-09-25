Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbXIYEqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbXIYEqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 00:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760294AbXIYEqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 00:46:06 -0400
Received: from ozlabs.org ([203.10.76.45]:54728 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759629AbXIYEqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 00:46:04 -0400
Subject: Re: [PATCH 1/3] Virtualization config cleanup: Select
	CONFIG_PARAVIRT when required
From: Rusty Russell <rusty@rustcorp.com.au>
To: Adrian Bunk <bunk@kernel.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Andi Kleen <ak@muc.de>, Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <20070925042623.GM6800@stusta.de>
References: <1190692688.27805.276.camel@localhost.localdomain>
	 <20070925040537.GL6800@stusta.de>
	 <1190694003.27805.291.camel@localhost.localdomain>
	 <20070925042623.GM6800@stusta.de>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 14:45:44 +1000
Message-Id: <1190695544.27805.310.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-25 at 06:26 +0200, Adrian Bunk wrote:
> On Tue, Sep 25, 2007 at 02:20:03PM +1000, Rusty Russell wrote:
> > On Tue, 2007-09-25 at 06:05 +0200, Adrian Bunk wrote:
> > > depends on !(X86_VISWS || X86_VOYAGER)
> > 
> > Hmm, if A selects B and B depends on C, does A not depend on C?
> 
> No.

OK, here 'tis:
===
Normalize config options for guest support

1) Group all the "guest OS" support options together, under a PARAVIRT_GUEST
   menu.
2) Make those options select CONFIG_PARAVIRT, as suggested by Andi.
3) Make kconfig help titles consistent.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/i386/Kconfig     |   33 ++++++++++++++++++++-------------
 arch/i386/xen/Kconfig |    1 +
 2 files changed, 21 insertions(+), 13 deletions(-)

diff -r de6df17c6477 arch/i386/Kconfig
--- a/arch/i386/Kconfig	Tue Sep 25 14:41:39 2007 +1000
+++ b/arch/i386/Kconfig	Tue Sep 25 14:41:39 2007 +1000
@@ -215,27 +215,45 @@ endchoice
 endchoice
 
 config PARAVIRT
-	bool "Paravirtualization support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool
 	depends on !(X86_VISWS || X86_VOYAGER)
 	help
-	  Paravirtualization is a way of running multiple instances of
-	  Linux on the same machine, under a hypervisor.  This option
-	  changes the kernel so it can modify itself when it is run
-	  under a hypervisor, improving performance significantly.
-	  However, when run without a hypervisor the kernel is
-	  theoretically slower.  If in doubt, say N.
+	  This changes the kernel so it can modify itself when it is run
+	  under a hypervisor, potentially improving performance significantly
+	  over full virtualization.  However, when run without a hypervisor
+	  the kernel is theoretically slower and slightly larger.
+
+menuconfig PARAVIRT_GUEST
+	bool "Paravirtualized guest support"
+	help
+	  Say Y here to get to see options related to running Linux under
+	  various hypervisors.  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
+
+if PARAVIRT_GUEST
 
 source "arch/i386/xen/Kconfig"
 
 config VMI
-	bool "VMI Paravirt-ops support"
-	depends on PARAVIRT
+	bool "VMI Guest support"
+	select PARAVIRT
+	depends on !(X86_VISWS || X86_VOYAGER)
 	help
 	  VMI provides a paravirtualized interface to the VMware ESX server
 	  (it could be used by other hypervisors in theory too, but is not
 	  at the moment), by linking the kernel to a GPL-ed ROM module
 	  provided by the hypervisor.
+
+config LGUEST_GUEST
+	bool "Lguest guest support"
+	select PARAVIRT
+	depends on !X86_PAE
+	help
+	  Lguest is a tiny in-kernel hypervisor.  Selecting this will
+	  allow your kernel to boot under lguest.  This option will increase
+	  your kernel size by about 6k.  If in doubt, say N.
+endif
 
 config ACPI_SRAT
 	bool
diff -r de6df17c6477 arch/i386/xen/Kconfig
--- a/arch/i386/xen/Kconfig	Tue Sep 25 14:41:39 2007 +1000
+++ b/arch/i386/xen/Kconfig	Tue Sep 25 14:42:41 2007 +1000
@@ -3,8 +3,9 @@
 #
 
 config XEN
-	bool "Enable support for Xen hypervisor"
-	depends on PARAVIRT && X86_CMPXCHG && X86_TSC && !NEED_MULTIPLE_NODES
+	bool "Xen guest support"
+	select PARAVIRT
+	depends on X86_CMPXCHG && X86_TSC && !NEED_MULTIPLE_NODES && !(X86_VISWS || X86_VOYAGER)
 	help
 	  This is the Linux Xen port.  Enabling this will allow the
 	  kernel to boot in a paravirtualized environment under the
diff -r de6df17c6477 drivers/lguest/Kconfig
--- a/drivers/lguest/Kconfig	Tue Sep 25 14:41:39 2007 +1000
+++ b/drivers/lguest/Kconfig	Tue Sep 25 14:41:39 2007 +1000
@@ -1,7 +1,6 @@ config LGUEST
 config LGUEST
 	tristate "Linux hypervisor example code"
-	depends on X86 && PARAVIRT && EXPERIMENTAL && !X86_PAE && FUTEX
-	select LGUEST_GUEST
+	depends on X86 && EXPERIMENTAL && !X86_PAE && FUTEX && !(X86_VISWS || X86_VOYAGER)
 	select HVC_DRIVER
 	---help---
 	  This is a very simple module which allows you to run


