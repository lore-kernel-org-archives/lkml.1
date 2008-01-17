Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbYAQUkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbYAQUkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 15:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbYAQUjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 15:39:49 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:64802 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbYAQUjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:39:47 -0500
Date: Thu, 17 Jan 2008 12:45:34 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86: left over fix for leak of early_ioremp
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200801171245.35095.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: left over fix for leak of early_ioremp

Signed-off-by: Yinghai Lu <yinghai@sun.com>

Index: linux-2.6/drivers/acpi/tables.c
===================================================================
--- linux-2.6.orig/drivers/acpi/tables.c
+++ linux-2.6/drivers/acpi/tables.c
@@ -206,8 +206,10 @@ acpi_table_parse_entries(char *id,
 	       table_end) {
 		if (entry->type == entry_id
 		    && (!max_entries || count++ < max_entries))
-			if (handler(entry, table_end))
+			if (handler(entry, table_end)) {
+				acpi_os_unmap_memory(table_header, table_header->length);
 				return -EINVAL;
+			}
 
 		entry = (struct acpi_subtable_header *)
 		    ((unsigned long)entry + entry->length);
@@ -282,6 +285,7 @@ static void __init check_multiple_madt(v
 		       "notify linux-acpi@vger.kernel.org\n",
 		       acpi_apic_instance ? 0 : 2);
 
+		acpi_os_unmap_memory(table, table->length);
 	} else
 		acpi_apic_instance = 0;
 
Index: linux-2.6/drivers/firmware/dmi_scan.c
===================================================================
--- linux-2.6.orig/drivers/firmware/dmi_scan.c
+++ linux-2.6/drivers/firmware/dmi_scan.c
@@ -353,6 +353,7 @@ void __init dmi_scan_machine(void)
 				return;
 			}
 		}
+		dmi_iounmap(p, 0x10000);
 	}
  out:	printk(KERN_INFO "DMI not present or invalid.\n");
 }
