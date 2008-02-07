Return-Path: <linux-kernel-owner+w=401wt.eu-S933700AbYBGWKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700AbYBGWKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932975AbYBGWKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:10:34 -0500
Received: from harold.telenet-ops.be ([195.130.133.65]:46721 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982AbYBGWKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:10:32 -0500
Date: Thu, 7 Feb 2008 23:10:28 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k: correct setting of struct user.u_ar0
Message-ID: <Pine.LNX.4.64.0802072309460.1833@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6e16d89bcd668a95eb22add24c02d80890232b66

    Sanitize the type of struct user.u_ar0
    
    struct user.u_ar0 is defined to contain a pointer offset on all
    architectures in which it is defined (all architectures which define an
    a.out format except SPARC.) However, it has a pointer type in the headers,
    which is pointless -- <asm/user.h> is not exported to userspace, and it
    just makes the code messy.
    
    Redefine the field as "unsigned long" (which is the same size as a pointer
    on all Linux architectures) and change the setting code to user offsetof()
    instead of hand-coded arithmetic.

forgot to change the m68k setting code, causing the following compiler warning:

    arch/m68k/kernel/process.c:338: warning: assignment makes integer from pointer without a cast

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -335,7 +335,7 @@ void dump_thread(struct pt_regs * regs, 
 	if (dump->start_stack < TASK_SIZE)
 		dump->u_ssize = ((unsigned long) (TASK_SIZE - dump->start_stack)) >> PAGE_SHIFT;
 
-	dump->u_ar0 = (struct user_regs_struct *)((int)&dump->regs - (int)dump);
+	dump->u_ar0 = offsetof(struct user, regs);
 	sw = ((struct switch_stack *)regs) - 1;
 	dump->regs.d1 = regs->d1;
 	dump->regs.d2 = regs->d2;

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
