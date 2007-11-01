Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbXKAITw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbXKAITw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 04:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbXKAITh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 04:19:37 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:51106 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbXKAITg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 04:19:36 -0400
Date: Thu, 01 Nov 2007 01:20:29 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86: check boundary in count/setup_resource called by
 get_current_resources
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Gary Hade <gary.hade@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200711010120.30410.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: check boundary in count/setup_resource called by get_current_resources

need to check info->res_num less than PCI_BUS_NUM_RESOURCES, so
info->bus->resource[info->res_num] = res will not beyond of bus resource array
when acpi resutrn too many resource entries.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/pci/acpi.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/acpi.c
+++ linux-2.6/arch/x86/pci/acpi.c
@@ -77,9 +77,13 @@ count_resource(struct acpi_resource *acp
 	struct acpi_resource_address64 addr;
 	acpi_status status;
 
+	if (info->res_num >= PCI_BUS_NUM_RESOURCES)
+		return AE_OK;
+
 	status = resource_to_addr(acpi_res, &addr);
 	if (ACPI_SUCCESS(status))
 		info->res_num++;
+
 	return AE_OK;
 }
 
@@ -93,6 +97,9 @@ setup_resource(struct acpi_resource *acp
 	unsigned long flags;
 	struct resource *root;
 
+	if (info->res_num >= PCI_BUS_NUM_RESOURCES)
+		return AE_OK;
+
 	status = resource_to_addr(acpi_res, &addr);
 	if (!ACPI_SUCCESS(status))
 		return AE_OK;
 
