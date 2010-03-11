Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab0CKULW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 15:11:22 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:29682 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120Ab0CKUKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 15:10:48 -0500
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
To: linux@arm.linux.org.uk, mroberto@cpti.cetuc.puc-rio.br
Cc: mad_soft@inbox.ru, rpjday@crashcourse.ca, jaswinderrajput@gmail.com,
       kristoffer.ericson@gmail.com, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] ARM: mach-sa1100: Fix for a nasty initialization bug in the RTSR.
Date: Thu, 11 Mar 2010 17:10:24 -0300
Message-Id: <1268338225-32253-3-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1268338225-32253-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
References: <1268338225-32253-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a nasty initialization condition on the RTSR register.
Sometimes, bit 1 will wake up set, sometimes not. This can be seen
by checking the value of the RTSR by typing '$ cat /proc/driver/rtc',
which has been provided by the previous patch.

If this bit is set, the command '$ cat /dev/rtc0' will lock the system
in an endless interrupt routine calling loop.

This patch fixes the issue both at sa1100_rtc_probe(), where it avoids
a spurious interrupt from happening, and at sa1100_rtc_interrupt(),
which is the robust solution, though it does not avoid the first
spurious interrupt.

Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
---
 drivers/rtc/rtc-sa1100.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index b04c837..b0985f7 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -117,7 +117,23 @@ static irqreturn_t sa1100_rtc_interrupt(int irq, void *dev_id)
 	rtsr = RTSR;
 	/* clear interrupt sources */
 	RTSR = 0;
-	RTSR = (RTSR_AL | RTSR_HZ) & (rtsr >> 2);
+	/* Fix for a nasty initialization problem the in SA11xx RTSR register.
+	 * See also the comments in sa1100_rtc_probe(). */
+	if (rtsr & (RTSR_ALE | RTSR_HZE)) {
+		/* This is the original code, before there was the if test
+		 * above. This code does not clear interrupts that were not
+		 * enabled. */
+		RTSR = (RTSR_AL | RTSR_HZ) & (rtsr >> 2);
+	} else {
+		/* For some reason, it is possible to enter this routine
+		 * without interruptions enabled, it has been tested with
+		 * several units (Bug in SA11xx chip?).
+		 *
+		 * This situation leads to an infinite "loop" of interrupt
+		 * routine calling and as a result the processor seems to
+		 * lock on its first call to open(). */
+		RTSR = RTSR_AL | RTSR_HZ;
+	}
 
 	/* clear alarm interrupt if it has occurred */
 	if (rtsr & RTSR_AL)
@@ -382,6 +398,30 @@ static int sa1100_rtc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, rtc);
 
+	/* Fix for a nasty initialization problem the in SA11xx RTSR register.
+	 * See also the comments in sa1100_rtc_interrupt().
+	 *
+	 * Sometimes bit 1 of the RTSR (RTSR_HZ) will wake up 1, which means an
+	 * interrupt pending, even though interrupts were never enabled.
+	 * In this case, this bit it must be reset before enabling
+	 * interruptions to avoid a nonexistent interrupt to occur.
+	 *
+	 * In principle, the same problem would apply to bit 0, although it has
+	 * never been observed to happen.
+	 *
+	 * This issue is addressed both here and in sa1100_rtc_interrupt().
+	 * If the issue is not addressed here, in the times when the processor
+	 * wakes up with the bit set there will be one spurious interrupt.
+	 *
+	 * The issue is also dealt with in sa1100_rtc_interrupt() to be on the
+	 * safe side, once the condition that lead to this strange
+	 * initialization is unknown and could in principle happen during
+	 * normal processing.
+	 *
+	 * Notice that clearing bit 1 and 0 is accomplished by writting ONES to
+	 * the corresponding bits in RTSR. */
+	RTSR = RTSR_AL | RTSR_HZ;
+
 	return 0;
 }
 
-- 
1.7.0.1

