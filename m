Return-Path: <linux-kernel-owner+w=401wt.eu-S1756323AbYCKVk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323AbYCKVk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYCKVkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:40:17 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:24971 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751819AbYCKVkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:40:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mkOlDZBwVlaeyc+Lk/iU3WBAtmr/faai2+9uUOfgpZxMxplEb1l2uz3N6kl0i0NeaWb8gPlbSjQUcxyNvQjz0wd+aJRfTLow5TURde5GWq2N5U+T5xZxLyqz6LrUOIADug9dDCUXl+pR2lQtB47ARreiVcOeocTGJiemGSN2i3o=  ;
X-YMail-OSG: ibzbF5oVM1nQN5bnyiJAlh.TthWU20PS7RE3PheTiHR6F356D.7e1aaoEvH7KFaHdR_9NwTL.g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Subject: Re: [UPDATED v3][PATCH 1/7] regulator: consumer interface
Date: Tue, 11 Mar 2008 13:36:28 -0800
User-Agent: KMail/1.9.6
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1204827056.15360.147.camel@a10323.wolfsonmicro.main> <200803101739.08628.david-b@pacbell.net> <1205230841.13653.204.camel@localhost.localdomain>
In-Reply-To: <1205230841.13653.204.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803111436.29073.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008, Liam Girdwood wrote:
> On Mon, 2008-03-10 at 16:39 -0800, David Brownell wrote:
> > On Sunday 09 March 2008, Liam Girdwood wrote:
> > > 
> > > > > +struct regulator *__must_check regulator_get(struct device *dev,
> > > > > +                                            const char *id);
> > > > 
> > > > The semantics of "id" and "dev" are unspecified in this patch,
> > > > so this isn't a good definition of the consumer interface!
> > > 
> > > 'id' is really the regulator name and will be renamed in the next patch.
> > 
> > Still not helping.  How would a driver know what names to use?
> 
> Platform data i.e. "WM8350-DCDC1". The links I gave in a previous mail
> have examples for this wrt LED. Backlight drivers.

I looked at some of that code a while back and didn't find them
all that informative.  Probably because implementations can be
interpreted in many ways, and I'm trying to understand which
concepts you intend to promote here...


> > Are those names globally scoped, or local to the device?
> > 
> 
> They are global.

So it's somewhat unlike the clock API then ... enough that I'd
reconsider *why* it's different.  The clock API allows both
global names and locally scoped ones.

Surely it would be better to just let device drivers call
something like

	client = regulator_lookup(dev, "Vcc");

and have the board setup code bind the right regulator to
that name for a given device?  It could work same way that
platform devices use logically numbered (or sometimes, named)
resources for register memory and IRQs, and the way the clock
framework uses logical names for device clocks.

Example:  all USART controllers may use the same logical
clock name "usart", instead of global names like "usart0_clk",
"usart1_clk", "mck", etc (as appropriate).  In the same way,
"Vcc" could be a local name for various devices ... where
the global name might be board-specific like "WM8350-DCDC1".


I suspect I'm walking towards a notion of a "power domain"
here, which would of course be fed by a regulator but would
be explicitly shared by multiple devices.  That's a notion
which has come up before in power management discussions, as
needing some explicit support by the Linux PM framwork.  It
applies both inside modern PM-aware SOCs, and at the board
level.  (It feels to me like you've focussed so far on the
latter.)

How would you see your notion of a "regulator" (client?)
relating to a "power domain"?  My first thought is that
there's a one-to-one correspondence but they may not be
quite the same thing.  Example, one might want to ask the
domain what devices it supports ... so that you could ask
them all to power off.

- Dave
