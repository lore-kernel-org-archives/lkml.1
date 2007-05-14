Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbXENSj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbXENSj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 14:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756860AbXENSjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 14:39:21 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:35119 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289AbXENSjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 14:39:20 -0400
X-Originating-Ip: 72.143.66.196
Date: Mon, 14 May 2007 14:38:38 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: tglx@linutronix.de
Subject: [PATCH][RFC] Remove final vestiges of interrupt-related "SA_" flags.
Message-ID: <Pine.LNX.4.64.0705141433490.14658@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.569, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	TW_QA 0.08, TW_QR 0.08, TW_RQ 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the few remaining traces of the interrupt-related "SA_" flags,
which were scheduled for official deletion in September of 2007,
anyway.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  there's little point in leaving this cruft in the tree since there
were only two instances of the deprecated flags left and since the
comment clearly states that the old flags were *not* to be used for
new code, there's no point continuing to support them once there are
no instances left in the tree.

  note:  this is just an RFC since there are still random comments
sprinkled around the tree referring to things like SA_INTERRUPT, so
this patch can still be prettied up a bit.

 Documentation/feature-removal-schedule.txt |    9 -------
 drivers/misc/tifm_7xx1.c                   |    2 -
 drivers/usb/gadget/fsl_usb2_udc.c          |    2 -
 include/linux/interrupt.h                  |   22 -------------------
 4 files changed, 2 insertions(+), 33 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 498ff31..c5d7775 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -160,15 +160,6 @@ Who:	Greg Kroah-Hartman <gregkh@suse.de>

 ---------------------------

-What:	Interrupt only SA_* flags
-When:	September 2007
-Why:	The interrupt related SA_* flags are replaced by IRQF_* to move them
-	out of the signal namespace.
-
-Who:	Thomas Gleixner <tglx@linutronix.de>
-
----------------------------
-
 What:	PHYSDEVPATH, PHYSDEVBUS, PHYSDEVDRIVER in the uevent environment
 When:	October 2008
 Why:	The stacking of class devices makes these values misleading and
diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
index c08ad8f..2d1b3df 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -343,7 +343,7 @@ static int tifm_7xx1_probe(struct pci_dev *dev,
 	if (!fm->addr)
 		goto err_out_free;

-	rc = request_irq(dev->irq, tifm_7xx1_isr, SA_SHIRQ, DRIVER_NAME, fm);
+	rc = request_irq(dev->irq, tifm_7xx1_isr, IRQF_SHARED, DRIVER_NAME, fm);
 	if (rc)
 		goto err_out_unmap;

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index 157054e..7f07a27 100644
--- a/drivers/usb/gadget/fsl_usb2_udc.c
+++ b/drivers/usb/gadget/fsl_usb2_udc.c
@@ -2332,7 +2332,7 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 		goto err2;
 	}

-	ret = request_irq(udc_controller->irq, fsl_udc_irq, SA_SHIRQ,
+	ret = request_irq(udc_controller->irq, fsl_udc_irq, IRQF_SHARED,
 			driver_name, udc_controller);
 	if (ret != 0) {
 		ERR("cannot request irq %d err %d \n",
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 5323f62..f048241 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -57,28 +57,6 @@
 #define IRQF_NOBALANCING	0x00000800
 #define IRQF_IRQPOLL		0x00001000

-/*
- * Migration helpers. Scheduled for removal in 9/2007
- * Do not use for new code !
- */
-static inline
-unsigned long __deprecated deprecated_irq_flag(unsigned long flag)
-{
-	return flag;
-}
-
-#define SA_INTERRUPT		deprecated_irq_flag(IRQF_DISABLED)
-#define SA_SAMPLE_RANDOM	deprecated_irq_flag(IRQF_SAMPLE_RANDOM)
-#define SA_SHIRQ		deprecated_irq_flag(IRQF_SHARED)
-#define SA_PROBEIRQ		deprecated_irq_flag(IRQF_PROBE_SHARED)
-#define SA_PERCPU		deprecated_irq_flag(IRQF_PERCPU)
-
-#define SA_TRIGGER_LOW		deprecated_irq_flag(IRQF_TRIGGER_LOW)
-#define SA_TRIGGER_HIGH		deprecated_irq_flag(IRQF_TRIGGER_HIGH)
-#define SA_TRIGGER_FALLING	deprecated_irq_flag(IRQF_TRIGGER_FALLING)
-#define SA_TRIGGER_RISING	deprecated_irq_flag(IRQF_TRIGGER_RISING)
-#define SA_TRIGGER_MASK		deprecated_irq_flag(IRQF_TRIGGER_MASK)
-
 typedef irqreturn_t (*irq_handler_t)(int, void *);

 struct irqaction {

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
