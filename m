Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923Ab0AVWE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab0AVWE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 17:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871Ab0AVWE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 17:04:26 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:3505 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab0AVWEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 17:04:25 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Date: Fri, 22 Jan 2010 14:04:10 -0800
From: "Leo (Hao) Chen" <leochen@broadcom.com>
To: "Roel Kluin" <roel.kluin@gmail.com>
cc: "Scott Branden" <sbranden@broadcom.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: hot spin and code duplication in
 nand_bcm_umi_bch_read_oobEcc()
Message-ID: <20100122220410.GN12439@broadcom.com>
References: <4B5A172C.2010609@gmail.com>
MIME-Version: 1.0
In-Reply-To: <4B5A172C.2010609@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-WSS-ID: 6744FF5620S238709-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for identifying the NumToRead bug.
Tested on board. Works.

Acked-by: Leo Chen <leochen@broadcom.com>

On Fri, Jan 22, 2010 at 01:22:52PM -0800, Roel Kluin wrote:
> In the branch where pagesize equalled NAND_DATA_ACCESS_SIZE, NumToRead
> wasn't decremented in the `while (numToRead > 11)' loop.
> Also the first and last while loops were duplicated in both branches.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/mtd/nand/nand_bcm_umi.h |   71 ++++++++++++++-------------------------
>  1 files changed, 25 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/mtd/nand/nand_bcm_umi.h b/drivers/mtd/nand/nand_bcm_umi.h
> index 7cec2cd..198b304 100644
> --- a/drivers/mtd/nand/nand_bcm_umi.h
> +++ b/drivers/mtd/nand/nand_bcm_umi.h
> @@ -167,18 +167,27 @@ static inline void nand_bcm_umi_bch_read_oobEcc(uint32_t pageSize,
>  	int numToRead = 16;	/* There are 16 bytes per sector in the OOB */
>  
>  	/* ECC is already paused when this function is called */
> +	if (pageSize != NAND_DATA_ACCESS_SIZE) {
> +		/* skip BI */
> +#if defined(__KERNEL__) && !defined(STANDALONE)
> +		*oobp++ = REG_NAND_DATA8;
> +#else
> +		REG_NAND_DATA8;
> +#endif
> +		numToRead--;
> +	}
>  
> -	if (pageSize == NAND_DATA_ACCESS_SIZE) {
> -		while (numToRead > numEccBytes) {
> -			/* skip free oob region */
> +	while (numToRead > numEccBytes) {
> +		/* skip free oob region */
>  #if defined(__KERNEL__) && !defined(STANDALONE)
> -			*oobp++ = REG_NAND_DATA8;
> +		*oobp++ = REG_NAND_DATA8;
>  #else
> -			REG_NAND_DATA8;
> +		REG_NAND_DATA8;
>  #endif
> -			numToRead--;
> -		}
> +		numToRead--;
> +	}
>  
> +	if (pageSize == NAND_DATA_ACCESS_SIZE) {
>  		/* read ECC bytes before BI */
>  		nand_bcm_umi_bch_resume_read_ecc_calc();
>  
> @@ -190,6 +199,7 @@ static inline void nand_bcm_umi_bch_read_oobEcc(uint32_t pageSize,
>  #else
>  			eccCalc[eccPos++] = REG_NAND_DATA8;
>  #endif
> +			numToRead--;
>  		}
>  
>  		nand_bcm_umi_bch_pause_read_ecc_calc();
> @@ -204,49 +214,18 @@ static inline void nand_bcm_umi_bch_read_oobEcc(uint32_t pageSize,
>  			numToRead--;
>  		}
>  
> -		/* read ECC bytes */
> -		nand_bcm_umi_bch_resume_read_ecc_calc();
> -		while (numToRead) {
> -#if defined(__KERNEL__) && !defined(STANDALONE)
> -			*oobp = REG_NAND_DATA8;
> -			eccCalc[eccPos++] = *oobp;
> -			oobp++;
> -#else
> -			eccCalc[eccPos++] = REG_NAND_DATA8;
> -#endif
> -			numToRead--;
> -		}
> -	} else {
> -		/* skip BI */
> +	}
> +	/* read ECC bytes */
> +	nand_bcm_umi_bch_resume_read_ecc_calc();
> +	while (numToRead) {
>  #if defined(__KERNEL__) && !defined(STANDALONE)
> -		*oobp++ = REG_NAND_DATA8;
> +		*oobp = REG_NAND_DATA8;
> +		eccCalc[eccPos++] = *oobp;
> +		oobp++;
>  #else
> -		REG_NAND_DATA8;
> +		eccCalc[eccPos++] = REG_NAND_DATA8;
>  #endif
>  		numToRead--;
> -
> -		while (numToRead > numEccBytes) {
> -			/* skip free oob region */
> -#if defined(__KERNEL__) && !defined(STANDALONE)
> -			*oobp++ = REG_NAND_DATA8;
> -#else
> -			REG_NAND_DATA8;
> -#endif
> -			numToRead--;
> -		}
> -
> -		/* read ECC bytes */
> -		nand_bcm_umi_bch_resume_read_ecc_calc();
> -		while (numToRead) {
> -#if defined(__KERNEL__) && !defined(STANDALONE)
> -			*oobp = REG_NAND_DATA8;
> -			eccCalc[eccPos++] = *oobp;
> -			oobp++;
> -#else
> -			eccCalc[eccPos++] = REG_NAND_DATA8;
> -#endif
> -			numToRead--;
> -		}
>  	}
>  }
>  
> 

-- 

Leo Hao Chen

------------------------
Life is short, run long.

