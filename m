Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYBISp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYBISp2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 13:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbYBISpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 13:45:16 -0500
Received: from mail.windriver.com ([147.11.1.11]:58589 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbYBISpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 13:45:14 -0500
Message-ID: <47ADF4C1.6010508@windriver.com>
Date: Sat, 09 Feb 2008 12:45:21 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH][7/8] kgdb: exclusive use kgdb8250 uart I/O driver
References: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com> <1202564114-18587-2-git-send-email-jason.wessel@windriver.com> <1202564114-18587-3-git-send-email-jason.wessel@windriver.com> <1202564114-18587-4-git-send-email-jason.wessel@windriver.com> <1202564114-18587-5-git-send-email-jason.wessel@windriver.com> <1202564114-18587-6-git-send-email-jason.wessel@windriver.com> <1202564114-18587-7-git-send-email-jason.wessel@windriver.com> <1202564114-18587-8-git-send-email-jason.wessel@windriver.com> <47ADBE81.8000506@web.de>
In-Reply-To: <47ADBE81.8000506@web.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2008 18:44:59.0407 (UTC) FILETIME=[DF5B21F0:01C86B4B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka wrote:
> There are a few things I missed in my last cleanup round, please fold
> them in, they reduce the changes outside kgdb. (I bet that membase
> dumping was related to mmio vs. mmap configuration, right?)
>
>   

That is correct, the right thing to do is remove the code.

I folded your patch into patch #7 and refreshed the git archive.

Thanks,
Jason.

> --- linux-2.6-kgdb.orig/drivers/serial/Kconfig
> +++ linux-2.6-kgdb/drivers/serial/Kconfig
> @@ -121,7 +121,7 @@ config SERIAL_8250_CS
>  
>  config SERIAL_8250_NR_UARTS
>  	int "Maximum number of 8250/16550 serial ports"
> -	depends on SERIAL_8250 || KGDB_8250
> +	depends on SERIAL_8250
>  	default "4"
>  	help
>  	  Set this to the number of serial ports you want the driver
> --- linux-2.6-kgdb.orig/drivers/serial/serial_core.c
> +++ linux-2.6-kgdb/drivers/serial/serial_core.c
> @@ -1685,9 +1685,6 @@ static int uart_line_info(char *buf, str
>  			mmio ? (unsigned long long)port->mapbase
>  			     : (unsigned long long) port->iobase,
>  			port->irq);
> -	if (port->iotype == UPIO_MEM)
> -		ret += sprintf(buf+ret, " membase 0x%08lX",
> -					   (unsigned long) port->membase);
>  
>  	if (port->type == PORT_UNKNOWN) {
>  		strcat(buf, "\n");
> @@ -2130,9 +2127,7 @@ uart_report_port(struct uart_driver *drv
>  	case UPIO_TSI:
>  	case UPIO_DWAPB:
>  		snprintf(address, sizeof(address),
> -			 "MMIO 0x%llx mem 0x%p",
> -			 (unsigned long long)port->mapbase,
> -			 port->membase);
> +			 "MMIO 0x%llx", (unsigned long long)port->mapbase);
>  		break;
>  	default:
>  		strlcpy(address, "*unknown*", sizeof(address));
> --- linux-2.6-kgdb.orig/include/linux/serial_8250.h
> +++ linux-2.6-kgdb/include/linux/serial_8250.h
> @@ -58,7 +58,6 @@ struct uart_port;
>  
>  int serial8250_register_port(struct uart_port *);
>  void serial8250_unregister_port(int line);
> -void serial8250_unregister_by_port(struct uart_port *port);
>  void serial8250_suspend_port(int line);
>  void serial8250_resume_port(int line);
>  int serial8250_get_port_def(struct uart_port *port, int line);
>   

