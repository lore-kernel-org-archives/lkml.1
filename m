Return-Path: <linux-kernel-owner+w=401wt.eu-S933120AbYDYXHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120AbYDYXHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 19:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYDYXHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 19:07:25 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:23231 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756460AbYDYXHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 19:07:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qfisTidmb68FzWFA9X2/AEY5qK8OT4fu2JITVm3rROitFzV4RkJtIqDqknNmbCwtKLlSVTljF7kOA8FuJeON33UiBPsHkKQSocuQKo6OmKlolP36GOunuGYYYN1EsBOg+8PE8quoRGDKrjwCYgUPbeJ9FZVvrB8YiL2ew8+O1Oo=  ;
X-YMail-OSG: AbyNDOsVM1ldDFzdx5llmcQMJ9YqP4WMQZaPl6BQFtVDHH2gkILF5dsNWNFlAu9k.qmiNzZm1OeFKORvyj641d2Z6WjRi4ZnulZ1K0KC7GGwiEX.FjFmbF0ckWKTAPG9Rp0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Dmitry <dbaryshkov@gmail.com>
Subject: Re: [PATCH 0/5] Clocklib: generic clocks framework
Date: Fri, 25 Apr 2008 15:46:51 -0700
User-Agent: KMail/1.9.6
Cc: "Paul Walmsley" <paul@pwsan.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "pHilipp Zabel" <philipp.zabel@gmail.com>,
       "Pavel Machek" <pavel@ucw.cz>, tony@atomide.com, hiroshi.DOYU@nokia.com
References: <20080420082925.GA32739@doriath.ww600.siemens.net> <alpine.DEB.1.00.0804210057000.17857@utopia.booyaka.com> <bc64b4640804210148p2d1c2fe0qe469152fa1a9697e@mail.gmail.com>
In-Reply-To: <bc64b4640804210148p2d1c2fe0qe469152fa1a9697e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804251546.52495.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 April 2008, Dmitry wrote:
> >  - I don't think that I understand the clk_functions part of your code.
> >   Is this a shorthand to construct aliases to other struct clks?
>
> Yes, that's one of usages for it. E.g. current AT91 code has same
> functionality named at91_clock_associate.

As in:

	at91_clock_associate("usart0_clk", &pdev0->dev, "usart");
	at91_clock_associate("usart1_clk", &pdev1->dev, "usart");
	at91_clock_associate("usart2_clk", &pdev2->dev, "usart");

That essentially maps a device and logical clock name to a specific
clock (those "usartX_clk" identifiers are global), so that drivers
can clk_get(dev, "usart") and get the right clock.  It decouples
clock and device declarations, which should help when integrating
external clocks too.

The assumption that clk_get(NULL, "usartX_clk") works is mostly
just a convenience, although it's probably a fair assumption for
many other SOC platforms.  Conceptually that first parameter is
a clock, not a name.


> > +struct clk_function {
> > +       const char *parent;
> > +       void *priv;
> > +       struct clk clk;
> > +};

That doesn't really seem attuned to the task of associating
logical clock names to devices.  Wouldn't it be better to
have something directly addressing that core mechanism?


> Also once we get to multiple chips providers/users, we'll see,
> that the clock simply can't have just one record in the clocks tree.

I don't follow.  Why not?  If a clock has multiple records, I'd
expect its refcounts would easily get borked.  I think I don't
like your notion of a "wrapper clock".


> It's provided by some
> pin (provider_name) and then consumed by several devices (several
> consumer_name + consumer_device pairs). That is it.

There would still be just one clock though.  It shouldn't matter
how clk_get(this_dev, "c1") and clk_get(that_dev, "c2") find it.
Hashtable, linked list, divination, ... so long as it works.

Those other records should just hold {dev, name} ==> clock mappings;
they wouldn't be records for the clock itself.  But those "functions"
do not seem to record just mappings.

- Dave

