Return-Path: <linux-kernel-owner+w=401wt.eu-S1759712AbXKGSs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712AbXKGSs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757203AbXKGSsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:48:18 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:35108 "EHLO
	outbound6-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753749AbXKGSsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:48:17 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Wed, 7 Nov 2007 19:48:02 +0100
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Len Brown" <lenb@kernel.org>
cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH] acpi: remove nested "ifdef CONFIG_ACPI"
Message-ID: <20071107184802.GA18373@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 07 Nov 2007 18:47:52.0034 (UTC)
 FILETIME=[B36B6C20:01C8216E]
X-WSS-ID: 6B2CD7E807S1768726-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In include/linux/acpi.h we have following ifdefs:

  #ifndef _LINUX_ACPI_H
  #define _LINUX_ACPI_H


  #ifdef  CONFIG_ACPI    <===

  #ifndef _LINUX
  #define _LINUX
  #endif

  #include <linux/list.h>
  #include <linux/mod_devicetable.h>

  #include <acpi/acpi.h>
  #include <acpi/acpi_bus.h>
  #include <acpi/acpi_drivers.h>
  #include <acpi/acpi_numa.h>
  #include <asm/acpi.h>


  #ifdef CONFIG_ACPI     <===

The nesting of "ifdef CONFIG_ACPI" is kind of interesting.
But I guess this was not intentional.(Or did I miss something?)

Attached is a patch to remove that nesting and to clean up
this header a little bit.


Regards,

Andreas
--
[PATCH] acpi: remove nested "ifdef CONFIG_ACPI"

 - Remove nested ifdef CONFIG_ACPI which required minor changes of the header.
 - Remove unused function declaration for acpi_paddr_to_node. grep didn't
   find a usage of that function.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 include/acpi/acpi_drivers.h |    3 +++
 include/linux/acpi.h        |   38 ++++++++++++++++++--------------------
 2 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index f85f77a..8420ff7 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -29,6 +29,8 @@
 #include <linux/acpi.h>
 #include <acpi/acpi_bus.h>
 
+#ifdef CONFIG_ACPI
+
 #define ACPI_MAX_STRING			80
 
 #define ACPI_BUS_COMPONENT		0x00010000
@@ -149,4 +151,5 @@ static inline void unregister_hotplug_dock_device(acpi_handle handle)
   -------------------------------------------------------------------------- */
 extern int acpi_sleep_init(void);
 
+#endif /* CONFIG_ACPI */
 #endif /*__ACPI_DRIVERS_H__*/
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 8ccedf7..0546684 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -26,8 +26,6 @@
 #define _LINUX_ACPI_H
 
 
-#ifdef	CONFIG_ACPI
-
 #ifndef _LINUX
 #define _LINUX
 #endif
@@ -125,6 +123,16 @@ extern unsigned long acpi_realmode_flags;
 
 #else	/* !CONFIG_ACPI */
 
+static inline int acpi_boot_init(void)
+{
+	return 0;
+}
+
+static inline int acpi_boot_table_init(void)
+{
+	return 0;
+}
+
 #define acpi_mp_config	0
 
 #endif 	/* !CONFIG_ACPI */
@@ -190,36 +198,26 @@ extern int acpi_blacklisted(void);
 extern void acpi_bios_year(char *s);
 
 #ifdef CONFIG_ACPI_NUMA
+
 int acpi_get_pxm(acpi_handle handle);
 int acpi_get_node(acpi_handle *handle);
-#else
-static inline int acpi_get_pxm(acpi_handle handle)
-{
-	return 0;
-}
-static inline int acpi_get_node(acpi_handle *handle)
-{
-	return 0;
-}
-#endif
-extern int acpi_paddr_to_node(u64 start_addr, u64 size);
-
-extern int pnpacpi_disabled;
 
 #define PXM_INVAL	(-1)
 #define NID_INVAL	(-1)
 
-#else	/* CONFIG_ACPI */
+#else
 
-static inline int acpi_boot_init(void)
+static inline int acpi_get_pxm(acpi_handle handle)
 {
 	return 0;
 }
-
-static inline int acpi_boot_table_init(void)
+static inline int acpi_get_node(acpi_handle *handle)
 {
 	return 0;
 }
 
-#endif	/* CONFIG_ACPI */
+#endif /* !CONFIG_ACPI_NUMA */
+
+extern int pnpacpi_disabled;
+
 #endif	/*_LINUX_ACPI_H*/
-- 
1.5.3.4




