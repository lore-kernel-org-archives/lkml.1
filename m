Return-Path: <linux-kernel-owner+w=401wt.eu-S1759738AbYBWPeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738AbYBWPeg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 10:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYBWPeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 10:34:07 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:57557 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751865AbYBWPeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 10:34:04 -0500
Date: Sat, 23 Feb 2008 21:03:56 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Nish Aravamudan <nish.aravamudan@gmail.com>,
       Len Brown <lenb@kernel.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] [BUILD_FAILURE] 2.6.25-rc2-mm1 - Build Failure at acpi_os
Message-ID: <20080223153356.GA7401@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <200802210208.47487.lenb@kernel.org> <29495f1d0802211054s26665d3cy1609d3347867cb16@mail.gmail.com> <20080221222245.GB30976@uranus.ravnborg.org> <29495f1d0802211738leb47f9ayf9b3ab6aa51b66cb@mail.gmail.com> <20080222180815.GB6434@uranus.ravnborg.org> <20080222101344.821ea02a.randy.dunlap@oracle.com> <20080222182737.GC6434@uranus.ravnborg.org> <47BF1492.20901@oracle.com> <20080222185648.GA6843@uranus.ravnborg.org> <20080222112504.04e6b6a9.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080222112504.04e6b6a9.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 11:25:04AM -0800, Randy Dunlap wrote:
> Let's see what the ACPI people think about this change.
> 
> Thanks, Sam.
> ---
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Make ACPI_CUSTOM_DSDT boolean config symbol a hidden and derived
> value, based on the value of ACPI_CUSTOM_DSDT_FILE (string).
> Only the latter is presented to the user as a config option.
> 
> This fixes problems with "make randconfig" setting ACPI_CUSTOM_DSDT
> but leaving ACPI_CUSTOM_DSDT_FILE empty/blank.
> 
Thanks, the patch solves the build failure.

Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/acpi/Kconfig |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- linux-2.6.25-rc2-git5.orig/drivers/acpi/Kconfig
+++ linux-2.6.25-rc2-git5/drivers/acpi/Kconfig
@@ -283,24 +283,23 @@ config ACPI_TOSHIBA
        If you have a legacy free Toshiba laptop (such as the Libretto
L1
        series), say Y.

-config ACPI_CUSTOM_DSDT
-     bool "Include Custom DSDT"
+config ACPI_CUSTOM_DSDT_FILE
+     string "Custom DSDT Table file to include"
+     default ""
      depends on !STANDALONE
-     default n 
      help
        This option supports a custom DSDT by linking it into the
kernel.
        See Documentation/acpi/dsdt-override.txt

-       If unsure, say N.
-
-config ACPI_CUSTOM_DSDT_FILE
-     string "Custom DSDT Table file to include"
-     depends on ACPI_CUSTOM_DSDT
-     default ""
-     help
        Enter the full path name to the file which includes the AmlCode
        declaration.

+       If unsure, don't enter a file name.
+
+config ACPI_CUSTOM_DSDT
+     bool
+     default ACPI_CUSTOM_DSDT_FILE != ""
+
 config ACPI_CUSTOM_DSDT_INITRD
      bool "Read Custom DSDT from initramfs"
      depends on BLK_DEV_INITRD

After applying the patch and continuing with the same randconfig
reported earlier, the build fails with following error

drivers/acpi/thermal.c: In function ‘acpi_thermal_init’:
drivers/acpi/thermal.c:1792: error: ‘thermal_dmi_table’ undeclared (first use in this function)
drivers/acpi/thermal.c:1792: error: (Each undeclared identifier is reported only once
drivers/acpi/thermal.c:1792: error: for each function it appears in.)
make[2]: *** [drivers/acpi/thermal.o] Error 1
make[1]: *** [drivers/acpi] Error 2
make: *** [drivers] Error 2

I have tested the patch for build failure only.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
--- linux-2.6.25-rc2/drivers/acpi/Kconfig	2008-02-23 19:54:11.000000000 +0530
+++ linux-2.6.25-rc2/drivers/acpi/~Kconfig	2008-02-24 04:16:07.000000000 +0530
@@ -187,7 +187,7 @@ config ACPI_HOTPLUG_CPU
 
 config ACPI_THERMAL
 	tristate "Thermal Zone"
-	depends on ACPI_PROCESSOR
+	depends on ACPI_PROCESSOR && DMI
 	select THERMAL
 	default y
 	help
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
