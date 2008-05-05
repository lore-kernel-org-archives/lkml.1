Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbYEET0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbYEET0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbYEETZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:25:52 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:60043 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbYEETZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:25:51 -0400
Date: Mon, 5 May 2008 21:25:48 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] m68k: Handle 68040 bus faults
In-Reply-To: <Pine.LNX.4.64.0805052118050.24098@anakin>
Message-ID: <Pine.LNX.4.64.0805052125220.28495@anakin>
References: <Pine.LNX.4.64.0805052118050.24098@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Zippel <zippel@linux-m68k.org>

Fix 68040 bus fault handling, so the standard kernel exception handling
can be used for i/o probing.
Contrary to normal access faults there is nothing to fix, but at least
we have to disable writebacks to avoid recursive faults.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/traps.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -468,15 +468,26 @@ static inline void access_error040(struc
 			 * (if do_page_fault didn't fix the mapping,
                          * the writeback won't do good)
 			 */
+disable_wb:
 #ifdef DEBUG
 			printk(".. disabling wb2\n");
 #endif
 			if (fp->un.fmt7.wb2a == fp->un.fmt7.faddr)
 				fp->un.fmt7.wb2s &= ~WBV_040;
+			if (fp->un.fmt7.wb3a == fp->un.fmt7.faddr)
+				fp->un.fmt7.wb3s &= ~WBV_040;
 		}
-	} else if (send_fault_sig(&fp->ptregs) > 0) {
-		printk("68040 access error, ssw=%x\n", ssw);
-		trap_c(fp);
+	} else {
+		/* In case of a bus error we either kill the process or expect
+		 * the kernel to catch the fault, which then is also responsible
+		 * for cleaning up the mess.
+		 */
+		current->thread.signo = SIGBUS;
+		current->thread.faddr = fp->un.fmt7.faddr;
+		if (send_fault_sig(&fp->ptregs) >= 0)
+			printk("68040 bus error (ssw=%x, faddr=%lx)\n", ssw,
+			       fp->un.fmt7.faddr);
+		goto disable_wb;
 	}
 
 	do_040writebacks(fp);

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
