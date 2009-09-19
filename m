Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbZISVwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbZISVwE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbZISVkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:40:16 -0400
Received: from kroah.org ([198.145.64.141]:40420 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbZISVkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:40:12 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 26/79] mos7840: remove old dead modem logic
Date: Sat, 19 Sep 2009 14:36:31 -0700
Message-Id: <1253396244-7885-26-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The modem ioctls are not routed via the ioctl method so kill the old dead
code. The correct code is also already present and hooked in.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/serial/mos7840.c |  115 ------------------------------------------
 1 files changed, 0 insertions(+), 115 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 270009a..b93f0f9 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2134,106 +2134,6 @@ static int mos7840_get_lsr_info(struct tty_struct *tty,
 }
 
 /*****************************************************************************
- * mos7840_set_modem_info
- *      function to set modem info
- *****************************************************************************/
-
-/* FIXME: Should be using the model control hooks */
-
-static int mos7840_set_modem_info(struct moschip_port *mos7840_port,
-				  unsigned int cmd, unsigned int __user *value)
-{
-	unsigned int mcr;
-	unsigned int arg;
-	__u16 Data;
-	int status;
-	struct usb_serial_port *port;
-
-	if (mos7840_port == NULL)
-		return -1;
-
-	port = (struct usb_serial_port *)mos7840_port->port;
-	if (mos7840_port_paranoia_check(port, __func__)) {
-		dbg("%s", "Invalid port");
-		return -1;
-	}
-
-	mcr = mos7840_port->shadowMCR;
-
-	if (copy_from_user(&arg, value, sizeof(int)))
-		return -EFAULT;
-
-	switch (cmd) {
-	case TIOCMBIS:
-		if (arg & TIOCM_RTS)
-			mcr |= MCR_RTS;
-		if (arg & TIOCM_DTR)
-			mcr |= MCR_RTS;
-		if (arg & TIOCM_LOOP)
-			mcr |= MCR_LOOPBACK;
-		break;
-
-	case TIOCMBIC:
-		if (arg & TIOCM_RTS)
-			mcr &= ~MCR_RTS;
-		if (arg & TIOCM_DTR)
-			mcr &= ~MCR_RTS;
-		if (arg & TIOCM_LOOP)
-			mcr &= ~MCR_LOOPBACK;
-		break;
-
-	case TIOCMSET:
-		/* turn off the RTS and DTR and LOOPBACK
-		 * and then only turn on what was asked to */
-		mcr &= ~(MCR_RTS | MCR_DTR | MCR_LOOPBACK);
-		mcr |= ((arg & TIOCM_RTS) ? MCR_RTS : 0);
-		mcr |= ((arg & TIOCM_DTR) ? MCR_DTR : 0);
-		mcr |= ((arg & TIOCM_LOOP) ? MCR_LOOPBACK : 0);
-		break;
-	}
-
-	lock_kernel();
-	mos7840_port->shadowMCR = mcr;
-
-	Data = mos7840_port->shadowMCR;
-	status = mos7840_set_uart_reg(port, MODEM_CONTROL_REGISTER, Data);
-	unlock_kernel();
-	if (status < 0) {
-		dbg("setting MODEM_CONTROL_REGISTER Failed");
-		return -1;
-	}
-
-	return 0;
-}
-
-/*****************************************************************************
- * mos7840_get_modem_info
- *      function to get modem info
- *****************************************************************************/
-
-static int mos7840_get_modem_info(struct moschip_port *mos7840_port,
-				  unsigned int __user *value)
-{
-	unsigned int result = 0;
-	__u16 msr;
-	unsigned int mcr = mos7840_port->shadowMCR;
-        mos7840_get_uart_reg(mos7840_port->port,
-						MODEM_STATUS_REGISTER, &msr);
-	result = ((mcr & MCR_DTR) ? TIOCM_DTR : 0)	/* 0x002 */
-	    |((mcr & MCR_RTS) ? TIOCM_RTS : 0)	/* 0x004 */
-	    |((msr & MOS7840_MSR_CTS) ? TIOCM_CTS : 0)	/* 0x020 */
-	    |((msr & MOS7840_MSR_CD) ? TIOCM_CAR : 0)	/* 0x040 */
-	    |((msr & MOS7840_MSR_RI) ? TIOCM_RI : 0)	/* 0x080 */
-	    |((msr & MOS7840_MSR_DSR) ? TIOCM_DSR : 0);	/* 0x100 */
-
-	dbg("%s -- %x", __func__, result);
-
-	if (copy_to_user(value, &result, sizeof(int)))
-		return -EFAULT;
-	return 0;
-}
-
-/*****************************************************************************
  * mos7840_get_serial_info
  *      function to get information about serial port
  *****************************************************************************/
@@ -2281,7 +2181,6 @@ static int mos7840_ioctl(struct tty_struct *tty, struct file *file,
 	struct async_icount cnow;
 	struct async_icount cprev;
 	struct serial_icounter_struct icount;
-	int mosret = 0;
 
 	if (mos7840_port_paranoia_check(port, __func__)) {
 		dbg("%s", "Invalid port");
@@ -2303,20 +2202,6 @@ static int mos7840_ioctl(struct tty_struct *tty, struct file *file,
 		return mos7840_get_lsr_info(tty, argp);
 		return 0;
 
-	/* FIXME: use the modem hooks and remove this */
-	case TIOCMBIS:
-	case TIOCMBIC:
-	case TIOCMSET:
-		dbg("%s (%d) TIOCMSET/TIOCMBIC/TIOCMSET", __func__,
-		    port->number);
-		mosret =
-		    mos7840_set_modem_info(mos7840_port, cmd, argp);
-		return mosret;
-
-	case TIOCMGET:
-		dbg("%s (%d) TIOCMGET", __func__, port->number);
-		return mos7840_get_modem_info(mos7840_port, argp);
-
 	case TIOCGSERIAL:
 		dbg("%s (%d) TIOCGSERIAL", __func__, port->number);
 		return mos7840_get_serial_info(mos7840_port, argp);
-- 
1.6.4.2

