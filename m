Return-Path: <linux-kernel-owner+w=401wt.eu-S933590AbZINUJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590AbZINUJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933653AbZINUJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:09:26 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54193 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933667AbZINUJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:09:07 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Bernd Schmidt <bernds_cb1@t-online.de>
Subject: [PATCH 66/72] Blackfin: add ICPLB coverage for async banks
Date: Mon, 14 Sep 2009 16:08:10 -0400
Message-Id: <1252958896-25150-67-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernd Schmidt <bernds_cb1@t-online.de>

When doing XIP, we need to execute out of the async banks, so we need
ICPLBs to allow this.

Signed-off-by: Bernd Schmidt <bernds_cb1@t-online.de>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/cplb-nompu/cplbinit.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/kernel/cplb-nompu/cplbinit.c b/arch/blackfin/kernel/cplb-nompu/cplbinit.c
index 685f160..5d8ad50 100644
--- a/arch/blackfin/kernel/cplb-nompu/cplbinit.c
+++ b/arch/blackfin/kernel/cplb-nompu/cplbinit.c
@@ -36,7 +36,7 @@ int first_switched_icplb PDT_ATTR;
 int first_switched_dcplb PDT_ATTR;
 
 struct cplb_boundary dcplb_bounds[9] PDT_ATTR;
-struct cplb_boundary icplb_bounds[7] PDT_ATTR;
+struct cplb_boundary icplb_bounds[9] PDT_ATTR;
 
 int icplb_nr_bounds PDT_ATTR;
 int dcplb_nr_bounds PDT_ATTR;
@@ -167,14 +167,21 @@ void __init generate_cplb_tables_all(void)
 		icplb_bounds[i_i++].data = (reserved_mem_icache_on ?
 					    SDRAM_IGENERIC : SDRAM_INON_CHBL);
 	}
+	/* Addressing hole up to the async bank.  */
+	icplb_bounds[i_i].eaddr = ASYNC_BANK0_BASE;
+	icplb_bounds[i_i++].data = 0;
+	/* ASYNC banks.  */
+	icplb_bounds[i_i].eaddr = ASYNC_BANK3_BASE + ASYNC_BANK3_SIZE;
+	icplb_bounds[i_i++].data = SDRAM_EBIU;
 	/* Addressing hole up to BootROM.  */
 	icplb_bounds[i_i].eaddr = BOOT_ROM_START;
 	icplb_bounds[i_i++].data = 0;
 	/* BootROM -- largest one should be less than 1 meg.  */
 	icplb_bounds[i_i].eaddr = BOOT_ROM_START + (1 * 1024 * 1024);
 	icplb_bounds[i_i++].data = SDRAM_IGENERIC;
+
 	if (L2_LENGTH) {
-		/* Addressing hole up to L2 SRAM, including the async bank.  */
+		/* Addressing hole up to L2 SRAM.  */
 		icplb_bounds[i_i].eaddr = L2_START;
 		icplb_bounds[i_i++].data = 0;
 		/* L2 SRAM.  */
-- 
1.6.4.2

