Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0BAMnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 07:43:18 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:27426 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab0BAMnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 07:43:17 -0500
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Feb 2010 07:43:16 EST
X-Spam-Processed: digidescorp.com, Mon, 01 Feb 2010 06:34:55 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 99.142.26.81
X-Return-Path: prvs=16487511a4=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: steve@digidescorp.com
To: microblaze-uclinux@itee.uq.edu.au
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
       "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH][NOMMU] microblaze: fix interrupt state restore
Date: Mon,  1 Feb 2010 06:34:45 -0600
Message-Id: <1265027685-8990-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interrupts must be disabled while an interrupt state restore 
(prep for interrupt return) is in progress.
Code to do this was lost in the port to the mainline kernel.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/arch/microblaze/kernel/entry-nommu.S b/arch/microblaze/kernel/entry-nommu.S
--- a/arch/microblaze/kernel/entry-nommu.S	2010-01-31 23:28:45.000000000 -0600
+++ b/arch/microblaze/kernel/entry-nommu.S	2010-01-31 23:31:35.000000000 -0600
@@ -122,7 +122,7 @@ ENTRY(_interrupt)
 
 ret_from_intr:
 	lwi	r11, r1, PT_MODE
-	bneid	r11, 3f
+	bneid	r11, no_intr_resched
 
 	lwi	r6, r31, TS_THREAD_INFO	/* get thread info */
 	lwi	r19, r6, TI_FLAGS	/* get flags in thread info */
@@ -133,16 +133,18 @@ ret_from_intr:
 	bralid	r15, schedule
 	nop
 1:	andi	r11, r19, _TIF_SIGPENDING
-	beqid	r11, no_intr_reshed
+	beqid	r11, no_intr_resched
 	addk	r5, r1, r0
 	addk	r7, r0, r0
 	bralid	r15, do_signal
 	addk	r6, r0, r0
 
-no_intr_reshed:
+no_intr_resched:
+	/* Disable interrupts, we are now committed to the state restore */
+	disable_irq
+
 	/* save mode indicator */
 	lwi	r11, r1, PT_MODE
-3:
 	swi	r11, r0, PER_CPU(KM)
 
 	/* save r31 */

