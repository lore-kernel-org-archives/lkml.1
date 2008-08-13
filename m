Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbYHMFzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbYHMFzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 01:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYHMFzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 01:55:11 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:61478 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751835AbYHMFzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 01:55:10 -0400
Date: Wed, 13 Aug 2008 06:54:53 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-sh@vger.kernel.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org, lethal@linux-sh.org, i2c@lm-sensors.org,
       akpm@linux-foundation.org, RMK <rmk@arm.linux.org.uk>
Subject: Re: [i2c] [PATCH 04/05] i2c-sh_mobile: IORESOURCE_CLK support
Message-ID: <20080813055452.GG2716@fluff.org.uk>
References: <20080718074002.32713.73442.sendpatchset@rx1.opensource.se> <20080718074036.32713.92629.sendpatchset@rx1.opensource.se> <20080718080457.GM24620@fluff.org.uk> <aec7e5c30807180218y1911d3d3h2e80f5a097a79a14@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aec7e5c30807180218y1911d3d3h2e80f5a097a79a14@mail.gmail.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 06:18:06PM +0900, Magnus Damm wrote:
> On Fri, Jul 18, 2008 at 5:04 PM, Ben Dooks <ben-linux@fluff.org> wrote:
> > On Fri, Jul 18, 2008 at 04:40:36PM +0900, Magnus Damm wrote:
> >> From: Magnus Damm <damm@igel.co.jp>
> >>
> >> This patch makes the i2c-sh_mobile driver get the clock name from the
> >> struct resource with type IORESOURCE_CLK provided by the platform data.
> >>
> >> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> >> ---
> >>
> >>  drivers/i2c/busses/i2c-sh_mobile.c |    8 +++++++-
> >>  1 file changed, 7 insertions(+), 1 deletion(-)
> >>
> >> --- 0001/drivers/i2c/busses/i2c-sh_mobile.c
> >> +++ work/drivers/i2c/busses/i2c-sh_mobile.c   2008-07-18 14:56:40.000000000 +0900
> >> @@ -390,13 +390,19 @@ static int sh_mobile_i2c_probe(struct pl
> >>       int size;
> >>       int ret;
> >>
> >> +     res = platform_get_resource(dev, IORESOURCE_CLK, 0);
> >> +     if (res == NULL || res->name == NULL) {
> >> +             dev_err(&dev->dev, "cannot find CLK resource\n");
> >> +             return -ENOENT;
> >> +     }

I note in this one you are re-using the resource.name field in the way
it was not intended to be used. This field is for use to differentiate
resources where this is more than one of them and they may not all be
present in the list. This is not a good course of action.

> >>       pd = kzalloc(sizeof(struct sh_mobile_i2c_data), GFP_KERNEL);
> >>       if (pd == NULL) {
> >>               dev_err(&dev->dev, "cannot allocate private data\n");
> >>               return -ENOMEM;
> >>       }
> >>
> >> -     pd->clk = clk_get(&dev->dev, "peripheral_clk");
> >
> > I think that is working correctly and there isn't really any
> > need to change this. The clk_get is supplied the device that
> > it needs the clock for, and the name of the clock needed.
> 
> Right, we could handle this "under the hood" of the clock frame work
> implementation, or we could deal with it together with the rest of the
> platform data and have one unique string per hardware block. On SuperH
> Mobile we currently have one shared clock implementation that supports
> multiple processors. Which clock that is assigned to what hardware
> block is currently handled by per-cpu platform data, and that's where
> this patch comes in.

We have a shared implementation for the s3c24xx, which all have subtly
different clock requirements and we change the clock registration for
the chip, instead of trying to subvert the platform system. I do not
see this as being "under the hood", changing resources at registration
time is done all over the place.

Techincally, if there is only one clock per block, then you don't
actually need a name, just supply the device that you are looking up
a clock for.

Note, added Russell King to the discussion, as he is the original
authour of the clock framework anyway.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
