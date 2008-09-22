Return-Path: <linux-kernel-owner+w=401wt.eu-S1752281AbYIVHLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbYIVHLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 03:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbYIVHLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 03:11:35 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:43105 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbYIVHLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 03:11:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=BLT0gbAM2U3htbTYlG00E1B735vJbfcEqMpIdDscKX5EoTsiSv668k3GoVq0nTCR1c
         APq7guvnTHJSXKF050yvXiEW6/N9cYByyLWQ6FbcBJU+x1oloS83fFGWN8XgiRvumnJv
         4Sz/aR5mnjtCGJqk/yCRzk5a3S6NCZxf+Zsvs=
Message-ID: <9c9fda240809220011w49c0875q804f836550ff3476@mail.gmail.com>
Date: Mon, 22 Sep 2008 16:11:31 +0900
From: "Kyungmin Park" <kmpark@infradead.org>
To: moorthy.apg@samsung.com
Subject: Re: [ANNOUNCE] [PATCH] [MTD] Flex-OneNAND MTD Driver available.
Cc: linux-mtd@lists.infradead.org, "Kyungmin Park" <kyungmin.park@samsung.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <19198934.52871221827459790.JavaMail.weblogic@epml16>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19198934.52871221827459790.JavaMail.weblogic@epml16>
X-Google-Sender-Auth: f6b02d234b66c37f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It's another fusion device intergrage SLC & MLC NAND into just one
chip. So I added cc LKML.

It looks good to me except some unclean variable & syntactic usages.
Please clarify it and give more descriptions.

Thank you,
Kyungmin Park

On Fri, Sep 19, 2008 at 9:31 PM, AYYANARPONNUSAMY GANGHEYAMOORTHY
<moorthy.apg@samsung.com> wrote:
> Hi All,
> We are happy to release Flex-OneNAND MTD to open source community.
>
> Brief description of Flex-OneNAND :
> Samsung Flex-OneNAND is a highly reliable embedded memory targeted
> for both consumer electronics, and next generation mobile phone market.
> With Samsung's accumulated NAND flash technologies over the last decade,
> Samsung designs an ideal single memory chip based on NAND architecture
> integrating SRAM buffers and logic interface. Samsung Flex-OneNAND takes
> both advantages from high-speed data read function of NOR flash and the
> advanced data storage function of NAND flash.
>
> Flex-OneNAND combines SLC and MLC technologies into a single device.
> SLC area provides increased reliability and speed, suitable for storing
> code and data, such as bootloader, kernel and root file system.
> MLC area provides high density and is best used for storing user data.
> Users can configure the size of SLC and MLC regions.
>
> Refer (http://www.samsung.com/global/business/semiconductor/products/fusionmemory/Products_FlexOneNAND.html)
>
> Existing MTD does not allow for erase regions with odd number
> of blocks(partitions turn read only). So it is better to set
> the die boundary to odd values. Die boundary setting can be
> done in include/mtd/onenand.h
>
> A partition, theoretically,  can span across SLC and MLC regions.
> There is no apparent advantage with it however. Also, such a
> partition will have MLC erase size, with two SLC blocks erased at
> a time during operation. If the second block goes bad, we end up
> marking the first block as bad. So, again, it is not advisable
> to create partitions across erase regions.
>
> Apart from this patch, some more posts for Flex-OneNAND support are
> 1. JFFS2        [PATCH 1/1] [MTD] [JFFS2] MLC NAND support
>        [PATCH 1/2] [MTD] [JFFS2] MLC NAND support
>
> 2. MTD-UTILS    [PATCH] [MTD-UTILS] Add support for 4KB page flash devices
>
> 3. UBOOT        [U-Boot] [PATCH] FlexOneNAND support in U-Boot
>               (Posted in http://lists.denx.de/mailman/listinfo/u-boot)
>
> Signed-off-by: Vishak G <vishak.g@samsung.com>
> Signed-off-by: Rohit Hagargundgi <h.rohit@samsung.com>



> ---
> diff --git a/drivers/mtd/onenand/onenand_base.c b/drivers/mtd/onenand/onenand_base.c
> index 926cf3a..42c19cb 100644
> --- a/drivers/mtd/onenand/onenand_base.c
> +++ b/drivers/mtd/onenand/onenand_base.c
> @@ -9,6 +9,10 @@
>  *     auto-placement support, read-while load support, various fixes
>  *     Copyright (C) Nokia Corporation, 2007
>  *
> + *     Vishak G <vishak.g@samsung.com>, Rohit Hagargundgi <h.rohit@samsung.com>
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
> +static int boundary[] = {
> +       FLEXONENAND_DIE0_BOUNDARY,
> +       FLEXONENAND_DIE1_BOUNDARY,
> +};
> +
> +static int lock[] = {
> +       FLEXONENAND_DIE0_ISLOCKED,
> +       FLEXONENAND_DIE1_ISLOCKED,
> +};

Is it really needed? and is it changed at runtime? If not please add 'const'.

> +
> +/**
> + *  onenand_oob_128 - oob info for Flex-Onenand with 4KB page
> + */
> +static struct nand_ecclayout onenand_oob_128 = {
> +       .eccbytes       = 80,
> +       .eccpos         = {
> +               6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
> +               22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
> +               38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
> +               54, 55, 56, 57, 58, 59, 60, 61, 62, 63,
> +               70, 71, 72, 73, 74, 75, 76, 77, 78, 79,
> +               86, 87, 88, 89, 90, 91, 92, 93, 94, 95,
> +               102, 103, 104, 105, 106, 107, 108, 109, 110, 111,
> +               118, 119, 120, 121, 122, 123, 124, 125, 126, 127
> +               },
> +       .oobfree        = {
> +               {2, 4}, {16, 6}, {32, 6}, {48, 6},
> +               {64, 6}, {80, 6}, {96, 6}, {112, 6}
> +       }
> +};

Even though we use 2nd Bad block Information (BI) we leave it. It uses
provided spare area. As you know, it's enough.


>        if (page != -1) {
>                /* Now we use page size operation */
> -               int sectors = 4, count = 4;
> +               int sectors = 0, count = 0;
>                int dataram;

The '0' means all sectors.

>
> +/**
> + * flexonenand_unlock_all - [Flex-OneNAND Interface] unlock all blocks
> + * @param mtd          MTD device structure
> + *
> + * Unlock all blocks
> + */
> +static int flexonenand_unlock_all(struct mtd_info *mtd)
> +{
> +       struct onenand_chip *this = mtd->priv;
> +       size_t len = mtd->erasesize;
> +
> +       if (mtd->numeraseregions > 1)
> +               len >>= 1;
> +
> +       onenand_do_lock_cmd(mtd, 0, len, ONENAND_CMD_UNLOCK_ALL);
> +       if (ONENAND_IS_DDP(this))
> +               onenand_do_lock_cmd(mtd, this->diesize[0], len,
> +                                                ONENAND_CMD_UNLOCK_ALL);
> +       onenand_check_lock_status(this);
> +       return 0;
> +}

Does it need to define unlock all for Flex-OneNAND?
I think it's same between OneNAND and Flex-OneNAND. Is it some chip
specific problem?

> +
>  #ifdef CONFIG_MTD_ONENAND_OTP
>

> -       ret = onenand_write_oob_nolock(mtd, from, &ops);
> +       ret = FLEXONENAND(this) ?
> +               onenand_write_ops_nolock(mtd, (mtd->writesize * 49), &ops)
> +               : onenand_write_oob_nolock(mtd, from, &ops);

Please describe why we multiply the '49' as mentioned below.

> @@ -2428,25 +2680,32 @@
>                        size_t len)
>  {
>        struct onenand_chip *this = mtd->priv;
> -       u_char *oob_buf = this->oob_buf;
> +       u_char *oob_buf = FLEXONENAND(this) ? this->page_buf : this->oob_buf;

How about the define 'buf' instead of 'oob_buf'.

>        size_t retlen;
>        int ret;
>
> -       memset(oob_buf, 0xff, mtd->oobsize);
> +       memset(oob_buf, 0xff, FLEXONENAND(this) ? this->writesize
> +                                                : mtd->oobsize);
>        /*
>         * Note: OTP lock operation
>         *       OTP block : 0xXXFC
>         *       1st block : 0xXXF3 (If chip support)
>         *       Both      : 0xXXF0 (If chip support)
>         */
> -       oob_buf[ONENAND_OTP_LOCK_OFFSET] = 0xFC;
> +       if (FLEXONENAND(this))
> +               oob_buf[FLEXONENAND_OTP_LOCK_OFFSET] = 0xFC;
> +       else
> +               oob_buf[ONENAND_OTP_LOCK_OFFSET] = 0xFC;
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
>        ret = onenand_otp_walk(mtd, from, len, &retlen, oob_buf, do_otp_lock, MTD_OTP_USER);
>
> @@ -2495,6 +2754,14 @@
>                break;
>        }
>
>
>         ddp = device & ONENAND_DEVICE_IS_DDP;
>         density = onenand_get_density(device);
> -        printk(KERN_INFO "%sOneNAND%s %dMB %sV 16-bit (0x%02x)\n",
> -                demuxed ? "" : "Muxed ",
> +       flexonenand = device & DEVICE_IS_FLEXONENAND;
> +       printk(KERN_INFO "%s%sOneNAND%s %dMB %sV 16-bit (0x%02x)\n",
> +               flexonenand ? "Flex-" : "",
> +               demuxed ? "" : "Mux",

Please display pin type and Flex such as, Muxed {Flex-}OneNAND

>                 ddp ? "(DDP)" : "",
>                 (16 << density),
>                 vcc ? "2.65/3.3" : "1.8",
>                 device);
> -       printk(KERN_INFO "OneNAND version = 0x%04x\n", version);
> +       printk(KERN_INFO "%sOneNAND version = 0x%04x\n",
> +       flexonenand ? "Flex-" : "", version);

Does it need to display Flex here?

>  }
>
>  static const struct onenand_manufacturers onenand_manuf_ids[] = {
> @@ -2558,6 +2828,181 @@
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
> +       this->write_word((syscfg | 0x0100), this->base + ONENAND_REG_SYS_CFG1);
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
> +                      this->boundary[die], locked ? "(Locked)" : "(Unlocked)");
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
> +void get_flexonenand_size(struct mtd_info *mtd)

Please make it 'static'.

> +{
> +       struct onenand_chip *this = mtd->priv;

>        /* Pages per a block are always 64 in OneNAND */
>        mtd->erasesize = mtd->writesize << 6;
> -
> +       mtd->erasesize <<= FLEXONENAND(this) ? 1 : 0;

Please add description Flex-OneNAND has always 128 pages per a block.

>        this->erase_shift = ffs(mtd->erasesize) - 1;
>        this->page_shift = ffs(mtd->writesize) - 1;
>        this->page_mask = (1 << (this->erase_shift - this->page_shift)) - 1;
> @@ -2632,7 +3092,20 @@
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
> @@ -2749,6 +3222,10 @@
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
> @@ -2768,6 +3245,10 @@
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
> @@ -2812,7 +3293,8 @@
>        mtd->owner = THIS_MODULE;
>
>        /* Unlock whole block */
> -       onenand_unlock_all(mtd);
> +       FLEXONENAND(this) ? flexonenand_unlock_all(mtd)
> +                        : onenand_unlock_all(mtd);
>
>        return this->scan_bbt(mtd);
>  }
> @@ -2843,6 +3325,8 @@
>                kfree(this->page_buf);
>        if (this->options & ONENAND_OOBBUF_ALLOC)
>                kfree(this->oob_buf);
> +       if (FLEXONENAND(this))
> +               kfree(mtd->eraseregions);
>  }
>
>  EXPORT_SYMBOL_GPL(onenand_scan);
> diff --git a/drivers/mtd/onenand/onenand_bbt.c b/drivers/mtd/onenand/onenand_bbt.c
> --- a/drivers/mtd/onenand/onenand_bbt.c
> +++ b/drivers/mtd/onenand/onenand_bbt.c
> @@ -60,6 +60,7 @@
>        struct bbm_info *bbm = this->bbm;
>        int i, j, numblocks, len, scanlen;
>        int startblock;
> +       unsigned slc;
>        loff_t from;
>        size_t readlen, ooblen;
>        struct mtd_oob_ops ops;

Initialize the slc as '0'.

> @@ -76,7 +77,7 @@
>        /* Note that numblocks is 2 * (real numblocks) here;
>         * see i += 2 below as it makses shifting and masking less painful
>         */
> -       numblocks = mtd->size >> (bbm->bbt_erase_shift - 1);
> +       numblocks = this->chipsize >> (bbm->bbt_erase_shift - 1);
>        startblock = 0;
>        from = 0;
>
> @@ -106,7 +107,13 @@
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
> @@ -143,7 +150,7 @@
>        uint8_t res;
>
>        /* Get block number * 2 */
> -       block = (int) (offs >> (bbm->bbt_erase_shift - 1));
> +       block = (int) (onenand_get_block(mtd, offs, NULL) << 1);
>        res = (bbm->bbt[block >> 3] >> (block & 0x06)) & 0x03;
>
>        DEBUG(MTD_DEBUG_LEVEL2, "onenand_isbad_bbt: bbt info for offs 0x%08x: (block %d) 0x%02x\n",
> @@ -178,7 +185,7 @@
>        struct bbm_info *bbm = this->bbm;
>        int len, ret = 0;
>
> -       len = mtd->size >> (this->erase_shift + 2);
> +       len = this->chipsize >> (this->erase_shift + 2);
>        /* Allocate memory (2bit per block) and clear the memory bad block table */
>        bbm->bbt = kzalloc(len, GFP_KERNEL);
>        if (!bbm->bbt) {

> diff --git a/include/linux/mtd/onenand.h b/include/linux/mtd/onenand.h
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
> @@ -51,6 +67,11 @@
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
> @@ -92,9 +113,14 @@
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
> @@ -145,6 +171,8 @@
>  #define ONENAND_SET_BUFFERRAM0(this)           (this->bufferram_index = 0)
>  #define ONENAND_SET_BUFFERRAM1(this)           (this->bufferram_index = 1)
>
> +#define FLEXONENAND(this)                                              \
> +       (this->device_id & DEVICE_IS_FLEXONENAND)
>  #define ONENAND_GET_SYS_CFG1(this)                                     \
>        (this->read_word(this->base + ONENAND_REG_SYS_CFG1))
>  #define ONENAND_SET_SYS_CFG1(v, this)                                  \
> @@ -153,6 +181,9 @@
>  #define ONENAND_IS_DDP(this)                                           \
>        (this->device_id & ONENAND_DEVICE_IS_DDP)
>
> +#define ONENAND_IS_MLC(this)                                           \
> +       (this->technology & ONENAND_TECHNOLOGY_IS_MLC)
> +
>  #ifdef CONFIG_MTD_ONENAND_2X_PROGRAM
>  #define ONENAND_IS_2PLANE(this)                                                \
>        (this->options & ONENAND_HAS_2PLANE)
> @@ -189,5 +220,7 @@
>
>  int onenand_bbt_read_oob(struct mtd_info *mtd, loff_t from,
>                         struct mtd_oob_ops *ops);
> +unsigned onenand_get_block(struct mtd_info *mtd, loff_t addr,
> +                        unsigned *isblkslc);
>
>  #endif /* __LINUX_MTD_ONENAND_H */
> diff --git a/include/linux/mtd/onenand_regs.h b/include/linux/mtd/onenand_regs.h
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
> @@ -190,10 +203,12 @@
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
> diff --git a/include/mtd/mtd-abi.h b/include/mtd/mtd-abi.h
> --- a/include/mtd/mtd-abi.h
> +++ b/include/mtd/mtd-abi.h
> @@ -102,7 +102,11 @@
>        uint32_t useecc;
>        uint32_t eccbytes;
>        uint32_t oobfree[8][2];
> +#ifdef CONFIG_MTD_ONENAND
> +       uint32_t eccpos[128];
> +#else
>        uint32_t eccpos[32];
> +#endif
>  };
>
>  struct nand_oobfree {
> @@ -117,7 +121,11 @@
>  */
>  struct nand_ecclayout {
>        uint32_t eccbytes;
> +#ifdef CONFIG_MTD_ONENAND
> +       uint32_t eccpos[128];
> +#else
>        uint32_t eccpos[64];
> +#endif
>        uint32_t oobavail;
>        struct nand_oobfree oobfree[MTD_MAX_OOBFREE_ENTRIES];
>  };
>
>
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
>
