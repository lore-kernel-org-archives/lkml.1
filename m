Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbZDEW4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbZDEW4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 18:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbZDEW4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 18:56:10 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:27929 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752212AbZDEW4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 18:56:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CDfUUfb+zZCqiW0SlrDuV1H6IiIFthcq/B1Z6ZsNM1hIyukp8YUHLlesd3/a1zK/pbehWhAPjVgozAo/HPLdW7JJskgnlMFy7fH6+pt+g6vJZkRgcffgy446hqF9s6pnFVvM5kjn5BzJGHAXzdr6wGtc3eX7Yapx5V36WvCGIUI=  ;
X-YMail-OSG: tqO_d.cVM1kFEvY1CZIRvKXph5fMKz3HqPeilXQ.BgetOmjyaqvIK89CwopogejKhym.gnVtIZ_gmx0mngeyhdIPNtfNlXuJA941bvdYQxjAM9g3hDBD73JqgBQQElQgZVj8fwd5PDtff5yuXDDCDJaV976M4I.E1nhJV7D7mysilnFPPT115tn4Zj0y41.Vp12v7CCt0Z0UYhxravrDS9twlESOa_D9HDNTIefwXfmMhYFb0DYCF6351fKUNzuZTuXTwLjPnrNYhBOEbt2IhJkPBl8C0hdid_r_tqBo7y68pw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: nsnehaprabha@ti.com
Subject: Re: [PATCH] MTD-NAND: Changes to read_page APIs to support NAND_ECC_HW_SYNDROME mode on TI DaVinci DM355
Date: Sun, 5 Apr 2009 15:56:05 -0700
User-Agent: KMail/1.9.10
Cc: davinci-linux-open-source@linux.davincidsp.com,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1238601784-9563-1-git-send-email-nsnehaprabha@ti.com>
In-Reply-To: <1238601784-9563-1-git-send-email-nsnehaprabha@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904051556.05368.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 April 2009, nsnehaprabha@ti.com wrote:
> From: Sneha Narnakaje <nsnehaprabha@ti.com>
> 
> The NAND controller on TI DaVinci DM355 supports NAND devices
> with large page size (2K and 4K), but the HW ECC is handled
> for every 512byte read/write chunks. The current HW_SYNDROME
> read_page/write_page APIs in the NAND core (nand_base) use the
> "infix OOB" scheme.

Makes me wonder if there should be a new NAND_ECC_HW_* mode,
which doesn't use "infix OOB" ... since that's the problem.

Given bugs recently uncovered in that area, it seems that
these DaVinci chips may be the first to use ECC_HW_SYNDROME
in multi-chunk mode (and thus "infix OOB" in its full glory,
rather than single-chunk subset which matches traditional
layout with OOB at the end).


> The core APIs overwrite NAND manufacturer's bad block meta
> data, thus complicating the jobs of non-Linux NAND programmers
> (end equipment manufacturering). These APIs also imply ECC
> protection for the prepad bytes, causing nand raw_write
> operations to fail.

All of those seem like reasons to avoid NAND_ECC_HW_SYNDROME
unless the ECC chunksize matches the page size ... that is,
to only use it when "infix OOB" won't apply.

I particularly dislike clobbering the bad block data, since
once that's done it can't easily be recovered.  Preferable
to leave those markers in place, so that the chip can still
be re-initialized cleanly.


> So the TI DaVinci NAND driver overrides these APIs for
> DaVinci DM355.

The same 4-bit ECC engine is used on most other DaVinci DM3xx
chips; OMAP-L1xx chips, and their technical relatives like
the DA8xx family, of course.


> The read_page APIs required "page" to be passed for reading
> the whole OOB area first and then data in chunks of 512bytes.
> The ECC status is checked after reading every 512byte chunk
> and passing the ECC syndrome.

If this were a new NAND_ECC_HW_* flavor, all that logic
would reside in the NAND core so that other chips could
easily reuse it.  (The interface changes would still be
needed.)

- Dave


> Since there is a change to read_page/read_page_raw API
> definitions, other NAND drivers overriding these APIs have
> also been changed (to address compilation problems).   
> 
> This patch also changes the way oobavail is calculated using
> the oobfree[].length and the way oobfree[] is used. The
> oobfree[] is defined as an array of MTD_MAX_OOBFREE_ENTRIES
> size (8). If we initialize all 8 entries, then the current
> for loop which has a chance to go beyond the array limit thus
> causing incorrect oobavail value. The NAND core and other NAND
> drivers do not require upto 8 oobfree entries, but the TI
> DaVinci NAND driver requires upto 8 oobfree entries to support
> upto 4K page size. The check for MTD_MAX_OOBFREE_ENTREIES is
> already there in the drivers/mtd/onenand/onenand_base.c, which
> is based on drivers/mtd/nand/nand_base.c. There is also a check
> for ecc.steps to make the oobfree[] backward compatible with 2K
> page size. The max oob size and page size have been adjusted for
> the 4K+128 page size. Supporting up to 4K page with
> NAND_ECC_HW_SYNDROME does not require changes to
> include/mtd/mtd-abi.h (breaks user space IOCTL interface).               
> 
> Signed-off-by: Sandeep Paulraj <s-paulraj@ti.com>
> Signed-off-by: Sneha Narnakaje <nsnehaprabha@ti.com>
> ---
>  drivers/mtd/nand/atmel_nand.c    |    2 +-
>  drivers/mtd/nand/cafe_nand.c     |    2 +-
>  drivers/mtd/nand/fsl_elbc_nand.c |    3 +-
>  drivers/mtd/nand/nand_base.c     |   45 ++++++++++++++++++++++----------------
>  drivers/mtd/nand/sh_flctl.c      |    2 +-
>  include/linux/mtd/nand.h         |    8 +++---
>  6 files changed, 35 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
> index 47a33ce..b63eddb 100644
> --- a/drivers/mtd/nand/atmel_nand.c
> +++ b/drivers/mtd/nand/atmel_nand.c
> @@ -214,7 +214,7 @@ static int atmel_nand_calculate(struct mtd_info *mtd,
>   * buf:        buffer to store read data
>   */
>  static int atmel_nand_read_page(struct mtd_info *mtd,
> -		struct nand_chip *chip, uint8_t *buf)
> +		struct nand_chip *chip, uint8_t *buf, int page)
>  {
>  	int eccsize = chip->ecc.size;
>  	int eccbytes = chip->ecc.bytes;
> diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
> index 22a6b2e..8ea1623 100644
> --- a/drivers/mtd/nand/cafe_nand.c
> +++ b/drivers/mtd/nand/cafe_nand.c
> @@ -381,7 +381,7 @@ static int cafe_nand_read_oob(struct mtd_info *mtd, struct nand_chip *chip,
>   * we need a special oob layout and handling.
>   */
>  static int cafe_nand_read_page(struct mtd_info *mtd, struct nand_chip *chip,
> -			       uint8_t *buf)
> +			       uint8_t *buf, int page)
>  {
>  	struct cafe_priv *cafe = mtd->priv;
>  
> diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
> index 1f6eb25..ddd37d2 100644
> --- a/drivers/mtd/nand/fsl_elbc_nand.c
> +++ b/drivers/mtd/nand/fsl_elbc_nand.c
> @@ -739,7 +739,8 @@ static int fsl_elbc_chip_init_tail(struct mtd_info *mtd)
>  
>  static int fsl_elbc_read_page(struct mtd_info *mtd,
>                                struct nand_chip *chip,
> -                              uint8_t *buf)
> +			      uint8_t *buf,
> +			      int page)
>  {
>  	fsl_elbc_read_buf(mtd, buf, mtd->writesize);
>  	fsl_elbc_read_buf(mtd, chip->oob_poi, mtd->oobsize);
> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> index 599185c..d7f6650 100644
> --- a/drivers/mtd/nand/nand_base.c
> +++ b/drivers/mtd/nand/nand_base.c
> @@ -750,7 +750,7 @@ static int nand_wait(struct mtd_info *mtd, struct nand_chip *chip)
>   * @buf:	buffer to store read data
>   */
>  static int nand_read_page_raw(struct mtd_info *mtd, struct nand_chip *chip,
> -			      uint8_t *buf)
> +			      uint8_t *buf, int page)
>  {
>  	chip->read_buf(mtd, buf, mtd->writesize);
>  	chip->read_buf(mtd, chip->oob_poi, mtd->oobsize);
> @@ -764,7 +764,7 @@ static int nand_read_page_raw(struct mtd_info *mtd, struct nand_chip *chip,
>   * @buf:	buffer to store read data
>   */
>  static int nand_read_page_swecc(struct mtd_info *mtd, struct nand_chip *chip,
> -				uint8_t *buf)
> +				uint8_t *buf, int page)
>  {
>  	int i, eccsize = chip->ecc.size;
>  	int eccbytes = chip->ecc.bytes;
> @@ -774,7 +774,7 @@ static int nand_read_page_swecc(struct mtd_info *mtd, struct nand_chip *chip,
>  	uint8_t *ecc_code = chip->buffers->ecccode;
>  	uint32_t *eccpos = chip->ecc.layout->eccpos;
>  
> -	chip->ecc.read_page_raw(mtd, chip, buf);
> +	chip->ecc.read_page_raw(mtd, chip, buf, page);
>  
>  	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize)
>  		chip->ecc.calculate(mtd, p, &ecc_calc[i]);
> @@ -887,7 +887,7 @@ static int nand_read_subpage(struct mtd_info *mtd, struct nand_chip *chip, uint3
>   * Not for syndrome calculating ecc controllers which need a special oob layout
>   */
>  static int nand_read_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
> -				uint8_t *buf)
> +				uint8_t *buf, int page)
>  {
>  	int i, eccsize = chip->ecc.size;
>  	int eccbytes = chip->ecc.bytes;
> @@ -932,7 +932,7 @@ static int nand_read_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
>   * we need a special oob layout and handling.
>   */
>  static int nand_read_page_syndrome(struct mtd_info *mtd, struct nand_chip *chip,
> -				   uint8_t *buf)
> +				   uint8_t *buf, int page)
>  {
>  	int i, eccsize = chip->ecc.size;
>  	int eccbytes = chip->ecc.bytes;
> @@ -997,8 +997,10 @@ static uint8_t *nand_transfer_oob(struct nand_chip *chip, uint8_t *oob,
>  		struct nand_oobfree *free = chip->ecc.layout->oobfree;
>  		uint32_t boffs = 0, roffs = ops->ooboffs;
>  		size_t bytes = 0;
> +		unsigned int i;
>  
> -		for(; free->length && len; free++, len -= bytes) {
> +		for (i = 0; i < chip->ecc.steps && i < MTD_MAX_OOBFREE_ENTRIES
> +		     && free->length && len; i++, free++, len -= bytes) {
>  			/* Read request not from offset 0 ? */
>  			if (unlikely(roffs)) {
>  				if (roffs >= free->length) {
> @@ -1074,11 +1076,13 @@ static int nand_do_read_ops(struct mtd_info *mtd, loff_t from,
>  
>  			/* Now read the page into the buffer */
>  			if (unlikely(ops->mode == MTD_OOB_RAW))
> -				ret = chip->ecc.read_page_raw(mtd, chip, bufpoi);
> +				ret = chip->ecc.read_page_raw(mtd, chip,
> +							      bufpoi, page);
>  			else if (!aligned && NAND_SUBPAGE_READ(chip) && !oob)
>  				ret = chip->ecc.read_subpage(mtd, chip, col, bytes, bufpoi);
>  			else
> -				ret = chip->ecc.read_page(mtd, chip, bufpoi);
> +				ret = chip->ecc.read_page(mtd, chip, bufpoi,
> +							  page);
>  			if (ret < 0)
>  				break;
>  
> @@ -1666,8 +1670,10 @@ static uint8_t *nand_fill_oob(struct nand_chip *chip, uint8_t *oob,
>  		struct nand_oobfree *free = chip->ecc.layout->oobfree;
>  		uint32_t boffs = 0, woffs = ops->ooboffs;
>  		size_t bytes = 0;
> +		unsigned int i;
>  
> -		for(; free->length && len; free++, len -= bytes) {
> +		for (i = 0; i < chip->ecc.steps && i < MTD_MAX_OOBFREE_ENTRIES
> +		     && free->length && len; i++, free++, len -= bytes) {
>  			/* Write request not from offset 0 ? */
>  			if (unlikely(woffs)) {
>  				if (woffs >= free->length) {
> @@ -2651,16 +2657,6 @@ int nand_scan_tail(struct mtd_info *mtd)
>  	}
>  
>  	/*
> -	 * The number of bytes available for a client to place data into
> -	 * the out of band area
> -	 */
> -	chip->ecc.layout->oobavail = 0;
> -	for (i = 0; chip->ecc.layout->oobfree[i].length; i++)
> -		chip->ecc.layout->oobavail +=
> -			chip->ecc.layout->oobfree[i].length;
> -	mtd->oobavail = chip->ecc.layout->oobavail;
> -
> -	/*
>  	 * Set the number of read / write steps for one page depending on ECC
>  	 * mode
>  	 */
> @@ -2672,6 +2668,17 @@ int nand_scan_tail(struct mtd_info *mtd)
>  	chip->ecc.total = chip->ecc.steps * chip->ecc.bytes;
>  
>  	/*
> +	 * The number of bytes available for a client to place data into
> +	 * the out of band area
> +	 */
> +	chip->ecc.layout->oobavail = 0;
> +	for (i = 0; i < chip->ecc.steps && i < MTD_MAX_OOBFREE_ENTRIES &&
> +	     chip->ecc.layout->oobfree[i].length; i++)
> +		chip->ecc.layout->oobavail +=
> +			chip->ecc.layout->oobfree[i].length;
> +	mtd->oobavail = chip->ecc.layout->oobavail;
> +
> +	/*
>  	 * Allow subpage writes up to ecc.steps. Not possible for MLC
>  	 * FLASH.
>  	 */
> diff --git a/drivers/mtd/nand/sh_flctl.c b/drivers/mtd/nand/sh_flctl.c
> index 821acb0..77e74a3 100644
> --- a/drivers/mtd/nand/sh_flctl.c
> +++ b/drivers/mtd/nand/sh_flctl.c
> @@ -324,7 +324,7 @@ static void set_cmd_regs(struct mtd_info *mtd, uint32_t cmd, uint32_t flcmcdr_va
>  }
>  
>  static int flctl_read_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
> -				uint8_t *buf)
> +				uint8_t *buf, int page)
>  {
>  	int i, eccsize = chip->ecc.size;
>  	int eccbytes = chip->ecc.bytes;
> diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
> index 27fb694..63ed0eb 100644
> --- a/include/linux/mtd/nand.h
> +++ b/include/linux/mtd/nand.h
> @@ -43,8 +43,8 @@ extern void nand_wait_ready(struct mtd_info *mtd);
>   * is supported now. If you add a chip with bigger oobsize/page
>   * adjust this accordingly.
>   */
> -#define NAND_MAX_OOBSIZE	64
> -#define NAND_MAX_PAGESIZE	2048
> +#define NAND_MAX_OOBSIZE	128
> +#define NAND_MAX_PAGESIZE	4096
>  
>  /*
>   * Constants for hardware specific CLE/ALE/NCE function
> @@ -278,13 +278,13 @@ struct nand_ecc_ctrl {
>  					   uint8_t *calc_ecc);
>  	int			(*read_page_raw)(struct mtd_info *mtd,
>  						 struct nand_chip *chip,
> -						 uint8_t *buf);
> +						 uint8_t *buf, int page);
>  	void			(*write_page_raw)(struct mtd_info *mtd,
>  						  struct nand_chip *chip,
>  						  const uint8_t *buf);
>  	int			(*read_page)(struct mtd_info *mtd,
>  					     struct nand_chip *chip,
> -					     uint8_t *buf);
> +					     uint8_t *buf, int page);
>  	int			(*read_subpage)(struct mtd_info *mtd,
>  					     struct nand_chip *chip,
>  					     uint32_t offs, uint32_t len,
> -- 
> 1.6.0.4
> 

