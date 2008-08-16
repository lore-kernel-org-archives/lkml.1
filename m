Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbYHPDsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbYHPDsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 23:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYHPDrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 23:47:51 -0400
Received: from ozlabs.org ([203.10.76.45]:54505 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbYHPDru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 23:47:50 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@linux.intel.com>
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
Date: Sat, 16 Aug 2008 13:47:40 +1000
User-Agent: KMail/1.9.9
Cc: Kay Sievers <kay.sievers@vrfy.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
References: <20080814172945.250a27f2.sfr@canb.auug.org.au> <1218854219.3629.30.camel@lgn.site> <48A64235.2030108@linux.intel.com>
In-Reply-To: <48A64235.2030108@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808161347.41253.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 August 2008 12:57:57 Andi Kleen wrote:
> >> Extract is:
> >>
> >> XXX adding modparam:'acpi.power_nocheck' 34 (ffffffff806a4cf0)
> >
> > ...
> >
> >> XXX adding modparam:'acpi.acpica_version' 45 (ffffffff806a4ea8)
> >
> > Two different "modules" use the same prefix, which does not work with
> > the current logic, they need to live next to each other in the sequence
> > of options.
>
> Sequence of options being defined by link order?

Simplest fix is to shuffle Makefile.  But better is to create an acpi "module"
so the namespacing just works, something like below.  Overriding MODULE_PREFIX
only works for builtin code anyway.  (Which makes sense: moving a parameter
from one module to another isn't a change we can cover up).

(Sam: foo-objs-y would make this neater)

diff -r 5f7194400572 drivers/acpi/Makefile
--- a/drivers/acpi/Makefile	Sat Aug 16 13:23:26 2008 +1000
+++ b/drivers/acpi/Makefile	Sat Aug 16 13:44:17 2008 +1000
@@ -21,10 +21,18 @@ obj-$(CONFIG_X86)		+= blacklist.o
 #
 # ACPI Core Subsystem (Interpreter)
 #
-obj-y				+= osl.o utils.o reboot.o\
+obj-y				+= osl.o utils.o reboot.o acpi.o \
 				   dispatcher/ events/ executer/ hardware/ \
 				   namespace/ parser/ resources/ tables/ \
 				   utilities/
+
+# "acpi." module_param namespace.
+ifdef CONFIG_ACPI_POWER
+acpi-objs	+= power.o
+endif
+ifdef CONFIG_ACPI_SYSTEM
+acpi-objs	+= system.o event.o
+endif
 
 #
 # ACPI Bus and Device Drivers
@@ -49,11 +57,9 @@ obj-$(CONFIG_ACPI_VIDEO)	+= video.o
 obj-$(CONFIG_ACPI_VIDEO)	+= video.o
 obj-y				+= pci_root.o pci_link.o pci_irq.o pci_bind.o
 obj-$(CONFIG_ACPI_PCI_SLOT)	+= pci_slot.o
-obj-$(CONFIG_ACPI_POWER)	+= power.o
 obj-$(CONFIG_ACPI_PROCESSOR)	+= processor.o
 obj-$(CONFIG_ACPI_CONTAINER)	+= container.o
 obj-$(CONFIG_ACPI_THERMAL)	+= thermal.o
-obj-$(CONFIG_ACPI_SYSTEM)	+= system.o event.o
 obj-$(CONFIG_ACPI_DEBUG)	+= debug.o
 obj-$(CONFIG_ACPI_NUMA)		+= numa.o
 obj-$(CONFIG_ACPI_WMI)		+= wmi.o
diff -r 5f7194400572 drivers/acpi/system.c
--- a/drivers/acpi/system.c	Sat Aug 16 13:23:26 2008 +1000
+++ b/drivers/acpi/system.c	Sat Aug 16 13:44:17 2008 +1000
@@ -33,10 +33,6 @@
 
 #define _COMPONENT		ACPI_SYSTEM_COMPONENT
 ACPI_MODULE_NAME("system");
-#ifdef MODULE_PARAM_PREFIX
-#undef MODULE_PARAM_PREFIX
-#endif
-#define MODULE_PARAM_PREFIX "acpi."
 
 #define ACPI_SYSTEM_CLASS		"system"
 #define ACPI_SYSTEM_DEVICE_NAME		"System"
