Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320Ab0BYPWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:22:52 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33157 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759202Ab0BYPWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:22:50 -0500
Date: Thu, 25 Feb 2010 15:26:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: linux-serial@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] serial: Add driver for the Altera JTAG UART
Message-ID: <20100225152622.7eb479aa@lxorguk.ukuu.org.uk>
In-Reply-To: <1267108523-32767-1-git-send-email-tklauser@distanz.ch>
References: <1267108523-32767-1-git-send-email-tklauser@distanz.ch>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static void altera_jtaguart_set_termios(struct uart_port *port,
> +					struct ktermios *termios,
> +					struct ktermios *old)
> +{
> +}

Erm no .. it may be wrong in the code you are copying but please don't
further that. The requirement is that the termios handed back reflects
the actual settings not the requested ones.

Use tty_termios_copy_hw() to copy the old termios hardware settings back
so that the caller sees it cannot set them.

> +
> +static void altera_jtaguart_rx_chars(struct altera_jtaguart *pp)
> +{
> +	struct uart_port *port = &pp->port;
> +	unsigned char ch, flag;
> +	unsigned long status;
> +
> +	while ((status = readl(port->membase + ALTERA_JTAGUART_DATA_REG)) &
> +	       ALTERA_JTAGUART_DATA_RVALID_MSK) {
> +		ch = status & ALTERA_JTAGUART_DATA_DATA_MSK;
> +		flag = TTY_NORMAL;
> +		port->icount.rx++;
> +
> +		if (uart_handle_sysrq_char(port, ch))
> +			continue;
> +		uart_insert_char(port, 0, 0, ch, flag);
> +	}
> +
> +	tty_flip_buffer_push(port->state->port.tty);

port.tty needs to be protected here - you might race an unplug/hangup as
far as I can see - I think you need to take the lock over a bigger area

[I'm working on switching this to krefs in all the drivers currently so
that will end up cleaner]

Basically fine other than that. The proposed UART number clashes with
some other pending patches but that will get sorted out when they get
merged
