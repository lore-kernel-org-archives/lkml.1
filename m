Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbZEZWYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbZEZWYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758752AbZEZWWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:22:40 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:33597 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758703AbZEZWWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:22:33 -0400
MBOX-Line: From nobody Tue May 26 16:12:35 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 08/10] OMAP3 SDRC: set FIXEDDELAY when disabling SDRC DLL
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Paul Walmsley <paul@pwsan.com>
Date: Tue, 26 May 2009 16:12:35 -0600
Message-ID: <20090526221234.25381.63193.stgit@localhost.localdomain>
In-Reply-To: <20090526220517.25381.75976.stgit@localhost.localdomain>
References: <20090526220517.25381.75976.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correspondence with the TI OMAP hardware team indicates that
SDRC_DLLA_CTRL.FIXEDDELAY should be initialized to 0x0f.  This number
was apparently derived from process validation.  This is only used
when the SDRC DLL is unlocked (e.g., SDRC clock frequency less than
83MHz).

Signed-off-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/sram34xx.S |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/sram34xx.S b/arch/arm/mach-omap2/sram34xx.S
index 487fa86..f41f8d9 100644
--- a/arch/arm/mach-omap2/sram34xx.S
+++ b/arch/arm/mach-omap2/sram34xx.S
@@ -41,8 +41,18 @@
 #define SDRC_UNLOCK_DLL			0x1
 
 /* SDRC_DLLA_CTRL bit settings */
+#define FIXEDDELAY_SHIFT		24
+#define FIXEDDELAY_MASK			(0xff << FIXEDDELAY_SHIFT)
 #define DLLIDLE_MASK			0x4
 
+/*
+ * SDRC_DLLA_CTRL default values: TI hardware team indicates that
+ * FIXEDDELAY should be initialized to 0xf.  This apparently was
+ * empirically determined during process testing, so no derivation
+ * was provided.
+ */
+#define FIXEDDELAY_DEFAULT		(0x0f << FIXEDDELAY_SHIFT)
+
 /* SDRC_DLLA_STATUS bit settings */
 #define LOCKSTATUS_MASK			0x4
 
@@ -103,6 +113,8 @@ return_to_sdram:
 unlock_dll:
 	ldr	r11, omap3_sdrc_dlla_ctrl
 	ldr	r12, [r11]
+	and	r12, r12, #FIXEDDELAY_MASK
+	orr	r12, r12, #FIXEDDELAY_DEFAULT
 	orr	r12, r12, #DLLIDLE_MASK
 	str	r12, [r11]		@ (no OCP barrier needed)
 	bx	lr


