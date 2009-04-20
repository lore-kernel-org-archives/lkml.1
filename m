Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbZDTCHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbZDTCHB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 22:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZDTCGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 22:06:52 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:47963
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852AbZDTCGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 22:06:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AogBAN9160l8qNY8/2dsb2JhbAAIy3iDfQY
X-IronPort-AV: E=Sophos;i="4.40,214,1238947200"; 
   d="scan'208";a="470583094"
Subject: [PATCH] ads7846: Allow both-edge interrupt mode
From: Ben Nizette <bn@niasdigital.com>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>, "imre.deak" <imre.deak@nokia.com>,
       "Egtvedt, Hans-Christian" <Hans-Christian.Egtvedt@atmel.com>,
       "haavard.skinnemoen" <haavard.skinnemoen@atmel.com>,
       kernel <kernel@avr32linux.org>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 12:06:18 +1000
Message-Id: <1240193178.24329.24.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some interrupt controllers (especially ones which can be used for
gpio as well) only support a limited number of interrupt modes.
Specifically, the AVR32 AT32AP7000's gpio interrupts only allow
both-edge triggering.

The ads7846 driver's interrupt handler can already deal with being
called for both edges of the interrupt, this patch adds the
ability for the platform to explicitly ask that the irq be
both-edge triggered to allow connection to a greater range of
interrupt controllers.

Also wire up the favr-32 board which requires this feature.

Tested on the favr-32 based ezLCD+101 from EarthLCD.

Signed-off-by: Ben Nizette <bn@niasdigital.com>
---
 arch/avr32/boards/favr-32/setup.c   |    6 ++++++
 drivers/input/touchscreen/ads7846.c |   10 +++++++++-
 include/linux/spi/ads7846.h         |    3 +++
 3 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/arch/avr32/boards/favr-32/setup.c b/arch/avr32/boards/favr-32/setup.c
index 46c9b0a..58203d1 100644
--- a/arch/avr32/boards/favr-32/setup.c
+++ b/arch/avr32/boards/favr-32/setup.c
@@ -72,6 +72,12 @@ static struct ads7846_platform_data ads7843_data = {
 	.debounce_max		= 20,
 	.debounce_rep		= 4,
 	.debounce_tol		= 5,
+
+	/* The ads7843 pendown irq is just connected to regular
+	 * gpio and therefore can only trigger interrupts on
+	 * both edges, not the falling-only mode which is the
+	 * driver default */
+	.force_irq_bothedge	= true,
 };
 
 static struct spi_board_info __initdata spi1_board_info[] = {
diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index 2b01e56..231f5d0 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -875,6 +875,7 @@ static int __devinit ads7846_probe(struct spi_device *spi)
 	struct spi_transfer		*x;
 	int				vref;
 	int				err;
+	int				irqflags;
 
 	if (!spi->irq) {
 		dev_dbg(&spi->dev, "no IRQ?\n");
@@ -1139,7 +1140,14 @@ static int __devinit ads7846_probe(struct spi_device *spi)
 
 	ts->last_msg = m;
 
-	if (request_irq(spi->irq, ads7846_irq, IRQF_TRIGGER_FALLING,
+	/* We only *need* falling edge interrupts but, if the
+	 * platform requests it, we can deal with both-edge too
+	 */
+	irqflags = IRQF_TRIGGER_FALLING;
+	if (pdata->force_irq_bothedge)
+		irqflags |= IRQF_TRIGGER_RISING;
+	
+	if (request_irq(spi->irq, ads7846_irq, irqflags,
 			spi->dev.driver->name, ts)) {
 		dev_dbg(&spi->dev, "irq %d busy?\n", spi->irq);
 		err = -EBUSY;
diff --git a/include/linux/spi/ads7846.h b/include/linux/spi/ads7846.h
index 2ea2032..dce814f 100644
--- a/include/linux/spi/ads7846.h
+++ b/include/linux/spi/ads7846.h
@@ -17,6 +17,9 @@ struct ads7846_platform_data {
 	u16	vref_mv;		/* external vref value, milliVolts */
 	bool	keep_vref_on;		/* set to keep vref on for differential
 					 * measurements as well */
+	bool	force_irq_bothedge;	/* Set if the interrupt to which the
+					 * ads7846 is connected only supports
+					 * both-edge triggering */
 
 	/* Settling time of the analog signals; a function of Vcc and the
 	 * capacitance on the X/Y drivers.  If set to non-zero, two samples
-- 
1.6.0.2


