Return-Path: <linux-kernel-owner+w=401wt.eu-S1762972AbYCXSWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762972AbYCXSWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760964AbYCXSVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:21:16 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42441 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760854AbYCXSVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:21:15 -0400
Date: Mon, 24 Mar 2008 13:21:14 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [RFC 4/8] x86_64: Parsing for ACPI "SAPIC" table
Message-ID: <20080324182114.GA28060@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add kernel support for new ACPI "sapic" tables that contain 16-bit APICIDs.
This patch simply adds parsing of an optional SAPIC table if present.
Otherwise, the traditional local APIC table is used.

Note: the SAPIC table is not a new ACPI table - it exists on other architectures
but is not currently recognized by x86_64.


	Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 arch/x86/kernel/acpi/boot.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux.orig/arch/x86/kernel/acpi/boot.c	2008-03-21 15:37:05.000000000 -0500
+++ linux/arch/x86/kernel/acpi/boot.c	2008-03-21 15:40:46.000000000 -0500
@@ -261,6 +261,24 @@ acpi_parse_lapic(struct acpi_subtable_he
 }
 
 static int __init
+acpi_parse_sapic(struct acpi_subtable_header *header, const unsigned long end)
+{
+	struct acpi_madt_local_sapic *processor = NULL;
+
+	processor = (struct acpi_madt_local_sapic *)header;
+
+	if (BAD_MADT_ENTRY(processor, end))
+		return -EINVAL;
+
+	acpi_table_print_madt_entry(header);
+
+	mp_register_lapic((processor->id << 8) | processor->eid,/* APIC ID */
+		processor->lapic_flags & ACPI_MADT_ENABLED);	/* Enabled? */
+
+	return 0;
+}
+
+static int __init
 acpi_parse_lapic_addr_ovr(struct acpi_subtable_header * header,
 			  const unsigned long end)
 {
@@ -753,8 +771,12 @@ static int __init acpi_parse_madt_lapic_
 
 	mp_register_lapic_address(acpi_lapic_addr);
 
-	count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC, acpi_parse_lapic,
-				      MAX_APICS);
+	count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_SAPIC,
+				      acpi_parse_sapic, MAX_APICS);
+
+	if (!count)
+		count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC,
+					      acpi_parse_lapic, MAX_APICS);
 	if (!count) {
 		printk(KERN_ERR PREFIX "No LAPIC entries present\n");
 		/* TBD: Cleanup to allow fallback to MPS */
