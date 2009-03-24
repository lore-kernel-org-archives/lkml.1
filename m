Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbZCXULW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbZCXULW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758945AbZCXULJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:11:09 -0400
Received: from n11.bullet.mail.mud.yahoo.com ([209.191.125.210]:25392 "HELO
	n11.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756182AbZCXULH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:11:07 -0400
X-Yahoo-Newman-Id: 944747.52133.bm@omp406.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Gzgd3Q8elSMhDKNGn5EIQEahyhop5mTZXhRKq68KxosiOYDKzvITvGqKqvvFPbMj3A6W0ewN82/W+SVoiuBg7KKuc52Nu3KAvb2EWxwXfg1fdfFv+G5KsA/npn3+dot/LAAzuIbZ1ovw0PQqmi6QiYVncL+/lZaHkQuZs1is8zo=  ;
X-YMail-OSG: RPGGBJwVM1ka2B9ElzvyYzZAJrYIJCUe49KLbyXR3hwpC7aHPKyP2zSSmUn6v3FepIEJEA8G5PkoVJHkSkSemGi3ISRvA2IGOFwOb160lcQCAk6_KT0NJB3c5XghsI90H95JnvIrbbXR6ytWwyxahHEfN7EEmbPUCdBRf4ZZ2DGQcdiJ2bSJVyKrjjhPXpKZOQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Subject: Re: [PATCH 4/7 revised] mmc_spi: do not check CID and CSD blocks with CRC16
Date: Tue, 24 Mar 2009 13:11:02 -0700
User-Agent: KMail/1.9.10
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200903181052.39586.wolfgang.mues@auerswald.de>
In-Reply-To: <200903181052.39586.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903241311.02878.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 March 2009, Wolfgang Mües wrote:
> From: Wolfgang Muees <wolfgang.mues@auerswald.de>
> 
> o Some cards are not able to calculate a valid CRC16 value
>   for CID and CSD reads (CRC for 512 byte data blocks is OK).
>   So ommit the check for CRC16, as CID and CSD have a checksum
>   inside the block.
> 
> Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

.... though I'd edit the patch to spell "Omit" with just one "t".

> 
> ---
> 
> This is patch #4 revised to apply after #1,#2,#5 (already applied) 
> and #3 (acked by David Brownell). Documentation was extended.
> There were some suggestions to move this check into an upper layer
> but none of these tries were a valid solution, so stick with this
> minimal change here in the readblock function.
> 
> diff -uprN 2_6_29_rc7_patch1253/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch12534/drivers/mmc/host/mmc_spi.c
> --- 2_6_29_rc7_patch1253/drivers/mmc/host/mmc_spi.c	2009-03-16 12:15:36.000000000 +0100
> +++ 2_6_29_rc7_patch12534/drivers/mmc/host/mmc_spi.c	2009-03-18 10:32:45.000000000 +0100
> @@ -767,7 +767,13 @@ mmc_spi_readblock(struct mmc_spi_host *h
>  		return -EIO;
>  	}
>  
> -	if (host->mmc->use_spi_crc) {
> +	/* Omitt the CRC check for CID reads. There are some SDHC
> +	 * cards which don't supply a valid CRC after CID reads.
> +	 * All data reads have len == MMC_SPI_BLOCKSIZE, so use this
> +	 * check to distinguish between data reads and CID/CSD reads.
> +	 * Note that CID/CSD has it's own CRC7 value inside the structure.
> +	 */
> +	if (host->mmc->use_spi_crc && (t->len == MMC_SPI_BLOCKSIZE)) {
>  		u16 crc = crc_itu_t(0, t->rx_buf, t->len);
>  
>  		be16_to_cpus(&scratch->crc_val);
> 
> ---
> regards
> 
> i. A. Wolfgang Mües
> -- 
> Auerswald GmbH & Co. KG
> Hardware Development
> Telefon: +49 (0)5306 9219 0
> Telefax: +49 (0)5306 9219 94 
> E-Mail: Wolfgang.Mues@Auerswald.de
> Web: http://www.auerswald.de
>  
> --------------------------------------------------------------
> Auerswald GmbH & Co. KG, Vor den Grashöfen 1, 38162 Cremlingen
> Registriert beim AG Braunschweig HRA 13289
> p.h.G Auerswald Geschäftsführungsges. mbH
> Registriert beim AG Braunschweig HRB 7463
> Geschäftsführer: Dipl-Ing. Gerhard Auerswald
> 
> 



