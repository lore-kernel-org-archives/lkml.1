Return-Path: <linux-kernel-owner+w=401wt.eu-S1945958AbXEAUqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945958AbXEAUqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945943AbXEAUmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:42:18 -0400
Received: from asia.telenet-ops.be ([195.130.137.74]:36893 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423612AbXEAUe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:34:56 -0400
Message-Id: <20070501203332.818015160@mail.of.borg>
References: <20070501203234.252205858@mail.of.borg>
User-Agent: quilt/0.45-1
Date: Tue, 01 May 2007 22:32:46 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 12/33] m68k: make Atari IDE lock reentrant
Content-Disposition: inline; filename=falconide_intr_lock-reentrant.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From Roman Zippel <zippel@linux-m68k.org>

Make the Atari IDE lock reentrant, as the new request is started in the
interrupt before the last one is completely released.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
---
 include/asm-m68k/ide.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-m68k-2.6.21.orig/include/asm-m68k/ide.h
+++ linux-m68k-2.6.21/include/asm-m68k/ide.h
@@ -117,8 +117,8 @@ static __inline__ void ide_release_lock 
 			printk("ide_release_lock: bug\n");
 			return;
 		}
-		falconide_intr_lock = 0;
-		stdma_release();
+		if (!--falconide_intr_lock)
+			stdma_release();
 	}
 }
 
@@ -126,12 +126,12 @@ static __inline__ void
 ide_get_lock(irq_handler_t handler, void *data)
 {
 	if (MACH_IS_ATARI) {
-		if (falconide_intr_lock == 0) {
+		if (!falconide_intr_lock) {
 			if (in_interrupt() > 0)
 				panic( "Falcon IDE hasn't ST-DMA lock in interrupt" );
 			stdma_lock(handler, data);
-			falconide_intr_lock = 1;
 		}
+		falconide_intr_lock++;
 	}
 }
 #endif /* CONFIG_BLK_DEV_FALCON_IDE */

--
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

