Return-Path: <linux-kernel-owner+w=401wt.eu-S1763426AbYB1UfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763426AbYB1UfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758791AbYB1Uet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:34:49 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:33640 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758189AbYB1Uer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:34:47 -0500
To: Wim Van Sebroeck <wim@iguana.be>,
       "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [WATCHDOG] hpwdt: Use dmi_walk() instead of own copy
X-Message-Flag: Warning: May contain useful information
References: <adad4qiwcmz.fsf@cisco.com>
	<alpine.LFD.1.00.0802271913050.7583@apollo.tec.linutronix.de>
	<ada1w6y1bzk.fsf@cisco.com>
	<alpine.LFD.1.00.0802272011130.7583@apollo.tec.linutronix.de>
	<20080227203655.GA30054@elte.hu>
	<alpine.LFD.1.00.0802272140050.7583@apollo.tec.linutronix.de>
	<alpine.LFD.1.00.0802272155190.7583@apollo.tec.linutronix.de>
	<ada3areyu7x.fsf@cisco.com>
	<E14D1C2A44812C4F9C3ED321127EDF6505829D59DF@G3W0854.americas.hpqcorp.net>
	<adamypmx7k1.fsf@cisco.com>
	<E14D1C2A44812C4F9C3ED321127EDF6505829D5D6C@G3W0854.americas.hpqcorp.net>
	<adaejaxx9p7.fsf_-_@cisco.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 28 Feb 2008 12:34:42 -0800
In-Reply-To: <adaejaxx9p7.fsf_-_@cisco.com> (Roland Dreier's message of "Thu, 28 Feb 2008 09:38:44 -0800")
Message-ID: <ada7igox1jx.fsf_-_@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Feb 2008 20:34:43.0465 (UTC) FILETIME=[599BE790:01C87A49]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my HP DL380 G5 system running a 64-bit kernel, loading the hpwdt
driver causes a crash because the driver attempts to ioremap an
invalid physical address.  This is because the driver has an incorrect
definition of the SMBIOS table entry point structure: the table
address is only a 32-bit quantity, and making it a u64 means that the
high-order 32 bits end up containing garbage.

We can fix this by simply deleting all of the duplicated DMI table
walking code and using the kernel's existing dmi_walk() interface to
find the DMI entry the driver is looking for.

Tested on an HP DL380 G5 running a 64-bit kernel.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
Wim/Thomas-- Here's an alternative way to fix the crash on 64-bit
systems: just delete all the duplicated DMI walking code, including
the part that has the bug.

 drivers/watchdog/hpwdt.c |  206 +++++-----------------------------------------
 1 files changed, 20 insertions(+), 186 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index a2e174b..2686f3e 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -58,41 +58,6 @@ struct bios32_service_dir {
 	u8 reserved[5];
 };
 
-/*
- * smbios_entry_point     - defines SMBIOS entry point structure
- *
- * anchor[4]              - anchor string (_SM_)
- * checksum               - checksum of the entry point structure
- * length                 - length of the entry point structure
- * major_ver              - major version (02h for revision 2.1)
- * minor_ver              - minor version (01h for revision 2.1)
- * max_struct_size        - size of the largest SMBIOS structure
- * revision               - entry point structure revision implemented
- * formatted_area[5]      - reserved
- * intermediate_anchor[5] - intermediate anchor string (_DMI_)
- * intermediate_checksum  - intermediate checksum
- * table_length           - structure table length
- * table_address          - structure table address
- * table_num_structs      - number of SMBIOS structures present
- * bcd_revision           - BCD revision
- */
-struct smbios_entry_point {
-	u8 anchor[4];
-	u8 checksum;
-	u8 length;
-	u8 major_ver;
-	u8 minor_ver;
-	u16 max_struct_size;
-	u8 revision;
-	u8 formatted_area[5];
-	u8 intermediate_anchor[5];
-	u8 intermediate_checksum;
-	u16 table_length;
-	u64 table_address;
-	u16 table_num_structs;
-	u8 bcd_revision;
-};
-
 /* type 212 */
 struct smbios_cru64_info {
 	u8 type;
@@ -175,24 +140,6 @@ static struct pci_device_id hpwdt_devices[] = {
 };
 MODULE_DEVICE_TABLE(pci, hpwdt_devices);
 
-/*
- *	bios_checksum
- */
-static int __devinit bios_checksum(const char __iomem *ptr, int len)
-{
-	char sum = 0;
-	int i;
-
-	/*
-	 * calculate checksum of size bytes. This should add up
-	 * to zero if we have a valid header.
-	 */
-	for (i = 0; i < len; i++)
-		sum += ptr[i];
-
-	return ((sum == 0) && (len > 0));
-}
-
 #ifndef CONFIG_X86_64
 /* --32 Bit Bios------------------------------------------------------------ */
 
@@ -303,6 +250,24 @@ static int __devinit cru_detect(unsigned long map_entry,
 }
 
 /*
+ *	bios_checksum
+ */
+static int __devinit bios_checksum(const char __iomem *ptr, int len)
+{
+	char sum = 0;
+	int i;
+
+	/*
+	 * calculate checksum of size bytes. This should add up
+	 * to zero if we have a valid header.
+	 */
+	for (i = 0; i < len; i++)
+		sum += ptr[i];
+
+	return ((sum == 0) && (len > 0));
+}
+
+/*
  *	bios32_present
  *
  *	Routine Description:
@@ -410,12 +375,8 @@ asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
  *	dmi_find_cru
  *
  *	Routine Description:
- *	This function checks wether or not a SMBIOS/DMI record is
+ *	This function checks whether or not a SMBIOS/DMI record is
  *	the 64bit CRU info or not
- *
- *	Return Value:
- *	0        :  SUCCESS - if record found
- *	<0       :  FAILURE - if record not found
  */
 static void __devinit dmi_find_cru(const struct dmi_header *dm)
 {
@@ -434,138 +395,11 @@ static void __devinit dmi_find_cru(const struct dmi_header *dm)
 	}
 }
 
-/*
- *	dmi_table
- *
- *	Routine Description:
- *	Decode the SMBIOS/DMI table and check if we have a 64bit CRU record
- *	or not.
- *
- *	We have to be cautious here. We have seen BIOSes with DMI pointers
- *	pointing to completely the wrong place for example
- */
-static void __devinit dmi_table(u8 *buf, int len, int num,
-		      void (*decode)(const struct dmi_header *))
-{
-	u8 *data = buf;
-	int i = 0;
-
-	/*
-	 *	Stop when we see all the items the table claimed to have
-	 *	OR we run off the end of the table (also happens)
-	 */
-	while ((i < num) && (data - buf + sizeof(struct dmi_header)) <= len) {
-		const struct dmi_header *dm = (const struct dmi_header *)data;
-
-		/*
-		 *  We want to know the total length (formated area and strings)
-		 *  before decoding to make sure we won't run off the table in
-		 *  dmi_decode or dmi_string
-		 */
-		data += dm->length;
-		while ((data - buf < len - 1) && (data[0] || data[1]))
-			data++;
-		if (data - buf < len - 1)
-			decode(dm);
-		data += 2;
-		i++;
-	}
-}
-
-/*
- *	smbios_present
- *
- *	Routine Description:
- *	This function parses the SMBIOS entry point table to retrieve
- *	the 64 bit CRU Service.
- *
- *	Return Value:
- *	0        :  SUCCESS
- *	<0       :  FAILURE
- */
-static int __devinit smbios_present(const char __iomem *p)
-{
-	struct smbios_entry_point *eps =
-		(struct smbios_entry_point *) p;
-	int length;
-	u8 *buf;
-
-	/* check if we have indeed the SMBIOS table entry point */
-	if ((strncmp((char *)eps->anchor, "_SM_",
-			     sizeof(eps->anchor))) == 0) {
-		length = eps->length;
-
-		/* SMBIOS v2.1 implementation might use 0x1e */
-		if ((length == 0x1e) &&
-		    (eps->major_ver == 2) &&
-		    (eps->minor_ver == 1))
-			length = 0x1f;
-
-		/*
-		 * Now we will check:
-		 * - SMBIOS checksum must be 0
-		 * - intermediate anchor should be _DMI_
-		 * - intermediate checksum should be 0
-		 */
-		if ((bios_checksum(p, length)) &&
-		    (strncmp((char *)eps->intermediate_anchor, "_DMI_",
-		             sizeof(eps->intermediate_anchor)) == 0) &&
-		    (bios_checksum(p+0x10, 15))) {
-			buf = ioremap(eps->table_address, eps->table_length);
-			if (buf == NULL)
-				return -ENODEV;
-
-
-			/* Scan the DMI table for the 64 bit CRU service */
-			dmi_table(buf, eps->table_length,
-			          eps->table_num_structs, dmi_find_cru);
-
-			iounmap(buf);
-			return 0;
-		}
-	}
-
-	return -ENODEV;
-}
-
-static int __devinit smbios_scan_machine(void)
-{
-	char __iomem *p, *q;
-	int rc;
-
-	if (efi_enabled) {
-		if (efi.smbios == EFI_INVALID_TABLE_ADDR)
-			return -ENODEV;
-
-		p = ioremap(efi.smbios, 32);
-		if (p == NULL)
-			return -ENOMEM;
-
-		rc = smbios_present(p);
-		iounmap(p);
-	} else {
-		/*
-		 * Search from 0x0f0000 through 0x0fffff, inclusive.
-		 */
-		p = ioremap(PCI_ROM_BASE1, ROM_SIZE);
-		if (p == NULL)
-			return -ENOMEM;
-
-		for (q = p; q < p + ROM_SIZE; q += 16) {
-			rc = smbios_present(q);
-			if (!rc) {
-				break;
-			}
-		}
-		iounmap(p);
-	}
-}
-
 static int __devinit detect_cru_service(void)
 {
 	cru_rom_addr = NULL;
 
-	smbios_scan_machine();	/* will become dmi_walk(dmi_find_cru); */
+	dmi_walk(dmi_find_cru);
 
 	/* if cru_rom_addr has been set then we found a CRU service */
 	return ((cru_rom_addr != NULL)? 0: -ENODEV);
