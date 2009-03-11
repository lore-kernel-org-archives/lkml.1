Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbZCKUH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbZCKUH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 16:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbZCKUHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 16:07:36 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:39296 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751688AbZCKUHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 16:07:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4hN5+/IdhB46nCG4riN5pMrlwcv6bTo/l35ozt/hhAEpAKmhtLTqjgoL6Z8ny77zZb0wslKzPmY6X+dLwkSbh6Sc33dKuXoXzCwjvgwQRiifdY6UnlCUKDDVwVam28ypQI19f8cvbRA0C/hduizmwe76+oNZz4OJyTLVU/Z+V/w=  ;
X-YMail-OSG: ogulb4IVM1lhITFKDsnNuYoZQ.L5FuNOLHZVbLbWFiI76yDYZY8OoAvJf3_PFsuwCbty7NMgH8awcxb4UDREHVIHprLiC4c7ZUa7vM3bkeakrr1594cFaLsq1IQpPrbIFH4uOGMfVKMneR0tyUtvnVLOR8DE2gmDbNooVzaSC4nR_A0R0QTcCzpQuwdA19EJNw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Subject: Re: [PATCH 4/7] mmc_spi: do not check CID and CSD blocks with CRC16
Date: Wed, 11 Mar 2009 12:07:30 -0800
User-Agent: KMail/1.9.10
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200903111425.48656.wolfgang.mues@auerswald.de>
In-Reply-To: <200903111425.48656.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903111307.31199.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 March 2009, Wolfgang Mües wrote:
> From: Wolfgang Muees <wolfgang.mues@auerswald.de>
> 
> o Some cards are not able to calculate a valid CRC16 value
>   for CID and CSD reads (CRC for 512 byte data blocks is OK).
>   So ommit the check for CRC16, as CID and CSD have a checksum
>   inside the block.
> 
> Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

> 
> ---
> This is one of a line of patches to enhance the usability of
> the mmc spi host port driver from "don't work with most SD cards"
> to "work with nearly all SD cards" (including those ugly cards
> with non-byte-aligned responses).
> 
> diff -uprN 2_6_29_rc7_patch3_delayed_data_response/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch4_no_crc_on_CID_CSD/drivers/mmc/host/mmc_spi.c
> --- 2_6_29_rc7_patch3_delayed_data_response/drivers/mmc/host/mmc_spi.c	2009-03-11 13:42:48.000000000 +0100
> +++ 2_6_29_rc7_patch4_no_crc_on_CID_CSD/drivers/mmc/host/mmc_spi.c	2009-03-11 13:43:13.000000000 +0100
> @@ -762,7 +762,11 @@ mmc_spi_readblock(struct mmc_spi_host *h
>  		return -EIO;
>  	}
>  
> -	if (host->mmc->use_spi_crc) {
> +	/* Omitt the CRC check for CID and CSD reads. There are some SDHC
> +	 * cards which don't supply a valid CRC after CID reads.
> +	 * Note that the CID has it's own CRC7 value inside the data block.
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


