Return-Path: <linux-kernel-owner+w=401wt.eu-S965585AbYCSVHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965585AbYCSVHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbYCST5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:57:22 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:11269 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761270AbYCST5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:57:20 -0400
Subject: [PATCH] serial 8250: tighten test for using backup timer
From: Alex Williamson <alex.williamson@hp.com>
To: linux-serial <linux-serial@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Koeller <thomas@koeller.dyndns.org>
Content-Type: text/plain
Organization: OSLO R&D
Date: Wed, 19 Mar 2008 10:50:37 -0600
Message-Id: <1205945437.6881.13.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

   Thomas Koeller had reported an issue where a device that had been
making use of the UART_BUG_TXEN code in the 8250 driver was mistakenly
being caught by the backup timer test, causing the device to work
improperly.  To fix this, the patch below tightens the test requirements
to enable the backup timer workaround.  The backup timer is really meant
to catch UARTs that don't re-assert the THRE interrupt.  The expectation
is that they do initially assert THRE.  This patch clarifies the test.
Thanks,

	Alex

Signed-off-by: Alex Williamson <alex.williamson@hp.com>
---

diff -r 2202c155b8c3 drivers/serial/8250.c
--- a/drivers/serial/8250.c	Tue Mar 18 21:34:48 2008 -0700
+++ b/drivers/serial/8250.c	Wed Mar 19 10:32:40 2008 -0600
@@ -1814,6 +1814,7 @@ static int serial8250_startup(struct uar
 	}
 
 	if (is_real_interrupt(up->port.irq)) {
+		unsigned char iir1;
 		/*
 		 * Test for UARTs that do not reassert THRE when the
 		 * transmitter is idle and the interrupt has already
@@ -1827,7 +1828,7 @@ static int serial8250_startup(struct uar
 		wait_for_xmitr(up, UART_LSR_THRE);
 		serial_out_sync(up, UART_IER, UART_IER_THRI);
 		udelay(1); /* allow THRE to set */
-		serial_in(up, UART_IIR);
+		iir1 = serial_in(up, UART_IIR);
 		serial_out(up, UART_IER, 0);
 		serial_out_sync(up, UART_IER, UART_IER_THRI);
 		udelay(1); /* allow a working UART time to re-assert THRE */
@@ -1840,7 +1841,7 @@ static int serial8250_startup(struct uar
 		 * If the interrupt is not reasserted, setup a timer to
 		 * kick the UART on a regular basis.
 		 */
-		if (iir & UART_IIR_NO_INT) {
+		if (!(iir1 & UART_IIR_NO_INT) && (iir & UART_IIR_NO_INT)) {
 			pr_debug("ttyS%d - using backup timer\n", port->line);
 			up->timer.function = serial8250_backup_timeout;
 			up->timer.data = (unsigned long)up;



