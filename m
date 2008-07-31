Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbYGaPc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbYGaPc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 11:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbYGaPct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 11:32:49 -0400
Received: from [128.224.252.2] ([128.224.252.2]:15688 "EHLO
	yow-pgortmak-d1.corp.ad.wrs.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752737AbYGaPcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 11:32:48 -0400
X-Greylist: delayed 474 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jul 2008 11:32:47 EDT
Date: Thu, 31 Jul 2008 11:26:30 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] suggested fix for 83xx/85xx PowerPC UART break bug
Message-ID: <20080731152616.GA14248@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is something I'd tripped over earlier, and wanted to follow up on
to get an acceptable fix in for everyone's benefit before it falls through
the cracks again.

There seems to be an issue with recent 83xx/85xx SOC UARTs, in which a break
triggers a short lived IRQ storm (hence killing any hope of using SysRQ).
The only fix I found to work was to just ignore the bogus events that
had the associated signature bit set.

This fix is what I was using against earlier kernels, but I hate to add more
board/arch specific ifdefs to files like 8250.c, so I'm wondering if
anyone has any other suggestions before I simply end up cleaning up the
boardlist (now ppc is dead) and respinning the patch much as it is now
and resending.

Thanks,
Paul.

-----------------

Variation/update of version1 of the patch -- orig. discussion at:

http://patchwork.ozlabs.org/linuxppc/patch?id=15986

Update is: Don't use MPC8540 as a selector for the 8548 boards,
since testing on a genuine (older) MPC8540ADS board shows that
it doesn't have the issue.  This will get coverage on the 
sbc8349, fsl_mpc8349_mitx, fsl_mpc832xe (and the similar 8323RDB)
and the sbc8548 and the fsl_8548cds. (i.e all the boards where
the problem has been demonstrated to exist so far.)

    Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

---
 drivers/serial/8250.c      |   17 +++++++++++++++++
 include/linux/serial_reg.h |    1 +
 2 files changed, 18 insertions(+)

--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1347,6 +1347,25 @@ serial8250_handle_port(struct uart_8250_
 
 	status = serial_inp(up, UART_LSR);
 
+#if defined(CONFIG_MPC834x) || defined(CONFIG_MPC85xx_CDS) || \
+	defined(CONFIG_SBC8548) || defined (CONFIG_PPC_MPC832x)
+	/*
+	 * There appears to be a quirk in the implementation on some 8xxx
+	 * where after a break is rec'd (UART_LSR_BI), the UART generates
+	 * a short duration burst of bogus IRQ events with the signature
+	 * of RFE set (along with "normal" bits set) in the LSR.
+	 */
+
+#define RFE_8xxx_ERR_BITS (	UART_LSR_RFE	| UART_LSR_TEMT	| \
+				UART_LSR_THRE	| UART_LSR_BI	| \
+				UART_LSR_DR	)
+
+	if (status == RFE_8xxx_ERR_BITS) {
+		spin_unlock(&up->port.lock);
+		return;
+	}
+#endif
+
 	DEBUG_INTR("status = %x...", status);
 
 	if (status & UART_LSR_DR) {
--- a/include/linux/serial_reg.h
+++ b/include/linux/serial_reg.h
@@ -109,6 +109,7 @@
 #define UART_MCR_DTR		0x01 /* DTR complement */
 
 #define UART_LSR	5	/* In:  Line Status Register */
+#define UART_LSR_RFE		0x80 /* Rx FIFO Error (BE, FE, or PE) */
 #define UART_LSR_TEMT		0x40 /* Transmitter empty */
 #define UART_LSR_THRE		0x20 /* Transmit-hold-register empty */
 #define UART_LSR_BI		0x10 /* Break interrupt indicator */

