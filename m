Return-Path: <linux-kernel-owner+w=401wt.eu-S1757976AbXENR3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976AbXENR3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 13:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbXENR26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 13:28:58 -0400
Received: from nwk-ea-fw-1.sun.com ([192.18.42.249]:39234 "EHLO
	nwk-ea-fw-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbXENR25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 13:28:57 -0400
Date: Mon, 14 May 2007 10:26:26 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] serial: set RTS and DTR if flow is 'r'
In-reply-to: <m1ejllqmo8.fsf@ebiederm.dsl.xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>, rmk@arm.linux.org.uk,
       Andi Kleen <ak@suse.de>, bjorn.helgaas@hp.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <46489BC2.6040403@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com>
 <m1ejllqmo8.fsf@ebiederm.dsl.xmission.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] serial: set RTS and DTR if flow is 'r'

if the serial console flow is set to 'r', We need to set RTS and DTR.
Some UARTs on other side need these bit set, otherwise will send char to or
receive char from the host that kernel is runing esp for kernel boot stage.

BTW:
earlyprintk and early_uart are hard coded to set DTR/RTS.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Andi Kleen <ak@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 48e259a..439a00a 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2154,6 +2154,16 @@ serial8250_set_termios(struct uart_port *port, 
struct ktermios *termios,
}
serial_outp(up, UART_FCR, fcr); /* set fcr */
}
+
+ /* if serial console flow is 'r', we need to set RTS and DTR to MCR.
+ * some uarts on other side don't support no flow control. So we state
+ * console=ttyS0,9600n8r in kernel command line to make those uart can
+ * work.
+ */
+ if (termios->c_cflag & CRTSCTS) {
+ up->port.mctrl |= TIOCM_RTS | TIOCM_DTR;
+ }
+
serial8250_set_mctrl(&up->port, up->port.mctrl);
spin_unlock_irqrestore(&up->port.lock, flags);
}
