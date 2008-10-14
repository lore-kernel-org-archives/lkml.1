Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbYJNTgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbYJNTgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 15:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbYJNTgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 15:36:35 -0400
Received: from smtp1.nine.ch ([217.150.241.29]:37159 "EHLO smtp1.nine.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbYJNTge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 15:36:34 -0400
X-Greylist: delayed 1289 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2008 15:36:34 EDT
Date: Tue, 14 Oct 2008 21:15:02 +0200 (CEST)
From: Alex Raimondi <mailinglist@miromico.ch>
X-X-Sender: raimondi@ibm1
To: haavard.skinnemoen@atmel.com
cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org, jmay@miromico.ch
Subject: [PATCH 1/1] Bypass probe_on_irq in ucb1400_ts
Message-ID: <alpine.DEB.1.10.0810142103500.5803@ibm1>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Irq probing in ucb1400_ts (drivers/input/touchscreen) fails (at least on 
our AVR32 board). On irq probing system hangs. 

This patch introduces a module parameter 'irq' to specify the irq line to 
use.  If modul is loaded with this parameter irq probing is bypassed, 
otherwise irq is probed.

I don't know who is actually maintaining the ucb1400_ts code. But I didn't 
want to sneak it in with our Hammerhead board code. Maybe you have an idea 
why irq probing fails.


Alex

>From 35cfb1355ace42fb6e83c34b0a0dd626a6f81d6e Mon Sep 17 00:00:00 2001
From: Alex Raimondi <mailinglist@miromico.ch>
Date: Tue, 14 Oct 2008 16:20:19 +0200
Subject: [PATCH 6/7] Automatic irq probing fails (at least) on AVR32 (system hangs). This
 patch introduces a module parameter in ucb1400_ts which allows to
 bypass irq probing by specifying the irq to use on the command line.


Signed-off-by: Alex Raimondi <mailinglist@miromico.ch>
---
 drivers/input/touchscreen/ucb1400_ts.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/input/touchscreen/ucb1400_ts.c b/drivers/input/touchscreen/ucb1400_ts.c
index 607f993..09bd395 100644
--- a/drivers/input/touchscreen/ucb1400_ts.c
+++ b/drivers/input/touchscreen/ucb1400_ts.c
@@ -97,6 +97,10 @@ struct ucb1400 {
 static int adcsync;
 static int ts_delay = 55; /* us */
 static int ts_delay_pressure;	/* us */
+static int irq;
+
+module_param(irq, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP);
+MODULE_PARM_DESC(irq, "IRQ");
 
 static inline u16 ucb1400_reg_read(struct ucb1400 *ucb, u16 reg)
 {
@@ -484,6 +488,8 @@ static int ucb1400_ts_probe(struct device *dev)
 	ucb->ts_idev = idev;
 	ucb->adcsync = adcsync;
 	ucb->ac97 = to_ac97_t(dev);
+	ucb->irq = irq;
+
 	init_waitqueue_head(&ucb->ts_wait);
 
 	id = ucb1400_reg_read(ucb, UCB_ID);
@@ -492,12 +498,15 @@ static int ucb1400_ts_probe(struct device *dev)
 		goto err_free_devs;
 	}
 
-	error = ucb1400_detect_irq(ucb);
-	if (error) {
-		printk(KERN_ERR "UCB1400: IRQ probe failed\n");
-		goto err_free_devs;
+	if (ucb->irq == 0) {
+		error = ucb1400_detect_irq(ucb);
+		if (error) {
+			printk(KERN_ERR "UCB1400: IRQ probe failed\n");
+			goto err_free_devs;
+		}
 	}
 
+
 	error = request_irq(ucb->irq, ucb1400_hard_irq, IRQF_TRIGGER_RISING,
 				"UCB1400", ucb);
 	if (error) {
-- 
1.5.5.GIT

