Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbZCKUSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbZCKUSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 16:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbZCKURv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 16:17:51 -0400
Received: from n29.bullet.mail.mud.yahoo.com ([68.142.207.48]:47197 "HELO
	n29.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752691AbZCKURu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 16:17:50 -0400
X-Yahoo-Newman-Id: 406912.84077.bm@omp405.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hDDD2bAFkQM6GLfSWX0Z0mMTJT12TuVvqvLCrCy9oznOwnlFFd5m8PscRdcjeJx4o2/kS4Z31h+/PacBmEdmfIDruwwRTbrlTeXJQSyIeTzUiO22SXS/NPSEJfbk1qif5SDj4KEZyLRNzV/TH5uMW6I6Zz3xeW5lU4L5O7G+fxE=  ;
X-YMail-OSG: .LncIfIVM1ld4ooPwTJjcAhYUul7xYmK3GApoSp_AqbDLTJ_rGBFQNOCV6TJS7p_mSw4z2srauxP.3QIEzEPMIeBXLHq2PdO4Yvl4vPcEajU..1hYlWogSAmxzKPp73JvemD7xa3Uryj992y7cyrny01hX._AEfnSkJuov_.Ypzqy8o4L0OeHnTELD7n7aO3HQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Subject: Re: [PATCH 5/7] mmc_spi: allow higher timeouts for SPI mode
Date: Wed, 11 Mar 2009 12:15:30 -0800
User-Agent: KMail/1.9.10
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200903111428.39831.wolfgang.mues@auerswald.de>
In-Reply-To: <200903111428.39831.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903111315.31494.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 March 2009, Wolfgang Mües wrote:
> From: Wolfgang Muees <wolfgang.mues@auerswald.de>
> 
> o Some SD cards have very high timeouts in SPI mode.
>   So adjust the timeouts from theory to practice.
> 
> Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


> ---
> This is one of a line of patches to enhance the usability of
> the mmc spi host port driver from "don't work with most SD cards"
> to "work with nearly all SD cards" (including those ugly cards
> with non-byte-aligned responses).
> 
> diff -uprN 2_6_29_rc7_patch4_no_crc_on_CID_CSD/drivers/mmc/core/core.c 2_6_29_rc7_patch5_extra_spi_timeouts/drivers/mmc/core/core.c
> --- 2_6_29_rc7_patch4_no_crc_on_CID_CSD/drivers/mmc/core/core.c	2009-03-04 02:05:22.000000000 +0100
> +++ 2_6_29_rc7_patch5_extra_spi_timeouts/drivers/mmc/core/core.c	2009-03-10 12:06:16.000000000 +0100
> @@ -297,6 +297,21 @@ void mmc_set_data_timeout(struct mmc_dat
>  			data->timeout_clks = 0;
>  		}
>  	}
> +	/*
> +	 * Some cards need very high timeouts if driven in SPI mode.
> +	 * The worst observed timeout was 900ms after writing a
> +	 * continuous stream of data until the internal logic
> +	 * overflowed.
> +	 */
> +	if (mmc_host_is_spi(card->host)) {
> +		if (data->flags & MMC_DATA_WRITE) {
> +			if (data->timeout_ns < 1000000000)
> +				data->timeout_ns = 1000000000;	/* 1s */
> +		} else {
> +			if (data->timeout_ns < 100000000)
> +				data->timeout_ns =  100000000;	/* 100ms */
> +		}
> +	}
>  }
>  EXPORT_SYMBOL(mmc_set_data_timeout);
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



