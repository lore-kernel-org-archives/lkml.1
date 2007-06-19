Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbXFSKBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbXFSKBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 06:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbXFSKBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 06:01:23 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:49521 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755134AbXFSKBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 06:01:22 -0400
Subject: Re: [PATCH/RFC] oops and panic message logging to MTD
From: Richard Purdie <rpurdie@openedhand.com>
To: dedekind@infradead.org
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1182239749.4403.48.camel@sauron>
References: <1182184301.6074.62.camel@localhost.localdomain>
	 <1182239749.4403.48.camel@sauron>
Content-Type: text/plain
Date: Tue, 19 Jun 2007 11:00:54 +0100
Message-Id: <1182247254.5760.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-19 at 10:55 +0300, Artem Bityutskiy wrote:
> On Mon, 2007-06-18 at 17:31 +0100, Richard Purdie wrote:
> > +	if (mtd->erasesize < OOPS_PAGE_SIZE)
> > +		erase.len = OOPS_PAGE_SIZE;
> 
> It seems to me that your code won't work if mtd->erasesize <
> OOPS_PAGE_SIZE anyway, so this check should not be here I guess.

Its just a sanity check...

> > +	ret = mtd->read(mtd, cxt->nextpage * OOPS_PAGE_SIZE, 4,
> > +			&retlen, (u_char *) &count);
> > +	if ((retlen != 4) || (ret < 0)) {
> > +		printk(KERN_ERR "mtdoops: Read failure at %d (%d of 4 read)"
> > +				", err %d.\n", cxt->nextpage * OOPS_PAGE_SIZE,
> > +				retlen, ret);
> > +		return 1;
> > +	}
> 
> mtd->read() returns -EUCLEAN in case of a correctable bit-flip, ignore
> this error code here and elsewhere as well please.

ok.

> > +static void mtdoops_prepare(struct mtdoops_context *cxt)
> > +{
> > +	struct mtd_info *mtd = cxt->mtd;
> > +	int i = 0, j, ret, mod;
> > +
> > +	/* We were unregistered */
> > +	if (!mtd)
> > +		return;
> > +
> > +	mod = (cxt->nextpage * OOPS_PAGE_SIZE) % mtd->erasesize;
> > +	if (mod != 0) {
> > +		cxt->nextpage = cxt->nextpage + ((mtd->erasesize - mod) / OOPS_PAGE_SIZE);
> > +		if (cxt->nextpage > cxt->oops_pages)
> > +			cxt->nextpage = 0;
> > +	}
> > +
> > +	while (mtd->block_isbad &&
> > +			mtd->block_isbad(mtd, cxt->nextpage * OOPS_PAGE_SIZE)) {
> 
> Well, mtd->block_isbad() may return error, unlikely, bu still. You also
> ignore the error at other places.

Ignoring that is deliberate since it doesn't really matter if the block
is bad or we can't read from it, the action is the same...

> > +badblock:
> > +		printk(KERN_WARNING "mtdoops: Bad block at %08x\n",
> > +				cxt->nextpage * OOPS_PAGE_SIZE);
> > +		i++;
> > +		cxt->nextpage = cxt->nextpage + (mtd->erasesize / OOPS_PAGE_SIZE);
> > +		if (cxt->nextpage > cxt->oops_pages)
> > +			cxt->nextpage = 0;
> > +		if (i == (cxt->oops_pages / (mtd->erasesize / OOPS_PAGE_SIZE))) {
> > +			printk(KERN_ERR "mtdoops: All blocks bad!\n");
> > +			return;
> > +		}
> > +	}
> > +
> > +	for (j = 0, ret = -1; (j < 3) && (ret < 0); j++)
> > +		ret = mtdoops_erase_block(mtd, cxt->nextpage * OOPS_PAGE_SIZE);
> 
> Ugh, why do you make it this difficult way instead of
> 
> for (all EBs) {
>     ret = erase()
>     if (ret == -EIO) {
>         markbad();
>     } else
>         return err;
> }

See below.

> > +
> > +	if (ret < 0) {
> > +		if (mtd->block_markbad)
> > +			mtd->block_markbad(mtd, cxt->nextpage * OOPS_PAGE_SIZE);
> > +		goto badblock;
> 
> Please, mark EB as bad only in case of -EIO. 

ok.

> Also, do not ignore error code of mtd->block_markbad()

All we can do is print a warning, the action will be the same...

> Is it possible to re-structure the code and erase/check if EB is bad in
> _one_ cycle (thus avoiding this goto which is difficult to understand)?
> 
> Surely all you want is to format the partition. So make a loop, skip bad
> EBs and erase good ones. In case of erase failure (-EIO) mark the EB as
> bad.

Its not a case of formatting the whole partition. The whole point of
this code is the following use case:

1. Device crashes
2. Device reboots
3. mtdoops partition has a log of why it crashed

If you erase the whole partition each time mtdoops loads, this won't
work so the code only finds the next block to use and erases that. It
keeps moving forwards until it finds that block.

I usually hate goto statements but in this case it simplifies the code a
lot (and it is on an error path). The alternative is a while loop with
several new variables, I tried it and it was more ugly/confusing...

> > +static int find_next_position(struct mtdoops_context *cxt)
> > +{
> > +	struct mtd_info *mtd = cxt->mtd;
> > +	int page, maxpos = 0;
> > +	u32 count, maxcount = 0xffffffff;
> > +	size_t retlen;
> > +
> > +	for (page = 0; page < cxt->oops_pages; page++) {
> > +		mtd->read(mtd, page * OOPS_PAGE_SIZE, 4, &retlen, (u_char *) &count);
> 
> Please, check return code here.

ok.

> Also, could you please use wait_event_interruptible() instead of
> set_current_state() which looks better (indeed, you have wait queue, 
> so use wq calls).

That piece of code is in keeping with the rest of the mtd erase handling
code. Looking through the various wq macros, I don't see any which help
particularly in this case...

Cheers,

Richard


