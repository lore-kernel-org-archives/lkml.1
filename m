Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbXIXF55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbXIXF55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 01:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbXIXF5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 01:57:50 -0400
Received: from ozlabs.org ([203.10.76.45]:54305 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbXIXF5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 01:57:49 -0400
Subject: [PATCH] fix modules oopsing in lguest guests
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 15:57:04 +1000
Message-Id: <1190613424.27805.181.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The assembly templates for lguest guest patching are in the .init.text
section.  This means that modules get patched with "cc cc cc cc" or
similar junk.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 554f72e059aa drivers/lguest/lguest_asm.S
--- a/drivers/lguest/lguest_asm.S	Thu Sep 13 16:56:44 2007 +1000
+++ b/drivers/lguest/lguest_asm.S	Mon Sep 24 15:34:31 2007 +1000
@@ -22,8 +22,9 @@
 	jmp lguest_init
 
 /*G:055 We create a macro which puts the assembler code between lgstart_ and
- * lgend_ markers.  These templates end up in the .init.text section, so they
- * are discarded after boot. */
+ * lgend_ markers.  These templates are put in the .text section: they can't be
+ * discarded after boot as we may need to patch modules, too. */
+.text
 #define LGUEST_PATCH(name, insns...)			\
 	lgstart_##name:	insns; lgend_##name:;		\
 	.globl lgstart_##name; .globl lgend_##name
@@ -34,7 +35,6 @@ LGUEST_PATCH(pushf, movl lguest_data+LGU
 LGUEST_PATCH(pushf, movl lguest_data+LGUEST_DATA_irq_enabled, %eax)
 /*:*/
 
-.text
 /* These demark the EIP range where host should never deliver interrupts. */
 .global lguest_noirq_start
 .global lguest_noirq_end


