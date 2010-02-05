Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116Ab0BECU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 21:20:57 -0500
Received: from mail.windriver.com ([147.11.1.11]:65457 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab0BECU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 21:20:56 -0500
Message-ID: <4B6B81AD.40704@windriver.com>
Date: Fri, 05 Feb 2010 10:25:49 +0800
From: "stanley.miao" <stanley.miao@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>, Alex Dubov <oakad@yahoo.com>,
       Artem Bityutskiy <dedekind1@gmail.com>, joern <joern@logfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 11/17] MTD: nand: fix bug that prevented write of more
 that	one page by ->write_oob
References: <1265326257-4446-1-git-send-email-maximlevitsky@gmail.com> <1265326257-4446-12-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1265326257-4446-12-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Feb 2010 02:19:32.0425 (UTC) FILETIME=[A73DEB90:01CAA609]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ops->ooblen is the oob bytes to write, you add a argument for 
nand_fill_oob to do this,
it is redundant.

I know the bug you want to fix, the ops->ooblen may be illegal. But this 
patch can't this
problem. If (ops->offset + ops->ooblen) > mtd->oobsize, it still will 
write beyond a page.

I think the right method is that nand_do_write_ops do the check like 
nand_do_write_oob,
I have the patch yesterday.

http://patchwork.ozlabs.org/patch/44450/

Stanley.

Maxim Levitsky wrote:
> Although nand_do_write_ops intends to allow such mode, it fails do do so
> Probably this was never tested
>
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>  drivers/mtd/nand/nand_base.c |   16 +++++++++-------
>  1 files changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> index 8ff36be..29e986e 100644
> --- a/drivers/mtd/nand/nand_base.c
> +++ b/drivers/mtd/nand/nand_base.c
> @@ -1879,11 +1879,9 @@ static int nand_write_page(struct mtd_info *mtd, struct nand_chip *chip,
>   * @oob:	oob data buffer
>   * @ops:	oob ops structure
>   */
> -static uint8_t *nand_fill_oob(struct nand_chip *chip, uint8_t *oob,
> -				  struct mtd_oob_ops *ops)
> +static uint8_t *nand_fill_oob(struct nand_chip *chip, uint8_t *oob, size_t len,
> +						struct mtd_oob_ops *ops)
>   

ops->ooblen is the oob bytes to write, you add a prara

>  {
> -	size_t len = ops->ooblen;
> -
>  	switch(ops->mode) {
>  
>  	case MTD_OOB_PLACE:
> @@ -1938,6 +1936,7 @@ static int nand_do_write_ops(struct mtd_info *mtd, loff_t to,
>  	int chipnr, realpage, page, blockmask, column;
>  	struct nand_chip *chip = mtd->priv;
>  	uint32_t writelen = ops->len;
> +	uint32_t oobwritelen = ops->ooblen;
>  	uint8_t *oob = ops->oobbuf;
>  	uint8_t *buf = ops->datbuf;
>  	int ret, subpage;
> @@ -1994,8 +1993,11 @@ static int nand_do_write_ops(struct mtd_info *mtd, loff_t to,
>  			wbuf = chip->buffers->databuf;
>  		}
>  
> -		if (unlikely(oob))
> -			oob = nand_fill_oob(chip, oob, ops);
> +		if (unlikely(oob)) {
> +			size_t len = min(oobwritelen, mtd->oobsize);
> +			oob = nand_fill_oob(chip, oob, len, ops);
> +			oobwritelen -= len;
> +		}
>  
>  		ret = chip->write_page(mtd, chip, wbuf, page, cached,
>  				       (ops->mode == MTD_OOB_RAW));
> @@ -2169,7 +2171,7 @@ static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
>  		chip->pagebuf = -1;
>  
>  	memset(chip->oob_poi, 0xff, mtd->oobsize);
> -	nand_fill_oob(chip, ops->oobbuf, ops);
> +	nand_fill_oob(chip, ops->oobbuf, ops->ooblen, ops);
>  	status = chip->ecc.write_oob(mtd, chip, page & chip->pagemask);
>  	memset(chip->oob_poi, 0xff, mtd->oobsize);
>  
>   

