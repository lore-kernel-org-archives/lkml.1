Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbYKLTEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbYKLTEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 14:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbYKLTE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 14:04:27 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:55020 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbYKLTE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 14:04:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=eF7KbWg2n7I7KiQ8GUcmSyMnJE7ldM7pWzZX/R2DgXUQ7PWQMgj8WtHGwfasv8mETW
         WEexn5jtHqP93dmLjwS82VCedHYkeDUWBHXZrj+EZo2QkItC0D3boICdhBEG6M6dwxFF
         57ERsiZvlbDyZKS3pswgsdP6UZdRC0KI9nxH0=
Message-ID: <3efb10970811121104o7497d354n6730a23ce5756093@mail.gmail.com>
Date: Wed, 12 Nov 2008 20:04:24 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Atsushi Nemoto" <anemo@mba.ocn.ne.jp>
Subject: Re: atmel_serial might lose modem status change
Cc: hskinnemoen@atmel.com, marc.pignat@hevs.ch, linux-kernel@vger.kernel.org
In-Reply-To: <20081113.021601.30439144.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081113.021601.30439144.anemo@mba.ocn.ne.jp>
X-Google-Sender-Auth: dabb91a9ae3d5634
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Atsushi,

2008/11/12 Atsushi Nemoto <anemo@mba.ocn.ne.jp>:
> I found a problem of handling of modem status of atmel_serial driver.
>
> With the commit 1ecc26 ("atmel_serial: split the interrupt handler"),
> handling of modem status signal was splitted into two parts.  The
> atmel_tasklet_func() compares new status with irq_status_prev, but
> irq_status_prev is not correct if signal status was changed while the
> port is closed.
>
> Here is a sequence to cause problem:
>
> 1. Remote side sets CTS (and DSR).
> 2. Local side close the port.
> 3. Local side clears RTS and DTR.
> 4. Remote side clears CTS and DSR.
> 5. Local side reopen the port.  hw_stopped becomes 1.
> 6. Local side sets RTS and DTR.
> 7. Remote side sets CTS and DSR.
>
> Then CTS change interrupt can be received, but since CTS bit in
> irq_status_prev and new status is same, uart_handle_cts_change() will
> not be called (so hw_stopped will not be cleared, i.e. cannot send any
> data).
>
> I suppose irq_status_prev should be initialized at somewhere in open
> sequence.  Is this fix correct?

I cannot shoot a hole in it... So, to me it appears okay.

Kind Regards,

Remy


> diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
> index 4c535f7..9f3b697 100644
> --- a/drivers/serial/atmel_serial.c
> +++ b/drivers/serial/atmel_serial.c
> @@ -877,6 +877,9 @@ static int atmel_startup(struct uart_port *port)
>                }
>        }
>
> +       /* Save current CSR for comparison in atmel_tasklet_func() */
> +       atmel_port->irq_status_prev = UART_GET_CSR(port);
> +
>        /*
>         * Finally, enable the serial port
>         */
>
> ---
> Atsushi Nemoto
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
