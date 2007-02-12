Return-Path: <linux-kernel-owner+w=401wt.eu-S964986AbXBLQ5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964986AbXBLQ5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964981AbXBLQ50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:57:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53617 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964986AbXBLQvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:36 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: takada <takada@mbf.nifty.com>, Jordan Crouse <jordan.crouse@amd.com>,
       Andi Kleen <ak@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [2/29] i386: support Classic MediaGXm
Message-Id: <20070212165121.BF0E613F45@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: takada <takada@mbf.nifty.com>

I hope to support "classic" MediaGXm in kernel.

The DIR1 register of MediaGXm( or Geode) shows the following values for
identify CPU.  For example, My MediaGXm shows 0x42.

We can read National Semiconductor's datasheet without any NDAs.
  http://www.national.com/pf/GX/GXLV.html

from datasheets:
DIR1
0x30 - 0x33 GXm rev. 1.0 - 2.3
0x34 - 0x4f GXm rev. 2.4 - 3.x
0x5x        GXm rev. 5.0 - 5.4
0x6x        GXLV
0x7x         (unknow)
0x8x	    Gx1

In nsc driver of X, accept 0x30 through 0x82. What will 0x7x mean?

Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/cpu/cyrix.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: linux/arch/i386/kernel/cpu/cyrix.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/cyrix.c
+++ linux/arch/i386/kernel/cpu/cyrix.c
@@ -285,10 +285,15 @@ static void __cpuinit init_cyrix(struct 
 		/* GXm supports extended cpuid levels 'ala' AMD */
 		if (c->cpuid_level == 2) {
 			/* Enable cxMMX extensions (GX1 Datasheet 54) */
-			setCx86(CX86_CCR7, getCx86(CX86_CCR7)|1);
+			setCx86(CX86_CCR7, getCx86(CX86_CCR7) | 1);
 			
-			/* GXlv/GXm/GX1 */
-			if((dir1 >= 0x50 && dir1 <= 0x54) || dir1 >= 0x63)
+			/*
+			 * GXm : 0x30 ... 0x5f GXm  datasheet 51
+			 * GXlv: 0x6x          GXlv datasheet 54
+			 *  ?  : 0x7x
+			 * GX1 : 0x8x          GX1  datasheet 56
+			 */
+			if((0x30 <= dir1 && dir1 <= 0x6f) || (0x80 <=dir1 && dir1 <= 0x8f))
 				geode_configure();
 			get_model_name(c);  /* get CPU marketing name */
 			return;
