Return-Path: <linux-kernel-owner+w=401wt.eu-S1758058AbYG2Kic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058AbYG2Kic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 06:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbYG2KiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 06:38:23 -0400
Received: from [210.82.31.146] ([210.82.31.146]:36424 "EHLO mx.linux.net.cn"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754893AbYG2KiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:38:22 -0400
X-Greylist: delayed 1704 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jul 2008 06:38:22 EDT
Date: Tue, 29 Jul 2008 17:58:34 +0800
From: Wang Jian <lark@linux.net.cn>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>, Wang Jian <lark@linux.net.cn>
Subject: 2.6.26-rc8 nftl + nand(diskonchip) + powerpc = crash + no work
Message-ID: <20080729095834.GA3291@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am off list so please CC: me.

I have problem when I try to make DOC2000 work on a powerpc dev board.
The DOC2000 is 8bit so I add 

#elif defined(__powerpc__)
#define ReadDOC_(adr, reg)      ((unsigned char)(*(volatile __u8 *)(((unsigned long)adr)+(reg))))
#define WriteDOC_(d, adr, reg)  do{ *(volatile __u8 *)(((unsigned long)adr)+((reg))) = (__u8)d; wmb();} while(0)
#define DOC_IOREMAP_LEN 0x2000
#else

to include/linux/mtd/doc2000.h. After this modification, the doc2000 can
be probed correctly.

But fdisk/mke2fs write on /dev/nftla will crash. I trace down to
driver/mtd/nftlcore.c

/*
 * Write data and oob to flash
 */
static int nftl_write(struct mtd_info *mtd, loff_t offs, size_t len,
		      size_t *retlen, uint8_t *buf, uint8_t *oob)
{
	struct mtd_oob_ops ops;
	int res;

	ops.mode = MTD_OOB_PLACE;
	ops.ooboffs = offs;
	// --> should be ops.ooboffs = offs & (mtd->writesize - 1); ???
	ops.ooblen = mtd->oobsize;
	ops.oobbuf = oob;
	ops.datbuf = buf;
	ops.len = len;

	res = mtd->write_oob(mtd, offs & ~(mtd->writesize - 1), &ops);
	*retlen = ops.retlen;
	return res;
}

This is the only place that offs assigned to ops.ooboffs without
masking. Then in drivers/mtd/nand/nand_base.c 

static uint8_t *nand_fill_oob(struct nand_chip *chip, uint8_t *oob,
				  struct mtd_oob_ops *ops)
{
------ snip ------
		memcpy(chip->oob_poi + ops->ooboffs, oob, len);
------ snip ------

This triggers the crash.

Fixing this does prevent fdisk/mke2fs from crash, but fdisk/mke2fs can't
work either. Hexdump tells me that it is all zero after write.

The questions are:

1. The DOC2000 can be correctly probed, (size correctly reported), then
the doc2000.h modification is correct and enough?

2. ops.ooboffs = offs; is intended here, or actually a bug?

3. what I can do next to find why no data is written?
