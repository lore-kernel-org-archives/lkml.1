Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbYFEMHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbYFEMHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 08:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757328AbYFEMH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 08:07:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47818 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385AbYFEMHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 08:07:20 -0400
Subject: [PATCH] firmware: convert Ambassador ATM driver to
	request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: Giuliano Procida <gprocida@marge.com>,
       linux-atm-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 05 Jun 2008 13:07:13 +0100
Message-Id: <1212667633.32207.205.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since it had various regions to be loaded to separate addresses, and it
wanted to do them in fairly small chunks anyway, switch it to use the
new ihex code. Encode the start address in the first record.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
Not entirely sure how we can claim that the firmware is under GPL
without providing its source in the preferred form for modification --
but transplanted the copyright blurb to the HEX file unmolested,
nonetheless.

 drivers/atm/Kconfig          |    8 +
 drivers/atm/ambassador.c     |  140 ++--
 drivers/atm/ambassador.h     |   11 -
 drivers/atm/atmsar11.data    | 2063 ------------------------------------------
 drivers/atm/atmsar11.regions |    6 -
 drivers/atm/atmsar11.start   |    4 -
 firmware/Makefile            |    1 +
 firmware/atmsar11.HEX        |  204 +++++
 8 files changed, 270 insertions(+), 2167 deletions(-)
 delete mode 100644 drivers/atm/atmsar11.data
 delete mode 100644 drivers/atm/atmsar11.regions
 delete mode 100644 drivers/atm/atmsar11.start
 create mode 100644 firmware/atmsar11.HEX

diff --git a/drivers/atm/Kconfig b/drivers/atm/Kconfig
index b554eda..03e126b 100644
--- a/drivers/atm/Kconfig
+++ b/drivers/atm/Kconfig
@@ -245,6 +245,7 @@ config ATM_IDT77252_USE_SUNI
 
 config ATM_AMBASSADOR
 	tristate "Madge Ambassador (Collage PCI 155 Server)"
+	select FW_LOADER
 	depends on PCI && VIRT_TO_BUS
 	select BITREVERSE
 	help
@@ -252,6 +253,13 @@ config ATM_AMBASSADOR
 	  Networks Ltd. Say Y (or M to compile as a module named ambassador)
 	  here if you have one of these cards.
 
+config ATM_AMBASSADOR_FIRMWARE
+	bool "Firmware for Madge Ambassador (Collage PCI 155 Server)"
+	depends on ATM_AMBASSADOR
+	help
+	  This allows you to build the firmware for the ATMizer based ATM
+	  card into the kernel. Say 'N' and let it get loaded from userspace.
+
 config ATM_AMBASSADOR_DEBUG
 	bool "Enable debugging messages"
 	depends on ATM_AMBASSADOR
diff --git a/drivers/atm/ambassador.c b/drivers/atm/ambassador.c
index 6adb72a..a2feeac 100644
--- a/drivers/atm/ambassador.c
+++ b/drivers/atm/ambassador.c
@@ -34,6 +34,8 @@
 #include <linux/poison.h>
 #include <linux/bitrev.h>
 #include <linux/mutex.h>
+#include <linux/firmware.h>
+#include <linux/ihex.h>
 
 #include <asm/atomic.h>
 #include <asm/io.h>
@@ -290,29 +292,6 @@ static inline void __init show_version (void) {
   
 */
 
-/********** microcode **********/
-
-#ifdef AMB_NEW_MICROCODE
-#define UCODE(x) UCODE2(atmsar12.x)
-#else
-#define UCODE(x) UCODE2(atmsar11.x)
-#endif
-#define UCODE2(x) #x
-
-static u32 __devinitdata ucode_start =
-#include UCODE(start)
-;
-
-static region __devinitdata ucode_regions[] = {
-#include UCODE(regions)
-  { 0, 0 }
-};
-
-static u32 __devinitdata ucode_data[] = {
-#include UCODE(data)
-  0xdeadbeef
-};
-
 static void do_housekeeping (unsigned long arg);
 /********** globals **********/
 
@@ -1841,45 +1820,34 @@ static int __devinit get_loader_version (loader_block * lb,
 
 /* loader: write memory data blocks */
 
-static int __devinit loader_write (loader_block * lb,
-				const amb_dev * dev, const u32 * data,
-				u32 address, unsigned int count) {
-  unsigned int i;
+static int __devinit loader_write (loader_block* lb,
+				   const amb_dev *dev,
+				   const struct ihex_binrec *rec) {
   transfer_block * tb = &lb->payload.transfer;
   
   PRINTD (DBG_FLOW|DBG_LOAD, "loader_write");
-  
-  if (count > MAX_TRANSFER_DATA)
-    return -EINVAL;
-  tb->address = cpu_to_be32 (address);
-  tb->count = cpu_to_be32 (count);
-  for (i = 0; i < count; ++i)
-    tb->data[i] = cpu_to_be32 (data[i]);
+
+  tb->address = rec->addr;
+  tb->count = rec->len / 4;
+  memcpy(tb->data, rec->data, rec->len);
   return do_loader_command (lb, dev, write_adapter_memory);
 }
 
 /* loader: verify memory data blocks */
 
 static int __devinit loader_verify (loader_block * lb,
-				 const amb_dev * dev, const u32 * data,
-				 u32 address, unsigned int count) {
-  unsigned int i;
+				    const amb_dev *dev,
+				    const struct ihex_binrec *rec) {
   transfer_block * tb = &lb->payload.transfer;
   int res;
   
   PRINTD (DBG_FLOW|DBG_LOAD, "loader_verify");
   
-  if (count > MAX_TRANSFER_DATA)
-    return -EINVAL;
-  tb->address = cpu_to_be32 (address);
-  tb->count = cpu_to_be32 (count);
+  tb->address = rec->addr;
+  tb->count = rec->len / 4;
   res = do_loader_command (lb, dev, read_adapter_memory);
-  if (!res)
-    for (i = 0; i < count; ++i)
-      if (tb->data[i] != cpu_to_be32 (data[i])) {
-	res = -EINVAL;
-	break;
-      }
+  if (!res && memcmp(tb->data, rec->data, rec->len))
+    res = -EINVAL;
   return res;
 }
 
@@ -1962,47 +1930,53 @@ static int amb_reset (amb_dev * dev, int diags) {
 /********** transfer and start the microcode **********/
 
 static int __devinit ucode_init (loader_block * lb, amb_dev * dev) {
-  unsigned int i = 0;
-  unsigned int total = 0;
-  const u32 * pointer = ucode_data;
-  u32 address;
-  unsigned int count;
+  const struct firmware *fw;
+  unsigned long start_address;
+  const struct ihex_binrec *rec;
   int res;
   
+  res = request_ihex_firmware(&fw, "atmsar11.fw", &dev->pci_dev->dev);
+  if (res) {
+    PRINTK (KERN_ERR, "Cannot load microcode data");
+    return res;
+  }
+
+  /* First record contains just the start address */
+  rec = (const struct ihex_binrec *)fw->data;
+  if (rec->len != sizeof(__be32) || be32_to_cpu(rec->addr)) {
+    PRINTK (KERN_ERR, "Bad microcode data (no start record)");
+    return -EINVAL;
+  }
+  start_address = *(__be32 *)rec->data;
+
+  rec = ihex_next_binrec(rec);
+
   PRINTD (DBG_FLOW|DBG_LOAD, "ucode_init");
-  
-  while (address = ucode_regions[i].start,
-	 count = ucode_regions[i].count) {
-    PRINTD (DBG_LOAD, "starting region (%x, %u)", address, count);
-    while (count) {
-      unsigned int words;
-      if (count <= MAX_TRANSFER_DATA)
-	words = count;
-      else
-	words = MAX_TRANSFER_DATA;
-      total += words;
-      res = loader_write (lb, dev, pointer, address, words);
-      if (res)
-	return res;
-      res = loader_verify (lb, dev, pointer, address, words);
-      if (res)
-	return res;
-      count -= words;
-      address += sizeof(u32) * words;
-      pointer += words;
+
+  while (rec) {
+    PRINTD (DBG_LOAD, "starting region (%x, %u)", be32_to_cpu(rec->addr),
+	    rec->len);
+    if (rec->len > 4 * MAX_TRANSFER_DATA) {
+	    PRINTK (KERN_ERR, "Bad microcode data (record too long)");
+	    return -EINVAL;
     }
-    i += 1;
-  }
-  if (*pointer == ATM_POISON) {
-    return loader_start (lb, dev, ucode_start);
-  } else {
-    // cast needed as there is no %? for pointer differnces
-    PRINTD (DBG_LOAD|DBG_ERR,
-	    "offset=%li, *pointer=%x, address=%x, total=%u",
-	    (long) (pointer - ucode_data), *pointer, address, total);
-    PRINTK (KERN_ERR, "incorrect microcode data");
-    return -ENOMEM;
+    if (rec->len & 3) {
+	    PRINTK (KERN_ERR, "Bad microcode data (odd number of bytes)");
+	    return -EINVAL;
+    }
+    res = loader_write(lb, dev, rec);
+    if (res)
+      break;
+
+    res = loader_verify(lb, dev, rec);
+    if (res)
+      break;
   }
+  release_firmware(fw);
+  if (!res)
+    res = loader_start(lb, dev, start_address);
+
+  return res;
 }
 
 /********** give adapter parameters **********/
diff --git a/drivers/atm/ambassador.h b/drivers/atm/ambassador.h
index df55fa8..bd1c46a 100644
--- a/drivers/atm/ambassador.h
+++ b/drivers/atm/ambassador.h
@@ -656,17 +656,6 @@ typedef struct amb_dev amb_dev;
 #define AMB_DEV(atm_dev) ((amb_dev *) (atm_dev)->dev_data)
 #define AMB_VCC(atm_vcc) ((amb_vcc *) (atm_vcc)->dev_data)
 
-/* the microcode */
-
-typedef struct {
-  u32 start;
-  unsigned int count;
-} region;
-
-static region ucode_regions[];
-static u32 ucode_data[];
-static u32 ucode_start;
-
 /* rate rounding */
 
 typedef enum {
diff --git a/drivers/atm/atmsar11.data b/drivers/atm/atmsar11.data
deleted file mode 100644
index 5dc8a76..0000000
--- a/drivers/atm/atmsar11.data
+++ /dev/null
@@ -1,2063 +0,0 @@
-/*
-  Madge Ambassador ATM Adapter microcode.
-  Copyright (C) 1995-1999  Madge Networks Ltd.
-  
-  This microcode data is placed under the terms of the GNU General
-  Public License. The GPL is contained in /usr/doc/copyright/GPL on a
-  Debian system and in the file COPYING in the Linux kernel source.
-  
-  We would prefer you not to distribute modified versions without
-  consultation and not to ask for assembly/other microcode source.
-*/
-
-  0x401a6800,
-  0x00000000,
-  0x335b007c,
-  0x13600005,
-  0x335b1000,
-  0x3c1aa0c0,
-  0x375a0180,
-  0x03400008,
-  0x00000000,
-  0x1760fffb,
-  0x335b4000,
-  0x401a7000,
-  0x13600003,
-  0x241b0fc0,
-  0xaf9b4500,
-  0x25080008,
-  0x03400008,
-  0x42000010,
-  0x8f810c90,
-  0x32220002,
-  0x10400003,
-  0x3c03a0d1,
-  0x2463f810,
-  0x0060f809,
-  0x24210001,
-  0x1000001a,
-  0xaf810c90,
-  0x82020011,
-  0xaf900c48,
-  0x0441000a,
-  0x34420080,
-  0x967d0002,
-  0x96020012,
-  0x00000000,
-  0x105d0011,
-  0x00000000,
-  0x04110161,
-  0xa6620002,
-  0x1000000d,
-  0xae62000c,
-  0x34848000,
-  0xa2020011,
-  0x4d01ffff,
-  0x00000000,
-  0x8f834c00,
-  0x00000000,
-  0xaf830fec,
-  0x00e0f809,
-  0x03e03821,
-  0x00041400,
-  0x0440fff7,
-  0x00000000,
-  0xaf80460c,
-  0x8e100008,
-  0x4d01ffff,
-  0x00000000,
-  0x8f834c00,
-  0x4900001d,
-  0xaf830fec,
-  0x8f820cbc,
-  0x8f9d0c4c,
-  0x24420001,
-  0x97be0000,
-  0xaf820cbc,
-  0x13c00009,
-  0xaca200d8,
-  0xa7a00000,
-  0x3c0100d1,
-  0x003e0825,
-  0x9422002c,
-  0x0411013f,
-  0xa4220002,
-  0xac22000c,
-  0xac200010,
-  0x8f9e0c54,
-  0x27bd0002,
-  0x17be0002,
-  0x8ca200c0,
-  0x8f9d0c50,
-  0x8f970fc8,
-  0xaf9d0c4c,
-  0x12e20005,
-  0x87804002,
-  0x3c02a0d1,
-  0x2442f94c,
-  0x0040f809,
-  0x00000000,
-  0x00e0f809,
-  0x03e03821,
-  0x4500ffdc,
-  0x8e11000c,
-  0x3c1300d1,
-  0x00111102,
-  0x2c430400,
-  0x1060ffb9,
-  0x00021180,
-  0x02629821,
-  0x8e76003c,
-  0x32220008,
-  0x1440ffb7,
-  0x8e770034,
-  0x8e750030,
-  0x3c03cfb0,
-  0x16c00003,
-  0x02d5102b,
-  0x041100be,
-  0x00000000,
-  0x1040ffa6,
-  0x00701826,
-  0x4d01ffff,
-  0x00000000,
-  0x8f824c00,
-  0xaf974c00,
-  0xaf820fec,
-  0xac760010,
-  0x02609021,
-  0x32220002,
-  0x10400007,
-  0x8f944a00,
-  0x9602003a,
-  0x34840004,
-  0x14400003,
-  0xaf820fbc,
-  0x3c029000,
-  0xaf820fbc,
-  0x8e100008,
-  0x32943f00,
-  0x8e11000c,
-  0x2694ff00,
-  0x12800073,
-  0x3c1300d1,
-  0x49010071,
-  0x32370008,
-  0x16e0006f,
-  0x00111102,
-  0x2c430400,
-  0x1060006c,
-  0x0002b980,
-  0x00041740,
-  0x0440003a,
-  0x02779821,
-  0x12720023,
-  0x26d60030,
-  0xae56003c,
-  0x8e76003c,
-  0x8e770034,
-  0x8e750030,
-  0x3c03cfb0,
-  0x16c00003,
-  0x02d5102b,
-  0x04110091,
-  0x00000000,
-  0x10400060,
-  0x2e821000,
-  0x14400009,
-  0x00701826,
-  0x4d01ffff,
-  0x00000000,
-  0x8f824c00,
-  0xaf974c00,
-  0xac760010,
-  0xae420034,
-  0x1000ffd0,
-  0xaf80460c,
-  0x00e0f809,
-  0x03e03821,
-  0x3c03cfb0,
-  0x00701826,
-  0xae460034,
-  0x4d01ffff,
-  0x00000000,
-  0x8f824c00,
-  0xaf974c00,
-  0xaf820fec,
-  0xac760010,
-  0x1000ffc3,
-  0xaf80460c,
-  0x02d5102b,
-  0x10400042,
-  0x3c17cfb0,
-  0x2e821000,
-  0x14400006,
-  0x02f0b826,
-  0x4d01ffff,
-  0x00000000,
-  0xaef60010,
-  0x1000ffb8,
-  0xaf80460c,
-  0x00e0f809,
-  0x03e03821,
-  0x4d01ffff,
-  0x00000000,
-  0x8f824c00,
-  0xaf864c00,
-  0xaef60010,
-  0xaf820fec,
-  0x1000ffae,
-  0xaf80460c,
-  0x3084fffb,
-  0x8e570038,
-  0x3242ffc0,
-  0x00021182,
-  0xa7820fb8,
-  0xaf970fb4,
-  0x865d002a,
-  0x865e0008,
-  0xa79d0fba,
-  0x279d0f18,
-  0x33de0060,
-  0x03bee821,
-  0x001ef0c2,
-  0x03bee821,
-  0x8f970c58,
-  0x4d01ffff,
-  0x00000000,
-  0x8f834c00,
-  0x8fa2001c,
-  0x12e30003,
-  0x3c030c40,
-  0x3c1ec000,
-  0xaf9e0fbc,
-  0xac620fb4,
-  0x8fa30018,
-  0x2442000c,
-  0x14430002,
-  0xaf80460c,
-  0x8fa20014,
-  0xae40003c,
-  0xafa2001c,
-  0x8e76003c,
-  0x8e770034,
-  0x8e750030,
-  0x3c03cfb0,
-  0x16c00003,
-  0x02d5102b,
-  0x0411003c,
-  0x00000000,
-  0x00701826,
-  0x4d01ffff,
-  0x00000000,
-  0xaca500e4,
-  0x10400032,
-  0xaf974c00,
-  0x1000ff7f,
-  0xac760010,
-  0x00041740,
-  0x04400007,
-  0x26d60030,
-  0xae56003c,
-  0x00e0f809,
-  0x03e03821,
-  0xaf80460c,
-  0x1000ff39,
-  0xae460034,
-  0x8e570038,
-  0x3242ffc0,
-  0x00021182,
-  0xa7820fb8,
-  0xaf970fb4,
-  0x8f970c58,
-  0x00e0f809,
-  0x03e03821,
-  0x12e60003,
-  0x3c030c40,
-  0x3c02c000,
-  0xaf820fbc,
-  0x865d002a,
-  0x865e0008,
-  0xa79d0fba,
-  0x279d0f18,
-  0x33de0060,
-  0x03bee821,
-  0x001ef0c2,
-  0x03bee821,
-  0x8fa2001c,
-  0x4d01ffff,
-  0x00000000,
-  0x8f974c00,
-  0xac620fb4,
-  0x3084fffb,
-  0x8fa30018,
-  0x2442000c,
-  0x14430002,
-  0xaf80460c,
-  0x8fa20014,
-  0xae40003c,
-  0xafa2001c,
-  0x4d01ffff,
-  0x00000000,
-  0xaca500e4,
-  0x1000ff13,
-  0xaf974c00,
-  0x00e0f809,
-  0x03e03821,
-  0x1000ff0f,
-  0x00000000,
-  0x1040005b,
-  0x867e0008,
-  0x279d0f18,
-  0x33de0060,
-  0x03bee821,
-  0x001e10c2,
-  0x03a2e821,
-  0x8fb70008,
-  0x8fa2000c,
-  0x8ef60004,
-  0x12e20028,
-  0x86620008,
-  0x82030010,
-  0x00021740,
-  0x04410019,
-  0x24630001,
-  0x10600017,
-  0x3c02d1b0,
-  0x00501026,
-  0x4d01ffff,
-  0x00000000,
-  0x8f9e4c00,
-  0xac560010,
-  0x26d6fffe,
-  0x86020010,
-  0x3c03cfb0,
-  0x34632000,
-  0xa662002a,
-  0x8ee20000,
-  0x26f70008,
-  0xae620038,
-  0x8fa20020,
-  0xafb70008,
-  0x2417ffff,
-  0x02c2a821,
-  0x4d01ffff,
-  0x00000000,
-  0xaf9e4c00,
-  0x03e00008,
-  0xae750030,
-  0x8ee20000,
-  0x26f70008,
-  0xae620038,
-  0x8fa20020,
-  0xafb70008,
-  0x2417ffff,
-  0xa677002a,
-  0x02c2a821,
-  0x3c03cfb0,
-  0x03e00008,
-  0xae750030,
-  0x001e18c2,
-  0x00651821,
-  0x8c6300c8,
-  0x8fa20010,
-  0x00000000,
-  0x0062b023,
-  0x1ec00003,
-  0x8fa10004,
-  0x12c0001b,
-  0x0022b023,
-  0x2ec30041,
-  0x14600002,
-  0x3c150040,
-  0x24160040,
-  0x00161e80,
-  0x00031882,
-  0x00751825,
-  0x4d01ffff,
-  0x00000000,
-  0x8f954c00,
-  0x001eb840,
-  0x00771821,
-  0xac624d00,
-  0x00561021,
-  0x14410002,
-  0x27830d00,
-  0x8fa20000,
-  0x02e3b821,
-  0xafa20010,
-  0x02d71821,
-  0xafa3000c,
-  0x4d01ffff,
-  0x00000000,
-  0x8ef60004,
-  0x1000ffb5,
-  0xaf954c00,
-  0x3c16dead,
-  0xae76003c,
-  0xae600038,
-  0x26d5ffff,
-  0x00001021,
-  0x03e00008,
-  0xae750030,
-  0x2c430ab2,
-  0x10600005,
-  0x2c4324b2,
-  0x10000004,
-  0x24020ab2,
-  0x10000002,
-  0x240224b1,
-  0x1060fffd,
-  0x304301ff,
-  0x00031840,
-  0x3c1da0d1,
-  0x27bdd6cc,
-  0x007d1821,
-  0x94630000,
-  0x0002ea42,
-  0x00031c00,
-  0x27bdfffb,
-  0x03e00008,
-  0x03a31006,
-  0x24030fc0,
-  0xaf834500,
-  0x10000002,
-  0x01206021,
-  0x3c0ccfb0,
-  0x11e00056,
-  0x01896026,
-  0x85fe0000,
-  0x00000000,
-  0x13c00047,
-  0x3c02cfb0,
-  0x07c0002d,
-  0x001e1f80,
-  0x04610034,
-  0x001e1fc0,
-  0x04600009,
-  0x3c02d3b0,
-  0x00e0f809,
-  0x03e03821,
-  0x4d01ffff,
-  0x00000000,
-  0x8f864c00,
-  0x8f990fec,
-  0x1000000b,
-  0xaf994c00,
-  0x01e27826,
-  0x00e0f809,
-  0x03e03821,
-  0x4d01ffff,
-  0x00000000,
-  0x8f864c00,
-  0xaf994c00,
-  0xadef2010,
-  0x3c02d3b0,
-  0x01e27826,
-  0x8f820fc0,
-  0x8f830fc4,
-  0xaf824d00,
-  0x8de20004,
-  0xa5e00000,
-  0xac620000,
-  0x8c620000,
-  0x24020380,
-  0xaf824d00,
-  0x8f824d00,
-  0x8f820f14,
-  0x24630004,
-  0x14620002,
-  0x2419ffff,
-  0x8f830f10,
-  0xaca500e4,
-  0xaf830fc4,
-  0x4d01ffff,
-  0x00000000,
-  0x8f824c80,
-  0x1000001f,
-  0xade2003c,
-  0x00e0f809,
-  0x03e03821,
-  0x4d01ffff,
-  0x00000000,
-  0xa5e00000,
-  0x8f864c00,
-  0x15800022,
-  0xaf8f4540,
-  0x10000017,
-  0x01e27826,
-  0x00e0f809,
-  0x03e03821,
-  0x4d01ffff,
-  0x00000000,
-  0x8f864c00,
-  0xaf994c00,
-  0xadef2010,
-  0x3c02cfb0,
-  0x01e27826,
-  0xa5e00000,
-  0x4d01ffff,
-  0x00000000,
-  0x10000007,
-  0x8f994c00,
-  0x00e0f809,
-  0x03e03821,
-  0x4d01ffff,
-  0x00000000,
-  0x8f864c00,
-  0x8f990fec,
-  0x1580000a,
-  0xaf8f4500,
-  0x00007821,
-  0x10000014,
-  0xaf190014,
-  0x00e0f809,
-  0x03e03821,
-  0x4d01ffff,
-  0x00000000,
-  0x1180fff8,
-  0x8f864c00,
-  0x85220000,
-  0x01207821,
-  0x0440000a,
-  0x8d290008,
-  0x130b0004,
-  0x000c1602,
-  0xaf190014,
-  0x8d790014,
-  0x0160c021,
-  0xaf994c00,
-  0xad8e4010,
-  0x3042003f,
-  0x01c27021,
-  0x00041780,
-  0x0440018b,
-  0x8f824a00,
-  0x30818000,
-  0x30420004,
-  0x1440ff8d,
-  0x8d4b0000,
-  0x1020000c,
-  0x30847fff,
-  0x8f820c48,
-  0x0120f021,
-  0x24430034,
-  0x8c5d000c,
-  0x24420004,
-  0xafdd000c,
-  0x1462fffc,
-  0x27de0004,
-  0xa5210000,
-  0x1000ff82,
-  0x25080008,
-  0x11600058,
-  0x00000000,
-  0x857d0008,
-  0x8d63000c,
-  0x9562000a,
-  0x8d410004,
-  0x07a10026,
-  0x00621821,
-  0xa563000a,
-  0x00031c02,
-  0x041101a0,
-  0x000318c0,
-  0x001d16c0,
-  0x0441001f,
-  0x27a20080,
-  0x00021cc0,
-  0x0461000e,
-  0x0040e821,
-  0x27bd0080,
-  0x95620000,
-  0x95630002,
-  0x3442000c,
-  0xad22000c,
-  0x24020100,
-  0xa5220010,
-  0x9562002c,
-  0xa5230014,
-  0xa5220012,
-  0xa5200016,
-  0x34028000,
-  0xa5220000,
-  0xa57d0008,
-  0x07a0000c,
-  0x8f820c4c,
-  0x8f830c50,
-  0x2441ffe8,
-  0x0023f02b,
-  0x13c00002,
-  0x00201021,
-  0x24420400,
-  0x945e0000,
-  0x2441fffe,
-  0x17c0fff9,
-  0xad620010,
-  0xa44b0000,
-  0x142b001c,
-  0xad400000,
-  0xad400004,
-  0x254a0008,
-  0x3142007f,
-  0x1440000e,
-  0x00041780,
-  0x04410003,
-  0x8f820fe0,
-  0x10000006,
-  0x34840001,
-  0x34840002,
-  0x24420008,
-  0x34421000,
-  0x38421000,
-  0xaf820fe0,
-  0x354a0100,
-  0x394a0100,
-  0x39420080,
-  0xaf820fe4,
-  0x001d14c0,
-  0x04410003,
-  0x33a2efff,
-  0x1000ff3c,
-  0xa5620008,
-  0x07a0009f,
-  0x33a2fffe,
-  0x10000021,
-  0xa5620008,
-  0x8d620024,
-  0x001d1cc0,
-  0x04610004,
-  0xad420000,
-  0x33a3efff,
-  0x1000ff31,
-  0xa5630008,
-  0x07a00005,
-  0x33a3fffe,
-  0xa5630008,
-  0x8d4b0000,
-  0x1000ffaa,
-  0x00000000,
-  0x1000008e,
-  0x25080008,
-  0x254a0008,
-  0x3142007f,
-  0x1440000e,
-  0x00041780,
-  0x04410003,
-  0x8f820fe0,
-  0x10000006,
-  0x34840001,
-  0x34840002,
-  0x24420008,
-  0x34421000,
-  0x38421000,
-  0xaf820fe0,
-  0x354a0100,
-  0x394a0100,
-  0x39420080,
-  0xaf820fe4,
-  0x11000003,
-  0x8d4b0000,
-  0x1000ff93,
-  0x2508fff8,
-  0x8f820fd8,
-  0x8f830fdc,
-  0x8f810fd4,
-  0x1062001d,
-  0x24620008,
-  0x4d01ffff,
-  0x00000000,
-  0x8f8c4c00,
-  0x847f0000,
-  0x3c1e00d1,
-  0x33fd03ff,
-  0x001d5980,
-  0x017e5821,
-  0x857e0008,
-  0x001de900,
-  0x001e0f00,
-  0x03e1f825,
-  0x07e00003,
-  0xaf820fdc,
-  0x879e0ca0,
-  0x278b0c98,
-  0x07c10042,
-  0x3c020840,
-  0x3c01f7b0,
-  0x8d620020,
-  0x00230826,
-  0xac220000,
-  0x8c620004,
-  0x94630002,
-  0x2442fff8,
-  0x00431021,
-  0x1000004e,
-  0xad620020,
-  0x8f820fd0,
-  0x87830ca0,
-  0x14220007,
-  0x278b0c98,
-  0x41000051,
-  0x3c018000,
-  0xaca100e0,
-  0x8ca100c4,
-  0x00000000,
-  0x1022004c,
-  0x0022e823,
-  0x8f9f0f0c,
-  0x07a10002,
-  0xaf810fd4,
-  0x03e2e823,
-  0x2fa30041,
-  0x14600002,
-  0x3c1e0040,
-  0x241d0040,
-  0x001d1e80,
-  0x00031882,
-  0x007e1825,
-  0x4d01ffff,
-  0x00000000,
-  0x8f8c4c00,
-  0xac624cc0,
-  0x005d1021,
-  0x145f0002,
-  0x27830cc0,
-  0x8f820f08,
-  0x03a3f021,
-  0xaf820fd0,
-  0xaf9e0fd8,
-  0x4d01ffff,
-  0x00000000,
-  0x1000ffc3,
-  0x24620008,
-  0x8d63000c,
-  0x8d7d0010,
-  0xa563000a,
-  0x13a00002,
-  0x00031c02,
-  0xa7a00000,
-  0x000318c0,
-  0x041100ef,
-  0x00681821,
-  0x4d01ffff,
-  0x00000000,
-  0x8f820c44,
-  0x8f830c40,
-  0xad620010,
-  0xa5630004,
-  0xa5630006,
-  0x10000021,
-  0xaf8c4c00,
-  0xa57d0000,
-  0x8c7d0004,
-  0x94630002,
-  0xac5d4c40,
-  0x27a20008,
-  0xad620018,
-  0x03a3e821,
-  0x27bdfff4,
-  0xad7d001c,
-  0x27bd0004,
-  0xad7d0020,
-  0x37c18001,
-  0x001e17c0,
-  0x0441ffe0,
-  0xa5610008,
-  0x4d01ffff,
-  0x00000000,
-  0x8f820c44,
-  0x8f830c40,
-  0xad620010,
-  0xa5630004,
-  0xa5630006,
-  0x8f820fd8,
-  0x8f830fdc,
-  0x4d01ffff,
-  0x00000000,
-  0x1462ff95,
-  0x24620008,
-  0xaf8c4c00,
-  0x87830ca0,
-  0x278b0c98,
-  0x0461fe97,
-  0x00041700,
-  0x04400005,
-  0x95620000,
-  0x11780006,
-  0x00000000,
-  0xaf0e0010,
-  0xa70d0004,
-  0x3084fff7,
-  0x956d0004,
-  0x8d6e0010,
-  0x25adffd0,
-  0x05a1fe8f,
-  0xad22000c,
-  0x3c0cffb0,
-  0x01896026,
-  0x000d1822,
-  0x25ad0030,
-  0x8d7e0018,
-  0x8d61001c,
-  0x4d01ffff,
-  0x00000000,
-  0x103e0036,
-  0x8f9d4c00,
-  0x3c010840,
-  0xac3e4c40,
-  0x27de0008,
-  0x11a00017,
-  0xad7e0018,
-  0x000df600,
-  0x019e6025,
-  0x4d01ffff,
-  0x00000000,
-  0xad8e4010,
-  0x8f8d0c40,
-  0x957e0006,
-  0x8f8e0c44,
-  0x03cdf021,
-  0xa57e0006,
-  0x000cf782,
-  0x000c0e02,
-  0x03c1f021,
-  0x001e0f80,
-  0x000c6200,
-  0x000c6202,
-  0x01816025,
-  0x33de003c,
-  0x019e6021,
-  0x34010001,
-  0x10000008,
-  0xa5210000,
-  0x957e0006,
-  0x4d01ffff,
-  0x00000000,
-  0x8f8d0c40,
-  0x8f8e0c44,
-  0x03cdf021,
-  0xa57e0006,
-  0x4d01ffff,
-  0x00000000,
-  0x01a3f02b,
-  0x17c00008,
-  0x0003f600,
-  0x01a36823,
-  0x019e6025,
-  0x01896026,
-  0x4d01fff7,
-  0x00000000,
-  0x1000fe58,
-  0xaf9d4c00,
-  0x8d7e0018,
-  0x8d61001c,
-  0x00000000,
-  0x143effce,
-  0x006d1823,
-  0x4d01ffff,
-  0x00000000,
-  0x2c610008,
-  0x10200017,
-  0x95610008,
-  0x00000000,
-  0x0001ff80,
-  0x07e0000b,
-  0x34210002,
-  0x006d1821,
-  0x00031e00,
-  0x01836025,
-  0x01896026,
-  0x240d002c,
-  0xa5610008,
-  0x4d01ffff,
-  0x00000000,
-  0x1000fe40,
-  0xaf9d4c00,
-  0x3c1f0c40,
-  0xaffe4fa8,
-  0x3021fffd,
-  0xa5610008,
-  0x3c0cd3cf,
-  0x358ce000,
-  0x10000008,
-  0x34030002,
-  0x3c1f0c40,
-  0xaffe4fa8,
-  0x11a0fff9,
-  0x000df600,
-  0x34030003,
-  0x019e6025,
-  0x01896026,
-  0x34840008,
-  0x34420002,
-  0xad22000c,
-  0x95620006,
-  0xa5230000,
-  0xad220038,
-  0x4d01ffff,
-  0x00000000,
-  0x857e0008,
-  0x8f820fa8,
-  0x97830fac,
-  0xad220004,
-  0x33c17fff,
-  0xad600010,
-  0xa5610008,
-  0x1060fe20,
-  0xaf9d4c00,
-  0xa57e0008,
-  0x00031900,
-  0x30633ff0,
-  0xa5630000,
-  0x8f820fb0,
-  0x3c030840,
-  0xac624c40,
-  0x24430008,
-  0xad630018,
-  0x97830fae,
-  0x2442fff4,
-  0x00621821,
-  0xad63001c,
-  0x4d01ffff,
-  0x00000000,
-  0x8f8d0c40,
-  0x8f830c44,
-  0xa56d0004,
-  0xa56d0006,
-  0xad630010,
-  0x1000fe0a,
-  0xaf9d4c00,
-  0x8f820fe0,
-  0x00040fc0,
-  0x8c430000,
-  0x0421001b,
-  0x8f9f0fe4,
-  0x8c5d0004,
-  0xac400004,
-  0x1060000e,
-  0xac400000,
-  0x00000000,
-  0x94620028,
-  0x00000000,
-  0x005f1020,
-  0x8c410004,
-  0x00000000,
-  0x10200003,
-  0xac430004,
-  0x10000002,
-  0xac230024,
-  0xac430000,
-  0x17a3fff4,
-  0x8c630024,
-  0x8f820fe0,
-  0x3bff0080,
-  0x24420008,
-  0x34421000,
-  0x38421000,
-  0xaf820fe0,
-  0xaf9f0fe4,
-  0x1000fe57,
-  0x3084fffe,
-  0x10600010,
-  0x00000000,
-  0x947d0028,
-  0x00000000,
-  0x03bfe820,
-  0x8fa10004,
-  0xafa30004,
-  0x10200003,
-  0x8c5e0004,
-  0x10000002,
-  0xac230024,
-  0xafa30000,
-  0x8c610024,
-  0x17c3fe48,
-  0xac410000,
-  0xac400004,
-  0xac400000,
-  0x1000fe44,
-  0x3084fffd,
-  0x2c620100,
-  0x1440000e,
-  0x006a1021,
-  0x3143007f,
-  0x01431823,
-  0x00431823,
-  0x3062007f,
-  0xa5620028,
-  0x00621823,
-  0x00031902,
-  0x8f820fe0,
-  0x2463fff8,
-  0x00621821,
-  0x34631000,
-  0x10000003,
-  0x38631000,
-  0x34430100,
-  0x38630100,
-  0x8c620004,
-  0x00000000,
-  0x10400003,
-  0xac6b0004,
-  0x03e00008,
-  0xac4b0024,
-  0x03e00008,
-  0xac6b0000,
-  0x00000002,
-  0xa0d0e000,
-  0x00000000,
-  0x00001000,
-  0x00000006,
-  0x00000008,
-  0x00000000,
-  0x00000008,
-  0x00000002,
-  0xa0d0d648,
-  0x00000000,
-  0x00000888,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x24313200,
-  0x24313200,
-  0x24313200,
-  0x00000000,
-  0x244d4352,
-  0x2420436f,
-  0x70797269,
-  0x67687420,
-  0x28632920,
-  0x4d616467,
-  0x65204e65,
-  0x74776f72,
-  0x6b73204c,
-  0x74642031,
-  0x3939352e,
-  0x20416c6c,
-  0x20726967,
-  0x68747320,
-  0x72657365,
-  0x72766564,
-  0x2e004d61,
-  0x64676520,
-  0x416d6261,
-  0x73736164,
-  0x6f722076,
-  0x312e3031,
-  0x00000000,
-  0x00000001,
-  0x00000001,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0xfff04000,
-  0x00000000,
-  0x0c343e2d,
-  0x00000000,
-  0x3c1ca0d1,
-  0x279c5638,
-  0x3c1da0d1,
-  0x27bddfd0,
-  0x3c08a0d1,
-  0x2508dfd0,
-  0xaf878008,
-  0x0c343c13,
-  0x00000000,
-  0x24040003,
-  0x0097000d,
-  0x3c08bfc0,
-  0x35080230,
-  0x8d080000,
-  0x00000000,
-  0x01000008,
-  0x00000000,
-  0x27bdffd0,
-  0xafbf001c,
-  0xafb10018,
-  0xafb00014,
-  0x3c11fff0,
-  0x00008021,
-  0x3c180056,
-  0x37183b79,
-  0x26190200,
-  0x17200002,
-  0x0319001a,
-  0x0007000d,
-  0x2401ffff,
-  0x17210005,
-  0x00000000,
-  0x3c018000,
-  0x17010002,
-  0x00000000,
-  0x0006000d,
-  0x00001012,
-  0x00101840,
-  0x3c05a0d1,
-  0x24a5d6cc,
-  0x00a32021,
-  0xa4820000,
-  0x26100001,
-  0x2a010200,
-  0x1420ffea,
-  0x00000000,
-  0x3c06a0d1,
-  0x24c6f9e4,
-  0x3c07a0d1,
-  0x24e7d648,
-  0xace60000,
-  0x3c08a0d1,
-  0x2508fb14,
-  0xace80004,
-  0x3c09a0d1,
-  0x2529fc94,
-  0xace90008,
-  0x3c0aa0d1,
-  0x254afcd4,
-  0xacea000c,
-  0x3c0ba0d1,
-  0x256bfba8,
-  0xaceb0010,
-  0x3c0ca0d1,
-  0x258cfbc4,
-  0xacec0014,
-  0x3c0da0d1,
-  0x25adfbe0,
-  0xaced0018,
-  0x3c0ea0d1,
-  0x25cefbfc,
-  0xacee001c,
-  0x3c0fa0d1,
-  0x25effc18,
-  0xacef0020,
-  0x3c18a0d1,
-  0x2718fc34,
-  0xacf80024,
-  0x3c19a0d1,
-  0x2739fc50,
-  0xacf90028,
-  0x3c02a0d1,
-  0x2442fc60,
-  0xace2002c,
-  0x3c03a0d1,
-  0x2463fc70,
-  0xace30030,
-  0x3c04a0d1,
-  0x2484fc80,
-  0xace40034,
-  0x3c05a0d1,
-  0x24a5fcb4,
-  0xace50038,
-  0x3c06a0d1,
-  0x24c6fe08,
-  0xace6003c,
-  0x3c08a0d1,
-  0x2508fe90,
-  0xace80040,
-  0x3c09a0d1,
-  0x2529fa38,
-  0xace90044,
-  0x3c0aa0d1,
-  0x254afa74,
-  0xacea0048,
-  0x24100013,
-  0x3c0ba0d1,
-  0x256bf9d8,
-  0x00106080,
-  0x3c0ea0d1,
-  0x25ced648,
-  0x01cc6821,
-  0xadab0000,
-  0x26100001,
-  0x2a010020,
-  0x1420fff6,
-  0x00000000,
-  0x8f988000,
-  0x00000000,
-  0xaf000100,
-  0x8f828000,
-  0x241903ff,
-  0xa4590202,
-  0x00008021,
-  0x8f868000,
-  0x24030fff,
-  0x00102040,
-  0x24c70380,
-  0x00e42821,
-  0xa4a30000,
-  0x26100001,
-  0x2a010008,
-  0x1420fff7,
-  0x00000000,
-  0x8f898000,
-  0x34089c40,
-  0xad2803a0,
-  0x8f8b8000,
-  0x3c0a00ff,
-  0x354affff,
-  0xad6a03a4,
-  0x00008021,
-  0x8f8f8000,
-  0x240c0fff,
-  0x00106840,
-  0x25f80300,
-  0x030d7021,
-  0xa5cc0000,
-  0x26100001,
-  0x2a010008,
-  0x1420fff7,
-  0x00000000,
-  0x8f828000,
-  0x34199c40,
-  0xac590320,
-  0x8f848000,
-  0x3c0300ff,
-  0x3463ffff,
-  0xac830324,
-  0x8f868000,
-  0x240502ff,
-  0xa4c50202,
-  0x3c08a0c0,
-  0x35080180,
-  0x3c09a0d1,
-  0x2529d5b8,
-  0x250a0028,
-  0x8d0b0000,
-  0x8d0c0004,
-  0xad2b0000,
-  0xad2c0004,
-  0x25080008,
-  0x150afffa,
-  0x25290008,
-  0x40026000,
-  0x00000000,
-  0xafa20028,
-  0x24030022,
-  0x3c04a0e0,
-  0x34840014,
-  0xac830000,
-  0x8fa50028,
-  0x00000000,
-  0x34a61001,
-  0x00c01021,
-  0xafa60028,
-  0x3c07ffbf,
-  0x34e7ffff,
-  0x00c73824,
-  0x00e01021,
-  0xafa70028,
-  0x40876000,
-  0x00000000,
-  0x3c080002,
-  0x3508d890,
-  0x3c09fffe,
-  0x35290130,
-  0xad280000,
-  0x8faa0028,
-  0x3c0bf000,
-  0x014b5825,
-  0x01601021,
-  0xafab0028,
-  0x01606021,
-  0x408c6000,
-  0x00000000,
-  0x00008021,
-  0x00107080,
-  0x022e7821,
-  0xade00000,
-  0x26100001,
-  0x2a010400,
-  0x1420fffa,
-  0x00000000,
-  0x24180001,
-  0x3c19a0e8,
-  0xaf380000,
-  0x24020011,
-  0x3c03a0f0,
-  0x34630017,
-  0xa0620000,
-  0x3c04f0eb,
-  0x34840070,
-  0x3c05fff0,
-  0x34a54a00,
-  0xaca40000,
-  0x3c06fceb,
-  0x34c60070,
-  0xaca60000,
-  0x3c07fff0,
-  0x34e74700,
-  0xace00000,
-  0x00008021,
-  0x3c08fff0,
-  0x35080fc0,
-  0x3c09fff0,
-  0x35294500,
-  0xad280000,
-  0x26100001,
-  0x2a010004,
-  0x1420fff8,
-  0x00000000,
-  0x00008021,
-  0x3c0adead,
-  0x00105980,
-  0x3c0100d1,
-  0x002b0821,
-  0xac2a003c,
-  0x3c0100d1,
-  0x002b0821,
-  0xac200030,
-  0x3c0100d1,
-  0x002b0821,
-  0xac200038,
-  0x240dffff,
-  0x3c0100d1,
-  0x002b0821,
-  0xac2d0014,
-  0x00107100,
-  0x3c0100d1,
-  0x002b0821,
-  0xa42e0000,
-  0x3c0100d1,
-  0x002b0821,
-  0xa4200004,
-  0x24180020,
-  0x3c0100d1,
-  0x002b0821,
-  0xa4380008,
-  0x3c0100d1,
-  0x002b0821,
-  0xac200010,
-  0x26100001,
-  0x2a010400,
-  0x1420ffe0,
-  0x00000000,
-  0x00008021,
-  0x001018c0,
-  0x3c05a0d1,
-  0x24a5e000,
-  0x00a32021,
-  0xac800000,
-  0x3c07a0d1,
-  0x24e7e000,
-  0x24e80004,
-  0x01033021,
-  0xacc00000,
-  0x26100001,
-  0x2a010009,
-  0x1420fff3,
-  0x00000000,
-  0x24090380,
-  0x3c0afff0,
-  0x354a4d00,
-  0xad490000,
-  0x3c0ca080,
-  0x358c009c,
-  0xad800000,
-  0x3c0da080,
-  0x35ad00a0,
-  0xada00000,
-  0x3c0e1100,
-  0x3c0fa080,
-  0x35ef00a8,
-  0xadee0000,
-  0x41010003,
-  0x00000000,
-  0x4100ffff,
-  0x00000000,
-  0x3c18a080,
-  0x371800e0,
-  0x8f190000,
-  0x3c01a0d1,
-  0xac39d6c8,
-  0x0c343d43,
-  0x03202021,
-  0x8fb00014,
-  0x8fbf001c,
-  0x8fb10018,
-  0x03e00008,
-  0x27bd0030,
-  0x0080b821,
-  0x3c1cfff0,
-  0xa3800c84,
-  0xa3800c88,
-  0x8f904400,
-  0x00002021,
-  0xaf800cbc,
-  0x240200a8,
-  0x27830f00,
-  0x2c5d0040,
-  0x17a0000c,
-  0x3c1dffb0,
-  0x03a3e826,
-  0xafb74000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x4d01ffff,
-  0x00000000,
-  0x2442ffc0,
-  0x24630040,
-  0x1000fff3,
-  0x26f70040,
-  0x1040000d,
-  0x00000000,
-  0x0002ee00,
-  0x3c010040,
-  0x03a1e825,
-  0x3c01fff0,
-  0x03a1e826,
-  0x03a3e826,
-  0xafb74000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x4d01ffff,
-  0x00000000,
-  0x3c05a080,
-  0x8f820f08,
-  0x00000000,
-  0xaf820fd4,
-  0xaf820fd0,
-  0xaca200c4,
-  0x8f820f10,
-  0x00000000,
-  0x00021d82,
-  0xaf830fc0,
-  0x00031d80,
-  0x00431023,
-  0x3c01a080,
-  0x00411025,
-  0xaf820fc4,
-  0xaf820f10,
-  0x8f820f14,
-  0x00000000,
-  0x00431023,
-  0x3c01a080,
-  0x00411025,
-  0xaf820f14,
-  0x24030003,
-  0x279d0f18,
-  0x24be00c8,
-  0x27810d00,
-  0x8fa20000,
-  0x00000000,
-  0xafa20010,
-  0xafc20000,
-  0xafa10008,
-  0xafa1000c,
-  0x8fa20014,
-  0x00000000,
-  0xafa2001c,
-  0x27bd0024,
-  0x27de0004,
-  0x24210040,
-  0x1460fff3,
-  0x2463ffff,
-  0x8f820f00,
-  0x00000000,
-  0xaf820fc8,
-  0xaca200c0,
-  0x27820800,
-  0x2403000f,
-  0xac400000,
-  0x24420004,
-  0x1460fffd,
-  0x2463ffff,
-  0x8f830fc0,
-  0x00000000,
-  0xaf834d00,
-  0x8f834d00,
-  0x8f830f14,
-  0x8f820f10,
-  0x2463fffc,
-  0xac400000,
-  0x1443fffe,
-  0x24420004,
-  0x24020380,
-  0xaf824d00,
-  0x279d0f18,
-  0x27a10090,
-  0x8fa20014,
-  0x8fa30018,
-  0x00000000,
-  0x00621823,
-  0x2c7f0040,
-  0x17e00009,
-  0x3c1f0040,
-  0x37ff0800,
-  0x03a0f021,
-  0x4d01ffff,
-  0x00000000,
-  0xafe20000,
-  0x24420040,
-  0x1000fff6,
-  0x2463ffc0,
-  0x10600006,
-  0x37ff0800,
-  0x00031e00,
-  0x03e3f825,
-  0x4d01ffff,
-  0x00000000,
-  0xafe20000,
-  0x27bd0024,
-  0x17a1ffe8,
-  0x00000000,
-  0x00003821,
-  0x8fc20014,
-  0x8fc30018,
-  0x00000000,
-  0x00621823,
-  0x2c7f0040,
-  0x13e00004,
-  0x3c1f0040,
-  0x00030e00,
-  0x10000002,
-  0x03e1f825,
-  0x24030040,
-  0x37ff0800,
-  0x241e03e7,
-  0x00000821,
-  0x4d01ffff,
-  0x00000000,
-  0xafe20000,
-  0x00230821,
-  0x4900fffb,
-  0x00000000,
-  0x87804002,
-  0x17c0fff8,
-  0x27deffff,
-  0x14e00004,
-  0x34e74000,
-  0x03e7f825,
-  0x1000fff0,
-  0xaf810c60,
-  0xaf810c5c,
-  0x3c01a0d1,
-  0x8c22d6c8,
-  0x00000000,
-  0x3c01a080,
-  0xac2200e0,
-  0x3c01a080,
-  0x8c2000e0,
-  0xaf800fb4,
-  0xa7800fb8,
-  0xa7800fba,
-  0xa7800fbc,
-  0xa7800fbe,
-  0x27820cc0,
-  0xaf820fdc,
-  0xaf820fd8,
-  0x3c02a0d1,
-  0x2442dacc,
-  0xaf820c4c,
-  0xaf820c50,
-  0x24420400,
-  0xaf820c54,
-  0x2402001e,
-  0x3c03fff0,
-  0x247d0040,
-  0xac7d0008,
-  0x03a01821,
-  0x1440fffc,
-  0x2442ffff,
-  0x3c1dfff0,
-  0xac7d0008,
-  0x3c02c704,
-  0x3442dd7b,
-  0xaf820c58,
-  0x3c070000,
-  0x24e70158,
-  0x08343fa9,
-  0x00000000,
-  0x8e620038,
-  0x00000000,
-  0x14400005,
-  0x8f830c94,
-  0x12a00022,
-  0x24630001,
-  0x10000020,
-  0xaf830c94,
-  0xaf820fb4,
-  0x3262ffc0,
-  0x00021182,
-  0x8663002a,
-  0xa7820fb8,
-  0x3c02a000,
-  0xaf820fbc,
-  0xa7830fba,
-  0x867e0008,
-  0x279d0f18,
-  0x33de0060,
-  0x03bee821,
-  0x001ef0c2,
-  0x03bee821,
-  0x8fa2001c,
-  0x3c030c40,
-  0x4d01ffff,
-  0x00000000,
-  0x8f974c00,
-  0xac620fb4,
-  0x8fa30018,
-  0x2442000c,
-  0x14430003,
-  0x00000000,
-  0x8fa20014,
-  0x00000000,
-  0xafa2001c,
-  0x4d01ffff,
-  0x00000000,
-  0xaca500e4,
-  0xaf974c00,
-  0x03e00008,
-  0xae60003c,
-  0x3c0da0d1,
-  0x25add500,
-  0x11a00021,
-  0x00000000,
-  0x8da90000,
-  0x00000000,
-  0x1120001d,
-  0x00000000,
-  0x8daa0004,
-  0x8dab0008,
-  0x8dac000c,
-  0x00094740,
-  0x05010004,
-  0x00000000,
-  0x3c08a0d1,
-  0x2508d638,
-  0x01485021,
-  0x00094780,
-  0x05010007,
-  0x00000000,
-  0x1180000d,
-  0x00000000,
-  0xad400000,
-  0x254a0004,
-  0x1000fffb,
-  0x258cfffc,
-  0x11800007,
-  0x00000000,
-  0x8d6e0000,
-  0x256b0004,
-  0xad4e0000,
-  0x254a0004,
-  0x1000fff9,
-  0x258cfffc,
-  0x1000ffe1,
-  0x25ad0010,
-  0x03e00008,
-  0x00000000,
-  0x3c021040,
-  0xac574ff0,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x4d01ffff,
-  0x00000000,
-  0x8f820ffc,
-  0x00000000,
-  0x3042001f,
-  0x00021080,
-  0x3c17a0d1,
-  0x02e2b821,
-  0x26f7d648,
-  0x8ef70000,
-  0x00000000,
-  0x02e00008,
-  0x00000000,
-  0x2402ffff,
-  0xaf820ffc,
-  0x8f970fc8,
-  0x3c021040,
-  0xac570ff0,
-  0x8f820f04,
-  0x26f70010,
-  0x16e20004,
-  0xaf970fc8,
-  0x8f970f00,
-  0x00000000,
-  0xaf970fc8,
-  0x4d01ffff,
-  0x00000000,
-  0x03e00008,
-  0x00000000,
-  0x3c1fa0d1,
-  0x27fff02c,
-  0x1000ffed,
-  0x8f970ff0,
-  0x3c0200d1,
-  0x32f703ff,
-  0x0017b980,
-  0x02e2b825,
-  0xaee0003c,
-  0x2402ffff,
-  0xaee20030,
-  0xaee20014,
-  0x97830ff4,
-  0x97820ff8,
-  0x3c1d0000,
-  0x27bd0698,
-  0xa6e30008,
-  0xa6e20002,
-  0xaf9f0fe8,
-  0x03a0f809,
-  0xa6e2002c,
-  0x8f9f0fe8,
-  0x1000ffd9,
-  0xaee2000c,
-  0x8f970ff0,
-  0x3c0200d1,
-  0x32f703ff,
-  0x0017b980,
-  0x02e2b825,
-  0x97820ff4,
-  0x3c030000,
-  0x24630698,
-  0xa6e20002,
-  0xaf9f0fe8,
-  0x0060f809,
-  0xa6e2002c,
-  0x8f9f0fe8,
-  0x1000ffca,
-  0xaee2000c,
-  0x8f970ff0,
-  0x3c0200d1,
-  0x32f703ff,
-  0x0017b980,
-  0x02e2b825,
-  0x97820ff4,
-  0x00000000,
-  0x96e30008,
-  0xa6e20008,
-  0x00431026,
-  0x30420060,
-  0x1040ffbd,
-  0x8ee2003c,
-  0xaee0003c,
-  0x1040ffba,
-  0x3c028800,
-  0xaf820fbc,
-  0x8ee20038,
-  0xaee00038,
-  0x30630060,
-  0x279d0f18,
-  0x03a3e821,
-  0x000318c2,
-  0x03a3e821,
-  0x8fa3001c,
-  0x1040ffaf,
-  0xaf820fb4,
-  0x3c020c40,
-  0xac430fb4,
-  0x8fa20018,
-  0x2463000c,
-  0x14430003,
-  0x00000000,
-  0x8fa30014,
-  0x00000000,
-  0xafa3001c,
-  0x4d01ffff,
-  0x00000000,
-  0x1000ffa2,
-  0x00000000,
-  0x8f970ff0,
-  0x3c0200d1,
-  0xa7970fb8,
-  0x0017b980,
-  0x32f7ffc0,
-  0x02e2b821,
-  0xaee00030,
-  0x3c02dead,
-  0x8ee3003c,
-  0xaee2003c,
-  0x8ee20038,
-  0x1060ff95,
-  0xaee00038,
-  0x3c038800,
-  0xaf830fbc,
-  0x86e30008,
-  0x27970f18,
-  0x30630060,
-  0x02e3b821,
-  0x000318c2,
-  0x02e3b821,
-  0x8ee3001c,
-  0x1040ff8a,
-  0xaf820fb4,
-  0x3c020c40,
-  0xac430fb4,
-  0x8ee20018,
-  0x2463000c,
-  0x14430003,
-  0x00000000,
-  0x8ee30014,
-  0x00000000,
-  0xaee3001c,
-  0x4d01ffff,
-  0x00000000,
-  0x1000ff7d,
-  0x00000000,
-  0x8f820ff0,
-  0x8f970ff4,
-  0x90410000,
-  0x00000000,
-  0x00370825,
-  0x1000ff76,
-  0xa0410000,
-  0x8f820ff0,
-  0x8f970ff4,
-  0x94410000,
-  0x00000000,
-  0x00370825,
-  0x1000ff6f,
-  0xa4410000,
-  0x8f820ff0,
-  0x8f970ff4,
-  0x8c410000,
-  0x00000000,
-  0x00370825,
-  0x1000ff68,
-  0xac410000,
-  0x8f820ff0,
-  0x8f970ff4,
-  0x90410000,
-  0x02e0b827,
-  0x00370824,
-  0x1000ff61,
-  0xa0410000,
-  0x8f820ff0,
-  0x8f970ff4,
-  0x94410000,
-  0x02e0b827,
-  0x00370824,
-  0x1000ff5a,
-  0xa4410000,
-  0x8f820ff0,
-  0x8f970ff4,
-  0x8c410000,
-  0x02e0b827,
-  0x00370824,
-  0x1000ff53,
-  0xac410000,
-  0x8f820ff0,
-  0x8f970ff4,
-  0x1000ff4f,
-  0xa0570000,
-  0x8f820ff0,
-  0x8f970ff4,
-  0x1000ff4b,
-  0xa4570000,
-  0x8f820ff0,
-  0x8f970ff4,
-  0x1000ff47,
-  0xac570000,
-  0x8f820ff0,
-  0x00000000,
-  0x8c420000,
-  0x1000ff42,
-  0xaf820ff4,
-  0x3c01a0c2,
-  0x8c22c000,
-  0x00000000,
-  0xaf820ff0,
-  0x3c01a0c2,
-  0x8c22c004,
-  0x1000ff3a,
-  0xaf820ff4,
-  0x3c01a0d1,
-  0x8c22d5ac,
-  0x00000000,
-  0xaf820ff0,
-  0x3c01a0d1,
-  0x8c22d5b0,
-  0x1000ff32,
-  0xaf820ff4,
-  0x3c02a0f0,
-  0xac400000,
-  0x90570153,
-  0x00000000,
-  0xa3970c80,
-  0x90570157,
-  0x00000000,
-  0xa3970c81,
-  0x9057015b,
-  0x00000000,
-  0xa3970c87,
-  0x9057015f,
-  0x00000000,
-  0xa3970c86,
-  0x90570163,
-  0x00000000,
-  0x32f70007,
-  0xa3970c85,
-  0x90570193,
-  0x00000000,
-  0xa3970c8b,
-  0x90570197,
-  0x00000000,
-  0xa3970c8a,
-  0x9057019b,
-  0x00000000,
-  0x32f70007,
-  0xa3970c89,
-  0x9057000b,
-  0x00000000,
-  0x32f700e0,
-  0x00170942,
-  0x90570047,
-  0x00000000,
-  0x32f70078,
-  0x00370825,
-  0x90570067,
-  0x00000000,
-  0x32f7000f,
-  0x0017b9c0,
-  0x00370825,
-  0x905700c7,
-  0x00000000,
-  0x32f7002f,
-  0x0017bac0,
-  0x00370825,
-  0x90570147,
-  0x00000000,
-  0x32f7001e,
-  0x0017bc00,
-  0x00370825,
-  0x90570183,
-  0x00000000,
-  0x32f70060,
-  0x0017bc00,
-  0x00370825,
-  0xaf810c8c,
-  0x3c021840,
-  0x8f970fc8,
-  0x00000000,
-  0x8f970ff0,
-  0x00000000,
-  0xac570c80,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x00000000,
-  0x4d01ffff,
-  0x00000000,
-  0x3c02a0d1,
-  0x2442f998,
-  0xaf800c90,
-  0xaf800c94,
-  0x00400008,
-  0x00000000,
-  0x87970ff0,
-  0x3c1300d1,
-  0xa6770008,
-  0x3c030000,
-  0x24630520,
-  0xaf9f0fe8,
-  0x0060f809,
-  0x24020001,
-  0x8f9f0fe8,
-  0x1040feda,
-  0x97970ff0,
-  0x27830f18,
-  0x00771821,
-  0x0017b8c2,
-  0x02e3b821,
-  0x3c028800,
-  0xaf820fbc,
-  0x8e620038,
-  0xa7800fb8,
-  0xaf820fb4,
-  0x8ee3001c,
-  0x3c020c40,
-  0xac430fb4,
-  0x8ee20018,
-  0x2463000c,
-  0x14430004,
-  0xaee3001c,
-  0x8ee30014,
-  0x00000000,
-  0xaee3001c,
-  0x4d01ffff,
-  0x00000000,
-  0x1000ffdf,
-  0x00000000,
-  0x8f820c5c,
-  0x8f830c60,
-  0xaf820ff0,
-  0x1000febe,
-  0xaf830ff4,
-  0x23890800,
-  0x01201821,
-  0x2402000f,
-  0x206c0040,
-  0xac6c0008,
-  0x01801821,
-  0x1440fffc,
-  0x2042ffff,
-  0xac690008,
-  0x278b0c98,
-  0xa5600000,
-  0x2403ffff,
-  0xad630014,
-  0x34020001,
-  0x34420020,
-  0xa5620008,
-  0x278a0e00,
-  0x01401021,
-  0x00001821,
-  0xac400000,
-  0x24630004,
-  0x2c6c0100,
-  0x1580fffc,
-  0x24420004,
-  0x3c02a0d1,
-  0x2442e000,
-  0xaf820fe0,
-  0x3c1800d1,
-  0x01206021,
-  0x00006821,
-  0x00007821,
-  0x00005821,
-  0x00004021,
-  0x40026000,
-  0x00000000,
-  0x34424001,
-  0x40826000,
-  0x3c020000,
-  0x244206f8,
-  0x00400008,
-  0x00000000,
diff --git a/drivers/atm/atmsar11.regions b/drivers/atm/atmsar11.regions
deleted file mode 100644
index 42252b7..0000000
--- a/drivers/atm/atmsar11.regions
+++ /dev/null
@@ -1,6 +0,0 @@
-/*
-  See copyright and licensing conditions in ambassador.* files.
-*/
-  { 0x00000080,  993, },
-  { 0xa0d0d500,   80, },
-  { 0xa0d0f000,  978, },
diff --git a/drivers/atm/atmsar11.start b/drivers/atm/atmsar11.start
deleted file mode 100644
index dba55e7..0000000
--- a/drivers/atm/atmsar11.start
+++ /dev/null
@@ -1,4 +0,0 @@
-/*
-  See copyright and licensing conditions in ambassador.* files.
-*/
-  0xa0d0f000
diff --git a/firmware/Makefile b/firmware/Makefile
index d60b4c4..abb1d22 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -40,6 +40,7 @@ fw-shipped-$(CONFIG_USB_TI_3410_FIRMWARE) += ti_3410.fw
 fw-shipped-$(CONFIG_USB_TI_5052_FIRMWARE) += ti_5052.fw
 fw-shipped-$(CONFIG_USB_SERIAL_WHITEHEAT_FIRMWARE) += whiteheat_loader.fw \
 		whiteheat.fw # whiteheat_loader_debug.fw
+fw-shipped-$(CONFIG_ATM_AMBASSADOR_FIRMWARE) += atmsar11.fw
 
 firmware-y    := $(fw-external-y) $(fw-shipped-y)
 firmware-dirs := $(sort $(patsubst %,$(objtree)/$(obj)/%/,$(dir $(firmware-y))))
diff --git a/firmware/atmsar11.HEX b/firmware/atmsar11.HEX
new file mode 100644
index 0000000..046d562
--- /dev/null
+++ b/firmware/atmsar11.HEX
@@ -0,0 +1,204 @@
+:04000000A0D0F0009C
+:2C008000401A680000000000335B007C13600005335B10003C1AA0C0375A018003400008000000001760FFFB335B400020
+:2C00AC00401A700013600003241B0FC0AF9B45002508000803400008420000108F810C9032220002104000033C03A0D174
+:2C00D8002463F8100060F809242100011000001AAF810C9082020011AF900C480441000A34420080967D000296020012A4
+:2C01040000000000105D00110000000004110161A66200021000000DAE62000C34848000A20200114D01FFFF000000005E
+:2C0130008F834C0000000000AF830FEC00E0F80903E03821000414000440FFF700000000AF80460C8E1000084D01FFFF36
+:2C015C00000000008F834C004900001DAF830FEC8F820CBC8F9D0C4C2442000197BE0000AF820CBC13C00009ACA200D872
+:2C018800A7A000003C0100D1003E08259422002C0411013FA4220002AC22000CAC2000108F9E0C5427BD000217BE00028C
+:2C01B4008CA200C08F9D0C508F970FC8AF9D0C4C12E20005878040023C02A0D12442F94C0040F8090000000000E0F8094A
+:2C01E00003E038214500FFDC8E11000C3C1300D1001111022C4304001060FFB900021180026298218E76003C32220008C1
+:2C020C001440FFB78E7700348E7500303C03CFB016C0000302D5102B041100BE000000001040FFA6007018264D01FFFFE5
+:2C023800000000008F824C00AF974C00AF820FECAC7600100260902132220002104000078F944A009602003A3484000492
+:2C02640014400003AF820FBC3C029000AF820FBC8E10000832943F008E11000C2694FF00128000733C1300D14901007162
+:2C0290003237000816E0006F001111022C4304001060006C0002B980000417400440003A027798211272002326D60030E0
+:2C02BC00AE56003C8E76003C8E7700348E7500303C03CFB016C0000302D5102B0411009100000000104000602E8210006B
+:2C02E80014400009007018264D01FFFF000000008F824C00AF974C00AC760010AE4200341000FFD0AF80460C00E0F8090D
+:2C03140003E038213C03CFB000701826AE4600344D01FFFF000000008F824C00AF974C00AF820FECAC7600101000FFC382
+:2C034000AF80460C02D5102B104000423C17CFB02E8210001440000602F0B8264D01FFFF00000000AEF600101000FFB8E9
+:2C036C00AF80460C00E0F80903E038214D01FFFF000000008F824C00AF864C00AEF60010AF820FEC1000FFAEAF80460C7F
+:2C0398003084FFFB8E5700383242FFC000021182A7820FB8AF970FB4865D002A865E0008A79D0FBA279D0F1833DE00604B
+:2C03C40003BEE821001EF0C203BEE8218F970C584D01FFFF000000008F834C008FA2001C12E300033C030C403C1EC0008B
+:2C03F000AF9E0FBCAC620FB48FA300182442000C14430002AF80460C8FA20014AE40003CAFA2001C8E76003C8E7700340D
+:2C041C008E7500303C03CFB016C0000302D5102B0411003C00000000007018264D01FFFF00000000ACA500E410400032D6
+:2C044800AF974C001000FF7FAC760010000417400440000726D60030AE56003C00E0F80903E03821AF80460C1000FF393E
+:2C047400AE4600348E5700383242FFC000021182A7820FB8AF970FB48F970C5800E0F80903E0382112E600033C030C4029
+:2C04A0003C02C000AF820FBC865D002A865E0008A79D0FBA279D0F1833DE006003BEE821001EF0C203BEE8218FA2001C23
+:2C04CC004D01FFFF000000008F974C00AC620FB43084FFFB8FA300182442000C14430002AF80460C8FA20014AE40003CC2
+:2C04F800AFA2001C4D01FFFF00000000ACA500E41000FF13AF974C0000E0F80903E038211000FF0F000000001040005B50
+:2C052400867E0008279D0F1833DE006003BEE821001E10C203A2E8218FB700088FA2000C8EF6000412E2002886620008BC
+:2C05500082030010000217400441001924630001106000173C02D1B0005010264D01FFFF000000008F9E4C00AC56001008
+:2C057C0026D6FFFE860200103C03CFB034632000A662002A8EE2000026F70008AE6200388FA20020AFB700082417FFFF46
+:2C05A80002C2A8214D01FFFF00000000AF9E4C0003E00008AE7500308EE2000026F70008AE6200388FA20020AFB70008DB
+:2C05D4002417FFFFA677002A02C2A8213C03CFB003E00008AE750030001E18C2006518218C6300C88FA200100000000064
+:2C0600000062B0231EC000038FA1000412C0001B0022B0232EC30041146000023C1500402416004000161E80000318829E
+:2C062C00007518254D01FFFF000000008F954C00001EB84000771821AC624D00005610211441000227830D008FA200004D
+:2C06580002E3B821AFA2001002D71821AFA3000C4D01FFFF000000008EF600041000FFB5AF954C003C16DEADAE76003C82
+:2C068400AE60003826D5FFFF0000102103E00008AE7500302C430AB2106000052C4324B21000000424020AB210000002AF
+:2C06B000240224B11060FFFD304301FF000318403C1DA0D127BDD6CC007D1821946300000002EA4200031C0027BDFFFBC1
+:2C06DC0003E0000803A3100624030FC0AF83450010000002012060213C0CCFB011E000560189602685FE00000000000089
+:2C07080013C000473C02CFB007C0002D001E1F8004610034001E1FC0046000093C02D3B000E0F80903E038214D01FFFF10
+:2C073400000000008F864C008F990FEC1000000BAF994C0001E2782600E0F80903E038214D01FFFF000000008F864C001B
+:2C076000AF994C00ADEF20103C02D3B001E278268F820FC08F830FC4AF824D008DE20004A5E00000AC6200008C62000094
+:2C078C0024020380AF824D008F824D008F820F1424630004146200022419FFFF8F830F10ACA500E4AF830FC44D01FFFF93
+:2C07B800000000008F824C801000001FADE2003C00E0F80903E038214D01FFFF00000000A5E000008F864C001580002238
+:2C07E400AF8F45401000001701E2782600E0F80903E038214D01FFFF000000008F864C00AF994C00ADEF20103C02CFB097
+:2C08100001E27826A5E000004D01FFFF00000000100000078F994C0000E0F80903E038214D01FFFF000000008F864C0015
+:2C083C008F990FEC1580000AAF8F45000000782110000014AF19001400E0F80903E038214D01FFFF000000001180FFF8C1
+:2C0868008F864C0085220000012078210440000A8D290008130B0004000C1602AF1900148D7900140160C021AF994C0084
+:2C089400AD8E40103042003F01C27021000417800440018B8F824A0030818000304200041440FF8D8D4B00001020000C47
+:2C08C00030847FFF8F820C480120F021244300348C5D000C24420004AFDD000C1462FFFC27DE0004A52100001000FF82E0
+:2C08EC00250800081160005800000000857D00088D63000C9562000A8D41000407A1002600621821A563000A00031C026D
+:2C091800041101A0000318C0001D16C00441001F27A2008000021CC00461000E0040E82127BD0080956200009563000293
+:2C0944003442000CAD22000C24020100A52200109562002CA5230014A5220012A520001634028000A5220000A57D0008D2
+:2C09700007A0000C8F820C4C8F830C502441FFE80023F02B13C000020020102124420400945E00002441FFFE17C0FFF994
+:2C099C00AD620010A44B0000142B001CAD400000AD400004254A00083142007F1440000E00041780044100038F820FE03A
+:2C09C800100000063484000134840002244200083442100038421000AF820FE0354A0100394A010039420080AF820FE4B9
+:2C09F400001D14C00441000333A2EFFF1000FF3CA562000807A0009F33A2FFFE10000021A56200088D620024001D1CC01D
+:2C0A200004610004AD42000033A3EFFF1000FF31A563000807A0000533A3FFFEA56300088D4B00001000FFAA000000001E
+:2C0A4C001000008E25080008254A00083142007F1440000E00041780044100038F820FE010000006348400013484000274
+:2C0A7800244200083442100038421000AF820FE0354A0100394A010039420080AF820FE4110000038D4B00001000FF9303
+:2C0AA4002508FFF88F820FD88F830FDC8F810FD41062001D246200084D01FFFF000000008F8C4C00847F00003C1E00D11C
+:2C0AD00033FD03FF001D5980017E5821857E0008001DE900001E0F0003E1F82507E00003AF820FDC879E0CA0278B0C986E
+:2C0AFC0007C100423C0208403C01F7B08D62002000230826AC2200008C620004946300022442FFF8004310211000004E12
+:2C0B2800AD6200208F820FD087830CA014220007278B0C98410000513C018000ACA100E08CA100C4000000001022004C4E
+:2C0B54000022E8238F9F0F0C07A10002AF810FD403E2E8232FA30041146000023C1E0040241D0040001D1E800003188256
+:2C0B8000007E18254D01FFFF000000008F8C4C00AC624CC0005D1021145F000227830CC08F820F0803A3F021AF820FD059
+:2C0BAC00AF9E0FD84D01FFFF000000001000FFC3246200088D63000C8D7D0010A563000A13A0000200031C02A7A00000F8
+:2C0BD800000318C0041100EF006818214D01FFFF000000008F820C448F830C40AD620010A5630004A563000610000021FC
+:2C0C0400AF8C4C00A57D00008C7D000494630002AC5D4C4027A20008AD62001803A3E82127BDFFF4AD7D001C27BD0004D4
+:2C0C3000AD7D002037C18001001E17C00441FFE0A56100084D01FFFF000000008F820C448F830C40AD620010A563000478
+:2C0C5C00A56300068F820FD88F830FDC4D01FFFF000000001462FF9524620008AF8C4C0087830CA0278B0C980461FE97F8
+:2C0C88000004170004400005956200001178000600000000AF0E0010A70D00043084FFF7956D00048D6E001025ADFFD075
+:2C0CB40005A1FE8FAD22000C3C0CFFB001896026000D182225AD00308D7E00188D61001C4D01FFFF00000000103E0036B9
+:2C0CE0008F9D4C003C010840AC3E4C4027DE000811A00017AD7E0018000DF600019E60254D01FFFF00000000AD8E40105F
+:2C0D0C008F8D0C40957E00068F8E0C4403CDF021A57E0006000CF782000C0E0203C1F021001E0F80000C6200000C6202C2
+:2C0D38000181602533DE003C019E60213401000110000008A5210000957E00064D01FFFF000000008F8D0C408F8E0C44CD
+:2C0D640003CDF021A57E00064D01FFFF0000000001A3F02B17C000080003F60001A36823019E6025018960264D01FFF7CF
+:2C0D9000000000001000FE58AF9D4C008D7E00188D61001C00000000143EFFCE006D18234D01FFFF000000002C61000864
+:2C0DBC001020001795610008000000000001FF8007E0000B34210002006D182100031E000183602501896026240D002CC0
+:2C0DE800A56100084D01FFFF000000001000FE40AF9D4C003C1F0C40AFFE4FA83021FFFDA56100083C0CD3CF358CE0006E
+:2C0E140010000008340300023C1F0C40AFFE4FA811A0FFF9000DF60034030003019E6025018960263484000834420002C4
+:2C0E4000AD22000C95620006A5230000AD2200384D01FFFF00000000857E00088F820FA897830FACAD22000433C17FFFA6
+:2C0E6C00AD600010A56100081060FE20AF9D4C00A57E00080003190030633FF0A56300008F820FB03C030840AC624C4007
+:2C0E980024430008AD63001897830FAE2442FFF400621821AD63001C4D01FFFF000000008F8D0C408F830C44A56D000474
+:2C0EC400A56D0006AD6300101000FE0AAF9D4C008F820FE000040FC08C4300000421001B8F9F0FE48C5D0004AC4000043A
+:2C0EF0001060000EAC400000000000009462002800000000005F10208C4100040000000010200003AC43000410000002B6
+:2C0F1C00AC230024AC43000017A3FFF48C6300248F820FE03BFF0080244200083442100038421000AF820FE0AF9F0FE46E
+:2C0F48001000FE573084FFFE1060001000000000947D00280000000003BFE8208FA10004AFA30004102000038C5E000439
+:2C0F740010000002AC230024AFA300008C61002417C3FE48AC410000AC400004AC4000001000FE443084FFFD2C6201006F
+:2C0FA0001440000E006A10213143007F01431823004318233062007FA562002800621823000319028F820FE02463FFF8BF
+:2C0FCC000062182134631000100000033863100034430100386301008C6200040000000010400003AC6B000403E000089A
+:0C0FF800AC4B002403E00008AC6B0000D0
+:02000004A0D08A
+:2CD5000000000002A0D0E00000000000000010000000000600000008000000000000000800000002A0D0D64800000000F7
+:2CD52C00000008880000000000000000000000000000000024313200243132002431320000000000244D43522420436FB2
+:2CD558007079726967687420286329204D61646765204E6574776F726B73204C746420313939352E20416C6C207269674C
+:2CD584006874732072657365727665642E004D6164676520416D6261737361646F722076312E303100000000000000012C
+:2CD5B00000000001000000000000000000000000000000000000000000000000000000000000000000000000000000004E
+:2CD5DC00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000023
+:2CD608000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000F6
+:0CD6340000000000FFF0400000000000BB
+:2CF000000C343E2D000000003C1CA0D1279C56383C1DA0D127BDDFD03C08A0D12508DFD0AF8780080C343C1300000000E4
+:2CF02C00240400030097000D3C08BFC0350802308D08000000000000010000080000000027BDFFD0AFBF001CAFB1001864
+:2CF05800AFB000143C11FFF0000080213C18005637183B7926190200172000020319001A0007000D2401FFFF172100056B
+:2CF08400000000003C01800017010002000000000006000D00001012001018403C05A0D124A5D6CC00A32021A4820000C5
+:2CF0B000261000012A0102001420FFEA000000003C06A0D124C6F9E43C07A0D124E7D648ACE600003C08A0D12508FB14D9
+:2CF0DC00ACE800043C09A0D12529FC94ACE900083C0AA0D1254AFCD4ACEA000C3C0BA0D1256BFBA8ACEB00103C0CA0D15C
+:2CF10800258CFBC4ACEC00143C0DA0D125ADFBE0ACED00183C0EA0D125CEFBFCACEE001C3C0FA0D125EFFC18ACEF0020AD
+:2CF134003C18A0D12718FC34ACF800243C19A0D12739FC50ACF900283C02A0D12442FC60ACE2002C3C03A0D12463FC70A6
+:2CF16000ACE300303C04A0D12484FC80ACE400343C05A0D124A5FCB4ACE500383C06A0D124C6FE08ACE6003C3C08A0D111
+:2CF18C002508FE90ACE800403C09A0D12529FA38ACE900443C0AA0D1254AFA74ACEA0048241000133C0BA0D1256BF9D8E7
+:2CF1B800001060803C0EA0D125CED64801CC6821ADAB0000261000012A0100201420FFF6000000008F988000000000006F
+:2CF1E400AF0001008F828000241903FFA4590202000080218F86800024030FFF0010204024C7038000E42821A4A30000C1
+:2CF21000261000012A0100081420FFF7000000008F89800034089C40AD2803A08F8B80003C0A00FF354AFFFFAD6A03A4FC
+:2CF23C00000080218F8F8000240C0FFF0010684025F80300030D7021A5CC0000261000012A0100081420FFF700000000AB
+:2CF268008F82800034199C40AC5903208F8480003C0300FF3463FFFFAC8303248F868000240502FFA4C502023C08A0C00C
+:2CF29400350801803C09A0D12529D5B8250A00288D0B00008D0C0004AD2B0000AD2C000425080008150AFFFA252900081B
+:2CF2C0004002600000000000AFA20028240300223C04A0E034840014AC8300008FA500280000000034A6100100C01021CB
+:2CF2EC00AFA600283C07FFBF34E7FFFF00C7382400E01021AFA7002840876000000000003C0800023508D8903C09FFFE59
+:2CF3180035290130AD2800008FAA00283C0BF000014B582501601021AFAB002801606021408C6000000000000000802141
+:2CF3440000107080022E7821ADE00000261000012A0104001420FFFA00000000241800013C19A0E8AF380000240200117C
+:2CF370003C03A0F034630017A06200003C04F0EB348400703C05FFF034A54A00ACA400003C06FCEB34C60070ACA6000027
+:2CF39C003C07FFF034E74700ACE00000000080213C08FFF035080FC03C09FFF035294500AD280000261000012A01000433
+:2CF3C8001420FFF800000000000080213C0ADEAD001059803C0100D1002B0821AC2A003C3C0100D1002B0821AC200030C1
+:2CF3F4003C0100D1002B0821AC200038240DFFFF3C0100D1002B0821AC2D0014001071003C0100D1002B0821A42E000054
+:2CF420003C0100D1002B0821A4200004241800203C0100D1002B0821A43800083C0100D1002B0821AC200010261000017F
+:2CF44C002A0104001420FFE00000000000008021001018C03C05A0D124A5E00000A32021AC8000003C07A0D124E7E000BF
+:2CF4780024E8000401033021ACC00000261000012A0100091420FFF300000000240903803C0AFFF0354A4D00AD4900005F
+:2CF4A4003C0CA080358C009CAD8000003C0DA08035AD00A0ADA000003C0E11003C0FA08035EF00A8ADEE000041010003A0
+:2CF4D000000000004100FFFF000000003C18A080371800E08F1900003C01A0D1AC39D6C80C343D43032020218FB00014DE
+:2CF4FC008FBF001C8FB1001803E0000827BD00300080B8213C1CFFF0A3800C84A3800C888F90440000002021AF800CBC7E
+:2CF52800240200A827830F002C5D004017A0000C3C1DFFB003A3E826AFB740000000000000000000000000004D01FFFFF6
+:2CF55400000000002442FFC0246300401000FFF326F700401040000D000000000002EE003C01004003A1E8253C01FFF099
+:2CF5800003A1E82603A3E826AFB740000000000000000000000000004D01FFFF000000003C05A0808F820F08000000007E
+:2CF5AC00AF820FD4AF820FD0ACA200C48F820F100000000000021D82AF830FC000031D80004310233C01A0800041102542
+:2CF5D800AF820FC4AF820F108F820F1400000000004310233C01A08000411025AF820F1424030003279D0F1824BE00C823
+:2CF6040027810D008FA2000000000000AFA20010AFC20000AFA10008AFA1000C8FA2001400000000AFA2001C27BD0024B4
+:2CF6300027DE0004242100401460FFF32463FFFF8F820F0000000000AF820FC8ACA200C0278208002403000FAC4000002C
+:2CF65C00244200041460FFFD2463FFFF8F830FC000000000AF834D008F834D008F830F148F820F102463FFFCAC40000091
+:2CF688001443FFFE2442000424020380AF824D00279D0F1827A100908FA200148FA3001800000000006218232C7F004017
+:2CF6B40017E000093C1F004037FF080003A0F0214D01FFFF00000000AFE20000244200401000FFF62463FFC01060000659
+:2CF6E00037FF080000031E0003E3F8254D01FFFF00000000AFE2000027BD002417A1FFE800000000000038218FC200145A
+:2CF70C008FC3001800000000006218232C7F004013E000043C1F004000030E001000000203E1F8252403004037FF080084
+:2CF73800241E03E7000008214D01FFFF00000000AFE20000002308214900FFFB000000008780400217C0FFF827DEFFFFCA
+:2CF7640014E0000434E7400003E7F8251000FFF0AF810C60AF810C5C3C01A0D18C22D6C8000000003C01A080AC2200E0E7
+:2CF790003C01A0808C2000E0AF800FB4A7800FB8A7800FBAA7800FBCA7800FBE27820CC0AF820FDCAF820FD83C02A0D156
+:2CF7BC002442DACCAF820C4CAF820C5024420400AF820C542402001E3C03FFF0247D0040AC7D000803A018211440FFFC55
+:2CF7E8002442FFFF3C1DFFF0AC7D00083C02C7043442DD7BAF820C583C07000024E7015808343FA9000000008E620038B9
+:2CF8140000000000144000058F830C9412A000222463000110000020AF830C94AF820FB43262FFC0000211828663002A70
+:2CF84000A7820FB83C02A000AF820FBCA7830FBA867E0008279D0F1833DE006003BEE821001EF0C203BEE8218FA2001CC6
+:2CF86C003C030C404D01FFFF000000008F974C00AC620FB48FA300182442000C14430003000000008FA2001400000000FB
+:2CF89800AFA2001C4D01FFFF00000000ACA500E4AF974C0003E00008AE60003C3C0DA0D125ADD50011A00021000000005C
+:2CF8C4008DA90000000000001120001D000000008DAA00048DAB00088DAC000C0009474005010004000000003C08A0D185
+:2CF8F0002508D638014850210009478005010007000000001180000D00000000AD400000254A00041000FFFB258CFFFC66
+:2CF91C0011800007000000008D6E0000256B0004AD4E0000254A00041000FFF9258CFFFC1000FFE125AD001003E00008B9
+:2CF94800000000003C021040AC574FF0000000000000000000000000000000004D01FFFF000000008F820FFC000000005B
+:2CF974003042001F000210803C17A0D102E2B82126F7D6488EF700000000000002E00008000000002402FFFFAF820FFCB9
+:2CF9A0008F970FC83C021040AC570FF08F820F0426F7001016E20004AF970FC88F970F0000000000AF970FC84D01FFFFA6
+:2CF9CC000000000003E00008000000003C1FA0D127FFF02C1000FFED8F970FF03C0200D132F703FF0017B98002E2B825AA
+:2CF9F800AEE0003C2402FFFFAEE20030AEE2001497830FF497820FF83C1D000027BD0698A6E30008A6E20002AF9F0FE819
+:2CFA240003A0F809A6E2002C8F9F0FE81000FFD9AEE2000C8F970FF03C0200D132F703FF0017B98002E2B82597820FF429
+:2CFA50003C03000024630698A6E20002AF9F0FE80060F809A6E2002C8F9F0FE81000FFCAAEE2000C8F970FF03C0200D174
+:2CFA7C0032F703FF0017B98002E2B82597820FF40000000096E30008A6E2000800431026304200601040FFBD8EE2003CF2
+:2CFAA800AEE0003C1040FFBA3C028800AF820FBC8EE20038AEE0003830630060279D0F1803A3E821000318C203A3E82116
+:2CFAD4008FA3001C1040FFAFAF820FB43C020C40AC430FB48FA200182463000C14430003000000008FA30014000000000E
+:2CFB0000AFA3001C4D01FFFF000000001000FFA2000000008F970FF03C0200D1A7970FB80017B98032F7FFC002E2B82140
+:2CFB2C00AEE000303C02DEAD8EE3003CAEE2003C8EE200381060FF95AEE000383C038800AF830FBC86E3000827970F1821
+:2CFB58003063006002E3B821000318C202E3B8218EE3001C1040FF8AAF820FB43C020C40AC430FB48EE200182463000C84
+:2CFB840014430003000000008EE3001400000000AEE3001C4D01FFFF000000001000FF7D000000008F820FF08F970FF4B8
+:2CFBB0009041000000000000003708251000FF76A04100008F820FF08F970FF49441000000000000003708251000FF6F9E
+:2CFBDC00A44100008F820FF08F970FF48C41000000000000003708251000FF68AC4100008F820FF08F970FF49041000040
+:2CFC080002E0B827003708241000FF61A04100008F820FF08F970FF49441000002E0B827003708241000FF5AA4410000DB
+:2CFC34008F820FF08F970FF48C41000002E0B827003708241000FF53AC4100008F820FF08F970FF41000FF4FA05700009D
+:2CFC60008F820FF08F970FF41000FF4BA45700008F820FF08F970FF41000FF47AC5700008F820FF0000000008C4200007A
+:2CFC8C001000FF42AF820FF43C01A0C28C22C00000000000AF820FF03C01A0C28C22C0041000FF3AAF820FF43C01A0D14E
+:2CFCB8008C22D5AC00000000AF820FF03C01A0D18C22D5B01000FF32AF820FF43C02A0F0AC400000905701530000000076
+:2CFCE400A3970C809057015700000000A3970C819057015B00000000A3970C879057015F00000000A3970C8690570163BA
+:2CFD10000000000032F70007A3970C859057019300000000A3970C8B9057019700000000A3970C8A9057019B00000000AE
+:2CFD3C0032F70007A3970C899057000B0000000032F700E000170942905700470000000032F700780037082590570067BE
+:2CFD68000000000032F7000F0017B9C000370825905700C70000000032F7002F0017BAC000370825905701470000000019
+:2CFD940032F7001E0017BC0000370825905701830000000032F700600017BC0000370825AF810C8C3C0218408F970FC83F
+:2CFDC000000000008F970FF000000000AC570C800000000000000000000000000000000000000000000000004D01FFFF17
+:2CFDEC00000000003C02A0D12442F998AF800C90AF800C94004000080000000087970FF03C1300D1A67700083C030000C2
+:2CFE180024630520AF9F0FE80060F809240200018F9F0FE81040FEDA97970FF027830F18007718210017B8C202E3B821FB
+:2CFE44003C028800AF820FBC8E620038A7800FB8AF820FB48EE3001C3C020C40AC430FB48EE200182463000C1443000487
+:2CFE7000AEE3001C8EE3001400000000AEE3001C4D01FFFF000000001000FFDF000000008F820C5C8F830C60AF820FF026
+:2CFE9C001000FEBEAF830FF423890800012018212402000F206C0040AC6C0008018018211440FFFC2042FFFFAC69000884
+:2CFEC800278B0C98A56000002403FFFFAD6300143402000134420020A5620008278A0E000140102100001821AC40000038
+:2CFEF400246300042C6C01001580FFFC244200043C02A0D12442E000AF820FE03C1800D1012060210000682100007821C6
+:28FF20000000582100004021400260000000000034424001408260003C020000244206F800400008000000007A
+:00000001FF
+/*
+  Madge Ambassador ATM Adapter microcode.
+  Copyright (C) 1995-1999  Madge Networks Ltd.
+  
+  This microcode data is placed under the terms of the GNU General
+  Public License. The GPL is contained in /usr/doc/copyright/GPL on a
+  Debian system and in the file COPYING in the Linux kernel source.
+  
+  We would prefer you not to distribute modified versions without
+  consultation and not to ask for assembly/other microcode source.
+*/
+
+First record is start address in a __be32.

-- 
1.5.4.5


-- 
dwmw2

