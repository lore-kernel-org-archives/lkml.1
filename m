Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZBYNFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZBYNFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 08:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbZBYNFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 08:05:22 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:42787 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbZBYNFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 08:05:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OXigujcrxqrKwHMKLjyzXdtmNsqdx+SNToUd2eZMHTh2HQKRUO/YD0W8hcc1oVf/oT
         33TbhRU10XSFgodWAbtR57YIO3BWulWVCT/gP6/KcEUEuli9limqBeqEjR2AplM9sULi
         7OpC4uwKOFFEXJpFTTqC/Tfr6vanhvArTpdx8=
MIME-Version: 1.0
In-Reply-To: <200902242012.06447.david-b@pacbell.net>
References: <200902241509.54649.david-b@pacbell.net>
	 <82ecf08e0902241755y5a7be725gb84116433b7d3be2@mail.gmail.com>
	 <200902242012.06447.david-b@pacbell.net>
Date: Wed, 25 Feb 2009 10:05:18 -0300
Message-ID: <82ecf08e0902250505l59f6ddebo9789d205e46b7751@mail.gmail.com>
Subject: Re: [patch/RESEND 2.6.29-rc3-git] NAND: davinci_nand driver
From: Thiago Galesi <thiagogalesi@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: Linux MTD <linux-mtd@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       DaVinci <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 1:12 AM, David Brownell <david-b@pacbell.net> wrote:
> On Tuesday 24 February 2009, Thiago Galesi wrote:
>> OK a couple of things
>>  +
>> > +
>> > +#ifdef CONFIG_MTD_PARTITIONS
>> > +static inline int mtd_has_partitions(void) { return 1; }
>> > +#else
>> > +static inline int mtd_has_partitions(void) { return 0; }
>> > +#endif
>
> My preference would be to have those functions live in the
> MTD headers.
>
> Needing #ifdefs in the body of probe() is *extremely* error
> prone.  Having function versions makes it harder to commit
> a lot of the common errors I've seen, like having some mix
> of options gratuitously break compiles because of missing
> code fragments or variable declarations.  It also makes it
> easier to see when code is obviously doing the wrong thing.

Agreed. Especially about having #ifdefs in probe, no question about
that, this way is _much_better_

>
> Note that #ifdefs-in-functions is contrary to standard
> kernel coding practices.

Yes, I know (and agree with) that 100% :)

>
> I too would like to see <linux/mtd/*.h> use u8/u32/etc.  But
> in this case, it's just doing what the MTD framework does.
> If I used u8/u32/etc the usual feedback would be "do what
> all the other drivers do", "match the interface decls", etc.

Yes, that happens a lot. But a movement towards 'the right way' is
always welcome.

>
>> > +static void nand_davinci_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
>> > +{
>> > +       struct nand_chip *chip = mtd->priv;
>> > +
>> > +       if ((0x03 & ((unsigned)buf)) == 0 && (0x03 & len) == 0)
>> > +               ioread32_rep(chip->IO_ADDR_R, buf, len >> 2);
>> > +       else if ((0x01 & ((unsigned)buf)) == 0 && (0x01 & len) == 0)
>>
>> What are those 0x03 and 0x01 (and other places as well), you'll have
>> to spell out those, preferably using defines.
>
> The "0x03" is "low two bits", "0x01" is "low one bit", etc.
> Those functions can't be used except when memory address
> is "naturally" aligned, and the data length likewise.
>
> You might have an argument if you suggested a comment were
> appropriate ... but those are very common idioms,

Oh, ok, now I get it. But this is still confusing. (Yes, put a comment there)
No need for the ifdefs though.

Also, in the case of non-aligned acesses what is commonly done goes like this:
you write the small unaligned part with 8/16 bit ops, then the rest
with 32 bit ops.

Maybe it's really not worth speedwise to do all of this, but this is
ARM after all :)


-- 
-
Thiago Galesi
