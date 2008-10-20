Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113AbYJTDBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbYJTDBq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 23:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbYJTDBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 23:01:37 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:45156 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbYJTDBe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 23:01:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=b+0Nk7JA3kQUEcPrUTS3BI05yAqfZTZHp1UhbPH+0FppjRTbPdH3W0OwWSxMempYVK
         IZRl0iBExh/4Ao8O6yAZya1v5Nh9SYe+rKUERylRouip7vK0bp7FEgWJm02sWLUsyfZI
         HPnYCS5ZWOLMG5TuF38IB62WdQCFT8Jb36hcw=
Message-ID: <9c9fda240810192001n73da2133gae48bc4472b65fc3@mail.gmail.com>
Date: Mon, 20 Oct 2008 12:01:32 +0900
From: "Kyungmin Park" <kmpark@infradead.org>
To: apgmoorthy <moorthy.apg@samsung.com>, dwmw2@infradead.org
Subject: Re: [ANNOUNCE] [PATCH] [MTD] Flex-OneNAND MTD Driver available
Cc: linux-mtd@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <000001c92f46$18a67c70$3dd66c6b@sisodomain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <000001c92f46$18a67c70$3dd66c6b@sisodomain.com>
X-Google-Sender-Auth: 63fff88cad91d266
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

This mail has updated patch.

Thank you,
Kyungmin Park

On Thu, Oct 16, 2008 at 1:16 PM, apgmoorthy <moorthy.apg@samsung.com> wrote:
>
> Hi,
>
> Kyungmin Park Wrote :
>
>>> +const static int boundary[] = {
>>> +       FLEXONENAND_DIE0_BOUNDARY,
>>> +       FLEXONENAND_DIE1_BOUNDARY,
>>> +};
>>> +
>>> +const static int lock[] = {
>>> +       FLEXONENAND_DIE0_ISLOCKED,
>>> +       FLEXONENAND_DIE1_ISLOCKED,
>>> +};
>>> +
>
>>static const as others.
>
>          - Taken care
>
>
>>> diff -uprN a/include/mtd/mtd-abi.h b/include/mtd/mtd-abi.h
>>> --- a/include/mtd/mtd-abi.h     2008-09-16 20:48:12.000000000 +0530
>>> +++ b/include/mtd/mtd-abi.h     2008-09-24 14:09:06.000000000 +0530
>>> @@ -102,7 +102,11 @@ struct nand_oobinfo {
>>>        uint32_t useecc;
>>>        uint32_t eccbytes;
>>>        uint32_t oobfree[8][2];
>>> +#ifdef CONFIG_MTD_ONENAND
>>> +       uint32_t eccpos[128];
>>> +#else
>>>        uint32_t eccpos[32];
>>> +#endif
>>>  };
>>>  struct nand_oobfree {
>>> @@ -117,7 +121,11 @@ struct nand_oobfree {
>>>  */
>>>  struct nand_ecclayout {
>>>        uint32_t eccbytes;
>>> +#ifdef CONFIG_MTD_ONENAND
>>> +       uint32_t eccpos[128];
>>> +#else
>>>        uint32_t eccpos[64];
>>> +#endif
>>>        uint32_t oobavail;
>>>        struct nand_oobfree oobfree[MTD_MAX_OOBFREE_ENTRIES];
>>>  };
>
>> This patch is already included others. Please remove it at this patch.
>
>        - Removed
>
>
> Please find the updated patch
>
> Signed-off-by: Vishak G <vishak.g@samsung.com>
> Signed-off-by: Rohit Hagargundgi <h.rohit@samsung.com>
> ---
>  drivers/mtd/onenand/onenand_base.c |  599
> ++++++++++++++++++++++++++++++++----
>  drivers/mtd/onenand/onenand_bbt.c  |   15 +-
>  drivers/mtd/onenand/onenand_sim.c  |  105 ++++++-
>  include/linux/mtd/onenand.h        |   33 ++
>  include/linux/mtd/onenand_regs.h   |   19 +-
>  5 files changed, 694 insertions(+), 77 deletions(-)
>
> diff --git a/drivers/mtd/onenand/onenand_base.c
> b/drivers/mtd/onenand/onenand_base.c
> index 90ed319..325a0f0 100644
> --- a/drivers/mtd/onenand/onenand_base.c
> +++ b/drivers/mtd/onenand/onenand_base.c
> @@ -9,6 +9,10 @@
>  *     auto-placement support, read-while load support, various fixes
>  *     Copyright (C) Nokia Corporation, 2007
>  *
> + *     Vishak G <vishak.g@samsung.com>, Rohit Hagargundgi
> <h.rohit@samsung.com>
> + *     Flex-OneNAND support
> + *     Copyright (C) Samsung Electronics, 2008
> + *
>  * This program is free software; you can redistribute it and/or modify
>  * it under the terms of the GNU General Public License version 2 as
>  * published by the Free Software Foundation.
> @@ -27,6 +31,37 @@
>
>  #include <asm/io.h>
>
> +static const int boundary[] = {
> +       FLEXONENAND_DIE0_BOUNDARY,
> +       FLEXONENAND_DIE1_BOUNDARY,
> +};
> +
> +static const int lock[] = {
> +       FLEXONENAND_DIE0_ISLOCKED,
> +       FLEXONENAND_DIE1_ISLOCKED,
> +};
> +
> +/**
> + *  onenand_oob_128 - oob info for Flex-Onenand with 4KB page
> + *  For now, we expose only 64 out of 80 ecc bytes
> + */
> +static struct nand_ecclayout onenand_oob_128 = {
> +       .eccbytes       = 64,
> +       .eccpos         = {
> +               6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
> +               22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
> +               38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
> +               54, 55, 56, 57, 58, 59, 60, 61, 62, 63,
> +               70, 71, 72, 73, 74, 75, 76, 77, 78, 79,
> +               86, 87, 88, 89, 90, 91, 92, 93, 94, 95,
> +               102, 103, 104, 105
> +               },
> +       .oobfree        = {
> +               {2, 4}, {18, 4}, {34, 4}, {50, 4},
> +               {66, 4}, {82, 4}, {98, 4}, {114, 4}
> +       }
> +};
> +
>  /**
>  * onenand_oob_64 - oob info for large (2KB) page
>  */
> @@ -65,6 +100,14 @@ static const unsigned char ffchars[] = {
>        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, /* 48 */
>        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
>        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, /* 64 */
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, /* 80 */
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, /* 96 */
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, /* 112 */
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> +       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, /* 128 */
>  };
>
>  /**
> @@ -171,6 +214,47 @@ static int onenand_buffer_address(int dataram1, int
> sectors, int count)
>  }
>
>  /**
> + * onenand_get_block   - For given address return block number and if slc
> + * @param mtd          - MTD device structure
> + * @param addr         - Address for which block number is needed
> + * @return isblkslc    - Block is an SLC block or not
> + */
> +unsigned onenand_get_block(struct mtd_info *mtd, loff_t addr,
> +                          unsigned *isblkslc)
> +{
> +       struct onenand_chip *this = mtd->priv;
> +       unsigned boundary, blk, die = 0;
> +
> +       if (!FLEXONENAND(this))
> +               return addr >> this->erase_shift;
> +
> +       if (this->chipsize == 0) {
> +               /* We have been called by flexonenand_get_boundary.
> +                * addr contains die index in this case.
> +                */
> +               blk = addr * this->density_mask;
> +               return blk;
> +       }
> +
> +       if (addr >= this->diesize[0]) {
> +               die = 1;
> +               addr -= this->diesize[0];
> +       }
> +
> +       boundary = this->boundary[die];
> +
> +       blk = addr >> (this->erase_shift - 1);
> +       if (blk > boundary)
> +               blk = (blk + boundary + 1) >> 1;
> +
> +       if (isblkslc)
> +               *isblkslc = (blk <= boundary) ? 1 : 0;
> +
> +       blk += die ? this->density_mask : 0;
> +       return blk;
> +}
> +
> +/**
>  * onenand_get_density - [DEFAULT] Get OneNAND density
>  * @param dev_id       OneNAND device ID
>  *
> @@ -196,6 +280,7 @@ static int onenand_command(struct mtd_info *mtd, int
> cmd, loff_t addr, size_t le
>  {
>        struct onenand_chip *this = mtd->priv;
>        int value, block, page;
> +       unsigned slc = 0;
>
>        /* Address translation */
>        switch (cmd) {
> @@ -207,15 +292,16 @@ static int onenand_command(struct mtd_info *mtd, int
> cmd, loff_t addr, size_t le
>                page = -1;
>                break;
>
> +       case FLEXONENAND_CMD_PI_ACCESS:
>        case ONENAND_CMD_ERASE:
>        case ONENAND_CMD_BUFFERRAM:
>        case ONENAND_CMD_OTP_ACCESS:
> -               block = (int) (addr >> this->erase_shift);
> +               block = onenand_get_block(mtd, addr, NULL);
>                page = -1;
>                break;
>
>        default:
> -               block = (int) (addr >> this->erase_shift);
> +               block = onenand_get_block(mtd, addr, &slc);
>                page = (int) (addr >> this->page_shift);
>
>                if (ONENAND_IS_2PLANE(this)) {
> @@ -227,6 +313,8 @@ static int onenand_command(struct mtd_info *mtd, int
> cmd, loff_t addr, size_t le
>                        page >>= 1;
>                }
>                page &= this->page_mask;
> +               if (FLEXONENAND(this) && slc)
> +                       page &= (this->page_mask >> 1);
>                break;
>        }
>
> @@ -236,7 +324,7 @@ static int onenand_command(struct mtd_info *mtd, int
> cmd, loff_t addr, size_t le
>                value = onenand_bufferram_address(this, block);
>                this->write_word(value, this->base +
> ONENAND_REG_START_ADDRESS2);
>
> -               if (ONENAND_IS_2PLANE(this))
> +               if (ONENAND_IS_MLC(this) || ONENAND_IS_2PLANE(this))
>                        /* It is always BufferRAM0 */
>                        ONENAND_SET_BUFFERRAM0(this);
>                else
> @@ -258,13 +346,18 @@ static int onenand_command(struct mtd_info *mtd, int
> cmd, loff_t addr, size_t le
>
>        if (page != -1) {
>                /* Now we use page size operation */
> -               int sectors = 4, count = 4;
> +               int sectors = 0, count = 0;
>                int dataram;
>
>                switch (cmd) {
> +               case FLEXONENAND_CMD_RECOVER_LSB:
>                case ONENAND_CMD_READ:
>                case ONENAND_CMD_READOOB:
> -                       dataram = ONENAND_SET_NEXT_BUFFERRAM(this);
> +                       if (ONENAND_IS_MLC(this))
> +                               /* It is always BufferRAM0 */
> +                               dataram = ONENAND_SET_BUFFERRAM0(this);
> +                       else
> +                               dataram = ONENAND_SET_NEXT_BUFFERRAM(this);
>                        break;
>
>                default:
> @@ -293,6 +386,31 @@ static int onenand_command(struct mtd_info *mtd, int
> cmd, loff_t addr, size_t le
>  }
>
>  /**
> + * onenand_read_ecc - return ecc status
> + * @param mtd          MTD device structure
> + */
> +int onenand_read_ecc(struct mtd_info *mtd)
> +{
> +       struct onenand_chip *this = mtd->priv;
> +       int ecc[4];
> +       int i, result = 0;
> +
> +       for (i = 0; i < 4; i++) {
> +               ecc[i] = this->read_word(this->base +
> +                                        (ONENAND_REG_ECC_STATUS + i));
> +               if (!FLEXONENAND(this))
> +                       return ecc[i];
> +               if (ecc[i] & FLEXONENAND_UNCORRECTABLE_ERROR) {
> +                       result = ONENAND_ECC_2BIT_ALL;
> +                       break;
> +               } else if (ecc[i])
> +                       result = ONENAND_ECC_1BIT_ALL;
> +       }
> +
> +       return result;
> +}
> +
> +/**
>  * onenand_wait - [DEFAULT] wait until the command is done
>  * @param mtd          MTD device structure
>  * @param state                state to select the max. timeout value
> @@ -331,7 +449,7 @@ static int onenand_wait(struct mtd_info *mtd, int state)
>         * power off recovery (POR) test, it should read ECC status first
>         */
>        if (interrupt & ONENAND_INT_READ) {
> -               int ecc = this->read_word(this->base +
> ONENAND_REG_ECC_STATUS);
> +               int ecc = onenand_read_ecc(mtd);
>                if (ecc) {
>                        if (ecc & ONENAND_ECC_2BIT_ALL) {
>                                printk(KERN_ERR "onenand_wait: ECC error =
> 0x%04x\n", ecc);
> @@ -656,7 +774,7 @@ static int onenand_check_bufferram(struct mtd_info *mtd,
> loff_t addr)
>
>        if (found && ONENAND_IS_DDP(this)) {
>                /* Select DataRAM for DDP */
> -               int block = (int) (addr >> this->erase_shift);
> +               int block = onenand_get_block(mtd, addr, NULL);
>                int value = onenand_bufferram_address(this, block);
>                this->write_word(value, this->base +
> ONENAND_REG_START_ADDRESS2);
>        }
> @@ -816,6 +934,43 @@ static int onenand_transfer_auto_oob(struct mtd_info
> *mtd, uint8_t *buf, int col
>  }
>
>  /**
> + * onenand_recover_lsb - [Flex-OneNAND] Recover LSB page data
> + * @param mtd          MTD device structure
> + * @param addr         address to recover
> + * @param status       return value from onenand_wait / onenand_bbt_wait
> + *
> + * Issue recovery command when read fails on MLC area.
> + */
> +static int onenand_recover_lsb(struct mtd_info *mtd, loff_t addr, int
> status)
> +{
> +       struct onenand_chip *this = mtd->priv;
> +       unsigned slc = 0;
> +
> +       /* Recovery is only for Flex-OneNAND */
> +       if (!FLEXONENAND(this))
> +               return status;
> +
> +       /* check if we failed due to uncorrectable error */
> +       if (status != (-EBADMSG) && status != (ONENAND_BBT_READ_ECC_ERROR))
> +               return status;
> +
> +       /* check if address lies in MLC region */
> +       onenand_get_block(mtd, addr, &slc);
> +       if (slc)
> +               return status;
> +
> +       /* We are attempting to reread, so decrement stats.failed
> +        * which was incremented by onenand_wait due to read failure
> +        */
> +       printk(KERN_DEBUG "Attempting to recover from uncorrectable
> read\n");
> +       mtd->ecc_stats.failed--;
> +
> +       /* Issue the LSB page recovery command */
> +       this->command(mtd, FLEXONENAND_CMD_RECOVER_LSB, addr,
> this->writesize);
> +       return this->wait(mtd, FL_READING);
> +}
> +
> +/**
>  * onenand_read_ops_nolock - [OneNAND Interface] OneNAND read main and/or
> out-of-band
>  * @param mtd          MTD device structure
>  * @param from         offset to read from
> @@ -857,12 +1012,14 @@ static int onenand_read_ops_nolock(struct mtd_info
> *mtd, loff_t from,
>        stats = mtd->ecc_stats;
>
>        /* Read-while-load method */
> +       /* Note: We can't use this feature in MLC */
>
>        /* Do first load to bufferRAM */
>        if (read < len) {
>                if (!onenand_check_bufferram(mtd, from)) {
>                        this->command(mtd, ONENAND_CMD_READ, from,
> writesize);
>                        ret = this->wait(mtd, FL_READING);
> +                       ret = ret ? onenand_recover_lsb(mtd, from, ret) :
> ret;
>                        onenand_update_bufferram(mtd, from, !ret);
>                        if (ret == -EBADMSG)
>                                ret = 0;
> @@ -877,7 +1034,7 @@ static int onenand_read_ops_nolock(struct mtd_info
> *mtd, loff_t from,
>        while (!ret) {
>                /* If there is more to load then start next load */
>                from += thislen;
> -               if (read + thislen < len) {
> +               if (!ONENAND_IS_MLC(this) && read + thislen < len) {
>                        this->command(mtd, ONENAND_CMD_READ, from,
> writesize);
>                        /*
>                         * Chip boundary handling in DDP
> @@ -909,6 +1066,15 @@ static int onenand_read_ops_nolock(struct mtd_info
> *mtd, loff_t from,
>                        oobcolumn = 0;
>                }
>
> +               if (ONENAND_IS_MLC(this) && (read + thislen < len)) {
> +                       this->command(mtd, ONENAND_CMD_READ, from,
> writesize);
> +                       ret = this->wait(mtd, FL_READING);
> +                       ret = ret ? onenand_recover_lsb(mtd, from, ret) :
> ret;
> +                       onenand_update_bufferram(mtd, from, !ret);
> +                       if (ret == -EBADMSG)
> +                               ret = 0;
> +               }
> +
>                /* See if we are done */
>                read += thislen;
>                if (read == len)
> @@ -916,16 +1082,19 @@ static int onenand_read_ops_nolock(struct mtd_info
> *mtd, loff_t from,
>                /* Set up for next read from bufferRAM */
>                if (unlikely(boundary))
>                        this->write_word(ONENAND_DDP_CHIP1, this->base +
> ONENAND_REG_START_ADDRESS2);
> -               ONENAND_SET_NEXT_BUFFERRAM(this);
> +               if (!ONENAND_IS_MLC(this))
> +                       ONENAND_SET_NEXT_BUFFERRAM(this);
>                buf += thislen;
>                thislen = min_t(int, writesize, len - read);
>                column = 0;
>                cond_resched();
> -               /* Now wait for load */
> -               ret = this->wait(mtd, FL_READING);
> -               onenand_update_bufferram(mtd, from, !ret);
> -               if (ret == -EBADMSG)
> -                       ret = 0;
> +               if (!ONENAND_IS_MLC(this)) {
> +                       /* Now wait for load in SLC */
> +                       ret = this->wait(mtd, FL_READING);
> +                       onenand_update_bufferram(mtd, from, !ret);
> +                       if (ret == -EBADMSG)
> +                               ret = 0;
> +               }
>        }
>
>        /*
> @@ -962,7 +1131,7 @@ static int onenand_read_oob_nolock(struct mtd_info
> *mtd, loff_t from,
>        size_t len = ops->ooblen;
>        mtd_oob_mode_t mode = ops->mode;
>        u_char *buf = ops->oobbuf;
> -       int ret = 0;
> +       int ret = 0, readcmd;
>
>        from += ops->ooboffs;
>
> @@ -993,17 +1162,21 @@ static int onenand_read_oob_nolock(struct mtd_info
> *mtd, loff_t from,
>
>        stats = mtd->ecc_stats;
>
> +       readcmd = ONENAND_IS_MLC(this) ? ONENAND_CMD_READ :
> ONENAND_CMD_READOOB;
> +
>        while (read < len) {
>                cond_resched();
>
>                thislen = oobsize - column;
>                thislen = min_t(int, thislen, len);
>
> -               this->command(mtd, ONENAND_CMD_READOOB, from, mtd->oobsize);
> +               this->command(mtd, readcmd, from, mtd->oobsize);
>
>                onenand_update_bufferram(mtd, from, 0);
>
>                ret = this->wait(mtd, FL_READING);
> +               ret = ret ? onenand_recover_lsb(mtd, from, ret) : ret;
> +
>                if (ret && ret != -EBADMSG) {
>                        printk(KERN_ERR "onenand_read_oob_nolock: read
> failed = 0x%x\n", ret);
>                        break;
> @@ -1128,11 +1301,11 @@ static int onenand_bbt_wait(struct mtd_info *mtd,
> int state)
>        ctrl = this->read_word(this->base + ONENAND_REG_CTRL_STATUS);
>
>        if (interrupt & ONENAND_INT_READ) {
> -               int ecc = this->read_word(this->base +
> ONENAND_REG_ECC_STATUS);
> +               int ecc = onenand_read_ecc(mtd);
>                if (ecc & ONENAND_ECC_2BIT_ALL) {
>                        printk(KERN_INFO "onenand_bbt_wait: ecc error =
> 0x%04x"
>                                ", controller error 0x%04x\n", ecc, ctrl);
> -                       return ONENAND_BBT_READ_ERROR;
> +                       return ONENAND_BBT_READ_ECC_ERROR;
>                }
>        } else {
>                printk(KERN_ERR "onenand_bbt_wait: read timeout!"
> @@ -1163,7 +1336,7 @@ int onenand_bbt_read_oob(struct mtd_info *mtd, loff_t
> from,
>  {
>        struct onenand_chip *this = mtd->priv;
>        int read = 0, thislen, column;
> -       int ret = 0;
> +       int ret = 0, readcmd;
>        size_t len = ops->ooblen;
>        u_char *buf = ops->oobbuf;
>
> @@ -1183,17 +1356,21 @@ int onenand_bbt_read_oob(struct mtd_info *mtd,
> loff_t from,
>
>        column = from & (mtd->oobsize - 1);
>
> +       readcmd = ONENAND_IS_MLC(this) ? ONENAND_CMD_READ :
> ONENAND_CMD_READOOB;
> +
>        while (read < len) {
>                cond_resched();
>
>                thislen = mtd->oobsize - column;
>                thislen = min_t(int, thislen, len);
>
> -               this->command(mtd, ONENAND_CMD_READOOB, from, mtd->oobsize);
> +               this->command(mtd, readcmd, from, mtd->oobsize);
>
>                onenand_update_bufferram(mtd, from, 0);
>
>                ret = onenand_bbt_wait(mtd, FL_READING);
> +               ret = ret ? onenand_recover_lsb(mtd, from, ret) : ret;
> +
>                if (ret)
>                        break;
>
> @@ -1230,9 +1407,11 @@ static int onenand_verify_oob(struct mtd_info *mtd,
> const u_char *buf, loff_t to
>  {
>        struct onenand_chip *this = mtd->priv;
>        u_char *oob_buf = this->oob_buf;
> -       int status, i;
> +       int status, i, readcmd;
> +
> +       readcmd = ONENAND_IS_MLC(this) ? ONENAND_CMD_READ :
> ONENAND_CMD_READOOB;
>
> -       this->command(mtd, ONENAND_CMD_READOOB, to, mtd->oobsize);
> +       this->command(mtd, readcmd, to, mtd->oobsize);
>        onenand_update_bufferram(mtd, to, 0);
>        status = this->wait(mtd, FL_READING);
>        if (status)
> @@ -1586,7 +1765,7 @@ static int onenand_write_oob_nolock(struct mtd_info
> *mtd, loff_t to,
>  {
>        struct onenand_chip *this = mtd->priv;
>        int column, ret = 0, oobsize;
> -       int written = 0;
> +       int written = 0, oobcmd;
>        u_char *oobbuf;
>        size_t len = ops->ooblen;
>        const u_char *buf = ops->oobbuf;
> @@ -1628,6 +1807,8 @@ static int onenand_write_oob_nolock(struct mtd_info
> *mtd, loff_t to,
>
>        oobbuf = this->oob_buf;
>
> +       oobcmd = ONENAND_IS_MLC(this) ? ONENAND_CMD_PROG :
> ONENAND_CMD_PROGOOB;
> +
>        /* Loop until all data write */
>        while (written < len) {
>                int thislen = min_t(int, oobsize, len - written);
> @@ -1645,7 +1826,14 @@ static int onenand_write_oob_nolock(struct mtd_info
> *mtd, loff_t to,
>                        memcpy(oobbuf + column, buf, thislen);
>                this->write_bufferram(mtd, ONENAND_SPARERAM, oobbuf, 0,
> mtd->oobsize);
>
> -               this->command(mtd, ONENAND_CMD_PROGOOB, to, mtd->oobsize);
> +               if (ONENAND_IS_MLC(this)) {
> +                       /* Set main area of DataRAM to 0xff*/
> +                       memset(this->page_buf, 0xff, mtd->writesize);
> +                       this->write_bufferram(mtd, ONENAND_DATARAM,
> +                                        this->page_buf, 0, mtd->writesize);
> +               }
> +
> +               this->command(mtd, oobcmd, to, mtd->oobsize);
>
>                onenand_update_bufferram(mtd, to, 0);
>                if (ONENAND_IS_2PLANE(this)) {
> @@ -1770,11 +1958,32 @@ static int onenand_erase(struct mtd_info *mtd,
> struct erase_info *instr)
>        unsigned int block_size;
>        loff_t addr;
>        int len;
> -       int ret = 0;
> +       int ret = 0, i = 0;
>
>        DEBUG(MTD_DEBUG_LEVEL3, "onenand_erase: start = 0x%08x, len = %i\n",
> (unsigned int) instr->addr, (unsigned int) instr->len);
>
> -       block_size = (1 << this->erase_shift);
> +       /* Do not allow erase past end of device */
> +       if (unlikely((instr->len + instr->addr) > mtd->size)) {
> +               printk(KERN_ERR "onenand_erase: Erase past end of
> device\n");
> +               return -EINVAL;
> +       }
> +
> +       if (FLEXONENAND(this) && (mtd->numeraseregions > 1)) {
> +               /* Find the eraseregion of this address */
> +               for (; i < mtd->numeraseregions &&
> +                       instr->addr >= mtd->eraseregions[i].offset; i++)
> +                       ;
> +               i--;
> +               block_size = mtd->eraseregions[i].erasesize;
> +
> +               /* Start address should be aligned on erase region boundary
> */
> +               if (unlikely((instr->addr - mtd->eraseregions[i].offset) &
> +                                                       (block_size - 1))) {
> +                       printk(KERN_ERR "onenand_erase: Unaligned
> address\n");
> +                       return -EINVAL;
> +               }
> +       } else
> +               block_size = mtd->erasesize;
>
>        /* Start address must align on block boundary */
>        if (unlikely(instr->addr & (block_size - 1))) {
> @@ -1788,12 +1997,6 @@ static int onenand_erase(struct mtd_info *mtd, struct
> erase_info *instr)
>                return -EINVAL;
>        }
>
> -       /* Do not allow erase past end of device */
> -       if (unlikely((instr->len + instr->addr) > mtd->size)) {
> -               printk(KERN_ERR "onenand_erase: Erase past end of
> device\n");
> -               return -EINVAL;
> -       }
> -
>        instr->fail_addr = MTD_FAIL_ADDR_UNKNOWN;
>
>        /* Grab the lock and see if the device is available */
> @@ -1822,7 +2025,8 @@ static int onenand_erase(struct mtd_info *mtd, struct
> erase_info *instr)
>                ret = this->wait(mtd, FL_ERASING);
>                /* Check, if it is write protected */
>                if (ret) {
> -                       printk(KERN_ERR "onenand_erase: Failed erase, block
> %d\n", (unsigned) (addr >> this->erase_shift));
> +                       printk(KERN_ERR "onenand_erase: Failed erase, block
> %d\n",
> +                        (unsigned)onenand_get_block(mtd, addr, NULL));
>                        instr->state = MTD_ERASE_FAILED;
>                        instr->fail_addr = addr;
>                        goto erase_exit;
> @@ -1830,6 +2034,19 @@ static int onenand_erase(struct mtd_info *mtd, struct
> erase_info *instr)
>
>                len -= block_size;
>                addr += block_size;
> +               if (FLEXONENAND(this) && (mtd->numeraseregions > 1)) {
> +                       if ((i < (mtd->numeraseregions - 1)) &&
> +                           (addr == mtd->eraseregions[i + 1].offset))
> +                               i++;
> +                       block_size = mtd->eraseregions[i].erasesize;
> +                       if (len & (block_size - 1)) {
> +                               /* This should be handled at MTD
> partitioning
> +                                * level.
> +                                */
> +                               printk(KERN_ERR "onenand_erase: Unaligned
> address\n");
> +                               goto erase_exit;
> +                       }
> +               }
>        }
>
>        instr->state = MTD_ERASE_DONE;
> @@ -1908,13 +2125,17 @@ static int onenand_default_block_markbad(struct
> mtd_info *mtd, loff_t ofs)
>        int block;
>
>        /* Get block number */
> -       block = ((int) ofs) >> bbm->bbt_erase_shift;
> +       block = onenand_get_block(mtd, ofs, NULL);
>         if (bbm->bbt)
>                 bbm->bbt[block >> 2] |= 0x01 << ((block & 0x03) << 1);
>
>         /* We write two bytes, so we dont have to mess with 16 bit access
> */
>         ofs += mtd->oobsize + (bbm->badblockpos & ~0x01);
> -        return onenand_write_oob_nolock(mtd, ofs, &ops);
> +       /* FIXME : What to do when marking SLC block in partition
> +        *         with MLC erasesize? For now, it is not advisable to
> +        *         create partitions containing both SLC and MLC regions.
> +        */
> +       return onenand_write_oob_nolock(mtd, ofs, &ops);
>  }
>
>  /**
> @@ -1958,8 +2179,8 @@ static int onenand_do_lock_cmd(struct mtd_info *mtd,
> loff_t ofs, size_t len, int
>        int start, end, block, value, status;
>        int wp_status_mask;
>
> -       start = ofs >> this->erase_shift;
> -       end = len >> this->erase_shift;
> +       start = onenand_get_block(mtd, ofs, NULL);
> +       end = onenand_get_block(mtd, ofs + len, NULL) - 1;
>
>        if (cmd == ONENAND_CMD_LOCK)
>                wp_status_mask = ONENAND_WP_LS;
> @@ -1971,7 +2192,8 @@ static int onenand_do_lock_cmd(struct mtd_info *mtd,
> loff_t ofs, size_t len, int
>                /* Set start block address */
>                this->write_word(start, this->base +
> ONENAND_REG_START_BLOCK_ADDRESS);
>                /* Set end block address */
> -               this->write_word(start + end - 1, this->base +
> ONENAND_REG_END_BLOCK_ADDRESS);
> +               this->write_word(end, this->base +
> +
> ONENAND_REG_END_BLOCK_ADDRESS);
>                /* Write lock command */
>                this->command(mtd, cmd, 0, 0);
>
> @@ -1992,7 +2214,7 @@ static int onenand_do_lock_cmd(struct mtd_info *mtd,
> loff_t ofs, size_t len, int
>        }
>
>        /* Block lock scheme */
> -       for (block = start; block < start + end; block++) {
> +       for (block = start; block < end + 1; block++) {
>                /* Set block address */
>                value = onenand_block_address(this, block);
>                this->write_word(value, this->base +
> ONENAND_REG_START_ADDRESS1);
> @@ -2086,7 +2308,6 @@ static int onenand_check_lock_status(struct
> onenand_chip *this)
>                        return 0;
>                }
>        }
> -
>        return 1;
>  }
>
> @@ -2100,7 +2321,8 @@ static void onenand_unlock_all(struct mtd_info *mtd)
>  {
>        struct onenand_chip *this = mtd->priv;
>        loff_t ofs = 0;
> -       size_t len = this->chipsize;
> +       size_t len = (mtd->numeraseregions > 1) ? this->diesize[0] :
> +                                                 this->chipsize;
>
>        if (this->options & ONENAND_HAS_UNLOCK_ALL) {
>                /* Set start block address */
> @@ -2122,9 +2344,14 @@ static void onenand_unlock_all(struct mtd_info *mtd)
>
>                /* Workaround for all block unlock in DDP */
>                if (ONENAND_IS_DDP(this)) {
> -                       /* All blocks on another chip */
> -                       ofs = this->chipsize >> 1;
> -                       len = this->chipsize >> 1;
> +                       /* All blocks on another chip
> +                        * For Flex-OneNAND with both slc
> +                        * mlc regions, we use diesize
> +                        */
> +                       ofs = (mtd->numeraseregions > 1) ? this->diesize[0]
> :
> +                                                       this->chipsize >> 1;
> +                       len = (mtd->numeraseregions > 1) ? this->diesize[1]
> :
> +                                                       this->chipsize >> 1;
>                }
>        }
>
> @@ -2230,21 +2457,34 @@ static int do_otp_lock(struct mtd_info *mtd, loff_t
> from, size_t len,
>                size_t *retlen, u_char *buf)
>  {
>        struct onenand_chip *this = mtd->priv;
> -       struct mtd_oob_ops ops = {
> -               .mode = MTD_OOB_PLACE,
> -               .ooblen = len,
> -               .oobbuf = buf,
> -               .ooboffs = 0,
> -       };
> +       struct mtd_oob_ops ops;
>        int ret;
>
> +       if (FLEXONENAND(this)) {
> +               ops.len = mtd->writesize;
> +               ops.ooblen = 0;
> +               ops.datbuf = buf;
> +               ops.oobbuf = NULL;
> +       } else {
> +               ops.mode = MTD_OOB_PLACE;
> +               ops.ooblen = len;
> +               ops.oobbuf = buf;
> +               ops.ooboffs = 0;
> +       }
> +
>        /* Enter OTP access mode */
>        this->command(mtd, ONENAND_CMD_OTP_ACCESS, 0, 0);
>        this->wait(mtd, FL_OTPING);
>
> -       ret = onenand_write_oob_nolock(mtd, from, &ops);
> +       /*
> +        * For Flex-OneNAND, we write lock mark to 1st word of sector 4 of
> +        * main area of page 49.
> +        */
> +       ret = FLEXONENAND(this) ?
> +               onenand_write_ops_nolock(mtd, (mtd->writesize * 49), &ops)
> +               : onenand_write_oob_nolock(mtd, from, &ops);
>
> -       *retlen = ops.oobretlen;
> +       *retlen = FLEXONENAND(this) ? ops.retlen : ops.oobretlen;
>
>        /* Exit OTP access mode */
>        this->command(mtd, ONENAND_CMD_RESET, 0, 0);
> @@ -2428,27 +2668,34 @@ static int onenand_lock_user_prot_reg(struct
> mtd_info *mtd, loff_t from,
>                        size_t len)
>  {
>        struct onenand_chip *this = mtd->priv;
> -       u_char *oob_buf = this->oob_buf;
> +       u_char *buf = FLEXONENAND(this) ? this->page_buf : this->oob_buf;
>        size_t retlen;
>        int ret;
>
> -       memset(oob_buf, 0xff, mtd->oobsize);
> +       memset(buf, 0xff, FLEXONENAND(this) ? this->writesize
> +                                                : mtd->oobsize);
>        /*
>         * Note: OTP lock operation
>         *       OTP block : 0xXXFC
>         *       1st block : 0xXXF3 (If chip support)
>         *       Both      : 0xXXF0 (If chip support)
>         */
> -       oob_buf[ONENAND_OTP_LOCK_OFFSET] = 0xFC;
> +       if (FLEXONENAND(this))
> +               buf[FLEXONENAND_OTP_LOCK_OFFSET] = 0xFC;
> +       else
> +               buf[ONENAND_OTP_LOCK_OFFSET] = 0xFC;
>
>        /*
>         * Write lock mark to 8th word of sector0 of page0 of the spare0.
>         * We write 16 bytes spare area instead of 2 bytes.
> +        * For Flex-OneNAND, we write lock mark to 1st word of sector 4 of
> +        * main area of page 49.
>         */
> +
>        from = 0;
> -       len = 16;
> +       len = FLEXONENAND(this) ? mtd->writesize : 16;
>
> -       ret = onenand_otp_walk(mtd, from, len, &retlen, oob_buf,
> do_otp_lock, MTD_OTP_USER);
> +       ret = onenand_otp_walk(mtd, from, len, &retlen, buf, do_otp_lock,
> MTD_OTP_USER);
>
>        return ret ? : retlen;
>  }
> @@ -2495,6 +2742,14 @@ static void onenand_check_features(struct mtd_info
> *mtd)
>                break;
>        }
>
> +       if (ONENAND_IS_MLC(this))
> +               this->options &= ~ONENAND_HAS_2PLANE;
> +
> +       if (FLEXONENAND(this)) {
> +               this->options &= ~ONENAND_HAS_CONT_LOCK;
> +               this->options |= ONENAND_HAS_UNLOCK_ALL;
> +       }
> +
>        if (this->options & ONENAND_HAS_CONT_LOCK)
>                printk(KERN_DEBUG "Lock scheme is Continuous Lock\n");
>        if (this->options & ONENAND_HAS_UNLOCK_ALL)
> @@ -2512,14 +2767,16 @@ static void onenand_check_features(struct mtd_info
> *mtd)
>  */
>  static void onenand_print_device_info(int device, int version)
>  {
> -        int vcc, demuxed, ddp, density;
> +       int vcc, demuxed, ddp, density, flexonenand;
>
>         vcc = device & ONENAND_DEVICE_VCC_MASK;
>         demuxed = device & ONENAND_DEVICE_IS_DEMUX;
>         ddp = device & ONENAND_DEVICE_IS_DDP;
>         density = onenand_get_density(device);
> -        printk(KERN_INFO "%sOneNAND%s %dMB %sV 16-bit (0x%02x)\n",
> -                demuxed ? "" : "Muxed ",
> +       flexonenand = device & DEVICE_IS_FLEXONENAND;
> +       printk(KERN_INFO "%s%sOneNAND%s %dMB %sV 16-bit (0x%02x)\n",
> +               demuxed ? "" : "Muxed ",
> +               flexonenand ? "Flex-" : "",
>                 ddp ? "(DDP)" : "",
>                 (16 << density),
>                 vcc ? "2.65/3.3" : "1.8",
> @@ -2558,6 +2815,181 @@ static int onenand_check_maf(int manuf)
>  }
>
>  /**
> +* flexonenand_get_boundary     - Reads the SLC boundary
> +* @param onenand_info          - onenand info structure
> +**/
> +static int flexonenand_get_boundary(struct mtd_info *mtd)
> +{
> +       struct onenand_chip *this = mtd->priv;
> +       unsigned die, bdry;
> +       int ret, syscfg, locked;
> +
> +       /* Disable ECC */
> +       syscfg = this->read_word(this->base + ONENAND_REG_SYS_CFG1);
> +       this->write_word((syscfg | 0x0100), this->base +
> ONENAND_REG_SYS_CFG1);
> +
> +       for (die = 0; die < this->dies; die++) {
> +               this->command(mtd, FLEXONENAND_CMD_PI_ACCESS, die, 0);
> +               this->wait(mtd, FL_SYNCING);
> +
> +               this->command(mtd, ONENAND_CMD_READ, die, 0);
> +               ret = this->wait(mtd, FL_READING);
> +
> +               bdry = this->read_word(this->base + ONENAND_DATARAM);
> +               locked = bdry >> FLEXONENAND_PI_UNLOCK_SHIFT;
> +               locked = (locked == 0x3) ? 0 : 1;
> +               this->boundary[die] = bdry & FLEXONENAND_PI_MASK;
> +               this->boundary_locked[die] = locked;
> +               this->command(mtd, ONENAND_CMD_RESET, 0, 0);
> +               ret = this->wait(mtd, FL_RESETING);
> +
> +               printk(KERN_INFO "Die %d boundary: %d%s\n", die,
> +                      this->boundary[die], locked ? "(Locked)" :
> "(Unlocked)");
> +       }
> +
> +       /* Enable ECC */
> +       this->write_word(syscfg, this->base + ONENAND_REG_SYS_CFG1);
> +       return 0;
> +}
> +
> +/**
> + * get_flexonenand_size - Fill up fields in onenand_chip
> + *                       boundary[], diesize[], chipsize,
> + *                       boundary_locked[]
> + * @param mtd          - MTD device structure
> + */
> +static void get_flexonenand_size(struct mtd_info *mtd)
> +{
> +       struct onenand_chip *this = mtd->priv;
> +       int die, ofs, i, eraseshift, density;
> +       int blksperdie, maxbdry;
> +
> +       density = onenand_get_density(this->device_id);
> +       blksperdie = ((16 << density) << 20) >> (this->erase_shift);
> +       blksperdie >>= ONENAND_IS_DDP(this) ? 1 : 0;
> +       maxbdry = blksperdie - 1;
> +       eraseshift = this->erase_shift - 1;
> +
> +       this->chipsize = 0;
> +       mtd->numeraseregions = this->dies << 1;
> +
> +       /* This fills up the device boundary */
> +       flexonenand_get_boundary(mtd);
> +       die = ofs = 0;
> +       i = -1;
> +       for (; die < this->dies; die++) {
> +               if (!die || this->boundary[die-1] != maxbdry) {
> +                       i++;
> +                       mtd->eraseregions[i].offset = ofs;
> +                       mtd->eraseregions[i].erasesize = 1 << eraseshift;
> +                       mtd->eraseregions[i].numblocks =
> +                                                       this->boundary[die]
> + 1;
> +                       ofs += mtd->eraseregions[i].numblocks << eraseshift;
> +                       eraseshift++;
> +               } else {
> +                       mtd->numeraseregions -= 1;
> +                       mtd->eraseregions[i].numblocks +=
> +                                                       this->boundary[die]
> + 1;
> +                       ofs += (this->boundary[die] + 1) << (eraseshift -
> 1);
> +               }
> +               if (this->boundary[die] != maxbdry) {
> +                       i++;
> +                       mtd->eraseregions[i].offset = ofs;
> +                       mtd->eraseregions[i].erasesize = 1 << eraseshift;
> +                       mtd->eraseregions[i].numblocks = maxbdry ^
> +
> this->boundary[die];
> +                       ofs += mtd->eraseregions[i].numblocks << eraseshift;
> +                       eraseshift--;
> +               } else
> +                       mtd->numeraseregions -= 1;
> +       }
> +
> +       mtd->erasesize = 1 << (this->erase_shift);
> +       if (mtd->numeraseregions == 1)
> +               mtd->erasesize >>= 1;
> +
> +       printk(KERN_INFO "Device has %d eraseregions\n",
> mtd->numeraseregions);
> +       for (i = 0; i < mtd->numeraseregions; i++)
> +               printk(KERN_INFO "[offset: 0x%08x, erasesize: 0x%05x,"
> +                        " numblocks: %04u]\n", mtd->eraseregions[i].offset,
> +                       mtd->eraseregions[i].erasesize,
> +                       mtd->eraseregions[i].numblocks);
> +
> +       for (die = 0, mtd->size = 0; die < this->dies; die++) {
> +               this->diesize[die] = (blksperdie << this->erase_shift);
> +               this->diesize[die] -= (this->boundary[die] + 1)
> +                                                << (this->erase_shift - 1);
> +               mtd->size += this->diesize[die];
> +       }
> +
> +       /* this->chipsize represents maximum possible chip size */
> +       this->chipsize = (16 << density) << 20;
> +}
> +
> +/**
> + * flexonenand_set_boundary    - Writes the SLC boundary
> + * @param onenand_info         - onenand info structure
> + */
> +static int flexonenand_set_boundary(struct mtd_info *mtd, unsigned die,
> +                                               int boundary, int lock)
> +{
> +       struct onenand_chip *this = mtd->priv;
> +       int ret, density, blksperdie;
> +       loff_t addr;
> +
> +       density = onenand_get_density(this->device_id);
> +       blksperdie = ((16 << density) << 20) >> this->erase_shift;
> +       blksperdie >>= ONENAND_IS_DDP(this) ? 1 : 0;
> +
> +       printk(KERN_INFO "Changing die %d boundary: %d%s\n", die, boundary,
> +                                        lock ? "(Locked)" : "(Unlocked)");
> +       if (boundary >= blksperdie) {
> +               printk(KERN_ERR "Invalid boundary value.\
> +                                                Boundary not changed.\n");
> +               return -1;
> +       }
> +
> +       if (this->boundary_locked[die]) {
> +               printk(KERN_ERR "Die boundary is locked.\
> +                                                Boundary not changed.\n");
> +               return -1;
> +       }
> +
> +       addr = die ? this->diesize[0] : 0;
> +
> +       boundary &= FLEXONENAND_PI_MASK;
> +       boundary |= lock ? 0 : (3 << FLEXONENAND_PI_UNLOCK_SHIFT);
> +
> +       this->command(mtd, FLEXONENAND_CMD_PI_ACCESS, addr, 0);
> +       this->wait(mtd, FL_SYNCING);
> +
> +       this->command(mtd, ONENAND_CMD_ERASE, addr, 0);
> +       this->wait(mtd, FL_ERASING);
> +
> +       this->write_word(boundary, this->base + ONENAND_DATARAM);
> +       this->command(mtd, ONENAND_CMD_PROG, addr, 0);
> +       ret = this->wait(mtd, FL_WRITING);
> +       if (ret) {
> +               printk(KERN_ERR "Failed PI write for Die %d\n", die);
> +               goto out;
> +       }
> +
> +       this->command(mtd, FLEXONENAND_CMD_PI_UPDATE, die, 0);
> +       ret = this->wait(mtd, FL_WRITING);
> +       if (ret)
> +               printk(KERN_ERR "Failed PI update for Die %d\n", die);
> +       else
> +               printk(KERN_INFO "Done\n");
> +out:
> +       this->write_word(ONENAND_CMD_RESET, this->base +
> ONENAND_REG_COMMAND);
> +       this->wait(mtd, FL_RESETING);
> +       if (!ret)
> +               /* Recalculate device size on boundary change*/
> +               get_flexonenand_size(mtd);
> +       return ret;
> +}
> +
> +/**
>  * onenand_probe - [OneNAND Interface] Probe the OneNAND device
>  * @param mtd          MTD device structure
>  *
> @@ -2599,6 +3031,7 @@ static int onenand_probe(struct mtd_info *mtd)
>        maf_id = this->read_word(this->base + ONENAND_REG_MANUFACTURER_ID);
>        dev_id = this->read_word(this->base + ONENAND_REG_DEVICE_ID);
>        ver_id = this->read_word(this->base + ONENAND_REG_VERSION_ID);
> +       this->technology = this->read_word(this->base +
> ONENAND_REG_TECHNOLOGY);
>
>        /* Check OneNAND device */
>        if (maf_id != bram_maf_id || dev_id != bram_dev_id)
> @@ -2610,20 +3043,35 @@ static int onenand_probe(struct mtd_info *mtd)
>        this->version_id = ver_id;
>
>        density = onenand_get_density(dev_id);
> -       this->chipsize = (16 << density) << 20;
> +       if (FLEXONENAND(this)) {
> +               this->dies = ONENAND_IS_DDP(this) ? 2 : 1;
> +               /* Maximum possible erase regions */
> +               mtd->numeraseregions = this->dies << 1;
> +               mtd->eraseregions = kzalloc(sizeof(struct
> mtd_erase_region_info)
> +                                       * (this->dies << 1), GFP_KERNEL);
> +               if (!mtd->eraseregions)
> +                       return -ENOMEM;
> +       }
> +       this->chipsize = FLEXONENAND(this) ? 0 : (16 << density) << 20;
>        /* Set density mask. it is used for DDP */
>        if (ONENAND_IS_DDP(this))
> -               this->density_mask = (1 << (density + 6));
> +               this->density_mask = (1 << (density +
> +                                                (FLEXONENAND(this) ? 4 :
> 6)));
>        else
>                this->density_mask = 0;
>
>        /* OneNAND page size & block size */
>        /* The data buffer size is equal to page size */
>        mtd->writesize = this->read_word(this->base +
> ONENAND_REG_DATA_BUFFER_SIZE);
> +       /* We use the full BufferRAM */
> +       if (ONENAND_IS_MLC(this))
> +               mtd->writesize <<= 1;
> +
>        mtd->oobsize = mtd->writesize >> 5;
>        /* Pages per a block are always 64 in OneNAND */
>        mtd->erasesize = mtd->writesize << 6;
> -
> +       /* Flex-OneNAND always has 128 pages per block */
> +       mtd->erasesize <<= FLEXONENAND(this) ? 1 : 0;
>        this->erase_shift = ffs(mtd->erasesize) - 1;
>        this->page_shift = ffs(mtd->writesize) - 1;
>        this->page_mask = (1 << (this->erase_shift - this->page_shift)) - 1;
> @@ -2632,7 +3080,20 @@ static int onenand_probe(struct mtd_info *mtd)
>
>        /* REVIST: Multichip handling */
>
> -       mtd->size = this->chipsize;
> +       if (FLEXONENAND(this)) {
> +               unsigned die;
> +
> +               get_flexonenand_size(mtd);
> +
> +               /* Change the device boundaries if required */
> +               for (die = 0; die < this->dies; die++)
> +                       if ((!this->boundary_locked[die]) &&
> +                          (boundary[die] >= 0) &&
> +                          (boundary[die] != this->boundary[die]))
> +                               flexonenand_set_boundary(mtd, die,
> +                                                boundary[die], lock[die]);
> +       } else
> +               mtd->size = this->chipsize;
>
>        /* Check OneNAND features */
>        onenand_check_features(mtd);
> @@ -2749,6 +3210,10 @@ int onenand_scan(struct mtd_info *mtd, int maxchips)
>         * Allow subpage writes up to oobsize.
>         */
>        switch (mtd->oobsize) {
> +       case 128:
> +               this->ecclayout = &onenand_oob_128;
> +               mtd->subpage_sft = 0;
> +               break;
>        case 64:
>                this->ecclayout = &onenand_oob_64;
>                mtd->subpage_sft = 2;
> @@ -2768,6 +3233,10 @@ int onenand_scan(struct mtd_info *mtd, int maxchips)
>                break;
>        }
>
> +       /* Don't allow the sub-page write in MLC */
> +       if (ONENAND_IS_MLC(this))
> +               mtd->subpage_sft = 0;
> +
>        this->subpagesize = mtd->writesize >> mtd->subpage_sft;
>
>        /*
> @@ -2843,6 +3312,8 @@ void onenand_release(struct mtd_info *mtd)
>                kfree(this->page_buf);
>        if (this->options & ONENAND_OOBBUF_ALLOC)
>                kfree(this->oob_buf);
> +       if (FLEXONENAND(this))
> +               kfree(mtd->eraseregions);
>  }
>
>  EXPORT_SYMBOL_GPL(onenand_scan);
> diff --git a/drivers/mtd/onenand/onenand_bbt.c
> b/drivers/mtd/onenand/onenand_bbt.c
> index 2f53b51..88c63b7 100644
> --- a/drivers/mtd/onenand/onenand_bbt.c
> +++ b/drivers/mtd/onenand/onenand_bbt.c
> @@ -60,6 +60,7 @@ static int create_bbt(struct mtd_info *mtd, uint8_t *buf,
> struct nand_bbt_descr
>        struct bbm_info *bbm = this->bbm;
>        int i, j, numblocks, len, scanlen;
>        int startblock;
> +       unsigned slc;
>        loff_t from;
>        size_t readlen, ooblen;
>        struct mtd_oob_ops ops;
> @@ -76,7 +77,7 @@ static int create_bbt(struct mtd_info *mtd, uint8_t *buf,
> struct nand_bbt_descr
>        /* Note that numblocks is 2 * (real numblocks) here;
>         * see i += 2 below as it makses shifting and masking less painful
>         */
> -       numblocks = mtd->size >> (bbm->bbt_erase_shift - 1);
> +       numblocks = this->chipsize >> (bbm->bbt_erase_shift - 1);
>        startblock = 0;
>        from = 0;
>
> @@ -106,7 +107,13 @@ static int create_bbt(struct mtd_info *mtd, uint8_t
> *buf, struct nand_bbt_descr
>                        }
>                }
>                i += 2;
> -               from += (1 << bbm->bbt_erase_shift);
> +               if (FLEXONENAND(this)) {
> +                       onenand_get_block(mtd, from, &slc);
> +                       from += (1 << bbm->bbt_erase_shift) >> 1;
> +                       if (!slc)
> +                               from += (1 << bbm->bbt_erase_shift) >> 1;
> +               } else
> +                       from += (1 << bbm->bbt_erase_shift);
>        }
>
>        return 0;
> @@ -143,7 +150,7 @@ static int onenand_isbad_bbt(struct mtd_info *mtd,
> loff_t offs, int allowbbt)
>        uint8_t res;
>
>        /* Get block number * 2 */
> -       block = (int) (offs >> (bbm->bbt_erase_shift - 1));
> +       block = (int) (onenand_get_block(mtd, offs, NULL) << 1);
>        res = (bbm->bbt[block >> 3] >> (block & 0x06)) & 0x03;
>
>        DEBUG(MTD_DEBUG_LEVEL2, "onenand_isbad_bbt: bbt info for offs
> 0x%08x: (block %d) 0x%02x\n",
> @@ -178,7 +185,7 @@ int onenand_scan_bbt(struct mtd_info *mtd, struct
> nand_bbt_descr *bd)
>        struct bbm_info *bbm = this->bbm;
>        int len, ret = 0;
>
> -       len = mtd->size >> (this->erase_shift + 2);
> +       len = this->chipsize >> (this->erase_shift + 2);
>        /* Allocate memory (2bit per block) and clear the memory bad block
> table */
>        bbm->bbt = kzalloc(len, GFP_KERNEL);
>        if (!bbm->bbt) {
> diff --git a/drivers/mtd/onenand/onenand_sim.c
> b/drivers/mtd/onenand/onenand_sim.c
> index d64200b..012d926 100644
> --- a/drivers/mtd/onenand/onenand_sim.c
> +++ b/drivers/mtd/onenand/onenand_sim.c
> @@ -6,6 +6,10 @@
>  *  Copyright Â(c) 2005-2007 Samsung Electronics
>  *  Kyungmin Park <kyungmin.park@samsung.com>
>  *
> + *  Vishak G <vishak.g@samsung.com>, Rohit Hagargundgi
> <h.rohit@samsung.com>
> + *  Flex-OneNAND simulator support
> + *  Copyright (C) Samsung Electronics, 2008
> + *
>  * This program is free software; you can redistribute it and/or modify
>  * it under the terms of the GNU General Public License version 2 as
>  * published by the Free Software Foundation.
> @@ -24,16 +28,38 @@
>  #ifndef CONFIG_ONENAND_SIM_MANUFACTURER
>  #define CONFIG_ONENAND_SIM_MANUFACTURER         0xec
>  #endif
> +
>  #ifndef CONFIG_ONENAND_SIM_DEVICE_ID
>  #define CONFIG_ONENAND_SIM_DEVICE_ID            0x04
>  #endif
> +
> +#define CONFIG_FLEXONENAND ((CONFIG_ONENAND_SIM_DEVICE_ID >> 9) & 1)
> +
>  #ifndef CONFIG_ONENAND_SIM_VERSION_ID
>  #define CONFIG_ONENAND_SIM_VERSION_ID           0x1e
>  #endif
>
> +#ifndef CONFIG_ONENAND_SIM_TECHNOLOGY_ID
> +#define CONFIG_ONENAND_SIM_TECHNOLOGY_ID CONFIG_FLEXONENAND
> +#endif
> +
> +/* Initial boundary values for Flex-OneNAND Simulator */
> +#ifndef CONFIG_FLEXONENAND_SIM_DIE0_BOUNDARY
> +#define CONFIG_FLEXONENAND_SIM_DIE0_BOUNDARY   0x01
> +#endif
> +
> +#ifndef CONFIG_FLEXONENAND_SIM_DIE1_BOUNDARY
> +#define CONFIG_FLEXONENAND_SIM_DIE1_BOUNDARY   0x01
> +#endif
> +
>  static int manuf_id    = CONFIG_ONENAND_SIM_MANUFACTURER;
>  static int device_id   = CONFIG_ONENAND_SIM_DEVICE_ID;
>  static int version_id  = CONFIG_ONENAND_SIM_VERSION_ID;
> +static int technology_id = CONFIG_ONENAND_SIM_TECHNOLOGY_ID;
> +static int boundary[] = {
> +       CONFIG_FLEXONENAND_SIM_DIE0_BOUNDARY,
> +       CONFIG_FLEXONENAND_SIM_DIE1_BOUNDARY,
> +};
>
>  struct onenand_flash {
>        void __iomem *base;
> @@ -57,12 +83,18 @@ struct onenand_flash {
>        (writew(v, this->base + ONENAND_REG_WP_STATUS))
>
>  /* It has all 0xff chars */
> -#define MAX_ONENAND_PAGESIZE           (2048 + 64)
> +#define MAX_ONENAND_PAGESIZE           (4096 + 128)
>  static unsigned char *ffchars;
>
> +#if CONFIG_FLEXONENAND
> +#define PARTITION_NAME "Flex-OneNAND simulator partition"
> +#else
> +#define PARTITION_NAME "OneNAND simulator partition"
> +#endif
> +
>  static struct mtd_partition os_partitions[] = {
>        {
> -               .name           = "OneNAND simulator partition",
> +               .name           = PARTITION_NAME,
>                .offset         = 0,
>                .size           = MTDPART_SIZ_FULL,
>        },
> @@ -104,6 +136,7 @@ static void onenand_lock_handle(struct onenand_chip
> *this, int cmd)
>
>        switch (cmd) {
>        case ONENAND_CMD_UNLOCK:
> +       case ONENAND_CMD_UNLOCK_ALL:
>                if (block_lock_scheme)
>                        ONENAND_SET_WP_STATUS(ONENAND_WP_US, this);
>                else
> @@ -228,10 +261,11 @@ static void onenand_data_handle(struct onenand_chip
> *this, int cmd,
>  {
>        struct mtd_info *mtd = &info->mtd;
>        struct onenand_flash *flash = this->priv;
> -       int main_offset, spare_offset;
> +       int main_offset, spare_offset, die = 0;
>        void __iomem *src;
>        void __iomem *dest;
> -       unsigned int i;
> +       unsigned int i, slc = 0;
> +       static int pi_operation;
>
>        if (dataram) {
>                main_offset = mtd->writesize;
> @@ -241,10 +275,27 @@ static void onenand_data_handle(struct onenand_chip
> *this, int cmd,
>                spare_offset = 0;
>        }
>
> +       if (pi_operation) {
> +               die = readw(this->base + ONENAND_REG_START_ADDRESS2);
> +               die >>= ONENAND_DDP_SHIFT;
> +       }
> +
>        switch (cmd) {
> +       case FLEXONENAND_CMD_PI_ACCESS:
> +               pi_operation = 1;
> +               break;
> +
> +       case ONENAND_CMD_RESET:
> +               pi_operation = 0;
> +               break;
> +
>        case ONENAND_CMD_READ:
>                src = ONENAND_CORE(flash) + offset;
>                dest = ONENAND_MAIN_AREA(this, main_offset);
> +               if (pi_operation) {
> +                       writew(boundary[die], this->base + ONENAND_DATARAM);
> +                       break;
> +               }
>                memcpy(dest, src, mtd->writesize);
>                /* Fall through */
>
> @@ -257,6 +308,10 @@ static void onenand_data_handle(struct onenand_chip
> *this, int cmd,
>        case ONENAND_CMD_PROG:
>                src = ONENAND_MAIN_AREA(this, main_offset);
>                dest = ONENAND_CORE(flash) + offset;
> +               if (pi_operation) {
> +                       boundary[die] = readw(this->base + ONENAND_DATARAM);
> +                       break;
> +               }
>                /* To handle partial write */
>                for (i = 0; i < (1 << mtd->subpage_sft); i++) {
>                        int off = i * this->subpagesize;
> @@ -284,9 +339,16 @@ static void onenand_data_handle(struct onenand_chip
> *this, int cmd,
>                break;
>
>        case ONENAND_CMD_ERASE:
> +               if (pi_operation)
> +                       break;
> +               onenand_get_block(mtd, offset, &slc);
> +               if (slc && (mtd->numeraseregions > 1))
> +                       mtd->erasesize >>= 1;
>                memset(ONENAND_CORE(flash) + offset, 0xff, mtd->erasesize);
>                memset(ONENAND_CORE_SPARE(flash, this, offset), 0xff,
>                       (mtd->erasesize >> 5));
> +               if (slc && (mtd->numeraseregions > 1))
> +                       mtd->erasesize <<= 1;
>                break;
>
>        default:
> @@ -295,6 +357,29 @@ static void onenand_data_handle(struct onenand_chip
> *this, int cmd,
>  }
>
>  /**
> + * flexonenand_get_addr - Return address of the block
> + * @block:             Block number on Flex-OneNAND
> + *
> + */
> +loff_t flexonenand_get_addr(struct onenand_chip *this, int block)
> +{
> +       loff_t ofs;
> +       int die = 0, boundary;
> +
> +       ofs = 0;
> +       if (ONENAND_IS_DDP(this) && block >= this->density_mask) {
> +               block -= this->density_mask;
> +               die = 1;
> +               ofs = this->diesize[0];
> +       }
> +       boundary = this->boundary[die];
> +       ofs += block << (this->erase_shift - 1);
> +       if (block > (boundary + 1))
> +               ofs += (block - boundary - 1) << (this->erase_shift - 1);
> +       return ofs;
> +}
> +
> +/**
>  * onenand_command_handle - Handle command
>  * @this:              OneNAND device structure
>  * @cmd:               The command to be sent
> @@ -338,8 +423,12 @@ static void onenand_command_handle(struct onenand_chip
> *this, int cmd)
>                break;
>        }
>
> -       if (block != -1)
> -               offset += block << this->erase_shift;
> +       if (block != -1) {
> +               if (FLEXONENAND(this))
> +                       offset = flexonenand_get_addr(this, block);
> +               else
> +                       offset += block << this->erase_shift;
> +       }
>
>        if (page != -1)
>                offset += page << this->page_shift;
> @@ -390,6 +479,7 @@ static int __init flash_init(struct onenand_flash
> *flash)
>        }
>
>        density = device_id >> ONENAND_DEVICE_DENSITY_SHIFT;
> +       density &= ONENAND_DEVICE_DENSITY_MASK;
>        size = ((16 << 20) << density);
>
>        ONENAND_CORE(flash) = vmalloc(size + (size >> 5));
> @@ -405,8 +495,9 @@ static int __init flash_init(struct onenand_flash
> *flash)
>        writew(manuf_id, flash->base + ONENAND_REG_MANUFACTURER_ID);
>        writew(device_id, flash->base + ONENAND_REG_DEVICE_ID);
>        writew(version_id, flash->base + ONENAND_REG_VERSION_ID);
> +       writew(technology_id, flash->base + ONENAND_REG_TECHNOLOGY);
>
> -       if (density < 2)
> +       if (density < 2 && (!CONFIG_FLEXONENAND))
>                buffer_size = 0x0400;   /* 1KiB page */
>        else
>                buffer_size = 0x0800;   /* 2KiB page */
> diff --git a/include/linux/mtd/onenand.h b/include/linux/mtd/onenand.h
> index 9aa2a91..c3b9f9a 100644
> --- a/include/linux/mtd/onenand.h
> +++ b/include/linux/mtd/onenand.h
> @@ -17,8 +17,24 @@
>  #include <linux/mtd/onenand_regs.h>
>  #include <linux/mtd/bbm.h>
>
> +#define MAX_DIES                       2
>  #define MAX_BUFFERRAM          2
>
> +/**
> + *  FlexOneNAND device boundary setting
> + *  Setting -1 will not change the boundary
> + */
> +#define FLEXONENAND_DIE0_BOUNDARY      -1
> +#define FLEXONENAND_DIE1_BOUNDARY      -1
> +
> +/**
> + *  Setting value 1 locks the boundary
> + *  WARNING : Once locked, the boundary cannot be changed.
> + *           Use with care.
> + */
> +#define FLEXONENAND_DIE0_ISLOCKED      0
> +#define FLEXONENAND_DIE1_ISLOCKED      0
> +
>  /* Scan and identify a OneNAND device */
>  extern int onenand_scan(struct mtd_info *mtd, int max_chips);
>  /* Free resources held by the OneNAND device */
> @@ -51,6 +67,11 @@ struct onenand_bufferram {
>  /**
>  * struct onenand_chip - OneNAND Private Flash Chip Data
>  * @base:              [BOARDSPECIFIC] address to access OneNAND
> + * @dies:              [INTERN][FLEX-ONENAND] number of dies on chip
> + * @boundary:          [INTERN][FLEX-ONENAND] Boundary of the dies
> + * @boundary_locked:   [INTERN][FLEX-ONENAND] TRUE indicates die boundary
> + *                     is locked and cannot be changed
> + * @diesize:           [INTERN][FLEX-ONENAND] Size of the dies
>  * @chipsize:          [INTERN] the size of one chip for multichip arrays
>  * @device_id:         [INTERN] device ID
>  * @density_mask:      chip density, used for DDP devices
> @@ -92,9 +113,14 @@ struct onenand_bufferram {
>  */
>  struct onenand_chip {
>        void __iomem            *base;
> +       unsigned                dies;
> +       unsigned                boundary[MAX_DIES];
> +       unsigned int            boundary_locked[MAX_DIES];
> +       unsigned int            diesize[MAX_DIES];
>        unsigned int            chipsize;
>        unsigned int            device_id;
>        unsigned int            version_id;
> +       unsigned int            technology;
>        unsigned int            density_mask;
>        unsigned int            options;
>
> @@ -145,6 +171,8 @@ struct onenand_chip {
>  #define ONENAND_SET_BUFFERRAM0(this)           (this->bufferram_index = 0)
>  #define ONENAND_SET_BUFFERRAM1(this)           (this->bufferram_index = 1)
>
> +#define FLEXONENAND(this)                                              \
> +       (this->device_id & DEVICE_IS_FLEXONENAND)
>  #define ONENAND_GET_SYS_CFG1(this)                                     \
>        (this->read_word(this->base + ONENAND_REG_SYS_CFG1))
>  #define ONENAND_SET_SYS_CFG1(v, this)                                  \
> @@ -153,6 +181,9 @@ struct onenand_chip {
>  #define ONENAND_IS_DDP(this)                                           \
>        (this->device_id & ONENAND_DEVICE_IS_DDP)
>
> +#define ONENAND_IS_MLC(this)                                           \
> +       (this->technology & ONENAND_TECHNOLOGY_IS_MLC)
> +
>  #ifdef CONFIG_MTD_ONENAND_2X_PROGRAM
>  #define ONENAND_IS_2PLANE(this)
> \
>        (this->options & ONENAND_HAS_2PLANE)
> @@ -189,5 +220,7 @@ struct onenand_manufacturers {
>
>  int onenand_bbt_read_oob(struct mtd_info *mtd, loff_t from,
>                         struct mtd_oob_ops *ops);
> +unsigned onenand_get_block(struct mtd_info *mtd, loff_t addr,
> +                        unsigned *isblkslc);
>
>  #endif /* __LINUX_MTD_ONENAND_H */
> diff --git a/include/linux/mtd/onenand_regs.h
> b/include/linux/mtd/onenand_regs.h
> index 0c6bbe2..da48c36 100644
> --- a/include/linux/mtd/onenand_regs.h
> +++ b/include/linux/mtd/onenand_regs.h
> @@ -67,6 +67,9 @@
>  /*
>  * Device ID Register F001h (R)
>  */
> +#define DEVICE_IS_FLEXONENAND          (1 << 9)
> +#define FLEXONENAND_PI_MASK            (0x3ff)
> +#define FLEXONENAND_PI_UNLOCK_SHIFT    (14)
>  #define ONENAND_DEVICE_DENSITY_MASK    (0xf)
>  #define ONENAND_DEVICE_DENSITY_SHIFT   (4)
>  #define ONENAND_DEVICE_IS_DDP          (1 << 3)
> @@ -84,6 +87,11 @@
>  #define ONENAND_VERSION_PROCESS_SHIFT  (8)
>
>  /*
> + * Technology Register F006h (R)
> + */
> +#define ONENAND_TECHNOLOGY_IS_MLC      (1 << 0)
> +
> +/*
>  * Start Address 1 F100h (R/W) & Start Address 2 F101h (R/W)
>  */
>  #define ONENAND_DDP_SHIFT              (15)
> @@ -93,7 +101,8 @@
>  /*
>  * Start Address 8 F107h (R/W)
>  */
> -#define ONENAND_FPA_MASK               (0x3f)
> +/* Note: It's actually 0x3f in case of SLC */
> +#define ONENAND_FPA_MASK               (0x7f)
>  #define ONENAND_FPA_SHIFT              (2)
>  #define ONENAND_FSA_MASK               (0x03)
>
> @@ -105,7 +114,8 @@
>  #define ONENAND_BSA_BOOTRAM            (0 << 2)
>  #define ONENAND_BSA_DATARAM0           (2 << 2)
>  #define ONENAND_BSA_DATARAM1           (3 << 2)
> -#define ONENAND_BSC_MASK               (0x03)
> +/* Note: It's actually 0x03 in case of SLC */
> +#define ONENAND_BSC_MASK               (0x07)
>
>  /*
>  * Command Register F220h (R/W)
> @@ -124,6 +134,9 @@
>  #define ONENAND_CMD_RESET              (0xF0)
>  #define ONENAND_CMD_OTP_ACCESS         (0x65)
>  #define ONENAND_CMD_READID             (0x90)
> +#define FLEXONENAND_CMD_PI_UPDATE      (0x05)
> +#define FLEXONENAND_CMD_PI_ACCESS      (0x66)
> +#define FLEXONENAND_CMD_RECOVER_LSB    (0x05)
>
>  /* NOTE: Those are not *REAL* commands */
>  #define ONENAND_CMD_BUFFERRAM          (0x1978)
> @@ -192,10 +205,12 @@
>  #define ONENAND_ECC_1BIT_ALL           (0x5555)
>  #define ONENAND_ECC_2BIT               (1 << 1)
>  #define ONENAND_ECC_2BIT_ALL           (0xAAAA)
> +#define FLEXONENAND_UNCORRECTABLE_ERROR        (0x1010)
>
>  /*
>  * One-Time Programmable (OTP)
>  */
> +#define FLEXONENAND_OTP_LOCK_OFFSET            (2048)
>  #define ONENAND_OTP_LOCK_OFFSET                (14)
>
>  #endif /* __ONENAND_REG_H */
>
>
>
