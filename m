Return-Path: <linux-kernel-owner+w=401wt.eu-S1423634AbXEAUuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423634AbXEAUuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423650AbXEAUlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:41:52 -0400
Received: from assei2bl6.telenet-ops.be ([195.130.133.69]:45668 "EHLO
	assei2bl6.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423636AbXEAUfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:35:00 -0400
Message-Id: <20070501203335.420518542@mail.of.borg>
References: <20070501203234.252205858@mail.of.borg>
User-Agent: quilt/0.45-1
Date: Tue, 01 May 2007 22:32:55 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Finn Thain <fthain@telegraphics.com.au>
Subject: [patch 21/33] m68k: reverse Mac IRQ damage
Content-Disposition: inline; filename=mac68k-revert-remaining-irq-damage.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

Reverse the last of a monumental brown-paper-bag commit that went into the 2.3
kernel.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/mac/baboon.c |    2 +-
 arch/m68k/mac/oss.c    |    6 +++---
 arch/m68k/mac/psc.c    |    2 +-
 arch/m68k/mac/via.c    |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

--- linux-m68k-2.6.21.orig/arch/m68k/mac/baboon.c
+++ linux-m68k-2.6.21/arch/m68k/mac/baboon.c
@@ -81,9 +81,9 @@ irqreturn_t baboon_irq(int irq, void *de
 	for (i = 0, irq_bit = 1 ; i < 3 ; i++, irq_bit <<= 1) {
 	        if (events & irq_bit/* & baboon_active*/) {
 			baboon_active &= ~irq_bit;
+			baboon->mb_ifr &= ~irq_bit;
 			m68k_handle_int(IRQ_BABOON_0 + i);
 			baboon_active |= irq_bit;
-			baboon->mb_ifr &= ~irq_bit;
 		}
 	}
 #if 0
--- linux-m68k-2.6.21.orig/arch/m68k/mac/oss.c
+++ linux-m68k-2.6.21/arch/m68k/mac/oss.c
@@ -109,12 +109,12 @@ irqreturn_t oss_irq(int irq, void *dev_i
 	/* FIXME: how do you clear a pending IRQ?    */
 
 	if (events & OSS_IP_SOUND) {
-		/* FIXME: call sound handler */
 		oss->irq_pending &= ~OSS_IP_SOUND;
+		/* FIXME: call sound handler */
 	} else if (events & OSS_IP_SCSI) {
 		oss->irq_level[OSS_SCSI] = OSS_IRQLEV_DISABLED;
-		m68k_handle_int(IRQ_MAC_SCSI);
 		oss->irq_pending &= ~OSS_IP_SCSI;
+		m68k_handle_int(IRQ_MAC_SCSI);
 		oss->irq_level[OSS_SCSI] = OSS_IRQLEV_SCSI;
 	} else {
 		/* FIXME: error check here? */
@@ -146,8 +146,8 @@ irqreturn_t oss_nubus_irq(int irq, void 
 	for (i = 0, irq_bit = 1 ; i < 6 ; i++, irq_bit <<= 1) {
 		if (events & irq_bit) {
 			oss->irq_level[i] = OSS_IRQLEV_DISABLED;
-			m68k_handle_int(NUBUS_SOURCE_BASE + i);
 			oss->irq_pending &= ~irq_bit;
+			m68k_handle_int(NUBUS_SOURCE_BASE + i);
 			oss->irq_level[i] = OSS_IRQLEV_NUBUS;
 		}
 	}
--- linux-m68k-2.6.21.orig/arch/m68k/mac/psc.c
+++ linux-m68k-2.6.21/arch/m68k/mac/psc.c
@@ -149,8 +149,8 @@ irqreturn_t psc_irq(int irq, void *dev_i
 	for (i = 0, irq_bit = 1 ; i < 4 ; i++, irq_bit <<= 1) {
 	        if (events & irq_bit) {
 			psc_write_byte(pIER, irq_bit);
-			m68k_handle_int(base_irq + i);
 			psc_write_byte(pIFR, irq_bit);
+			m68k_handle_int(base_irq + i);
 			psc_write_byte(pIER, irq_bit | 0x80);
 		}
 	}
--- linux-m68k-2.6.21.orig/arch/m68k/mac/via.c
+++ linux-m68k-2.6.21/arch/m68k/mac/via.c
@@ -430,8 +430,8 @@ irqreturn_t via1_irq(int irq, void *dev_
 	for (i = 0, irq_bit = 1 ; i < 7 ; i++, irq_bit <<= 1)
 		if (events & irq_bit) {
 			via1[vIER] = irq_bit;
-			m68k_handle_int(VIA1_SOURCE_BASE + i);
 			via1[vIFR] = irq_bit;
+			m68k_handle_int(VIA1_SOURCE_BASE + i);
 			via1[vIER] = irq_bit | 0x80;
 		}
 

--
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

