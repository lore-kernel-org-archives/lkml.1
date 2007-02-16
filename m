Return-Path: <linux-kernel-owner+w=401wt.eu-S1423153AbXBPEkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423153AbXBPEkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 23:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423161AbXBPEkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 23:40:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:43346 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423153AbXBPEkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 23:40:12 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: David Brownell <david-b@pacbell.net>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: loosen dependancy on rtc cmos
Date: Thu, 15 Feb 2007 23:38:46 -0500
User-Agent: KMail/1.9.5
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070214180915.GA6412@redhat.com> <200702141820.33928.lenb@kernel.org> <200702141547.36106.david-b@pacbell.net>
In-Reply-To: <200702141547.36106.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702152338.47151.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 February 2007 18:47, David Brownell wrote:
> On Wednesday 14 February 2007 3:20 pm, Len Brown wrote:
> > > 
> > > I still need to resubmit the patch, for X86_PC, which defines the platform
> > > device in the (common) case where PNPACPI isn't defined.
> > 
> > CONFIG_PNPACPI=y is not the common case?
> 
> It's certainly not in the defconfig for x86-64.  And it's only been
> three weeks since the CONFIG_EXPERIMENTAL dependency got removed.
> 
> So, no I would not think it's the common case.

Turns out that it is common.
It is in i386 defconfig, ships on i386 Fedora Core 6,  ships on i386 OpenSuse 10.2.

For x86_64 it isn't in defconfig or OpenSuse 10.2, but is in Fedora Core 6.

So I've taken Andi's advice and checked in the patches below.
(I didn't bother updating defconfig, it will generate according to this rule
and I don't want to conflict with any re-generation andi might be checking in)

thanks,
-Len

commit 243b66e76ab722cdec1921d7f80c0cb808131c37
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 15 22:34:36 2007 -0500

    ACPI: always enable CONFIG_PNPACPI on CONFIG_ACPI kernels
    
    We removed the ACPI motherboard driver which handled
    the ACPI=y, PNP=n case, so now we need to enforce that
    PNP & PNPACPI are always enabled for ACPI kernels.
    
    Most major distros ship this way this already.
    
    Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 20eacc2..2d21fed 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -13,6 +13,7 @@ config ACPI
 	depends on IA64 || X86
 	depends on PCI
 	depends on PM
+	select PNP
 	default y
 	---help---
 	  Advanced Configuration and Power Interface (ACPI) support for 
diff --git a/drivers/pnp/pnpacpi/Kconfig b/drivers/pnp/pnpacpi/Kconfig
index ad27e5e..b04767c 100644
--- a/drivers/pnp/pnpacpi/Kconfig
+++ b/drivers/pnp/pnpacpi/Kconfig
@@ -2,17 +2,5 @@
 # Plug and Play ACPI configuration
 #
 config PNPACPI
-	bool "Plug and Play ACPI support"
-	depends on PNP && ACPI
-	default y
-	---help---
-	  Linux uses the PNPACPI to autodetect built-in
-	  mainboard resources (e.g. parallel port resources).
-
-          Some features (e.g. real hotplug) are not currently
-          implemented.
-
-          If you would like the kernel to detect and allocate resources to
-          your mainboard devices (on some systems they are disabled by the
-          BIOS) say Y here.  Also the PNPACPI can help prevent resource
-          conflicts between mainboard devices and other bus devices.
+	bool
+	default (PNP && ACPI)


commit 8d4956c201c2f7683289f70095443c59a39f94ef
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 15 22:46:42 2007 -0500

    ACPI: remove non-PNPACPI version of get_rtc_dev()
    
    It isn't needed in ACPI code anymore because
    now ACPI always includes PNPACPI.
    
    Cc: David Brownell <david-b@pacbell.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 9950087..4334c20 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -255,8 +255,6 @@ arch_initcall(init_acpi_device_notify);
 static struct cmos_rtc_board_info rtc_info;
 
 
-#ifdef CONFIG_PNPACPI
-
 /* PNP devices are registered in a subsys_initcall();
  * ACPI specifies the PNP IDs to use.
  */
@@ -280,31 +278,6 @@ static struct device *__init get_rtc_dev(void)
 	return bus_find_device(&pnp_bus_type, NULL, NULL, pnp_match);
 }
 
-#else
-
-/* We expect non-PNPACPI platforms to register an RTC device, usually
- * at or near arch_initcall().  That also helps for example PCs that
- * aren't configured with ACPI (where this code wouldn't run, but the
- * RTC would still be available).  The device name matches the driver;
- * that's how the platform bus works.
- */
-#include <linux/platform_device.h>
-
-static int __init platform_match(struct device *dev, void *data)
-{
-	struct platform_device	*pdev;
-
-	pdev = container_of(dev, struct platform_device, dev);
-	return strcmp(pdev->name, "rtc_cmos") == 0;
-}
-
-static struct device *__init get_rtc_dev(void)
-{
-	return bus_find_device(&platform_bus_type, NULL, NULL, platform_match);
-}
-
-#endif
-
 static int __init acpi_rtc_init(void)
 {
 	struct device *dev = get_rtc_dev();
