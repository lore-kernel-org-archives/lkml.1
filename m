Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbXFYKyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbXFYKyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 06:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbXFYKyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 06:54:06 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:51599 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbXFYKyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 06:54:04 -0400
Date: Mon, 25 Jun 2007 12:53:58 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Message-ID: <20070625105358.GA18739@gundam.enneenne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070621093719.GB4836@enneenne.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH] ARM PXA: invalid clocks settings.
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some bugs in the CPU clocks settings entered by commit
7053acbd78336abf5d4bc3d8a875a03624cfb83f. These bugs also prevent the system
in going to sleep correctly leaving it into a non consistent status.

The clocks enable/disable defines was changed from:

	#define CKEN_CAMERA  (1 << 24)

to:

	#define CKEN_CAMERA  (24)

so direct access to the CKEN register should be now in the form:

	CKEN |= (1 << CKEN_CAMERA)

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 arch/arm/mach-pxa/pxa27x.c  |    5 +++--
 sound/arm/pxa2xx-ac97.c     |    2 +-
 sound/soc/pxa/pxa2xx-ac97.c |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-pxa/pxa27x.c b/arch/arm/mach-pxa/pxa27x.c
index c64bab4..7be8a74 100644
--- a/arch/arm/mach-pxa/pxa27x.c
+++ b/arch/arm/mach-pxa/pxa27x.c
@@ -140,9 +140,10 @@ void pxa_cpu_pm_enter(suspend_state_t state)
 	extern void pxa_cpu_resume(void);
 
 	if (state == PM_SUSPEND_STANDBY)
-		CKEN = CKEN_MEMC | CKEN_OSTIMER | CKEN_LCD | CKEN_PWM0;
+		CKEN = (1 << CKEN_MEMC) | (1 << CKEN_OSTIMER) | \
+			(1 << CKEN_LCD) | (1 << CKEN_PWM0);
 	else
-		CKEN = CKEN_MEMC | CKEN_OSTIMER;
+		CKEN = (1 << CKEN_MEMC) | (1 << CKEN_OSTIMER);
 
 	/* ensure voltage-change sequencer not initiated, which hangs */
 	PCFR &= ~PCFR_FVC;
diff --git a/sound/arm/pxa2xx-ac97.c b/sound/arm/pxa2xx-ac97.c
index 19c65a8..7bc2767 100644
--- a/sound/arm/pxa2xx-ac97.c
+++ b/sound/arm/pxa2xx-ac97.c
@@ -361,7 +361,7 @@ static int __devinit pxa2xx_ac97_probe(struct platform_device *dev)
  err:
 	if (card)
 		snd_card_free(card);
-	if (CKEN & CKEN_AC97) {
+	if (CKEN & (1 << CKEN_AC97)) {
 		GCR |= GCR_ACLINK_OFF;
 		free_irq(IRQ_AC97, NULL);
 		pxa_set_cken(CKEN_AC97, 0);
diff --git a/sound/soc/pxa/pxa2xx-ac97.c b/sound/soc/pxa/pxa2xx-ac97.c
index b222755..129d851 100644
--- a/sound/soc/pxa/pxa2xx-ac97.c
+++ b/sound/soc/pxa/pxa2xx-ac97.c
@@ -300,7 +300,7 @@ static int pxa2xx_ac97_probe(struct platform_device *pdev)
 	return 0;
 
  err:
-	if (CKEN & CKEN_AC97) {
+	if (CKEN & (1 << CKEN_AC97)) {
 		GCR |= GCR_ACLINK_OFF;
 		free_irq(IRQ_AC97, NULL);
 		pxa_set_cken(CKEN_AC97, 0);
-- 
1.5.2.2


-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
