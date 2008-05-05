Return-Path: <linux-kernel-owner+w=401wt.eu-S1760867AbYEET0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760867AbYEET0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbYEET0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:26:19 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:33361 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbYEET0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:26:17 -0400
Date: Mon, 5 May 2008 21:26:15 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] m68k: remove old mac_esp cruft
In-Reply-To: <Pine.LNX.4.64.0805052118050.24098@anakin>
Message-ID: <Pine.LNX.4.64.0805052125510.28495@anakin>
References: <Pine.LNX.4.64.0805052118050.24098@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

Remove the rest of the old mac_esp driver. Also ditch the rest of the 
machw mechanism, it needs to be replaced by a fake openfirmware tree.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 Documentation/kernel-parameters.txt |    3 ---
 arch/m68k/mac/config.c              |   24 ------------------------
 include/asm-m68k/machw.h            |   30 ------------------------------
 3 files changed, 57 deletions(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1094,9 +1094,6 @@ and is between 256 and 4096 characters. 
 	mac5380=	[HW,SCSI] Format:
 			<can_queue>,<cmd_per_lun>,<sg_tablesize>,<hostid>,<use_tags>
 
-	mac53c9x=	[HW,SCSI] Format:
-			<num_esps>,<disconnect>,<nosync>,<can_queue>,<cmd_per_lun>,<sg_tablesize>,<hostid>,<use_tags>
-
 	machvec=	[IA64] Force the use of a particular machine-vector
 			(machvec) in a generic kernel.
 			Example: machvec=hpzx1_swiotlb
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -48,9 +48,6 @@
 struct mac_booter_data mac_bi_data;
 int mac_bisize = sizeof mac_bi_data;
 
-struct mac_hw_present mac_hw_present;
-EXPORT_SYMBOL(mac_hw_present);
-
 /* New m68k bootinfo stuff and videobase */
 
 extern int m68k_num_memory;
@@ -817,27 +814,6 @@ void __init mac_identify(void)
 		m68k_ramdisk.addr, m68k_ramdisk.size);
 #endif
 
-	/*
-	 * TODO: set the various fields in macintosh_config->hw_present here!
-	 */
-	switch (macintosh_config->scsi_type) {
-	case MAC_SCSI_OLD:
-		MACHW_SET(MAC_SCSI_80);
-		break;
-	case MAC_SCSI_QUADRA:
-	case MAC_SCSI_QUADRA2:
-	case MAC_SCSI_QUADRA3:
-		MACHW_SET(MAC_SCSI_96);
-		if ((macintosh_config->ident == MAC_MODEL_Q900) ||
-		    (macintosh_config->ident == MAC_MODEL_Q950))
-			MACHW_SET(MAC_SCSI_96_2);
-		break;
-	default:
-		printk(KERN_WARNING "config.c: wtf: unknown scsi, using 53c80\n");
-		MACHW_SET(MAC_SCSI_80);
-		break;
-	}
-
 	iop_init();
 	via_init();
 	oss_init();
--- a/include/asm-m68k/machw.h
+++ b/include/asm-m68k/machw.h
@@ -66,36 +66,6 @@ struct MAC_SCC
 # define mac_scc ((*(volatile struct SCC*)MAC_SCC_BAS))
 #endif
 
-/* hardware stuff */
-
-#define MACHW_DECLARE(name)	unsigned name : 1
-#define MACHW_SET(name)		(mac_hw_present.name = 1)
-#define MACHW_PRESENT(name)	(mac_hw_present.name)
-
-struct mac_hw_present {
-  /* video hardware */
-  /* sound hardware */
-  /* disk storage interfaces */
-  MACHW_DECLARE(MAC_SCSI_80);     /* Directly mapped NCR5380 */
-  MACHW_DECLARE(MAC_SCSI_96);     /* 53c9[46] */
-  MACHW_DECLARE(MAC_SCSI_96_2);   /* 2nd 53c9[46] Q900 and Q950 */
-  MACHW_DECLARE(IDE);             /* IDE Interface */
-  /* other I/O hardware */
-  MACHW_DECLARE(SCC);             /* Serial Communications Contr. */
-  /* DMA */
-  MACHW_DECLARE(SCSI_DMA);        /* DMA for the NCR5380 */
-  /* real time clocks */
-  MACHW_DECLARE(RTC_CLK);         /* clock chip */
-  /* supporting hardware */
-  MACHW_DECLARE(VIA1);            /* Versatile Interface Ad. 1 */
-  MACHW_DECLARE(VIA2);            /* Versatile Interface Ad. 2 */
-  MACHW_DECLARE(RBV);             /* Versatile Interface Ad. 2+ */
-  /* NUBUS */
-  MACHW_DECLARE(NUBUS);           /* NUBUS */
-};
-
-extern struct mac_hw_present mac_hw_present;
-
 #endif /* __ASSEMBLY__ */
 
 #endif /* linux/machw.h */

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
