Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab0BEJob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 04:44:31 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:47547 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab0BEJo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 04:44:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Pl4y5d0JyWXPGNXYzkXnLlRQv5nLDD8ukuQvvpW1nkqGKFwbcT2/UgpUtS0msQGofT
         Nhh4MMluYHIjU6jcdrezfj6Qg21jtIO4IbTatEpJiVlbxTKT9bcEGZcmQk08tNSEg3ds
         d9zTuhyx7DPvvbsgoq2l3mv3eDTKtY3eWN5s4=
Subject: Re: [PATCH 11/17] MTD: nand: fix bug that prevented write of more
 that	one page by ->write_oob
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "stanley.miao" <stanley.miao@windriver.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Alex Dubov <oakad@yahoo.com>,
       Artem Bityutskiy <dedekind1@gmail.com>, joern <joern@logfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4B6B81AD.40704@windriver.com>
References: <1265326257-4446-1-git-send-email-maximlevitsky@gmail.com>
	 <1265326257-4446-12-git-send-email-maximlevitsky@gmail.com>
	 <4B6B81AD.40704@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 11:44:23 +0200
Message-ID: <1265363063.15383.27.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-05 at 10:25 +0800, stanley.miao wrote: 
> ops->ooblen is the oob bytes to write, you add a argument for 
> nand_fill_oob to do this,
> it is redundant.
No its not.
ops->ooblen can be legitimately larger that mtd->oobsize because user
might want to write two or more pages in a row.

I want to be able to write two pages + two oobs in same time.



> 
> I know the bug you want to fix, the ops->ooblen may be illegal. But this 
> patch can't this
> problem. If (ops->offset + ops->ooblen) > mtd->oobsize, it still will 
> write beyond a page.
This is true, I just didn't use the ops->offset....


> 
> I think the right method is that nand_do_write_ops do the check like 
> nand_do_write_oob,
> I have the patch yesterday.
> 
> http://patchwork.ozlabs.org/patch/44450/
This again won't work for multipage writes I have in mind.
However if ops->ooboffs is set, I think multipage write shouldn't be
allowed

This is:

if (ops->ooboffs && (ops->ooboffs + ops->ooblen) > len))

Also check for 'ops->ooboffs >= len' is almost redundant.
Only case it would trigger is when 'ops->ooblen == 0'
But this probably can be dealt with, without error.

Best regards,
Maxim Levitsky

> 
> Stanley.
> 
> Maxim Levitsky wrote:
> > Although nand_do_write_ops intends to allow such mode, it fails do do so
> > Probably this was never tested
> >
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > ---
> >  drivers/mtd/nand/nand_base.c |   16 +++++++++-------
> >  1 files changed, 9 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> > index 8ff36be..29e986e 100644
> > --- a/drivers/mtd/nand/nand_base.c
> > +++ b/drivers/mtd/nand/nand_base.c
> > @@ -1879,11 +1879,9 @@ static int nand_write_page(struct mtd_info *mtd, struct nand_chip *chip,
> >   * @oob:	oob data buffer
> >   * @ops:	oob ops structure
> >   */
> > -static uint8_t *nand_fill_oob(struct nand_chip *chip, uint8_t *oob,
> > -				  struct mtd_oob_ops *ops)
> > +static uint8_t *nand_fill_oob(struct nand_chip *chip, uint8_t *oob, size_t len,
> > +						struct mtd_oob_ops *ops)
> >   
> 
> ops->ooblen is the oob bytes to write, you add a prara
> 
> >  {
> > -	size_t len = ops->ooblen;
> > -
> >  	switch(ops->mode) {
> >  
> >  	case MTD_OOB_PLACE:
> > @@ -1938,6 +1936,7 @@ static int nand_do_write_ops(struct mtd_info *mtd, loff_t to,
> >  	int chipnr, realpage, page, blockmask, column;
> >  	struct nand_chip *chip = mtd->priv;
> >  	uint32_t writelen = ops->len;
> > +	uint32_t oobwritelen = ops->ooblen;
> >  	uint8_t *oob = ops->oobbuf;
> >  	uint8_t *buf = ops->datbuf;
> >  	int ret, subpage;
> > @@ -1994,8 +1993,11 @@ static int nand_do_write_ops(struct mtd_info *mtd, loff_t to,
> >  			wbuf = chip->buffers->databuf;
> >  		}
> >  
> > -		if (unlikely(oob))
> > -			oob = nand_fill_oob(chip, oob, ops);
> > +		if (unlikely(oob)) {
> > +			size_t len = min(oobwritelen, mtd->oobsize);
> > +			oob = nand_fill_oob(chip, oob, len, ops);
> > +			oobwritelen -= len;
> > +		}
> >  
> >  		ret = chip->write_page(mtd, chip, wbuf, page, cached,
> >  				       (ops->mode == MTD_OOB_RAW));
> > @@ -2169,7 +2171,7 @@ static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
> >  		chip->pagebuf = -1;
> >  
> >  	memset(chip->oob_poi, 0xff, mtd->oobsize);
> > -	nand_fill_oob(chip, ops->oobbuf, ops);
> > +	nand_fill_oob(chip, ops->oobbuf, ops->ooblen, ops);
> >  	status = chip->ecc.write_oob(mtd, chip, page & chip->pagemask);
> >  	memset(chip->oob_poi, 0xff, mtd->oobsize);
> >  
> >   
> 


