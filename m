Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbYBIOyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbYBIOyI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 09:54:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYBIOx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 09:53:56 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:43154 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbYBIOxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 09:53:55 -0500
Message-ID: <47ADBE81.8000506@web.de>
Date: Sat, 09 Feb 2008 15:53:53 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: jason.wessel@windriver.com
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH][7/8] kgdb: exclusive use kgdb8250 uart I/O driver
References: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com> <1202564114-18587-2-git-send-email-jason.wessel@windriver.com> <1202564114-18587-3-git-send-email-jason.wessel@windriver.com> <1202564114-18587-4-git-send-email-jason.wessel@windriver.com> <1202564114-18587-5-git-send-email-jason.wessel@windriver.com> <1202564114-18587-6-git-send-email-jason.wessel@windriver.com> <1202564114-18587-7-git-send-email-jason.wessel@windriver.com> <1202564114-18587-8-git-send-email-jason.wessel@windriver.com>
In-Reply-To: <1202564114-18587-8-git-send-email-jason.wessel@windriver.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19xUmMoZHZbuUgaV7GzQ4mWAvmdv1FtsNoEpIOq
	tDi/NpBDaS9CT/0hypeTSzH/mkehmklg+RxnhzMn14wvLKopQy
	JPz7Cl7Fk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jason.wessel@windriver.com wrote:
> From: Jason Wessel <jason.wessel@windriver.com>
> 
> This patch some small hooks into the normal serial core so that a uart
> can be unregistered to be exclusively used for KGDB.  These changes
> allow for registering and unregistering a port with a struct
> uart_port. From that point on KGDB does raw accesses to the serial
> IO ports it has taken over.
> 
> CC: linux-serial@vger.kernel.org
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  Documentation/DocBook/kgdb.tmpl |   44 ++++
>  drivers/serial/8250.c           |   30 +++
>  drivers/serial/8250_kgdb.c      |  489 +++++++++++++++++++++++++++++++++++++++
>  drivers/serial/Kconfig          |    2 +-
>  drivers/serial/Makefile         |    1 +
>  drivers/serial/serial_core.c    |   18 ++-
>  include/linux/serial_8250.h     |    2 +
>  lib/Kconfig.kgdb                |   21 ++
>  8 files changed, 603 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/serial/8250_kgdb.c

There are a few things I missed in my last cleanup round, please fold
them in, they reduce the changes outside kgdb. (I bet that membase
dumping was related to mmio vs. mmap configuration, right?)

--- linux-2.6-kgdb.orig/drivers/serial/Kconfig
+++ linux-2.6-kgdb/drivers/serial/Kconfig
@@ -121,7 +121,7 @@ config SERIAL_8250_CS
 
 config SERIAL_8250_NR_UARTS
 	int "Maximum number of 8250/16550 serial ports"
-	depends on SERIAL_8250 || KGDB_8250
+	depends on SERIAL_8250
 	default "4"
 	help
 	  Set this to the number of serial ports you want the driver
--- linux-2.6-kgdb.orig/drivers/serial/serial_core.c
+++ linux-2.6-kgdb/drivers/serial/serial_core.c
@@ -1685,9 +1685,6 @@ static int uart_line_info(char *buf, str
 			mmio ? (unsigned long long)port->mapbase
 			     : (unsigned long long) port->iobase,
 			port->irq);
-	if (port->iotype == UPIO_MEM)
-		ret += sprintf(buf+ret, " membase 0x%08lX",
-					   (unsigned long) port->membase);
 
 	if (port->type == PORT_UNKNOWN) {
 		strcat(buf, "\n");
@@ -2130,9 +2127,7 @@ uart_report_port(struct uart_driver *drv
 	case UPIO_TSI:
 	case UPIO_DWAPB:
 		snprintf(address, sizeof(address),
-			 "MMIO 0x%llx mem 0x%p",
-			 (unsigned long long)port->mapbase,
-			 port->membase);
+			 "MMIO 0x%llx", (unsigned long long)port->mapbase);
 		break;
 	default:
 		strlcpy(address, "*unknown*", sizeof(address));
--- linux-2.6-kgdb.orig/include/linux/serial_8250.h
+++ linux-2.6-kgdb/include/linux/serial_8250.h
@@ -58,7 +58,6 @@ struct uart_port;
 
 int serial8250_register_port(struct uart_port *);
 void serial8250_unregister_port(int line);
-void serial8250_unregister_by_port(struct uart_port *port);
 void serial8250_suspend_port(int line);
 void serial8250_resume_port(int line);
 int serial8250_get_port_def(struct uart_port *port, int line);
