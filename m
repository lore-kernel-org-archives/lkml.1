Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbXFSH43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbXFSH43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 03:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbXFSH4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 03:56:22 -0400
Received: from smtp.nokia.com ([131.228.20.172]:26978 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbXFSH4V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 03:56:21 -0400
Subject: Re: [PATCH/RFC] oops and panic message logging to MTD
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Richard Purdie <rpurdie@openedhand.com>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1182184301.6074.62.camel@localhost.localdomain>
References: <1182184301.6074.62.camel@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Date: Tue, 19 Jun 2007 10:55:49 +0300
Message-Id: <1182239749.4403.48.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 19 Jun 2007 07:55:49.0072 (UTC) FILETIME=[40126D00:01C7B247]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-18 at 17:31 +0100, Richard Purdie wrote:
> +static int mtdoops_erase_block(struct mtd_info *mtd, int offset)
> +{
> +	struct erase_info erase;
> +	DECLARE_WAITQUEUE(wait, current);
> +	wait_queue_head_t wait_q;
> +	int ret;
> +
> +	init_waitqueue_head(&wait_q);
> +	erase.mtd = mtd;
> +	erase.callback = mtdoops_erase_callback;
> +	erase.addr = offset;
> +	if (mtd->erasesize < OOPS_PAGE_SIZE)
> +		erase.len = OOPS_PAGE_SIZE;

It seems to me that your code won't work if mtd->erasesize <
OOPS_PAGE_SIZE anyway, so this check should not be here I guess.


> +	ret = mtd->read(mtd, cxt->nextpage * OOPS_PAGE_SIZE, 4,
> +			&retlen, (u_char *) &count);
> +	if ((retlen != 4) || (ret < 0)) {
> +		printk(KERN_ERR "mtdoops: Read failure at %d (%d of 4 read)"
> +				", err %d.\n", cxt->nextpage * OOPS_PAGE_SIZE,
> +				retlen, ret);
> +		return 1;
> +	}

mtd->read() returns -EUCLEAN in case of a correctable bit-flip, ignore
this error code here and elsewhere as well please.

> +static void mtdoops_prepare(struct mtdoops_context *cxt)
> +{
> +	struct mtd_info *mtd = cxt->mtd;
> +	int i = 0, j, ret, mod;
> +
> +	/* We were unregistered */
> +	if (!mtd)
> +		return;
> +
> +	mod = (cxt->nextpage * OOPS_PAGE_SIZE) % mtd->erasesize;
> +	if (mod != 0) {
> +		cxt->nextpage = cxt->nextpage + ((mtd->erasesize - mod) / OOPS_PAGE_SIZE);
> +		if (cxt->nextpage > cxt->oops_pages)
> +			cxt->nextpage = 0;
> +	}
> +
> +	while (mtd->block_isbad &&
> +			mtd->block_isbad(mtd, cxt->nextpage * OOPS_PAGE_SIZE)) {

Well, mtd->block_isbad() may return error, unlikely, bu still. You also
ignore the error at other places.

> +badblock:
> +		printk(KERN_WARNING "mtdoops: Bad block at %08x\n",
> +				cxt->nextpage * OOPS_PAGE_SIZE);
> +		i++;
> +		cxt->nextpage = cxt->nextpage + (mtd->erasesize / OOPS_PAGE_SIZE);
> +		if (cxt->nextpage > cxt->oops_pages)
> +			cxt->nextpage = 0;
> +		if (i == (cxt->oops_pages / (mtd->erasesize / OOPS_PAGE_SIZE))) {
> +			printk(KERN_ERR "mtdoops: All blocks bad!\n");
> +			return;
> +		}
> +	}
> +
> +	for (j = 0, ret = -1; (j < 3) && (ret < 0); j++)
> +		ret = mtdoops_erase_block(mtd, cxt->nextpage * OOPS_PAGE_SIZE);

Ugh, why do you make it this difficult way instead of

for (all EBs) {
    ret = erase()
    if (ret == -EIO) {
        markbad();
    } else
        return err;
}

> +
> +	if (ret < 0) {
> +		if (mtd->block_markbad)
> +			mtd->block_markbad(mtd, cxt->nextpage * OOPS_PAGE_SIZE);
> +		goto badblock;

Please, mark EB as bad only in case of -EIO. Also, do not ignore error
code of mtd->block_markbad()


Is it possible to re-structure the code and erase/check if EB is bad in
_one_ cycle (thus avoiding this goto which is difficult to understand)?

Surely all you want is to format the partition. So make a loop, skip bad
EBs and erase good ones. In case of erase failure (-EIO) mark the EB as
bad.

> +static int find_next_position(struct mtdoops_context *cxt)
> +{
> +	struct mtd_info *mtd = cxt->mtd;
> +	int page, maxpos = 0;
> +	u32 count, maxcount = 0xffffffff;
> +	size_t retlen;
> +
> +	for (page = 0; page < cxt->oops_pages; page++) {
> +		mtd->read(mtd, page * OOPS_PAGE_SIZE, 4, &retlen, (u_char *) &count);

Please, check return code here.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

