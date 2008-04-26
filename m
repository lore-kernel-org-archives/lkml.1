Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbYDZIia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbYDZIia (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 04:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYDZIiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 04:38:22 -0400
Received: from rv-out-0708.google.com ([209.85.198.245]:5242 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752398AbYDZIiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 04:38:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=msU1vWIsxL43MkdOfEbvqIFeL0889/ALQbIXiM9eJcIQvcJ+zJkBly+XuXnGxX4PK0RlIse6i7F5AmocCDE5FTp6pdZk4bjAv0f0QRjFW2Qkt2C6itiAdX04wFhVDLnWZA8WVQ6/9DPVDcVTQ/d1MUdLSF01OqBcKo7b8YI5MGg=
Message-ID: <bc64b4640804260138v29fada38m55f3e4c053aa1a41@mail.gmail.com>
Date: Sat, 26 Apr 2008 12:38:15 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 0/5] Clocklib: generic clocks framework
Cc: "Paul Walmsley" <paul@pwsan.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "pHilipp Zabel" <philipp.zabel@gmail.com>,
       "Pavel Machek" <pavel@ucw.cz>, tony@atomide.com, hiroshi.DOYU@nokia.com
In-Reply-To: <200804251546.52495.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080420082925.GA32739@doriath.ww600.siemens.net>
	 <alpine.DEB.1.00.0804210057000.17857@utopia.booyaka.com>
	 <bc64b4640804210148p2d1c2fe0qe469152fa1a9697e@mail.gmail.com>
	 <200804251546.52495.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/4/26 David Brownell <david-b@pacbell.net>:
> On Monday 21 April 2008, Dmitry wrote:
>  > >  - I don't think that I understand the clk_functions part of your code.
>  > >   Is this a shorthand to construct aliases to other struct clks?
>  >
>  > Yes, that's one of usages for it. E.g. current AT91 code has same
>  > functionality named at91_clock_associate.
>
>  As in:
>
>         at91_clock_associate("usart0_clk", &pdev0->dev, "usart");
>         at91_clock_associate("usart1_clk", &pdev1->dev, "usart");
>         at91_clock_associate("usart2_clk", &pdev2->dev, "usart");
>
>  That essentially maps a device and logical clock name to a specific
>  clock (those "usartX_clk" identifiers are global), so that drivers
>  can clk_get(dev, "usart") and get the right clock.  It decouples
>  clock and device declarations, which should help when integrating
>  external clocks too.
>
>  The assumption that clk_get(NULL, "usartX_clk") works is mostly
>  just a convenience, although it's probably a fair assumption for
>  many other SOC platforms.  Conceptually that first parameter is
>  a clock, not a name.

Yes. It's just a convenient form to specify the parent (holding) clock
(usartX_clk).
Usually you register all such clocks via an array of various clocks,
so it's just
easier to specify the name, than the struct clk pointer. Hope this makes it more
clear.

>
>
>  > > +struct clk_function {
>  > > +       const char *parent;
>  > > +       void *priv;
>  > > +       struct clk clk;
>  > > +};
>
>  That doesn't really seem attuned to the task of associating
>  logical clock names to devices.  Wouldn't it be better to
>  have something directly addressing that core mechanism?

In reality it does. Some platforms prefer to specify name+device,
some prefer name + id of the device, etc. Thus this definition.
For example of dev+name association, you can check the PXA
patch (e.g. for {FF,BT,ST,HW}UARTCLK -> UARTCLK definitions).

The association is done with the help of the clk_dev_ops operations.
Maybe them should be moved to the generic library.

>  > Also once we get to multiple chips providers/users, we'll see,
>
> > that the clock simply can't have just one record in the clocks tree.
>
>  I don't follow.  Why not?  If a clock has multiple records, I'd
>  expect its refcounts would easily get borked.  I think I don't
>  like your notion of a "wrapper clock".

It seems, I failed to describe it correctly.
Let's suppose this situation:
We have CLK, that is connected to the pin CK1 of the device dev_A and to the pin
CK36M of the device dev_B.

The we'll have these clocks:
.CLK count=0
\- CK1 count=0 for dev_A
\- CK36M count=0 for dev_B

When device dev_A enables it's clock,
we'll have this:
.CLK count=1
\- CK1 count=1 for dev_A
\- CK36M count=0 for dev_B

After that dev_B enables it's clock:
.CLK count=2
\- CK1 count=1 for dev_A
\- CK36M count=1 for dev_B

So refcounting is correct.

>  > It's provided by some
>  > pin (provider_name) and then consumed by several devices (several
>  > consumer_name + consumer_device pairs). That is it.
>
>  There would still be just one clock though.  It shouldn't matter
>  how clk_get(this_dev, "c1") and clk_get(that_dev, "c2") find it.
>  Hashtable, linked list, divination, ... so long as it works.
>
>  Those other records should just hold {dev, name} ==> clock mappings;
>  they wouldn't be records for the clock itself.  But those "functions"
>  do not seem to record just mappings.

It's easier from the abstraction POV to make that "records" to be real clocks.
Why introduce another object, if we can unify access to both types?

-- 
With best wishes
Dmitry
