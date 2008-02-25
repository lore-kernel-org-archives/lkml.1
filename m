Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbYBYSGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbYBYSGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbYBYSGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:06:47 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:45981 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753927AbYBYSGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:06:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=u/UVA54NJxS3Bkh+tkozC08UsVF43sap3RF55jyvrwGudVABUyEeySBNeRjPaeuIArE3HCNjxMGrZIvNoGCSePu+JHcy4rn5s3pBNSO4D1nSbYKkqWDgk39r4U+khmjQALIOkwrnHmHMaoRg98diaCT6nSPj0XYoLyoulRZputg=  ;
X-YMail-OSG: v3V1zVoVM1nL1b.wtfPipP27HH3CeSbAtf5sJQGp_Qe6g31SEJpsYoZcMmlBl_tJ3KmKlT_4yA--
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 25 Feb 2008 10:06:44 -0800
From: David Brownell <david-b@pacbell.net>
To: hskinnemoen@atmel.com
Subject: Re: [patch 2.6.25-rc2-git 1/2] atmel_tc library
Cc: nicolas.ferre@rfo.atmel.com, linux@maxim.org.za,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <200802221723.24003.david-b@pacbell.net>
 <20080224184554.2c863f63@siona>
 <20080224225527.62D5D28E1A2@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20080225012637.1535c95b@siona>
 <20080225010310.B59E98E4B8@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20080225124319.4ec8a00b@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080225124319.4ec8a00b@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080225180644.78CA31E564F@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Which reminds me...you were talking about a patch that adds oneshot
> > > support for the count/compare clocksource and more cleanups, but I
> > > don't think I've seen it...?
> > 
> > I avoid sending non-working patches, and hadn't made time to
> > work on that issue recently.
>
> I was thinking that I could perhaps help you get it working...

OK, if you want I'll send it.


> > > I've never really seen the point of indenting those defines at all.
> > 
> > Without them, it's harder to discern the logical structure of
> > all the various bitfields and their contents.
>
> I prefer to separate the registers from the bitfields and the other
> stuff. That way, no indentation is necessary.

But that way it's no longer clear which symbols apply to which
registers.  It's not "needed" because that information became
harder to find ... as in <include/asm-avr32/arch-at32ap/time.h>,
which ISTR isn't even complete in its bitfield definitions.


> > > I thought about that, but while the driver can safely call clk_enable()
> > > on the same clock several times, I'm not sure if it's such a great idea
> > > to call request_irq() on the same interrupt several times. So the
> > > driver probably needs to know how many irqs there really are and might
> > > as well use platform_get_irq() to find out.
> > 
> > I thought the whole point of passing the clocks was to avoid needing
> > to ask for them!!  If trying one or three platform_get_irq() calls is
> > OK, then surely trying one or three clk_get() calls is also OK...
>
> If you want to go down that path, surely reserving the iomem resource
> is fine too? Why don't we just kill the whole tclib layer, the driver
> can certainly do everything itself?

There's one clear need for tclib:  to hand out timers from the (small)
pool of hardware entities.  Each one can be used for different purposes
by different drivers.

The *current* tclib addresses only that minimal need.

You're the one who wants to add more to it; I was just pointing out that
you were being inconsistent.


> Of course the driver should be responsible for calling clk_enable() and
> clk_disable(). Otherwise, power management will be tricky. And since
> the driver may need to make a decision about which interrupts to
> request, it might as well call platform_get_irq() directly.

You're being inconsistent here.  It has to make the same kinds of
decision about which clocks to enable/disable.  So why should it
have to platform_get_irq() but not clk_get()?


> On the other hand, the driver will _always_ need a reference to each
> clock,

No; it doesn't need references to clocks for unused TC channels.


>	and it will always need a pointer through which to access the
> registers, so the mid-layer might as well do those things.

True about doing the ioremap.

- Dave

