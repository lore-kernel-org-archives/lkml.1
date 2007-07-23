Return-Path: <linux-kernel-owner+w=401wt.eu-S1763483AbXGWW0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763483AbXGWW0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 18:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbXGWW0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 18:26:07 -0400
Received: from aun.it.uu.se ([130.238.12.36]:39124 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbXGWW0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 18:26:05 -0400
Date: Tue, 24 Jul 2007 00:25:59 +0200 (MEST)
Message-Id: <200707232225.l6NMPxrq009114@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.23-rc1] APM detection logic bug fix
Cc: "H. Peter Anvin" <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Starting with kernel 2.6.23-rc1, the i386 APM driver fails
on several of my machines with the message:

apm: BIOS not found

This happens because of a bug in the i386 boot code rewrite
from assembler to C. The original assembly code had the
following code in its APM BIOS presence test (boot/setup.S):

	andw	$0x02, %cx			# Is 32 bit supported?
	je	done_apm_bios			# No 32-bit, no (good) APM BIOS

That is, the code bails out if bit 2 is zero.

In the new C version, this is coded as (boot/apm.c):

	if (cx & 0x02)		/* 32 bits supported? */
		return -1;

Here we see that the test has been accidentally inverted.

The fix is to negate the test. I've verified that this
allows the APM driver to work again on my affected machines.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>

diff -rupN linux-2.6.23-rc1/arch/i386/boot/apm.c linux-2.6.23-rc1.apm-detect-fix/arch/i386/boot/apm.c
--- linux-2.6.23-rc1/arch/i386/boot/apm.c	2007-07-23 02:32:03.000000000 +0200
+++ linux-2.6.23-rc1.apm-detect-fix/arch/i386/boot/apm.c	2007-07-23 23:51:17.000000000 +0200
@@ -40,7 +40,7 @@ int query_apm_bios(void)
 	if (bx != 0x504d)	/* "PM" signature */
 		return -1;
 
-	if (cx & 0x02)		/* 32 bits supported? */
+	if (!(cx & 0x02))		/* 32 bits supported? */
 		return -1;
 
 	/* Disconnect first, just in case */
