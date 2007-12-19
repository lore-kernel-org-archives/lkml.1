Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbXLSQk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbXLSQk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 11:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbXLSQku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 11:40:50 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:12601 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbXLSQkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 11:40:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=L2ZWQE1fNFJwo0lbGSbFvJSrvVV8dlY+0yISObghQc3ENw/HpZed/Ued6z5zNo/si/QfCFoup3Yg7+IuSCCAr/SGFB91jubfJ8RPOMEzPDCu+NTdF2XWF0jHeHhX6I9zgXixph5iIPdaQrkhJVbTq3AciFowFp3EIUbwGsFde1E=
Message-ID: <3efb10970712190840m39876762yb4d31c36723c3b8a@mail.gmail.com>
Date: Wed, 19 Dec 2007 17:40:44 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [PATCH v2 0/6] atmel_serial: Cleanups, irq handler splitup & DMA
Cc: "Andrew Victor" <linux@maxim.org.za>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       "Russell King" <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org
In-Reply-To: <20071219170935.4df62471@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1198077130-9021-1-git-send-email-hskinnemoen@atmel.com>
	 <3efb10970712190757m18f8851cq54061ff109790805@mail.gmail.com>
	 <20071219170935.4df62471@dhcp-252-066.norway.atmel.com>
X-Google-Sender-Auth: 080bd65a49489ae2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Haavard,

> Could you try the patch below? It's a bit strange that you got an oops
> though...

It is not really strange... spinlocks are mutexes on preempt-rt, and
recursive mutex locking is not allowed, this is one differences with
the mainline spinlock.

But... I tried that patch, and it works a lot better, no oopses
anymore, but I noticed that I sometimes get an input overrun (ttyS0: 1
input overrun(s) ) during stress conditions.
This is something I did not notice before, maybe it was already there,
or has something changed in this area that it is now more sensitive
for this?

Kind Regards,

Remy

2007/12/19, Haavard Skinnemoen <hskinnemoen@atmel.com>:
> On Wed, 19 Dec 2007 16:57:04 +0100
> "Remy Bohmer" <linux@bohmer.net> wrote:
>
> > Hello Haavard,
> >
> > Sorry.. But I get an Oops on Preempt-RT with the latest set of
> > patches. I did not see it earlier today with the other set of patches.
>
> Hmm...from the backtrace, it looks like lock recursion -- port->lock is
> held for the whole duration of the tasklet, but we somehow end up in
> uart_start(), which grabs the lock again.
>
> Could you try the patch below? It's a bit strange that you got an oops
> though...
>
> Haavard
>
> diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
> index 7967054..948c643 100644
> --- a/drivers/serial/atmel_serial.c
> +++ b/drivers/serial/atmel_serial.c
> @@ -666,7 +666,13 @@ static void atmel_rx_from_ring(struct uart_port *port)
>                 uart_insert_char(port, status, ATMEL_US_OVRE, c.ch, flg);
>         }
>
> +       /*
> +        * Drop the lock here since it might end up calling
> +        * uart_start(), which takes the lock.
> +        */
> +       spin_unlock(&port->lock);
>         tty_flip_buffer_push(port->info->tty);
> +       spin_lock(&port->lock);
>  }
>
>  static void atmel_rx_from_dma(struct uart_port *port)
>
