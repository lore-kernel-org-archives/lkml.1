Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbZBYEMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbZBYEMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbZBYEML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:12:11 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:26426 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753854AbZBYEMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:12:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LoGHRaHRPRW+7KhFzSrB2OfJMcTz/fOr0ezEOJcAdoHfKZeC2cptU1fumE55oF3z78EejdHP362yl96x+jR6yubVM1+4bUfo3erGwn9FSVLlIg/FgjL2FIV0B/8lr5FoKu3XXVnPj2AAarM1JDCD7fI1MIdkQrROQlQ+2oT+8LM=  ;
X-YMail-OSG: 3551BbAVM1lkjf._87eMAhYWTxdEv.FXhCjaWt6Oe5jv6lGAsVVYAZmYxQK0rnJZe0WrbEghjdAruLZRWQ8rbnG1oc1LXaK3wfHO0Sb6SdauWKhqRlUm2Qka60OmnniTDkEJFhhgwlUrA7ymzAQczF.m
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Thiago Galesi <thiagogalesi@gmail.com>
Subject: Re: [patch/RESEND 2.6.29-rc3-git] NAND: davinci_nand driver
Date: Tue, 24 Feb 2009 20:12:06 -0800
User-Agent: KMail/1.9.10
Cc: Linux MTD <linux-mtd@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       DaVinci <davinci-linux-open-source@linux.davincidsp.com>
References: <200902241509.54649.david-b@pacbell.net> <82ecf08e0902241755y5a7be725gb84116433b7d3be2@mail.gmail.com>
In-Reply-To: <82ecf08e0902241755y5a7be725gb84116433b7d3be2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902242012.06447.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009, Thiago Galesi wrote:
> OK a couple of things
>  +
> > +
> > +#ifdef CONFIG_MTD_PARTITIONS
> > +static inline int mtd_has_partitions(void) { return 1; }
> > +#else
> > +static inline int mtd_has_partitions(void) { return 0; }
> > +#endif
> > +
> > +#ifdef CONFIG_MTD_CMDLINE_PARTS
> > +static inline int mtd_has_cmdlinepart(void) { return 1; }
> > +#else
> > +static inline int mtd_has_cmdlinepart(void) { return 0; }
> > +#endif
> 
> I'm not sure stylewise this is the best way. Even though #ifdefs stays
> outside of functions, this is a case where maybe it's better to put it
> inside or rething the need / usage for these functions.

My preference would be to have those functions live in the
MTD headers.

Needing #ifdefs in the body of probe() is *extremely* error
prone.  Having function versions makes it harder to commit
a lot of the common errors I've seen, like having some mix
of options gratuitously break compiles because of missing
code fragments or variable declarations.  It also makes it
easier to see when code is obviously doing the wrong thing.

Note that #ifdefs-in-functions is contrary to standard
kernel coding practices.  It persists in the MTD code
mostly due to legacy drivers, from what I can tell, which
do so because ... there's been no better option, such as
having those functions.


> > +static int nand_davinci_calculate_1bit(struct mtd_info *mtd,
> > +                                     const u_char *dat, u_char *ecc_code)
> 
> (and others)
> 
> My beef here is the use of u_char. This is really not a standart C
> type or a standart Linux type (u8/u32 etc), so we should aim for those
> (yes, I hate typing unsigned blah blah blah) but you can use u8 for
> that.

I too would like to see <linux/mtd/*.h> use u8/u32/etc.  But
in this case, it's just doing what the MTD framework does.
If I used u8/u32/etc the usual feedback would be "do what
all the other drivers do", "match the interface decls", etc.


> > +static void nand_davinci_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
> > +{
> > +       struct nand_chip *chip = mtd->priv;
> > +
> > +       if ((0x03 & ((unsigned)buf)) == 0 && (0x03 & len) == 0)
> > +               ioread32_rep(chip->IO_ADDR_R, buf, len >> 2);
> > +       else if ((0x01 & ((unsigned)buf)) == 0 && (0x01 & len) == 0)
> 
> What are those 0x03 and 0x01 (and other places as well), you'll have
> to spell out those, preferably using defines.

The "0x03" is "low two bits", "0x01" is "low one bit", etc.
Those functions can't be used except when memory address
is "naturally" aligned, and the data length likewise.

You might have an argument if you suggested a comment were
appropriate ... but those are very common idioms, used all
over the kernel without #defines that I've ever seen.  Did
you have suggestions for pre-existing symbols to use?

- Dave

