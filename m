Return-Path: <linux-kernel-owner+w=401wt.eu-S1759108AbZC0Wwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759108AbZC0Wwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756549AbZC0Wwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:52:31 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54598 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927AbZC0Ww3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:52:29 -0400
Date: Fri, 27 Mar 2009 22:52:25 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] acpi: Use 32-bit FADT values on X86
Message-ID: <20090327225225.GA1772@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI specification says that we should use the 64-bit address 
offsets contained within the FADT if they exist. However, Windows uses 
the legacy address. Various vendors have left incorrect values in the 
64-bit field which then causes problems later. Since the vast majority 
of machines have never been tested with an OS that uses the 64-bit value 
by default, we should behave like Windows and ignore the spec by only 
using the 64-bit address if it contains something that can't be 
represented in the legacy field. Since system io space is only 16 bits 
on x86, this should be entirely safe.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

Some question remains as to whether we should be using the 32-bit values 
from the FADT provided by the XSDT or whether we should just be using 
the values from the FADT provided by the RSDT. So far every acpidump 
I've looked at has contained the same values in both, even when the 
64-bit values are broken. We know that there's a large number of 
machines out there that are broken in this respect. We have no evidence 
whatsoever to believe that there are any machines that this breaks. Can 
we just apply it and worry about further corner cases later?

diff --git a/drivers/acpi/acpica/tbfadt.c b/drivers/acpi/acpica/tbfadt.c
index 3636e4f..ad0e858 100644
--- a/drivers/acpi/acpica/tbfadt.c
+++ b/drivers/acpi/acpica/tbfadt.c
@@ -361,9 +361,28 @@ static void acpi_tb_convert_fadt(void)
 		    ACPI_ADD_PTR(struct acpi_generic_address, &acpi_gbl_FADT,
 				 fadt_info_table[i].address64);
 
-		/* Expand only if the 64-bit X target is null */
+		/*
+		 * The ACPI specification says that we should use the
+		 * 64-bit address offsets if they exists. However,
+		 * Windows uses the legacy address. Various vendors
+		 * have left incorrect values in the 64-bit field,
+		 * which then causes problems later. Since the vast
+		 * majority of machines have never been tested with an
+		 * OS that uses the 64-bit value by default, we should
+		 * behave like Windows and ignore the spec by only
+		 * using the 64-bit address if it contains something
+		 * that can't be represented in the legacy
+		 * field. Since system io space is only 16 bits on
+		 * x86, this should be entirely safe. We also extend
+		 * the 32-bit value into the 64-bit one if no 64-bit
+		 * address is provided.
+		 */
 
-		if (!target64->address) {
+		if (!target64->address
+#ifdef CONFIG_X86
+		    || (target64->space_id == ACPI_ADR_SPACE_SYSTEM_IO)
+#endif
+			) {
 
 			/* The space_id is always I/O for the 32-bit legacy address fields */
 
-- 
Matthew Garrett | mjg59@srcf.ucam.org
