Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab0BJWAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 17:00:31 -0500
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:42575 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab0BJWAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 17:00:30 -0500
Date: Wed, 10 Feb 2010 23:00:25 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] winbond-cir: fix suspend/resume
Message-ID: <20100210220025.GA10609@hardeman.nu>
Mail-Followup-To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I finally got the time to fix suspend/resume with the winbond-cir
driver on my mainboard. The main problem turned out to be that the
ACPI _DIS method would completely power off the SP3 module which
meant that the output lines (including IRQ lines) would be left
in an undefined state which could cause spurious interrupts and
that the hardware has to be reinitialized from scratch during
resume.

This fixes:
http://bugzilla.kernel.org/show_bug.cgi?id=15257

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/input/misc/winbond-cir.c |  213 ++++++++++++++++++-------------------
 1 files changed, 104 insertions(+), 109 deletions(-)

diff --git a/drivers/input/misc/winbond-cir.c b/drivers/input/misc/winbond-cir.c
index c8f5a9a..cbec3df 100644
--- a/drivers/input/misc/winbond-cir.c
+++ b/drivers/input/misc/winbond-cir.c
@@ -538,6 +538,7 @@ wbcir_reset_irdata(struct wbcir_data *data)
 	data->irdata_count = 0;
 	data->irdata_off = 0;
 	data->irdata_error = 0;
+	data->idle_count = 0;
 }
 
 /* Adds one bit of irdata */
@@ -1006,7 +1007,6 @@ wbcir_irq_handler(int irqno, void *cookie)
 		}
 
 		wbcir_reset_irdata(data);
-		data->idle_count = 0;
 	}
 
 out:
@@ -1018,7 +1018,7 @@ out:
 
 /*****************************************************************************
  *
- * SUSPEND/RESUME FUNCTIONS
+ * SETUP/INIT/SUSPEND/RESUME FUNCTIONS
  *
  *****************************************************************************/
 
@@ -1197,7 +1197,16 @@ finish:
 	}
 
 	/* Disable interrupts */
+	wbcir_select_bank(data, WBCIR_BANK_0);
 	outb(WBCIR_IRQ_NONE, data->sbase + WBCIR_REG_SP3_IER);
+
+	/*
+	 * ACPI will set the HW disable bit for SP3 which means that the
+	 * output signals are left in an undefined state which may cause
+	 * spurious interrupts which we need to ignore until the hardware
+	 * is reinitialized.
+	 */
+	disable_irq(data->irq);
 }
 
 static int
@@ -1207,37 +1216,15 @@ wbcir_suspend(struct pnp_dev *device, pm_message_t state)
 	return 0;
 }
 
-static int
-wbcir_resume(struct pnp_dev *device)
-{
-	struct wbcir_data *data = pnp_get_drvdata(device);
-
-	/* Clear BUFF_EN, Clear END_EN, Clear MATCH_EN */
-	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_EV_EN, 0x00, 0x07);
-
-	/* Clear CEIR_EN */
-	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_CTL, 0x00, 0x01);
-
-	/* Enable interrupts */
-	wbcir_reset_irdata(data);
-	outb(WBCIR_IRQ_RX | WBCIR_IRQ_ERR, data->sbase + WBCIR_REG_SP3_IER);
-
-	return 0;
-}
-
-
-
-/*****************************************************************************
- *
- * SETUP/INIT FUNCTIONS
- *
- *****************************************************************************/
-
 static void
-wbcir_cfg_ceir(struct wbcir_data *data)
+wbcir_init_hw(struct wbcir_data *data)
 {
 	u8 tmp;
 
+	/* Disable interrupts */
+	wbcir_select_bank(data, WBCIR_BANK_0);
+	outb(WBCIR_IRQ_NONE, data->sbase + WBCIR_REG_SP3_IER);
+
 	/* Set PROT_SEL, RX_INV, Clear CEIR_EN (needed for the led) */
 	tmp = protocol << 4;
 	if (invert)
@@ -1264,6 +1251,93 @@ wbcir_cfg_ceir(struct wbcir_data *data)
 	 * set SP3_IRRX_SW to binary 01, helpfully not documented
 	 */
 	outb(0x10, data->ebase + WBCIR_REG_ECEIR_CTS);
+
+	/* Enable extended mode */
+	wbcir_select_bank(data, WBCIR_BANK_2);
+	outb(WBCIR_EXT_ENABLE, data->sbase + WBCIR_REG_SP3_EXCR1);
+
+	/*
+	 * Configure baud generator, IR data will be sampled at
+	 * a bitrate of: (24Mhz * prescaler) / (divisor * 16).
+	 *
+	 * The ECIR registers include a flag to change the
+	 * 24Mhz clock freq to 48Mhz.
+	 *
+	 * It's not documented in the specs, but fifo levels
+	 * other than 16 seems to be unsupported.
+	 */
+
+	/* prescaler 1.0, tx/rx fifo lvl 16 */
+	outb(0x30, data->sbase + WBCIR_REG_SP3_EXCR2);
+
+	/* Set baud divisor to generate one byte per bit/cell */
+	switch (protocol) {
+	case IR_PROTOCOL_RC5:
+		outb(0xA7, data->sbase + WBCIR_REG_SP3_BGDL);
+		break;
+	case IR_PROTOCOL_RC6:
+		outb(0x53, data->sbase + WBCIR_REG_SP3_BGDL);
+		break;
+	case IR_PROTOCOL_NEC:
+		outb(0x69, data->sbase + WBCIR_REG_SP3_BGDL);
+		break;
+	}
+	outb(0x00, data->sbase + WBCIR_REG_SP3_BGDH);
+
+	/* Set CEIR mode */
+	wbcir_select_bank(data, WBCIR_BANK_0);
+	outb(0xC0, data->sbase + WBCIR_REG_SP3_MCR);
+	inb(data->sbase + WBCIR_REG_SP3_LSR); /* Clear LSR */
+	inb(data->sbase + WBCIR_REG_SP3_MSR); /* Clear MSR */
+
+	/* Disable RX demod, run-length encoding/decoding, set freq span */
+	wbcir_select_bank(data, WBCIR_BANK_7);
+	outb(0x10, data->sbase + WBCIR_REG_SP3_RCCFG);
+
+	/* Disable timer */
+	wbcir_select_bank(data, WBCIR_BANK_4);
+	outb(0x00, data->sbase + WBCIR_REG_SP3_IRCR1);
+
+	/* Enable MSR interrupt, Clear AUX_IRX */
+	wbcir_select_bank(data, WBCIR_BANK_5);
+	outb(0x00, data->sbase + WBCIR_REG_SP3_IRCR2);
+
+	/* Disable CRC */
+	wbcir_select_bank(data, WBCIR_BANK_6);
+	outb(0x20, data->sbase + WBCIR_REG_SP3_IRCR3);
+
+	/* Set RX/TX (de)modulation freq, not really used */
+	wbcir_select_bank(data, WBCIR_BANK_7);
+	outb(0xF2, data->sbase + WBCIR_REG_SP3_IRRXDC);
+	outb(0x69, data->sbase + WBCIR_REG_SP3_IRTXMC);
+
+	/* Set invert and pin direction */
+	if (invert)
+		outb(0x10, data->sbase + WBCIR_REG_SP3_IRCFG4);
+	else
+		outb(0x00, data->sbase + WBCIR_REG_SP3_IRCFG4);
+
+	/* Set FIFO thresholds (RX = 8, TX = 3), reset RX/TX */
+	wbcir_select_bank(data, WBCIR_BANK_0);
+	outb(0x97, data->sbase + WBCIR_REG_SP3_FCR);
+
+	/* Clear AUX status bits */
+	outb(0xE0, data->sbase + WBCIR_REG_SP3_ASCR);
+
+	/* Enable interrupts */
+	wbcir_reset_irdata(data);
+	outb(WBCIR_IRQ_RX | WBCIR_IRQ_ERR, data->sbase + WBCIR_REG_SP3_IER);
+}
+
+static int
+wbcir_resume(struct pnp_dev *device)
+{
+	struct wbcir_data *data = pnp_get_drvdata(device);
+
+	wbcir_init_hw(data);
+	enable_irq(data->irq);
+
+	return 0;
 }
 
 static int __devinit
@@ -1393,86 +1467,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 
 	device_init_wakeup(&device->dev, 1);
 
-	wbcir_cfg_ceir(data);
-
-	/* Disable interrupts */
-	wbcir_select_bank(data, WBCIR_BANK_0);
-	outb(WBCIR_IRQ_NONE, data->sbase + WBCIR_REG_SP3_IER);
-
-	/* Enable extended mode */
-	wbcir_select_bank(data, WBCIR_BANK_2);
-	outb(WBCIR_EXT_ENABLE, data->sbase + WBCIR_REG_SP3_EXCR1);
-
-	/*
-	 * Configure baud generator, IR data will be sampled at
-	 * a bitrate of: (24Mhz * prescaler) / (divisor * 16).
-	 *
-	 * The ECIR registers include a flag to change the
-	 * 24Mhz clock freq to 48Mhz.
-	 *
-	 * It's not documented in the specs, but fifo levels
-	 * other than 16 seems to be unsupported.
-	 */
-
-	/* prescaler 1.0, tx/rx fifo lvl 16 */
-	outb(0x30, data->sbase + WBCIR_REG_SP3_EXCR2);
-
-	/* Set baud divisor to generate one byte per bit/cell */
-	switch (protocol) {
-	case IR_PROTOCOL_RC5:
-		outb(0xA7, data->sbase + WBCIR_REG_SP3_BGDL);
-		break;
-	case IR_PROTOCOL_RC6:
-		outb(0x53, data->sbase + WBCIR_REG_SP3_BGDL);
-		break;
-	case IR_PROTOCOL_NEC:
-		outb(0x69, data->sbase + WBCIR_REG_SP3_BGDL);
-		break;
-	}
-	outb(0x00, data->sbase + WBCIR_REG_SP3_BGDH);
-
-	/* Set CEIR mode */
-	wbcir_select_bank(data, WBCIR_BANK_0);
-	outb(0xC0, data->sbase + WBCIR_REG_SP3_MCR);
-	inb(data->sbase + WBCIR_REG_SP3_LSR); /* Clear LSR */
-	inb(data->sbase + WBCIR_REG_SP3_MSR); /* Clear MSR */
-
-	/* Disable RX demod, run-length encoding/decoding, set freq span */
-	wbcir_select_bank(data, WBCIR_BANK_7);
-	outb(0x10, data->sbase + WBCIR_REG_SP3_RCCFG);
-
-	/* Disable timer */
-	wbcir_select_bank(data, WBCIR_BANK_4);
-	outb(0x00, data->sbase + WBCIR_REG_SP3_IRCR1);
-
-	/* Enable MSR interrupt, Clear AUX_IRX */
-	wbcir_select_bank(data, WBCIR_BANK_5);
-	outb(0x00, data->sbase + WBCIR_REG_SP3_IRCR2);
-
-	/* Disable CRC */
-	wbcir_select_bank(data, WBCIR_BANK_6);
-	outb(0x20, data->sbase + WBCIR_REG_SP3_IRCR3);
-
-	/* Set RX/TX (de)modulation freq, not really used */
-	wbcir_select_bank(data, WBCIR_BANK_7);
-	outb(0xF2, data->sbase + WBCIR_REG_SP3_IRRXDC);
-	outb(0x69, data->sbase + WBCIR_REG_SP3_IRTXMC);
-
-	/* Set invert and pin direction */
-	if (invert)
-		outb(0x10, data->sbase + WBCIR_REG_SP3_IRCFG4);
-	else
-		outb(0x00, data->sbase + WBCIR_REG_SP3_IRCFG4);
-
-	/* Set FIFO thresholds (RX = 8, TX = 3), reset RX/TX */
-	wbcir_select_bank(data, WBCIR_BANK_0);
-	outb(0x97, data->sbase + WBCIR_REG_SP3_FCR);
-
-	/* Clear AUX status bits */
-	outb(0xE0, data->sbase + WBCIR_REG_SP3_ASCR);
-
-	/* Enable interrupts */
-	outb(WBCIR_IRQ_RX | WBCIR_IRQ_ERR, data->sbase + WBCIR_REG_SP3_IER);
+	wbcir_init_hw(data);
 
 	return 0;
 
-- 
1.6.6.1

