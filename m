Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbYKTUzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbYKTUzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756949AbYKTUvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:51:46 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:22391 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756903AbYKTUvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:51:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=n5MD2FqCwrdUFvN06sxZiDdvQrIT2MEaaUK2RiAGf7GGMIEaf4zzTLjR6kqrT0QV9HtS5gqcm0hsqG5ze+DuTW25uqnPp2IH/m9ThTL/cjD9eYJ5LzVWu3qwedE8B5SCk9clAmbpw6awmQSQPDqeyCz8mGnVIWWP4K+OaJU1LaA=  ;
X-YMail-OSG: GXDO_wYVM1kG8WqjE69nBG3idp7W.TncL4.mbh_a4S1owcWRB9JFb.UDnm2CElooVelB0nsPPGqlvNgQnfWNOQtkFSLnQBTwDhdDwTSq_q0ozCxpqrCU1Cwew9TM6vH5LG4iO9mScVXZcySvRs5r2i7Xrl3FYoTq7_UGktcuhCFsJ0GHKcuKNUqyxJyC
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 15/16] Blackfin SPI Driver: fix bug - spi controller driver does not assert/deassert CS correctly
Date: Thu, 20 Nov 2008 12:47:46 -0800
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Yi Li <yi.li@analog.com>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org> <1226994760-4301-16-git-send-email-cooloney@kernel.org>
In-Reply-To: <1226994760-4301-16-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201247.46730.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2008, Bryan Wu wrote:
> From: Yi Li <yi.li@analog.com>
> 
> This bug can be observed when two SPI devices are sharing the spi bus:
> One device is set as SPI CS 7, another one is using SPI CS 4.
> 
> In spi_bfin5xx.c: cs_active(), cs_deactive() are used to control SPI_FLG
> register. From the debug bellow:
> 
> cs_active: flag: 0x7f91, chip->flag: 0x7f80, cs: 7
> cs_active: flag: 0xef91, chip->flag: 0xef10, cs: 4
> 
> When device A (cs_7) activate CS 7, SPI_FLG is set as 0x7f91 (however,
> SPI_FLG should be set as 0x7f80, or 0x6f91 if in broadcast mode).
> 
> Due to some HW bug (very possibly), if SPI_FLG is set as 0x7f91,
> SPISSEL7 is asserted, however SPISSEL4 will be asserted too (I can see
> this using the scope). This is unreasonable according to HRM.
> 
> Signed-off-by: Yi Li <yi.li@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

Yay!  Real patch comments!  Although ... it doesn't exactly
say *how* it was fixed, which would make the comments better.
("Clear flags that were wrongly left set." maybe.)

Saying what was fixed is at least a start.


> ---
>  drivers/spi/spi_bfin5xx.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
> index 9c602ad..8cf5d6e 100644
> --- a/drivers/spi/spi_bfin5xx.c
> +++ b/drivers/spi/spi_bfin5xx.c
> @@ -189,6 +189,7 @@ static void cs_deactive(struct driver_data *drv_data, struct chip_data *chip)
>  {
>  	u16 flag = read_FLAG(drv_data);
>  
> +	flag &= ~chip->flag;
>  	flag |= (chip->flag << 8);
>  
>  	write_FLAG(drv_data, flag);
> @@ -1032,7 +1033,6 @@ static int setup(struct spi_device *spi)
>  	struct bfin5xx_spi_chip *chip_info = NULL;
>  	struct chip_data *chip;
>  	struct driver_data *drv_data = spi_master_get_devdata(spi->master);
> -	u8 spi_flg;
>  
>  	/* Abort device setup if requested features are not supported */
>  	if (spi->mode & ~(SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST)) {
> @@ -1115,8 +1115,7 @@ static int setup(struct spi_device *spi)
>  	 * SPI_BAUD, not the real baudrate
>  	 */
>  	chip->baud = hz_to_spi_baud(spi->max_speed_hz);
> -	spi_flg = ~(1 << (spi->chip_select));
> -	chip->flag = ((u16) spi_flg << 8) | (1 << (spi->chip_select));
> +	chip->flag = 1 << (spi->chip_select);
>  	chip->chip_select_num = spi->chip_select;
>  
>  	switch (chip->bits_per_word) {
> -- 
> 1.5.6.3
> 
> 


