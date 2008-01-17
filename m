Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbYAQUj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbYAQUj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 15:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbYAQUjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 15:39:48 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:64803 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbYAQUjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:39:47 -0500
Date: Thu, 17 Jan 2008 12:44:45 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86: copy srat table and unmap in acpi_parse_table
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200801171244.46228.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: copy srat table and unmap in acpi_parse_table


the old acpi_numa_slit_init was saving old address in early stage acpi_slit
and acpi_parse_table can not unmap address that.
the patch copy the slit in the callback,
so we could unmap table in acpi_parse_table instead of outside track it.

need to revert
"
commit d8d28f25f33c6a035cdfb1d421c79293d16e5c58
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Jan 17 15:26:42 2008 +0100

    x86: ACPI: fix mapping leaks

    ioremap_early() is stateful, hence we cannot tolerate mapping leaks.
"

before appling this patch

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_64.c
+++ linux-2.6/arch/x86/mm/srat_64.c
@@ -23,7 +23,9 @@
 
 int acpi_numa __initdata;
 
-static struct acpi_table_slit *acpi_slit;
+static int slit_copied;
+static u64 slit_locality_count;
+static u8 slit_entry[MAX_NUMNODES * MAX_NUMNODES];
 
 static nodemask_t nodes_parsed __initdata;
 static struct bootnode nodes[MAX_NUMNODES] __initdata;
@@ -130,7 +132,16 @@ void __init acpi_numa_slit_init(struct a
 		printk(KERN_INFO "ACPI: SLIT table looks invalid. Not used.\n");
 		return;
 	}
-	acpi_slit = slit;
+
+	if (slit->locality_count > MAX_NUMNODES)
+		return;
+
+	slit_locality_count = slit->locality_count;
+
+	memcpy(slit_entry, slit->entry,
+	       slit_locality_count * slit_locality_count);
+
+	slit_copied = 1;
 }
 
 /* Callback for Proximity Domain -> LAPIC mapping */
@@ -502,11 +513,11 @@ int __node_distance(int a, int b)
 {
 	int index;
 
-	if (!acpi_slit)
+	if (!slit_copied)
 		return null_slit_node_compare(a, b) ? LOCAL_DISTANCE :
 						      REMOTE_DISTANCE;
-	index = acpi_slit->locality_count * node_to_pxm(a);
-	return acpi_slit->entry[index + node_to_pxm(b)];
+	index = slit_locality_count * node_to_pxm(a);
+	return slit_entry[index + node_to_pxm(b)];
 }
 
 EXPORT_SYMBOL(__node_distance);
Index: linux-2.6/drivers/acpi/tables.c
===================================================================
--- linux-2.6.orig/drivers/acpi/tables.c
+++ linux-2.6/drivers/acpi/tables.c
@@ -260,6 +260,7 @@ int __init acpi_table_parse(char *id, ac
 
 	if (table) {
 		handler(table);
+		acpi_os_unmap_memory(table, table->length);
 		return 0;
 	} else
 		return 1;
