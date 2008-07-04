Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbYGDS3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbYGDS3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 14:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYGDS3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 14:29:23 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:17482 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbYGDS3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 14:29:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=quaUaDdD1Le6/Fkyg+YKYTx1fj4NyDeQhp4aGaywigsPRQnJEJT58YpiD26UE22Gcy
         bR7Mo1dRlGzSrul7Qimf77Oe5snvHwSzFiFMhziYW5aAYjawdSY10AhKUFcLMXEEoVaV
         DvYZSbdQGmii0nMVKoiXBuTbAdxufdtMO7Lcw=
Date: Fri, 4 Jul 2008 14:29:10 -0400
From: Joseph Fannin <jfannin@gmail.com>
To: Alan Cox <alan@redhat.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next-0703 -- more ppc serial fixes
Message-ID: <20080704182909.GB1631@nineveh.local>
Mail-Followup-To: Alan Cox <alan@redhat.com>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>
References: <20080703190948.8e7bceca.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080703190948.8e7bceca.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 07:09:48PM +1000, Stephen Rothwell wrote:

[next-0703]

> $ git quiltimport --author "Alan Cox <alan@lxorguk.ukuu.org.uk>" --patches "../quilt/ttydev"

More fixes for ppc serial drivers seem to be needed since next-0701 (exclusive):

drivers/serial/mpc52xx_uart.c: In function 'mpc52xx_uart_int_rx_chars':
drivers/serial/mpc52xx_uart.c:735: error: 'struct uart_info' has no member named 'tty'
drivers/serial/mpc52xx_uart.c: In function 'mpc52xx_uart_of_probe':
drivers/serial/mpc52xx_uart.c:1277: warning: cast to pointer from integer of different size

[...]

drivers/serial/uartlite.c: In function 'ulite_receive':
drivers/serial/uartlite.c:78: error: 'struct uart_info' has no member named 'tty'
drivers/serial/uartlite.c: In function 'ulite_isr':
drivers/serial/uartlite.c:165: error: 'struct uart_info' has no member named 'tty'

The following patch just fixes the build errors gcc emitted; if more
is needed to make the drivers actually work, it's wasn't blatently
obvious.

The patch is against next-0703, but I don't think it will matter.

FWIW --
Signed-Off-By: Joseph Fannin <jfannin@gmail.com>

---

diff --git a/drivers/serial/mpc52xx_uart.c b/drivers/serial/mpc52xx_uart.c
index e673008..d456cda 100644
--- a/drivers/serial/mpc52xx_uart.c
+++ b/drivers/serial/mpc52xx_uart.c
@@ -732,7 +732,7 @@ static struct uart_ops mpc52xx_uart_ops = {
 static inline int
 mpc52xx_uart_int_rx_chars(struct uart_port *port)
 {
-	struct tty_struct *tty = port->info->tty;
+	struct tty_struct *tty = port->info->port.tty;
 	unsigned char ch, flag;
 	unsigned short status;
 
diff --git a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
index b51c242..6a3f8fb 100644
--- a/drivers/serial/uartlite.c
+++ b/drivers/serial/uartlite.c
@@ -75,7 +75,7 @@ static struct uart_port ulite_ports[ULITE_NR_UARTS];
 
 static int ulite_receive(struct uart_port *port, int stat)
 {
-	struct tty_struct *tty = port->info->tty;
+	struct tty_struct *tty = port->info->port.tty;
 	unsigned char ch = 0;
 	char flag = TTY_NORMAL;
 
@@ -162,7 +162,7 @@ static irqreturn_t ulite_isr(int irq, void *dev_id)
 		busy |= ulite_transmit(port, stat);
 	} while (busy);
 
-	tty_flip_buffer_push(port->info->tty);
+	tty_flip_buffer_push(port->info->port.tty);
 
 	return IRQ_HANDLED;
 }

--
Joseph Fannin
jfannin@gmail.com
