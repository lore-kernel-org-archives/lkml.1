Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbXJIIia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbXJIIia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 04:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbXJIIiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 04:38:11 -0400
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:36031 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbXJIIiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 04:38:09 -0400
X-Greylist: delayed 1256 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Oct 2007 04:38:08 EDT
Subject: [PATCH -mm] Make Smart Battery System  depend on ACPI_SBS
	ACPI_PROC_EVENT
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: astarikovskiy@suse.de, vladimir.p.lebedev@intel.com,
       akpm@linux-foundation.org, len.brown@intel.com
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Tue, 09 Oct 2007 17:17:11 +0900
Message-Id: <1191917831.10086.28.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Playing with the latest -mm kernel I stumbled upon the following compile
error:

  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
<stdin>:1389:2: warning: #warning syscall revokeat not implemented
<stdin>:1393:2: warning: #warning syscall frevoke not implemented
  CHK     include/linux/compile.h
  LD      drivers/acpi/built-in.o
  LD [M]  drivers/acpi/processor.o
  CC [M]  drivers/acpi/sbs.o
drivers/acpi/sbs.c: In function 'acpi_battery_add':
drivers/acpi/sbs.c:825: warning: ignoring return value of 'device_create_file',\
 declared with attribute warn_unused_result
drivers/acpi/sbs.c: In function 'acpi_sbs_callback':
drivers/acpi/sbs.c:898: error: implicit declaration of function 'acpi_bus_gener\
ate_proc_event4'
make[2]: *** [drivers/acpi/sbs.o] Error 1
make[1]: *** [drivers/acpi] Error 2
make: *** [drivers] Error 2

The problem turned out to be that the sbs module is still using
acpi_bus_generate_proc_event4(), which is part of the
deprecated /proc/acpi/event interface. This patch makes this dependency
explicit.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.23-rc8-mm2-orig/drivers/acpi/Kconfig linux-2.6.23-rc8-mm2/drivers/acpi/Kconfig
--- linux-2.6.23-rc8-mm2-orig/drivers/acpi/Kconfig	2007-10-09 17:12:55.000000000 +0900
+++ linux-2.6.23-rc8-mm2/drivers/acpi/Kconfig	2007-10-09 16:36:07.000000000 +0900
@@ -352,6 +352,7 @@ config ACPI_HOTPLUG_MEMORY
 config ACPI_SBS
 	tristate "Smart Battery System (EXPERIMENTAL)"
 	depends on X86
+	depends on ACPI_PROC_EVENT
 	depends on EXPERIMENTAL
 	help
 	  This driver adds support for the Smart Battery System.


