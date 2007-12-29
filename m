Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbXL2B3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbXL2B3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 20:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbXL2B3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 20:29:25 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:34896 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbXL2B3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 20:29:22 -0500
Date: Sat, 29 Dec 2007 02:29:19 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH 1/1] mxser, remove it
In-Reply-To: <1198836540-8042-1-git-send-email-jirislaby@gmail.com>
Message-ID: <Pine.LNX.4.64.0712290211240.29013@fbirervta.pbzchgretzou.qr>
References: <1198836540-8042-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 28 2007 11:09, Jiri Slaby wrote:
> 
>+struct mxser_cardinfo {
>+	unsigned int nports;
>+	char *name;
>+	unsigned int flags;
>+};

const char *name. Maybe name could also be put at the front
to get closer struct packing on 64-bit?

> 
>+static int mxvar_baud_table[] = {
>+	0, 50, 75, 110, 134, 150, 200, 300, 600, 1200, 1800, 2400,
>+	4800, 9600, 19200, 38400, 57600, 115200, 230400, 460800, 921600
>+};
>+static unsigned int mxvar_baud_table1[] = {
>+	0, B50, B75, B110, B134, B150, B200, B300, B600, B1200, B1800, B2400,
>+	B4800, B9600, B19200, B38400, B57600, B115200, B230400, B460800, B921600
>+};

Constify both, if possible?

>+struct mxser_port {
>+	struct mxser_board *board;
>+	struct tty_struct *tty;
>+
>+	unsigned long ioaddr;
>+	unsigned long opmode_ioaddr;
>+	int max_baud;
> 
> 	int rx_high_water;
> 	int rx_trigger;		/* Rx fifo trigger level */
> 	int rx_low_water;
> 	int baud_base;		/* max. speed */
>+	long realbaud;
> 	int type;		/* UART type */

realbaud could also be reordered one up or one down.
There are probably more fields around.

>-static int CheckIsMoxaMust(int io)
>+static int __devinit CheckIsMoxaMust(unsigned long io)
> {
> 	u8 oldmcr, hwid;
> 	int i;
>@@ -434,90 +336,15 @@ static int CheckIsMoxaMust(int io)
> 	}
> 
> 	GET_MOXA_MUST_HARDWARE_ID(io, &hwid);
>-	for (i = 0; i < UART_TYPE_NUM; i++) {
>-		if (hwid == Gmoxa_uart_id[i])
>+	for (i = 1; i < UART_INFO_NUM; i++) { /* 0 = OTHER_UART */
>+		if (hwid == Gpci_uart_info[i].type)
> 			return (int)hwid;

I do not think a cast is necessary, hwid is implicitly upconverted to int.

>+static int mxser_get_serial_info(struct mxser_port *info,
>+		struct serial_struct __user *retinfo)
> {
>-	struct mxser_struct *info = tty->driver_data;
>-	int retval;
>+	struct serial_struct tmp;
>+
>+	if (!retinfo)
>+		return -EFAULT;
>+	memset(&tmp, 0, sizeof(tmp));
>+	tmp.type = info->type;
>+	tmp.line = info->tty->index;
>+	tmp.port = info->ioaddr;
>+	tmp.irq = info->board->irq;
>+	tmp.flags = info->flags;
>+	tmp.baud_base = info->baud_base;
>+	tmp.close_delay = info->close_delay;
>+	tmp.closing_wait = info->closing_wait;
>+	tmp.custom_divisor = info->custom_divisor;
>+	tmp.hub6 = 0;
>+	if (copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
>+		return -EFAULT;
>+	return 0;
>+}
>+

Maybe without the extra memcpy?:

static int mxser_get_serial_info(struct mxser_port *info,
		struct serial_struct __user *retinfo)
{
	struct mxser_struct *info = tty->driver_data;
	int retval;
	struct serial_struct tmp = {
		.type = info->type,
		.line = info->tty->index,
		.port = info->ioaddr,
		.irq = info->board->irq,
		.flags = info->flags,
		.baud_base = info->baud_base,
		.close_delay = info->close_delay,
		.closing_wait = info->closing_wait,
		.custom_divisor = info->custom_divisor,
		.hub6 = 0,
	};
	if (copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
		return -EFAULT;
	return 0;
}

