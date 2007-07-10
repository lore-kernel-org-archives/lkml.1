Return-Path: <linux-kernel-owner+w=401wt.eu-S1760617AbXGJDjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760617AbXGJDjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbXGJDj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:39:28 -0400
Received: from terminus.zytor.com ([192.83.249.54]:39406 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbXGJDj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:39:26 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 23/33] EDD probing code for the new x86 setup code
Date: Mon,  9 Jul 2007 19:52:02 -0700
Message-Id: <11840383522914-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11840382473923-git-send-email-hpa@zytor.com>
References: <11840359321823-git-send-email-hpa@zytor.com>
 <11840360383913-git-send-email-hpa@zytor.com>
 <11840361432207-git-send-email-hpa@zytor.com>
 <11840362483663-git-send-email-hpa@zytor.com>
 <11840363531039-git-send-email-hpa@zytor.com>
 <11840364593068-git-send-email-hpa@zytor.com>
 <1184036564610-git-send-email-hpa@zytor.com>
 <11840366692770-git-send-email-hpa@zytor.com>
 <11840367741994-git-send-email-hpa@zytor.com>
 <11840368791603-git-send-email-hpa@zytor.com>
 <11840369841576-git-send-email-hpa@zytor.com>
 <11840370903975-git-send-email-hpa@zytor.com>
 <11840371953778-git-send-email-hpa@zytor.com>
 <11840373002601-git-send-email-hpa@zytor.com>
 <11840374052662-git-send-email-hpa@zytor.com>
 <1184037510289-git-send-email-hpa@zytor.com>
 <11840376162370-git-send-email-hpa@zytor.com>
 <11840377211519-git-send-email-hpa@zytor.com>
 <11840378261081-git-send-email-hpa@zytor.com>
 <11840379311574-git-send-email-hpa@zytor.com>
 <11840380363720-git-send-email-hpa@zytor.com>
 <11840381413065-git-send-email-hpa@zytor.com>
 <11840382473923-git-send-email-hpa@zytor.com>
Message-Id: <b577403d806edfbb1c17ecfec94971fc757a066c.1184032749.git.hpa@zytor.com>
In-Reply-To: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
References: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
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

