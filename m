Return-Path: <linux-kernel-owner+w=401wt.eu-S1763267AbXEPTzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763267AbXEPTzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759555AbXEPTzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:55:05 -0400
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:42076 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759169AbXEPTzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:55:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hHTPoyU/i+DvgKmnrkaBQK5uIRbhPcSgBh/R7pXQ3ad7VdFwKDUmvM7GRjwsspxVdKg3e8dUkZdBZSfp36wqVwqTnmwN93Fu28p8Snw3p9RiMJvnxsFjl7PzIMUNTR/kglvnEttJJ4xUUlzgZdavpHxgfEpBKwYO1i9+xLFAyNw=  ;
X-YMail-OSG: B7pc4AgVM1k1uen18.S9GgW1McV_NHAs03sv6JifL439Zx0lon7JeSGz92BQf_6jQATaKpPL9Q--
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH] atmel_spi: Pass correct DMA address to controller
Date: Wed, 16 May 2007 12:54:59 -0700
User-Agent: KMail/1.9.6
Cc: wux@landicorp.com, linux-kernel@vger.kernel.org
References: <11793107892086-git-send-email-hskinnemoen@atmel.com>
In-Reply-To: <11793107892086-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705161254.59308.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2007, Haavard Skinnemoen wrote:
> When either rx_buf or tx_buf is not being used, i.e. for plain read-
> or write operations, the atmel_spi uses a fixed-size DMA buffer
> instead. If the transfer is longer than the size of this buffer, it is
> split into multiple DMA transfers.
> 
> When the transfer is split like this, the atmel_spi driver ends up
> using the same DMA address again and again even for the buffer that
> came from the user, which is of course wrong.

Yes, and needs fixing.  This is almost right, see below.


> Fix this by adding the 
> number of bytes already transferred to the DMA address so that the
> data ends up in the right place.
> 
> Thanks to Wu Xuan for discovering this bug.
> 
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> ---
>  drivers/spi/atmel_spi.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
> index 1d8a2f6..8b2601d 100644
> --- a/drivers/spi/atmel_spi.c
> +++ b/drivers/spi/atmel_spi.c
> @@ -113,16 +113,16 @@ static void atmel_spi_next_xfer(struct spi_master *master,
>  
>  	len = as->remaining_bytes;
>  
> -	tx_dma = xfer->tx_dma;
> -	rx_dma = xfer->rx_dma;
> +	tx_dma = xfer->tx_dma + xfer->len - len;
> +	rx_dma = xfer->rx_dma + xfer->len - len;
>  
>  	/* use scratch buffer only when rx or tx data is unspecified */
> -	if (rx_dma == INVALID_DMA_ADDRESS) {
> +	if (!xfer->rx_buf) {

This test ...

>  		rx_dma = as->buffer_dma;
>  		if (len > BUFFER_SIZE)
>  			len = BUFFER_SIZE;
>  	}
> -	if (tx_dma == INVALID_DMA_ADDRESS) {
> +	if (!xfer->tx_buf) {

... and this one must not assume that the relevant buffer
is always NULL when the tx_dma has been set up.  Keep the
test against INVALID_DMA_ADDRESS, but fetch the address
from the spi_transfer.

It's legit to set up cpu-virtual (for PIO) and dma addresses
for each buffer, since the upper layer driver has no way to
know if the underlying controller driver is DMA-capable, or
for that matter PIO-capable.

>  		tx_dma = as->buffer_dma;
>  		if (len > BUFFER_SIZE)
>  			len = BUFFER_SIZE;
> -- 
> 1.4.4.4
> 


