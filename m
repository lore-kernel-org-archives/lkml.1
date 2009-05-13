Return-Path: <linux-kernel-owner+w=401wt.eu-S1759015AbZEMAL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015AbZEMAL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756456AbZEMAHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:07:39 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:56380 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbZEMAHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:07:38 -0400
MBOX-Line: From nobody Tue May 12 18:05:15 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 01/10] OMAP3 SRAM: mark OCM RAM as Non-cacheable Normal memory
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Paul Walmsley <paul@pwsan.com>, Tero Kristo <tero.kristo@nokia.com>,
       Richard Woodruff <r-woodruff2@ti.com>
Date: Tue, 12 May 2009 18:05:15 -0600
Message-ID: <20090513000509.10349.87859.stgit@localhost.localdomain>
In-Reply-To: <20090512235713.10349.49339.stgit@localhost.localdomain>
References: <20090512235713.10349.49339.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark the SRAM (aka OCM RAM) as Non-cacheable Normal memory[1].  This
is to prevent the ARM from evicting existing cache lines to SDRAM
while code is executing from the SRAM.  Necessary since one of the
primary uses for the SRAM is to hold the code and data for the CORE
DPLL M2 divider reprogramming code, which must execute while the SDRC
is idled.  If the ARM attempts to write cache lines back to the while
the SRAM code is running, the ARM will stall[2].

TI deals with this problem in the CDP kernel by marking the SRAM as
Strongly-ordered memory.

Tero Kristo <tero.kristo@nokia.com> caught a bug in an earlier version of
this patch - thanks Tero.

...

1. ARMv7 ARM (DDI 0406A) pp. A3-30, A3-31, B3-32.

2. Private communication with Richard Woodruff <r-woodruff2@ti.com>

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Tero Kristo <tero.kristo@nokia.com>
Cc: Richard Woodruff <r-woodruff2@ti.com>
---
 arch/arm/plat-omap/sram.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/sram.c b/arch/arm/plat-omap/sram.c
index fa5297d..3835338 100644
--- a/arch/arm/plat-omap/sram.c
+++ b/arch/arm/plat-omap/sram.c
@@ -201,6 +201,15 @@ void __init omap_map_sram(void)
 		base = OMAP3_SRAM_PA;
 		base = ROUND_DOWN(base, PAGE_SIZE);
 		omap_sram_io_desc[0].pfn = __phys_to_pfn(base);
+
+		/*
+		 * SRAM must be marked as non-cached on OMAP3 since the
+		 * CORE DPLL M2 divider change code (in SRAM) runs with the
+		 * SDRAM controller disabled, and if it is marked cached,
+		 * the ARM may attempt to write cache lines back to SDRAM
+		 * which will cause the system to hang.
+		 */
+		omap_sram_io_desc[0].type = MT_MEMORY_NONCACHED;
 	}
 
 	omap_sram_io_desc[0].length = 1024 * 1024;	/* Use section desc */


