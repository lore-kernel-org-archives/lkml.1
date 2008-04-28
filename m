Return-Path: <linux-kernel-owner+w=401wt.eu-S932694AbYD1LNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbYD1LNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 07:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763109AbYD1LM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 07:12:59 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:50737 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763069AbYD1LM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 07:12:58 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-5.tower-164.messagelabs.com!1209381175!13764032!2
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] let setup_irq reenable a shared irq
Date: Mon, 28 Apr 2008 13:12:51 +0200
Message-ID: <1209381171-5520-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 Apr 2008 11:12:51.0807 (UTC) FILETIME=[CCAE1EF0:01C8A920]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.500.1026-15876.006
X-TM-AS-Result: No--9.311000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consider two devices A and B sharing an irq and B already asserts the irq on
a booting machine.
If the driver for A is loaded first the irq starts triggering and gets
disabled after some time by note_interrupt().  Later when the driver for B
is loaded the interrupt should be reenabled---other wise both A and B don't
work properly.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 438a014..831ebb2 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -365,11 +365,18 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 
 		desc->status &= ~(IRQ_AUTODETECT | IRQ_WAITING |
 				  IRQ_INPROGRESS);
+	}
+
+	/* in the shared case the interrupt might be disabled if a device
+	 * asserts the irq but the corresponding driver wasn't the first to be
+	 * loaded.  So retry enabling the irq.
+	 */
+	if (!shared || desc->status & IRQ_DISABLED) {
 
 		if (!(desc->status & IRQ_NOAUTOEN)) {
 			desc->depth = 0;
 			desc->status &= ~IRQ_DISABLED;
-			if (desc->chip->startup)
+			if (!shared && desc->chip->startup)
 				desc->chip->startup(irq);
 			else
 				desc->chip->enable(irq);
-- 
1.5.5.1

