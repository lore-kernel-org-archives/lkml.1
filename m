Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbXGKTaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbXGKTaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764778AbXGKTT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:19:57 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38285 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764789AbXGKTTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:19:38 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 23/33] EDD probing code for the new x86 setup code
Date: Wed, 11 Jul 2007 12:18:48 -0700
Message-Id: <11841815421819-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <118418154292-git-send-email-hpa@zytor.com>
References: <1184181538674-git-send-email-hpa@zytor.com>
 <118418153862-git-send-email-hpa@zytor.com>
 <11841815382283-git-send-email-hpa@zytor.com>
 <11841815392122-git-send-email-hpa@zytor.com>
 <11841815393975-git-send-email-hpa@zytor.com>
 <11841815393014-git-send-email-hpa@zytor.com>
 <1184181539416-git-send-email-hpa@zytor.com>
 <118418153972-git-send-email-hpa@zytor.com>
 <11841815391923-git-send-email-hpa@zytor.com>
 <11841815403678-git-send-email-hpa@zytor.com>
 <11841815403041-git-send-email-hpa@zytor.com>
 <11841815402349-git-send-email-hpa@zytor.com>
 <11841815401013-git-send-email-hpa@zytor.com>
 <1184181540369-git-send-email-hpa@zytor.com>
 <11841815401476-git-send-email-hpa@zytor.com>
 <11841815411443-git-send-email-hpa@zytor.com>
 <1184181541746-git-send-email-hpa@zytor.com>
 <11841815411436-git-send-email-hpa@zytor.com>
 <11841815412873-git-send-email-hpa@zytor.com>
 <11841815412175-git-send-email-hpa@zytor.com>
 <1184181541492-git-send-email-hpa@zytor.com>
 <11841815421028-git-send-email-hpa@zytor.com>
 <118418154292-git-send-email-hpa@zytor.com>
Message-Id: <099b1190b55993dc1ee0ac7bf4faa3bf55ce5223.1184181208.git.hpa@zytor.com>
In-Reply-To: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
References: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Probe EDD and MBR signatures, in order to make it easier to map
physical hard drives to BIOS drives.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/boot/edd.c |  196 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 196 insertions(+), 0 deletions(-)
 create mode 100644 arch/i386/boot/edd.c

diff --git a/arch/i386/boot/edd.c b/arch/i386/boot/edd.c
new file mode 100644
index 0000000..25a2824
--- /dev/null
+++ b/arch/i386/boot/edd.c
@@ -0,0 +1,196 @@
+/* -*- linux-c -*- ------------------------------------------------------- *
+ *
+ *   Copyright (C) 1991, 1992 Linus Torvalds
+ *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * arch/i386/boot/edd.c
+ *
+ * Get EDD BIOS disk information
+ */
+
+#include "boot.h"
+#include <linux/edd.h>
+
+#if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
+
+struct edd_dapa {
+	u8	pkt_size;
+	u8	rsvd;
+	u16	sector_cnt;
+	u16	buf_off, buf_seg;
+	u64	lba;
+	u64	buf_lin_addr;
+};
+
+/*
+ * Read the MBR (first sector) from a specific device.
+ */
+static int read_mbr(u8 devno, void *buf)
+{
+	struct edd_dapa dapa;
+	u16 ax, bx, cx, dx, si;
+
+	memset(&dapa, 0, sizeof dapa);
+	dapa.pkt_size = sizeof(dapa);
+	dapa.sector_cnt = 1;
+	dapa.buf_off = (size_t)buf;
+	dapa.buf_seg = ds();
+	/* dapa.lba = 0; */
+
+	ax = 0x4200;		/* Extended Read */
+	si = (size_t)&dapa;
+	dx = devno;
+	asm("pushfl; stc; int $0x13; setc %%al; popfl"
+	    : "+a" (ax), "+S" (si), "+d" (dx)
+	    : "m" (dapa)
+	    : "ebx", "ecx", "edi", "memory");
+
+	if (!(u8)ax)
+		return 0;	/* OK */
+
+	ax = 0x0201;		/* Legacy Read, one sector */
+	cx = 0x0001;		/* Sector 0-0-1 */
+	dx = devno;
+	bx = (size_t)buf;
+	asm("pushfl; stc; int $0x13; setc %%al; popfl"
+	    : "+a" (ax), "+c" (cx), "+d" (dx), "+b" (bx)
+	    : : "esi", "edi", "memory");
+
+	return -(u8)ax;		/* 0 or -1 */
+}
+
+static u32 read_mbr_sig(u8 devno, struct edd_info *ei)
+{
+	int sector_size;
+	char *mbrbuf_ptr, *mbrbuf_end;
+	u32 mbrsig;
+	u32 buf_base, mbr_base;
+	extern char _end[];
+	static char mbr_buf[1024];
+
+	sector_size = ei->params.bytes_per_sector;
+	if (!sector_size)
+		sector_size = 512; /* Best available guess */
+
+	buf_base = (ds() << 4) + (u32)&_end;
+	mbr_base = (buf_base+sector_size-1) & ~(sector_size-1);
+	mbrbuf_ptr = mbr_buf + (mbr_base-buf_base);
+	mbrbuf_end = mbrbuf_ptr + sector_size;
+
+	if (!(boot_params.hdr.loadflags & CAN_USE_HEAP))
+		return 0;
+	if (mbrbuf_end > (char *)(size_t)boot_params.hdr.heap_end_ptr)
+		return 0;
+
+	if (read_mbr(devno, mbrbuf_ptr))
+		return 0;
+
+	mbrsig = *(u32 *)&mbrbuf_ptr[EDD_MBR_SIG_OFFSET];
+	return mbrsig;
+}
+
+static int get_edd_info(u8 devno, struct edd_info *ei)
+{
+	u16 ax, bx, cx, dx, di;
+
+	memset(ei, 0, sizeof *ei);
+
+	/* Check Extensions Present */
+
+	ax = 0x4100;
+	bx = EDDMAGIC1;
+	dx = devno;
+	asm("pushfl; stc; int $0x13; setc %%al; popfl"
+	    : "+a" (ax), "+b" (bx), "=c" (cx), "+d" (dx)
+	    : : "esi", "edi");
+
+	if ((u8)ax)
+		return -1;	/* No extended information */
+
+	if (bx != EDDMAGIC2)
+		return -1;
+
+	ei->device  = devno;
+	ei->version = ax >> 8;	/* EDD version number */
+	ei->interface_support = cx; /* EDD functionality subsets */
+
+	/* Extended Get Device Parameters */
+
+	ei->params.length = sizeof(ei->params);
+	ax = 0x4800;
+	dx = devno;
+	asm("pushfl; int $0x13; popfl"
+	    : "+a" (ax), "+d" (dx)
+	    : "S" (&ei->params)
+	    : "ebx", "ecx", "edi");
+
+	/* Get legacy CHS parameters */
+
+	/* Ralf Brown recommends setting ES:DI to 0:0 */
+	ax = 0x0800;
+	dx = devno;
+	di = 0;
+	asm("pushw %%es; "
+	    "movw %%di,%%es; "
+	    "pushfl; stc; int $0x13; setc %%al; popfl; "
+	    "popw %%es"
+	    : "+a" (ax), "=b" (bx), "=c" (cx), "+d" (dx), "+D" (di)
+	    : : "esi");
+
+	if ((u8)ax == 0) {
+		ei->legacy_max_cylinder = (cx >> 8) + ((cx & 0xc0) << 2);
+		ei->legacy_max_head = dx >> 8;
+		ei->legacy_sectors_per_track = cx & 0x3f;
+	}
+
+	return 0;
+}
+
+void query_edd(void)
+{
+	char eddarg[8];
+	int do_mbr = 1;
+	int do_edd = 1;
+	int devno;
+	struct edd_info ei, *edp;
+
+	if (cmdline_find_option("edd", eddarg, sizeof eddarg) > 0) {
+		if (!strcmp(eddarg, "skipmbr") || !strcmp(eddarg, "skip"))
+			do_mbr = 0;
+		else if (!strcmp(eddarg, "off"))
+			do_edd = 0;
+	}
+
+	edp = (struct edd_info *)boot_params.eddbuf;
+
+	if (!do_edd)
+		return;
+
+	for (devno = 0x80; devno < 0x80+EDD_MBR_SIG_MAX; devno++) {
+		/*
+		 * Scan the BIOS-supported hard disks and query EDD
+		 * information...
+		 */
+		get_edd_info(devno, &ei);
+
+		if (boot_params.eddbuf_entries < EDDMAXNR) {
+			memcpy(edp, &ei, sizeof ei);
+			edp++;
+			boot_params.eddbuf_entries++;
+		}
+
+		if (do_mbr) {
+			u32 mbr_sig;
+			mbr_sig = read_mbr_sig(devno, &ei);
+			boot_params.edd_mbr_sig_buffer[devno-0x80] = mbr_sig;
+		}
+	}
+}
+
+#endif
-- 
1.5.2.2

