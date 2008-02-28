Return-Path: <linux-kernel-owner+w=401wt.eu-S1764215AbYB1V0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764215AbYB1V0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 16:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757643AbYB1VZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 16:25:42 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:46943 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbYB1VZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:25:40 -0500
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: Roland Dreier <rdreier@cisco.com>, Wim Van Sebroeck <wim@iguana.be>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 28 Feb 2008 21:24:48 +0000
Subject: RE: [PATCH] [WATCHDOG] hpwdt: Use dmi_walk() instead of own copy
Thread-Topic: [PATCH] [WATCHDOG] hpwdt: Use dmi_walk() instead of own copy
Thread-Index: Ach6SV+mWKvWEGvIQeqP/G+rEgCCngABclXA
Message-ID: <E14D1C2A44812C4F9C3ED321127EDF650582A5F206@G3W0854.americas.hpqcorp.net>
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
	<adaejaxx9p7.fsf_-_@cisco.com> <ada7igox1jx.fsf_-_@cisco.com>
In-Reply-To: <ada7igox1jx.fsf_-_@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes look good.

Wim, please merge for 2.6.25.

    Acknowledged-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>


Thanks,

Tom

-----Original Message-----
From: Roland Dreier [mailto:rdreier@cisco.com]
Sent: Thursday, February 28, 2008 2:35 PM
To: Wim Van Sebroeck; Mingarelli, Thomas
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [WATCHDOG] hpwdt: Use dmi_walk() instead of own copy

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
-       u8 anchor[4];
-       u8 checksum;
-       u8 length;
-       u8 major_ver;
-       u8 minor_ver;
-       u16 max_struct_size;
-       u8 revision;
-       u8 formatted_area[5];
-       u8 intermediate_anchor[5];
-       u8 intermediate_checksum;
-       u16 table_length;
-       u64 table_address;
-       u16 table_num_structs;
-       u8 bcd_revision;
-};
-
 /* type 212 */
 struct smbios_cru64_info {
        u8 type;
@@ -175,24 +140,6 @@ static struct pci_device_id hpwdt_devices[] = {
 };
 MODULE_DEVICE_TABLE(pci, hpwdt_devices);

-/*
- *     bios_checksum
- */
-static int __devinit bios_checksum(const char __iomem *ptr, int len)
-{
-       char sum = 0;
-       int i;
-
-       /*
-        * calculate checksum of size bytes. This should add up
-        * to zero if we have a valid header.
-        */
-       for (i = 0; i < len; i++)
-               sum += ptr[i];
-
-       return ((sum == 0) && (len > 0));
-}
-
 #ifndef CONFIG_X86_64
 /* --32 Bit Bios------------------------------------------------------------ */

@@ -303,6 +250,24 @@ static int __devinit cru_detect(unsigned long map_entry,
 }

 /*
+ *     bios_checksum
+ */
+static int __devinit bios_checksum(const char __iomem *ptr, int len)
+{
+       char sum = 0;
+       int i;
+
+       /*
+        * calculate checksum of size bytes. This should add up
+        * to zero if we have a valid header.
+        */
+       for (i = 0; i < len; i++)
+               sum += ptr[i];
+
+       return ((sum == 0) && (len > 0));
+}
+
+/*
  *     bios32_present
  *
  *     Routine Description:
@@ -410,12 +375,8 @@ asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
  *     dmi_find_cru
  *
  *     Routine Description:
- *     This function checks wether or not a SMBIOS/DMI record is
+ *     This function checks whether or not a SMBIOS/DMI record is
  *     the 64bit CRU info or not
- *
- *     Return Value:
- *     0        :  SUCCESS - if record found
- *     <0       :  FAILURE - if record not found
  */
 static void __devinit dmi_find_cru(const struct dmi_header *dm)
 {
@@ -434,138 +395,11 @@ static void __devinit dmi_find_cru(const struct dmi_header *dm)
        }
 }

-/*
- *     dmi_table
- *
- *     Routine Description:
- *     Decode the SMBIOS/DMI table and check if we have a 64bit CRU record
- *     or not.
- *
- *     We have to be cautious here. We have seen BIOSes with DMI pointers
- *     pointing to completely the wrong place for example
- */
-static void __devinit dmi_table(u8 *buf, int len, int num,
-                     void (*decode)(const struct dmi_header *))
-{
-       u8 *data = buf;
-       int i = 0;
-
-       /*
-        *      Stop when we see all the items the table claimed to have
-        *      OR we run off the end of the table (also happens)
-        */
-       while ((i < num) && (data - buf + sizeof(struct dmi_header)) <= len) {
-               const struct dmi_header *dm = (const struct dmi_header *)data;
-
-               /*
-                *  We want to know the total length (formated area and strings)
-                *  before decoding to make sure we won't run off the table in
-                *  dmi_decode or dmi_string
-                */
-               data += dm->length;
-               while ((data - buf < len - 1) && (data[0] || data[1]))
-                       data++;
-               if (data - buf < len - 1)
-                       decode(dm);
-               data += 2;
-               i++;
-       }
-}
-
-/*
- *     smbios_present
- *
- *     Routine Description:
- *     This function parses the SMBIOS entry point table to retrieve
- *     the 64 bit CRU Service.
- *
- *     Return Value:
- *     0        :  SUCCESS
- *     <0       :  FAILURE
- */
-static int __devinit smbios_present(const char __iomem *p)
-{
-       struct smbios_entry_point *eps =
-               (struct smbios_entry_point *) p;
-       int length;
-       u8 *buf;
-
-       /* check if we have indeed the SMBIOS table entry point */
-       if ((strncmp((char *)eps->anchor, "_SM_",
-                            sizeof(eps->anchor))) == 0) {
-               length = eps->length;
-
-               /* SMBIOS v2.1 implementation might use 0x1e */
-               if ((length == 0x1e) &&
-                   (eps->major_ver == 2) &&
-                   (eps->minor_ver == 1))
-                       length = 0x1f;
-
-               /*
-                * Now we will check:
-                * - SMBIOS checksum must be 0
-                * - intermediate anchor should be _DMI_
-                * - intermediate checksum should be 0
-                */
-               if ((bios_checksum(p, length)) &&
-                   (strncmp((char *)eps->intermediate_anchor, "_DMI_",
-                            sizeof(eps->intermediate_anchor)) == 0) &&
-                   (bios_checksum(p+0x10, 15))) {
-                       buf = ioremap(eps->table_address, eps->table_length);
-                       if (buf == NULL)
-                               return -ENODEV;
-
-
-                       /* Scan the DMI table for the 64 bit CRU service */
-                       dmi_table(buf, eps->table_length,
-                                 eps->table_num_structs, dmi_find_cru);
-
-                       iounmap(buf);
-                       return 0;
-               }
-       }
-
-       return -ENODEV;
-}
-
-static int __devinit smbios_scan_machine(void)
-{
-       char __iomem *p, *q;
-       int rc;
-
-       if (efi_enabled) {
-               if (efi.smbios == EFI_INVALID_TABLE_ADDR)
-                       return -ENODEV;
-
-               p = ioremap(efi.smbios, 32);
-               if (p == NULL)
-                       return -ENOMEM;
-
-               rc = smbios_present(p);
-               iounmap(p);
-       } else {
-               /*
-                * Search from 0x0f0000 through 0x0fffff, inclusive.
-                */
-               p = ioremap(PCI_ROM_BASE1, ROM_SIZE);
-               if (p == NULL)
-                       return -ENOMEM;
-
-               for (q = p; q < p + ROM_SIZE; q += 16) {
-                       rc = smbios_present(q);
-                       if (!rc) {
-                               break;
-                       }
-               }
-               iounmap(p);
-       }
-}
-
 static int __devinit detect_cru_service(void)
 {
        cru_rom_addr = NULL;

-       smbios_scan_machine();  /* will become dmi_walk(dmi_find_cru); */
+       dmi_walk(dmi_find_cru);

        /* if cru_rom_addr has been set then we found a CRU service */
        return ((cru_rom_addr != NULL)? 0: -ENODEV);
