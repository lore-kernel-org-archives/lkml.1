Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbZCKT2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbZCKT2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbZCKT2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:28:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752544AbZCKT2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:28:39 -0400
Date: Wed, 11 Mar 2009 12:25:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: sonic zhang <sonic.adi@gmail.com>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       cooloney@kernel.org
Subject: Re: [PATCH 03/18] Blackfin Serial Driver: fix a bug in dma circle
 rx buffer handling - v2
Message-Id: <20090311122533.bcf77b85.akpm@linux-foundation.org>
In-Reply-To: <1236678569.28294.3.camel@eight.analog.com>
References: <1236678569.28294.3.camel@eight.analog.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009 17:49:29 +0800
sonic zhang <sonic.adi@gmail.com> wrote:

> The rx buffer tail index may increase to UART_XMIT_SIZE, which is not a valid
> index, at the beginning of the Loop. The exit check should happen after this
> index is adjusted properly.
> 
> Reported-by: Qian Zhang <zhangq@sansitech.com>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/serial/bfin_5xx.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
> index 350bfc4..1e027e3 100644
> --- a/drivers/serial/bfin_5xx.c
> +++ b/drivers/serial/bfin_5xx.c
> @@ -402,9 +402,11 @@ static void bfin_serial_dma_rx_chars(struct bfin_serial_port *uart)
>  	else
>  		flg = TTY_NORMAL;
>  
> -	for (i = uart->rx_dma_buf.tail; i != uart->rx_dma_buf.head; i++) {
> +	for (i = uart->rx_dma_buf.tail; ; i++) {
>  		if (i >= UART_XMIT_SIZE)
>  			i = 0;
> +		if (i == uart->rx_dma_buf.head)
> +			break;
>  		if (!uart_handle_sysrq_char(&uart->port, uart->rx_dma_buf.buf[i]))
>  			uart_insert_char(&uart->port, status, OE,
>  				uart->rx_dma_buf.buf[i], flg);

This appears to be identical to the v1 ptch whcih I merged.
