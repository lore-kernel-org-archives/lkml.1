Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbZKLWZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbZKLWZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 17:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZKLWZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 17:25:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754826AbZKLWZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 17:25:30 -0500
Date: Thu, 12 Nov 2009 14:24:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: avictor.za@gmail.com, linux-kernel@vger.kernel.org,
       haavard.skinnemoen@atmel.com, nicolas.ferre@atmel.com
Subject: Re: [PATCH v2] Add poll_get_char and poll_put_char uart_ops to
 atmel_serial.
Message-Id: <20091112142450.d3c2dc90.akpm@linux-foundation.org>
In-Reply-To: <1252317170-9782-1-git-send-email-albin.tonnerre@free-electrons.com>
References: <cd73a99e0909062322j683952e6m803dd6b703bf758d@mail.gmail.com>
	<1252317170-9782-1-git-send-email-albin.tonnerre@free-electrons.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  7 Sep 2009 11:52:50 +0200
Albin Tonnerre <albin.tonnerre@free-electrons.com> wrote:

> +#ifdef CONFIG_CONSOLE_POLL
> +static int atmel_poll_get_char(struct uart_port *port)
> +{
> +	while (!(UART_GET_CSR(port) & ATMEL_US_RXRDY))
> +		barrier();
> +
> +	return UART_GET_CHAR(port);
> +}
> +
> +static void atmel_poll_put_char(struct uart_port *port, unsigned char ch)
> +{
> +	while (!(UART_GET_CSR(port) & ATMEL_US_TXRDY))
> +		barrier();
> +
> +	UART_PUT_CHAR(port, ch);
> +}
> +#endif

The use of barrier() is not appropriate here - it's purely a compiler
concept.

I'll switch it to cpu_relax().  Even that's probably unneeded, as the
IO operation is usually slow and should be an opportunity for the CPU
to take a little nap.

