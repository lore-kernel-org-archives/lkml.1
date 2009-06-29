Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbZF2Hmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbZF2Hmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 03:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbZF2HmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 03:42:22 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:32832 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbZF2HmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 03:42:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bGDRFW1r7bYqCry+bnXw7ptoI8kQtLbbMGsdk9fANZL3UYjmR6NPq9mHyTD//nm/ub
         O/YJtDNZ1BCsmJnqCavOxW7grEruprOgu/dj4g2dYWZRdhWhqJxVneAtgzi3C6kg7awx
         1FvQwuhaQ7eglm8SRqkmhJMQosrB7ptg/IQ2A=
MIME-Version: 1.0
In-Reply-To: <f69abfc30906250147n7e0b2945x50af858f52adb904@mail.gmail.com>
References: <f69abfc30906250042g4e6cec13n1a25f4b04ce5177c@mail.gmail.com>
	 <1245917167.17089.102.camel@macbook.infradead.org>
	 <f69abfc30906250147n7e0b2945x50af858f52adb904@mail.gmail.com>
Date: Mon, 29 Jun 2009 09:42:22 +0200
Message-ID: <f69abfc30906290042j7f98f99fs80d2ca952550ddd1@mail.gmail.com>
Subject: Re: Add support for the SST 39VF3202, 39VF6401B and 39VF6402B flash 
	chips
From: Yegor Yefremov <yegorslists@googlemail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the SST 39VF3202, 39VF6401B and 39VF6402B flash chips

- extend struct amd_flash_info to enable 8 erase regions for 8MiB flash chips
- change erase block command to 0x50 due to the differences
between 39VF6401/02 and 39VF6401B/02B chips. Refer to the
corresponding data sheets
Table 6 -> 6th bus write cycle:
39VF6401B data sheet http://www.sst.com/downloads/datasheet/S71288.pdf
39VF6401 data sheet http://www.sst.com/downloads/datasheet/S71223-03.pdf

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>

Index: linus/drivers/mtd/chips/cfi_cmdset_0002.c
===================================================================
--- linus.orig/drivers/mtd/chips/cfi_cmdset_0002.c
+++ linus/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -50,6 +50,8 @@
 #define SST49LF004B	        0x0060
 #define SST49LF040B	        0x0050
 #define SST49LF008A		0x005a
+#define SST39VF6401B		0x236D
+#define SST39VF6402B		0x236C
 #define AT49BV6416		0x00d6

 static int cfi_amdstd_read (struct mtd_info *, loff_t, size_t, size_t
*, u_char *);
@@ -1629,7 +1631,11 @@ static int __xipram do_erase_oneblock(st
 	cfi_send_gen_cmd(0x80, cfi->addr_unlock1, chip->start, map, cfi,
cfi->device_type, NULL);
 	cfi_send_gen_cmd(0xAA, cfi->addr_unlock1, chip->start, map, cfi,
cfi->device_type, NULL);
 	cfi_send_gen_cmd(0x55, cfi->addr_unlock2, chip->start, map, cfi,
cfi->device_type, NULL);
-	map_write(map, CMD(0x30), adr);
+
+	if (cfi->mfr == MANUFACTURER_SST && (cfi->id == SST39VF6401B ||
cfi->id == SST39VF6402B))
+		map_write(map, CMD(0x50), adr);
+	else
+		map_write(map, CMD(0x30), adr);

 	chip->state = FL_ERASING;
 	chip->erase_suspended = 0;
Index: linus/drivers/mtd/chips/jedec_probe.c
===================================================================
--- linus.orig/drivers/mtd/chips/jedec_probe.c
+++ linus/drivers/mtd/chips/jedec_probe.c
@@ -160,6 +160,9 @@
 #define SST39LF160	0x2782
 #define SST39VF1601	0x234b
 #define SST39VF3201	0x235b
+#define SST39VF3202	0x235a
+#define SST39VF6401B	0x236D
+#define SST39VF6402B	0x236C
 #define SST39LF512	0x00D4
 #define SST39LF010	0x00D5
 #define SST39LF020	0x00D6
@@ -273,7 +276,7 @@ struct amd_flash_info {
 	const uint8_t dev_size;
 	const uint8_t nr_regions;
 	const uint16_t cmd_set;
-	const uint32_t regions[6];
+	const uint32_t regions[8];
 	const uint8_t devtypes;		/* Bitmask for x8, x16 etc. */
 	const uint8_t uaddr;		/* unlock addrs for 8, 16, 32, 64 */
 };
@@ -1519,6 +1522,59 @@ static const struct amd_flash_info jedec
 			ERASEINFO(0x1000,256)
 		}
 	}, {
+		.mfr_id		= MANUFACTURER_SST,     /* should be CFI */
+		.dev_id		= SST39VF3202,
+		.name		= "SST 39VF3202",
+		.devtypes	= CFI_DEVICETYPE_X16,
+		.uaddr		= MTD_UADDR_0xAAAA_0x5555,
+		.dev_size	= SIZE_4MiB,
+		.cmd_set	= P_ID_AMD_STD,
+		.nr_regions	= 4,
+		.regions	= {
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256)
+		}
+	}, {
+		.mfr_id		= MANUFACTURER_SST,     /* should be CFI */
+		.dev_id		= SST39VF6401B,
+		.name		= "SST 39VF6401B",
+		.devtypes	= CFI_DEVICETYPE_X16,
+		.uaddr		= MTD_UADDR_0x0AAA_0x0555,
+		.dev_size	= SIZE_8MiB,
+		.cmd_set	= P_ID_AMD_STD,
+		.nr_regions	= 8,
+		.regions	= {
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256),
+		}
+	}, {
+		.mfr_id		= MANUFACTURER_SST,     /* should be CFI */
+		.dev_id		= SST39VF6402B,
+		.name		= "SST 39VF6402B",
+		.devtypes	= CFI_DEVICETYPE_X16,
+		.uaddr		= MTD_UADDR_0x0AAA_0x0555,
+		.dev_size	= SIZE_8MiB,
+		.cmd_set	= P_ID_AMD_STD,
+		.nr_regions	= 8,
+		.regions	= {
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256),
+		}
+	}, {
 		.mfr_id		= MANUFACTURER_SST,
 		.dev_id		= SST36VF3203,
 		.name		= "SST 36VF3203",
