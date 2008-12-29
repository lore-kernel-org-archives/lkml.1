Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbYL2Uge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbYL2Uge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYL2Ueh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:34:37 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:48221 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752702AbYL2Ueb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:34:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=MTo0YFPbiBhnc9oldePEuks3JEHKN2w+MBmxj+M7SbZrYOP51TsODBw+c1EGWVxUB0ko6o4eC+zc2Ep36ax9y3K7umaMGnRfognI3kXJPe12SNnrO1n8WIPzNyIlXFxpqw3mI1gBx34+hdBGLfkfXHp42oAEUT/oPrw4OSp5liA=  ;
X-YMail-OSG: Yw1AmgQVM1ljCGmcZUH08w_X_5PvSOWrR6v2fgc_4a_hcGdRUyeU5u_JDfryGifuZBUoV_R8tET21RM0kJHRCfPXS4S9..oitKgVSpPwUXtMKaGTtf_0UW4pWO.N4GH2bA6QLEXMGnbb5LX3B2_GGv._
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Eric Miao" <eric.y.miao@gmail.com>,
       "Jaya Kumar" <jayakumar.lkml@gmail.com>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add batch set/get
Date: Mon, 29 Dec 2008 12:33:38 -0800
User-Agent: KMail/1.9.10
Cc: "Eric Miao" <eric.miao@marvell.com>,
       "Paulius Zaleckas" <paulius.zaleckas@teltonika.lt>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Sam Ravnborg" <sam@ravnborg.org>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <1230395048446-git-send-email-jayakumar.lkml@gmail.com> <f17812d70812281938h1b8ad9ecq49a460ac7786ae76@mail.gmail.com>
In-Reply-To: <f17812d70812281938h1b8ad9ecq49a460ac7786ae76@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812291233.39258.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm a bit surprised to see patches against 2.6.27, rather
than a 2.6.28 (or 2.6.28-rc) kernel.  ;)


On Sunday 28 December 2008, Eric Miao wrote:
> > @@ -200,8 +203,12 @@ static void am300_set_hdb(struct broadsheetfb_par *par, u16 data)
> >  {
> >        int i;
> >
> > +#ifdef CONFIG_GPIOLIB_BATCH
> > +       gpio_set_batch(DB0_GPIO_PIN, data, 0xFFFF, 16);
> > +#else
> >        for (i = 0; i <= (DB15_GPIO_PIN - DB0_GPIO_PIN) ; i++)
> >                gpio_set_value(DB0_GPIO_PIN + i, (data >> i) & 0x01);
> > +#endif
> 
> Well, if AM300 selects GPIOLIB_BATCH, I don't think we need the
> gpio_set_value() stuffs, and get rid of this #ifdef completely.

Right ... although we don't *have* a GPIOLIB_BATCH,
so that's not (yet?) an option.


> > @@ -1056,6 +1056,128 @@ void __gpio_set_value(unsigned gpio, int value)
> >  }
> >  EXPORT_SYMBOL_GPL(__gpio_set_value);
> >
> > +#ifdef CONFIG_GPIOLIB_BATCH
> > +/**
> > + * __gpio_set_batch() - assign a batch of gpio pins together
> > + * @gpio: starting gpio pin
> > + * @values: values to assign, sequential and including masked bits
> > + * @bitmask: bitmask to be applied to values
> > + * @bitwidth: width inclusive of masked-off bits
> > + * Context: any
> > + *
> > + * This is used directly or indirectly to implement gpio_set_value().
> > + * It invokes the associated gpio_chip.set_batch() method. If that
> > + * method does not exist for any segment that is involved, then it drops
> > + * back down to standard gpio_chip.set()
> > + */
> > +void __gpio_set_batch(unsigned gpio, u32 values, u32 bitmask, int bitwidth)
> > +{
> > +       struct gpio_chip *chip;
> > +       int i = 0;
> > +       int value, width, remwidth;
> > +       u32 mask;
> > +
> > +       do {
> > +               chip = gpio_to_chip(gpio + i);
> > +               WARN_ON(extra_checks && chip->can_sleep);
> > +
> > +               if (!chip->set_batch) {
> > +                       while (((gpio + i) < (chip->base + chip->ngpio))
> > +                               && bitwidth) {
> > +                               mask = 1 << i;
> > +                               value = values & mask;
> > +                               if (bitmask & mask)
> > +                                       chip->set(chip, gpio + i - chip->base,
> > +                                                       value);
> > +                               i++;
> > +                               bitwidth--;
> 
> I recommend this being put into something like 'default_gpio_set_batch', and
> assign this to 'chip->set_batch' when the gpio chip is being registered and
> found 'chip->set_batch == NULL', so to keep this block consistent.
> 
> Same comment to the 'get_batch' implementation below.

Right ... this is something I had suggested earlier:  make
sure that the (renamed) "batch" interfaces don't depend on
some TBD extension to gpio_chip.

Those extensions should be just an optimization.

