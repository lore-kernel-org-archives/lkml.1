Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693Ab0BECnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 21:43:10 -0500
Received: from mail.windriver.com ([147.11.1.11]:36014 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933263Ab0BECnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 21:43:08 -0500
Message-ID: <4B6B86EE.5050803@windriver.com>
Date: Fri, 05 Feb 2010 10:48:14 +0800
From: "stanley.miao" <stanley.miao@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>, Alex Dubov <oakad@yahoo.com>,
       Artem Bityutskiy <dedekind1@gmail.com>, joern <joern@logfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 10/17] MTD: nand: make reads using MTD_OOB_RAW affect
 only ECC	validation
References: <1265326257-4446-1-git-send-email-maximlevitsky@gmail.com> <1265326257-4446-11-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1265326257-4446-11-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Feb 2010 02:41:58.0996 (UTC) FILETIME=[C9DC5940:01CAA60C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Levitsky wrote:
> This changes the behavier of MTD_OOB_RAW. It used to read both OOB and data
> to the data buffer, however you would still need to specify the dummy oob buffer.
>
> This is only used in one place, but makes it hard to read data+oob without ECC
> test, thus I removed that behavier, and fixed the user.
>
> Now MTD_OOB_RAW behaves like MTD_OOB_PLACE, but doesn't do ECC validation
>
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>  drivers/mtd/nand/nand_base.c |    5 -----
>  drivers/mtd/nand/nand_bbt.c  |   26 ++++++++++++++++++++++----
>  include/linux/mtd/mtd.h      |    4 +---
>  3 files changed, 23 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> index 405c538..8ff36be 100644
> --- a/drivers/mtd/nand/nand_base.c
> +++ b/drivers/mtd/nand/nand_base.c
> @@ -1286,8 +1286,6 @@ static int nand_do_read_ops(struct mtd_info *mtd, loff_t from,
>  
>  			if (unlikely(oob)) {
>  
> -				/* Raw mode does data:oob:data:oob */
> -				if (ops->mode != MTD_OOB_RAW) {
>   

I am not sure if it is legal to modify the behavior of MTD_OOB_RAW. But 
if you
remove the "if" command, the following code should be indent again.

Stanley.

>  					int toread = min(oobreadlen,
>  								max_oobsize);
>  					if (toread) {
> @@ -1295,9 +1293,6 @@ static int nand_do_read_ops(struct mtd_info *mtd, loff_t from,
>  							oob, ops, toread);
>  						oobreadlen -= toread;
>  					}
> -				} else
> -					buf = nand_transfer_oob(chip,
> -						buf, ops, mtd->oobsize);
>  			}
>  
>  			if (!(chip->options & NAND_NO_READRDY)) {
> diff --git a/drivers/mtd/nand/nand_bbt.c b/drivers/mtd/nand/nand_bbt.c
> index 55c23e5..387c45c 100644
> --- a/drivers/mtd/nand/nand_bbt.c
> +++ b/drivers/mtd/nand/nand_bbt.c
> @@ -237,15 +237,33 @@ static int scan_read_raw(struct mtd_info *mtd, uint8_t *buf, loff_t offs,
>  			 size_t len)
>  {
>  	struct mtd_oob_ops ops;
> +	int res;
>  
>  	ops.mode = MTD_OOB_RAW;
>  	ops.ooboffs = 0;
>  	ops.ooblen = mtd->oobsize;
> -	ops.oobbuf = buf;
> -	ops.datbuf = buf;
> -	ops.len = len;
>  
> -	return mtd->read_oob(mtd, offs, &ops);
> +
> +	while (len > 0) {
> +		if (len <= mtd->writesize) {
> +			ops.oobbuf = buf + len;
> +			ops.datbuf = buf;
> +			ops.len = len;
> +			return mtd->read_oob(mtd, offs, &ops);
> +		} else {
> +			ops.oobbuf = buf + mtd->writesize;
> +			ops.datbuf = buf;
> +			ops.len = mtd->writesize;
> +			res = mtd->read_oob(mtd, offs, &ops);
> +
> +			if (res)
> +				return res;
> +		}
> +
> +		buf += mtd->oobsize + mtd->writesize;
> +		len -= mtd->writesize;
> +	}
> +	return 0;
>  }
>  
>  /*
> diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
> index 662d747..84bb375 100644
> --- a/include/linux/mtd/mtd.h
> +++ b/include/linux/mtd/mtd.h
> @@ -61,9 +61,7 @@ struct mtd_erase_region_info {
>   * MTD_OOB_PLACE:	oob data are placed at the given offset
>   * MTD_OOB_AUTO:	oob data are automatically placed at the free areas
>   *			which are defined by the ecclayout
> - * MTD_OOB_RAW:		mode to read raw data+oob in one chunk. The oob data
> - *			is inserted into the data. Thats a raw image of the
> - *			flash contents.
> + * MTD_OOB_RAW:		mode to read oob and data without doing ECC checking
>   */
>  typedef enum {
>  	MTD_OOB_PLACE,
>   

