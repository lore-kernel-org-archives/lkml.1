Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbZCCUu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbZCCUu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 15:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbZCCUuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 15:50:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752366AbZCCUuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 15:50:19 -0500
Date: Tue, 3 Mar 2009 12:49:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rohit Hagargundgi <h.rohit@samsung.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       h.rohit@samsung.com
Subject: Re: [PATCH 1/3] [MTD] Flex-OneNAND support
Message-Id: <20090303124948.dda294e5.akpm@linux-foundation.org>
In-Reply-To: <20090303063605.GA30258@july>
References: <20090303063605.GA30258@july>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Mar 2009 15:36:05 +0900
Rohit Hagargundgi <h.rohit@samsung.com> wrote:

> This is a repost of the Flex-OneNAND devices support.
> Changes since the last post:
>  - Fix bug which caused 2X program in OneNAND to fail.
>  - Fix bug with eraseregions containing odd number of blocks.
>  - Add routine to check blocks are erased before changing boundary.

"changes since last post" is not interesting information in the
mainline git commit, so I habitually delete it.

After that, we end up without any useful changelog at all.  Is that
really optimal?

> ---
>  drivers/mtd/onenand/Kconfig        |   62 +++
>  drivers/mtd/onenand/onenand_base.c |  827 ++++++++++++++++++++++++++++++++----
>  drivers/mtd/onenand/onenand_bbt.c  |   13 +-
>  drivers/mtd/onenand/onenand_sim.c  |   76 +++-
>  include/linux/mtd/onenand.h        |   41 ++
>  include/linux/mtd/onenand_regs.h   |   20 +-
>  6 files changed, 950 insertions(+), 89 deletions(-)
> 
> diff --git a/drivers/mtd/onenand/Kconfig b/drivers/mtd/onenand/Kconfig
> index 79fa79e..0c8fa54 100644
> --- a/drivers/mtd/onenand/Kconfig
> +++ b/drivers/mtd/onenand/Kconfig
> @@ -71,4 +71,66 @@ config MTD_ONENAND_SIM
>  	  The simulator may simulate various OneNAND flash chips for the
>  	  OneNAND MTD layer.
>  
> +config MTD_FLEXONENAND_BOUNDARY
> +	bool "Flex-OneNAND Boundary Configuration"
> +	depends on MTD_ONENAND
> +	default n
> +	help
> +	  Set SLC and MLC regions of Flex-OneNAND
> +
> +config MTD_FLEXONENAND_DIE0_BOUNDARY
> +	int "Last SLC Block of Flex-OneNAND (min = 0, max = 1023)"
> +	depends on MTD_ONENAND && MTD_FLEXONENAND_BOUNDARY
> +	default "-1"
> +	help
> +	  Configure Partition Information (PI) of Flex-OneNAND
> +
> +	  Entered value indicates index of last SLC block on Flex-OneNAND.
> +	  The remaining blocks are configured as MLC blocks.
> +
> +	  A value of -1 means that PI remains unchanged.
> +
> +	  This setting applies to :
> +		- SDP Flex-OneNAND
> +		- Die 1 of DDP Flex-OneNAND.
> +
> +config MTD_FLEXONENAND_DIE0_ISLOCKED
> +	bool "Lock Boundary of Flex-OneNAND"
> +	depends on MTD_ONENAND && MTD_FLEXONENAND_BOUNDARY
> +	default n
> +	help
> +	  Configure if Flex-OneNAND boundary should be locked.
> +	  Once locked, the boundary cannot be changed.
> +
> +	  This setting applies to :
> +		- SDP Flex-OneNAND
> +		- Die 1 of DDP Flex-OneNAND
> +
> +config MTD_FLEXONENAND_DDP_BOUNDARY
> +	bool "Flex-OneNAND DDP Boundary Configuration"
> +	depends on MTD_ONENAND && MTD_FLEXONENAND_BOUNDARY
> +	default n
> +	help
> +	  Set SLC and MLC regions of Die 2 of Flex-OneNAND DDP
> +
> +config MTD_FLEXONENAND_DIE1_BOUNDARY
> +	int "Last SLC Block of Flex-OneNAND Die 2 (min = 0, max = 1023)"
> +	depends on MTD_ONENAND && MTD_FLEXONENAND_BOUNDARY && MTD_FLEXONENAND_DDP_BOUNDARY
> +	default "-1"
> +	help
> +	  Configure Partition Information (PI) for Die 2 of DDP Flex-OneNAND.
> +
> +	  Entered value indicates index of last SLC block on Flex-OneNAND.
> +	  The remaining blocks are configured as MLC blocks.
> +
> +	  A value of -1 means that PI remains unchanged.
> +
> +config MTD_FLEXONENAND_DIE1_ISLOCKED
> +	bool "Lock Boundary of Flex-OneNAND Die 2"
> +	depends on MTD_ONENAND && MTD_FLEXONENAND_BOUNDARY && MTD_FLEXONENAND_DDP_BOUNDARY
> +	default n
> +	help
> +	  Configure if boundary for Die 2 of DDP Flex-OneNAND should be locked.
> +	  Once locked, the boundary cannot be changed.

This looks quite user-unfriendly to me.  People will need to rebuild
their kernel (or request a new one from their provider) just to alter
some obscure MTD option.

It is about 100000000000 times better for people to be able to compile
or distribute a single kernel image, and for the users of those kernels
to be able to select options at boot-time or at runtime.

Can that be done here?

>
> ...
>
> +static loff_t flexonenand_get_addr(struct onenand_chip *this, int block)
> +{
> +	loff_t ofs = 0;
> +	int die = 0, boundary;
> +
> +	if (ONENAND_IS_DDP(this) && block >= this->density_mask) {
> +		block -= this->density_mask;
> +		die = 1;
> +		ofs = this->diesize[0];
> +	}
> +
> +	boundary = this->boundary[die];
> +	ofs += block << (this->erase_shift - 1);
> +	if (block > (boundary + 1))
> +		ofs += (block - boundary - 1) << (this->erase_shift - 1);

Both `block' and `boundary' have 32-bit types.  Are you sure that the
left-shift cannot overflow?

> +	return ofs;
> +}
> +
> +inline loff_t onenand_get_addr(struct onenand_chip *this, int block)
> +{
> +	if (!FLEXONENAND(this))
> +		return block << this->erase_shift;

Ditto.

> +	return flexonenand_get_addr(this, block);
> +}
> +
>
> ...
>
> +static inline int onenand_read_ecc(struct onenand_chip *this)
> +{
> +	int ecc, i, result = 0;
> +
> +	if (!FLEXONENAND(this))
> +		return this->read_word(this->base + ONENAND_REG_ECC_STATUS);
> +
> +	for (i = 0; i < 4; i++) {
> +		ecc = this->read_word(this->base + ONENAND_REG_ECC_STATUS + i);
> +		if (likely(!ecc))
> +			continue;
> +		if (ecc & FLEXONENAND_UNCORRECTABLE_ERROR)
> +			return ONENAND_ECC_2BIT_ALL;
> +		else
> +			result = ONENAND_ECC_1BIT_ALL;
> +	}
> +
> +	return result;
> +}

This patch does too much manual inlining.  THis function in particular
(which has two callsites) is waaaaaaaay too large to be inlined.

>
> ...
>
> +static int onenand_mlc_read_ops_nolock(struct mtd_info *mtd, loff_t from,
> +				struct mtd_oob_ops *ops)
> +{
> +	struct onenand_chip *this = mtd->priv;
> +	struct mtd_ecc_stats stats;
> +	size_t len = ops->len;
> +	size_t ooblen = ops->ooblen;
> +	u_char *buf = ops->datbuf;
> +	u_char *oobbuf = ops->oobbuf;
> +	int read = 0, column, thislen;
> +	int oobread = 0, oobcolumn, thisooblen, oobsize;
> +	int ret = 0;
> +	int writesize = this->writesize;
> +
> +	DEBUG(MTD_DEBUG_LEVEL3, "onenand_mlc_read_ops_nolock: from = 0x%08x, len = %i\n", (unsigned int) from, (int) len);
> +
> +	if (ops->mode == MTD_OOB_AUTO)
> +		oobsize = this->ecclayout->oobavail;
> +	else
> +		oobsize = mtd->oobsize;
> +
> +	oobcolumn = from & (mtd->oobsize - 1);
> +
> +	/* Do not allow reads past end of device */
> +	if (from + len > mtd->size) {
> +		printk(KERN_ERR "onenand_mlc_read_ops_nolock: Attempt read beyond end of device\n");
> +		ops->retlen = 0;
> +		ops->oobretlen = 0;
> +		return -EINVAL;
> +	}
> +
> +	stats = mtd->ecc_stats;
> +
> +	while (read < len) {
> +		cond_resched();
> +
> +		thislen = min_t(int, writesize, len - read);

Use of min_t is often a sign that the types are wrong.

`len' and `read' should have type size_t.  Probably other things should
be size_t as well.

> +		column = from & (writesize - 1);
> +		if (column + thislen > writesize)
> +			thislen = writesize - column;
> +
> +		if (!onenand_check_bufferram(mtd, from)) {
> +			this->command(mtd, ONENAND_CMD_READ, from, writesize);
> +
> +			ret = this->wait(mtd, FL_READING);
> +			if (unlikely(ret))
> +				ret = onenand_recover_lsb(mtd, from, ret);
> +			onenand_update_bufferram(mtd, from, !ret);
> +			if (ret == -EBADMSG)
> +				ret = 0;
> +		}
> +
> +		this->read_bufferram(mtd, ONENAND_DATARAM, buf, column, thislen);
> +		if (oobbuf) {
> +			thisooblen = oobsize - oobcolumn;
> +			thisooblen = min_t(int, thisooblen, ooblen - oobread);
> +
> +			if (ops->mode == MTD_OOB_AUTO)
> +				onenand_transfer_auto_oob(mtd, oobbuf, oobcolumn, thisooblen);
> +			else
> +				this->read_bufferram(mtd, ONENAND_SPARERAM, oobbuf, oobcolumn, thisooblen);
> +			oobread += thisooblen;
> +			oobbuf += thisooblen;
> +			oobcolumn = 0;
> +		}
> +
> +		read += thislen;
> +		if (read == len)
> +			break;
> +
> +		from += thislen;
> +		buf += thislen;
> +	}
> +
> +	/*
> +	 * Return success, if no ECC failures, else -EBADMSG
> +	 * fs driver will take care of that, because
> +	 * retlen == desired len and result == -EBADMSG
> +	 */
> +	ops->retlen = read;
> +	ops->oobretlen = oobread;
> +
> +	if (ret)
> +		return ret;
> +
> +	if (mtd->ecc_stats.failed - stats.failed)
> +		return -EBADMSG;
> +
> +	return mtd->ecc_stats.corrected - stats.corrected ? -EUCLEAN : 0;
> +}

I wonder what the heck EUCLEAN was invented for and whether MTD's
extensive use of it is appropriate.

>
> ...
>
> --- a/include/linux/mtd/onenand.h
> +++ b/include/linux/mtd/onenand.h
> @@ -17,8 +17,32 @@
>  #include <linux/mtd/onenand_regs.h>
>  #include <linux/mtd/bbm.h>
>  
> +#define MAX_DIES		2
>  #define MAX_BUFFERRAM		2
>  
> +#if defined CONFIG_MTD_FLEXONENAND_DIE0_BOUNDARY

Plain old `#ifdef' is more common.

> +#define FLEXONENAND_DIE0_BOUNDARY	CONFIG_MTD_FLEXONENAND_DIE0_BOUNDARY
> +#else
> +#define FLEXONENAND_DIE0_BOUNDARY	-1
> +#endif
> +
> +#if defined CONFIG_MTD_FLEXONENAND_DIE1_BOUNDARY
> +#define FLEXONENAND_DIE1_BOUNDARY	CONFIG_MTD_FLEXONENAND_DIE1_BOUNDARY
> +#else
> +#define FLEXONENAND_DIE1_BOUNDARY	-1
> +#endif
> +
> +#if defined CONFIG_MTD_FLEXONENAND_DIE0_ISLOCKED
> +#define FLEXONENAND_DIE0_ISLOCKED	1
> +#else
> +#define FLEXONENAND_DIE0_ISLOCKED	0
> +#endif
> +#if defined CONFIG_MTD_FLEXONENAND_DIE1_ISLOCKED
> +#define FLEXONENAND_DIE1_ISLOCKED	1
> +#else
> +#define FLEXONENAND_DIE1_ISLOCKED	0
> +#endif
> +
>
> ...
>
> +#define ONENAND_IS_MLC(this)						\
> +	(this->technology & ONENAND_TECHNOLOGY_IS_MLC)

hm, I wonder why all these things were implemented as macros.

>
> ...
>

