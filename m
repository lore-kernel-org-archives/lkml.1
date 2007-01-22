Return-Path: <linux-kernel-owner+w=401wt.eu-S932749AbXAVVMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749AbXAVVMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 16:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932671AbXAVVMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 16:12:17 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45475 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932667AbXAVVMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 16:12:16 -0500
Date: Mon, 22 Jan 2007 21:23:19 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git master
Message-ID: <20070122212319.185fd10b@localhost.localdomain>
In-Reply-To: <45B50A19.6090909@pmc-sierra.com>
References: <45B50A19.6090909@pmc-sierra.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> There are three different fixes:
> 1. Fix for THRE errata

That should be handled anyway. The current code actually spots this and
uses a backup timer for dodgy UARTS

> 2. Fix for Busy Detect on LCR write
> 3. Workaround for interrupt/data concurrency issue

>   	case UPIO_MEM:
> +#ifdef CONFIG_PMC_MSP
> +		/* Save the LCR value so it can be re-written when a
> +		 * Busy Detect interrupt occurs. */
> +		if (dwapb_offset == UART_LCR)
> +			up->dwapb_lcr = value;
> +#endif
>   		writeb(value, up->port.membase + offset);
> +#ifdef CONFIG_PMC_MSP
> +		/* Re-read the IER to ensure any interrupt disabling has
> +		 * completed before proceeding with ISR. */
> +		if (dwapb_offset == UART_IER)
> +			value = serial_in(up, dwapb_offset);
> +#endif
>   		break;

This I would hope you can hide in the platform specific
serial_in/serial_out functions. If you write the UART_LCR save it in
serial_out(), if you read IER etc.


> +#ifdef CONFIG_PMC_MSP
> +		} else if ((iir & UART_IER_BUSY) == UART_IER_BUSY) {
> +			/*
> +			 * The MSP (DesignWare APB UART) serial subsystem has a
> +			 * non-standard interrupt condition (0x7) which means
> +			 * that the LCR was written while the UART was busy, so
> +			 * the LCR was not actually written.  It is cleared by
> +			 * reading the special non-standard extended UART status
> +			 * register.

Ditto... spot this case and whack it in your serial methods.


And we might want to add a void * for board specific insanity to the 8250
structures if we really have to so you can hang your brain damage
privately off that ?

