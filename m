Return-Path: <linux-kernel-owner+w=401wt.eu-S933606AbYBTU3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606AbYBTU3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbYBTU3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:29:30 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35502 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750888AbYBTU33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:29:29 -0500
Date: Wed, 20 Feb 2008 20:20:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mxser: prepare for BKL pushdown
Message-ID: <20080220202017.44f919f4@core>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Push the BKL down into various internal routines in the driver ready to
remove it from the break, ioctl and other call points.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/mxser.c linux-2.6.25-rc2-mm1/drivers/char/mxser.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/mxser.c	2008-02-19 11:03:26.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/mxser.c	2008-02-20 11:45:57.000000000 +0000
@@ -1658,6 +1658,7 @@
 	struct mxser_port *port;
 	int result, status;
 	unsigned int i, j;
+	int ret = 0;
 
 	switch (cmd) {
 	case MOXA_GET_MAJOR:
@@ -1665,18 +1666,21 @@
 
 	case MOXA_CHKPORTENABLE:
 		result = 0;
-
+		lock_kernel();
 		for (i = 0; i < MXSER_BOARDS; i++)
 			for (j = 0; j < MXSER_PORTS_PER_BOARD; j++)
 				if (mxser_boards[i].ports[j].ioaddr)
 					result |= (1 << i);
-
+		unlock_kernel();
 		return put_user(result, (unsigned long __user *)argp);
 	case MOXA_GETDATACOUNT:
+		lock_kernel();
 		if (copy_to_user(argp, &mxvar_log, sizeof(mxvar_log)))
-			return -EFAULT;
-		return 0;
+			ret = -EFAULT;
+		unlock_kernel();
+		return ret;
 	case MOXA_GETMSTATUS:
+		lock_kernel();
 		for (i = 0; i < MXSER_BOARDS; i++)
 			for (j = 0; j < MXSER_PORTS_PER_BOARD; j++) {
 				port = &mxser_boards[i].ports[j];
@@ -1713,6 +1717,7 @@
 				else
 					GMStatus[i].cts = 0;
 			}
+		unlock_kernel();
 		if (copy_to_user(argp, GMStatus,
 				sizeof(struct mxser_mstatus) * MXSER_PORTS))
 			return -EFAULT;
@@ -1722,7 +1727,8 @@
 		unsigned long opmode;
 		unsigned cflag, iflag;
 
-		for (i = 0; i < MXSER_BOARDS; i++)
+		lock_kernel();
+		for (i = 0; i < MXSER_BOARDS; i++) {
 			for (j = 0; j < MXSER_PORTS_PER_BOARD; j++) {
 				port = &mxser_boards[i].ports[j];
 				if (!port->ioaddr)
@@ -1787,13 +1793,14 @@
 				mon_data_ext.iftype[i] = opmode;
 
 			}
-			if (copy_to_user(argp, &mon_data_ext,
-						sizeof(mon_data_ext)))
-				return -EFAULT;
-
-			return 0;
-
-	} default:
+		}
+		unlock_kernel();
+		if (copy_to_user(argp, &mon_data_ext,
+					sizeof(mon_data_ext)))
+			return -EFAULT;
+		return 0;
+	}
+	default:
 		return -ENOIOCTLCMD;
 	}
 	return 0;
@@ -1849,16 +1856,20 @@
 					opmode != RS422_MODE &&
 					opmode != RS485_4WIRE_MODE)
 				return -EFAULT;
+			lock_kernel();
 			mask = ModeMask[p];
 			shiftbit = p * 2;
 			val = inb(info->opmode_ioaddr);
 			val &= mask;
 			val |= (opmode << shiftbit);
 			outb(val, info->opmode_ioaddr);
+			unlock_kernel();
 		} else {
+			lock_kernel();
 			shiftbit = p * 2;
 			opmode = inb(info->opmode_ioaddr) >> shiftbit;
 			opmode &= OP_MODE_MASK;
+			unlock_kernel();
 			if (put_user(opmode, (int __user *)argp))
 				return -EFAULT;
 		}
@@ -1885,19 +1896,18 @@
 		tty_wait_until_sent(tty, 0);
 		mxser_send_break(info, arg ? arg * (HZ / 10) : HZ / 4);
 		return 0;
-	case TIOCGSOFTCAR:
-		return put_user(!!C_CLOCAL(tty), (unsigned long __user *)argp);
-	case TIOCSSOFTCAR:
-		if (get_user(arg, (unsigned long __user *)argp))
-			return -EFAULT;
-		tty->termios->c_cflag = ((tty->termios->c_cflag & ~CLOCAL) | (arg ? CLOCAL : 0));
-		return 0;
 	case TIOCGSERIAL:
-		return mxser_get_serial_info(info, argp);
+		lock_kernel();
+		retval = mxser_get_serial_info(info, argp);
+		unlock_kernel();
+		return retval;
 	case TIOCSSERIAL:
-		return mxser_set_serial_info(info, argp);
+		lock_kernel();
+		retval = mxser_set_serial_info(info, argp);
+		unlock_kernel();
+		return retval;
 	case TIOCSERGETLSR:	/* Get line status register */
-		return mxser_get_lsr_info(info, argp);
+		return  mxser_get_lsr_info(info, argp);
 		/*
 		 * Wait for any of the 4 modem inputs (DCD,RI,DSR,CTS) to change
 		 * - mask passed in arg for lines of interest
@@ -1944,24 +1954,27 @@
 	case MOXA_HighSpeedOn:
 		return put_user(info->baud_base != 115200 ? 1 : 0, (int __user *)argp);
 	case MOXA_SDS_RSTICOUNTER:
+		lock_kernel();
 		info->mon_data.rxcnt = 0;
 		info->mon_data.txcnt = 0;
+		unlock_kernel();
 		return 0;
 
 	case MOXA_ASPP_OQUEUE:{
 		int len, lsr;
 
+		lock_kernel();
 		len = mxser_chars_in_buffer(tty);
-
 		lsr = inb(info->ioaddr + UART_LSR) & UART_LSR_TEMT;
-
 		len += (lsr ? 0 : 1);
+		unlock_kernel();
 
 		return put_user(len, (int __user *)argp);
 	}
 	case MOXA_ASPP_MON: {
 		int mcr, status;
 
+		lock_kernel();
 		status = mxser_get_msr(info->ioaddr, 1, tty->index);
 		mxser_check_modem_status(info, status);
 
@@ -1980,7 +1993,7 @@
 			info->mon_data.hold_reason |= NPPI_NOTIFY_CTSHOLD;
 		else
 			info->mon_data.hold_reason &= ~NPPI_NOTIFY_CTSHOLD;
-
+		unlock_kernel();
 		if (copy_to_user(argp, &info->mon_data,
 				sizeof(struct mxser_mon)))
 			return -EFAULT;
