Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269Ab0AMNlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab0AMNlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 08:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166Ab0AMNlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 08:41:35 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43784 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754965Ab0AMNle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:41:34 -0500
Date: Wed, 13 Jan 2010 13:44:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chaithrika U S <chaithrika@ti.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com,
       khilman@deeprootsystems.com, akpm@linux-foundation.org,
       Chaithrika U S <chaithrika@ti.com>
Subject: Re: [PATCH] serial: 8250: Add cpufreq support
Message-ID: <20100113134445.010d4f1c@lxorguk.ukuu.org.uk>
In-Reply-To: <1263386121-6644-1-git-send-email-chaithrika@ti.com>
References: <1263386121-6644-1-git-send-email-chaithrika@ti.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int serial8250_cpufreq_transition(struct notifier_block *nb,
> +					     unsigned long val, void *data)
> +{
> +	struct uart_8250_port *p;
> +	struct uart_port *uport;
> +
> +	p = container_of(nb, struct uart_8250_port, freq_transition);
> +	uport = &p->port;
> +
> +	if (IS_ERR(p->clk))
> +		goto cpu_freq_exit;
> +
> +	if (p->port.uartclk == clk_get_rate(p->clk))
> +		goto cpu_freq_exit;
> +
> +	p->port.uartclk = clk_get_rate(p->clk);
> +	if (val == CPUFREQ_POSTCHANGE) {
> +		struct ktermios *termios;
> +		struct tty_struct *tty;
> +		if (uport->state == NULL)
> +			goto cpu_freq_exit;
> +
> +		tty = uport->state->port.tty;

Need locking on port->tty.

> +		if (tty == NULL)
> +			goto cpu_freq_exit;
> +

Need locking on tty->termios

I'd say this is also probably at the wrong level - why not do it at the
uart_port level instead (ie move the code you have into serial_core using
uart_port) - you've made it all nicely generic already.

Alan
