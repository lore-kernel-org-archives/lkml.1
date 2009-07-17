Return-Path: <linux-kernel-owner+w=401wt.eu-S933816AbZGQAJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933816AbZGQAJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933713AbZGQAJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:09:53 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39106 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933232AbZGQAFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:05:48 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 01/21] Blackfin: cleanup code a bit with comments and defines
Date: Thu, 16 Jul 2009 20:05:26 -0400
Message-Id: <1247789146-18786-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
References: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

Improve the assembly with a few explanatory comments and use symbolic
defines rather than numeric values for bit positions.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-common/entry.S |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index 5a4e7c7..fb1795d 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -218,7 +218,7 @@ ENTRY(_ex_single_step)
 	/* Single stepping only a single instruction, so clear the trace
 	 * bit here.  */
 	r7 = syscfg;
-	bitclr (r7, 0);
+	bitclr (r7, SYSCFG_SSSTEP_P);
 	syscfg = R7;
 	jump _ex_trap_c;
 
@@ -251,7 +251,7 @@ ENTRY(_ex_single_step)
 	if !cc jump _bfin_return_from_exception;
 
 	r7 = syscfg;
-	bitclr (r7, 0);
+	bitclr (r7, SYSCFG_SSSTEP_P);	/* Turn off single step */
 	syscfg = R7;
 
 	/* Fall through to _bfin_return_from_exception.  */
@@ -342,9 +342,11 @@ ENTRY(_ex_trap_c)
 	r6 = retx;
 	[p5 + PDA_RETX] = r6;
 #endif
+	/* Save the state of single stepping */
 	r6 = SYSCFG;
 	[p5 + PDA_SYSCFG] = r6;
-	BITCLR(r6, 0);
+	/* Clear it while we handle the exception in IRQ5 mode */
+	BITCLR(r6, SYSCFG_SSSTEP_P);
 	SYSCFG = r6;
 
 	/* Disable all interrupts, but make sure level 5 is enabled so
@@ -367,7 +369,7 @@ ENDPROC(_ex_trap_c)
  * exception. This is a unrecoverable event, so crash.
  * Note: this cannot be ENTRY() as we jump here with "if cc jump" ...
  */
-_double_fault:
+ENTRY(_double_fault)
 	/* Turn caches & protection off, to ensure we don't get any more
 	 * double exceptions
 	 */
@@ -872,7 +874,7 @@ ENTRY(_ret_from_exception)
 	raise 15;		/* raise evt15 to do signal or reschedule */
 4:
 	r0 = syscfg;
-	bitclr(r0, 0);
+	bitclr(r0, SYSCFG_SSSTEP_P);		/* Turn off single step */
 	syscfg = r0;
 5:
 	rts;
-- 
1.6.3.3

