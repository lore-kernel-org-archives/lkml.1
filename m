Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbYHMHw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbYHMHw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 03:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbYHMHwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 03:52:18 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57663 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbYHMHwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 03:52:17 -0400
Date: Wed, 13 Aug 2008 08:51:54 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org, lethal@linux-sh.org,
       i2c@lm-sensors.org, akpm@linux-foundation.org
Subject: Re: [i2c] [PATCH 04/05] i2c-sh_mobile: IORESOURCE_CLK support
Message-ID: <20080813075154.GA4086@flint.arm.linux.org.uk>
References: <20080718074002.32713.73442.sendpatchset@rx1.opensource.se> <20080718074036.32713.92629.sendpatchset@rx1.opensource.se> <20080718080457.GM24620@fluff.org.uk> <aec7e5c30807180218y1911d3d3h2e80f5a097a79a14@mail.gmail.com> <20080813055452.GG2716@fluff.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813055452.GG2716@fluff.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 06:54:53AM +0100, Ben Dooks wrote:
> On Fri, Jul 18, 2008 at 06:18:06PM +0900, Magnus Damm wrote:
> > On Fri, Jul 18, 2008 at 5:04 PM, Ben Dooks <ben-linux@fluff.org> wrote:
> > > On Fri, Jul 18, 2008 at 04:40:36PM +0900, Magnus Damm wrote:
> > >> From: Magnus Damm <damm@igel.co.jp>
> > >>
> > >> This patch makes the i2c-sh_mobile driver get the clock name from the
> > >> struct resource with type IORESOURCE_CLK provided by the platform data.
> > >>
> > >> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> > >> ---
> > >>
> > >>  drivers/i2c/busses/i2c-sh_mobile.c |    8 +++++++-
> > >>  1 file changed, 7 insertions(+), 1 deletion(-)
> > >>
> > >> --- 0001/drivers/i2c/busses/i2c-sh_mobile.c
> > >> +++ work/drivers/i2c/busses/i2c-sh_mobile.c   2008-07-18 14:56:40.000000000 +0900
> > >> @@ -390,13 +390,19 @@ static int sh_mobile_i2c_probe(struct pl
> > >>       int size;
> > >>       int ret;
> > >>
> > >> +     res = platform_get_resource(dev, IORESOURCE_CLK, 0);
> > >> +     if (res == NULL || res->name == NULL) {
> > >> +             dev_err(&dev->dev, "cannot find CLK resource\n");
> > >> +             return -ENOENT;
> > >> +     }
> 
> I note in this one you are re-using the resource.name field in the way
> it was not intended to be used. This field is for use to differentiate
> resources where this is more than one of them and they may not all be
> present in the list. This is not a good course of action.
> 
> > >>       pd = kzalloc(sizeof(struct sh_mobile_i2c_data), GFP_KERNEL);
> > >>       if (pd == NULL) {
> > >>               dev_err(&dev->dev, "cannot allocate private data\n");
> > >>               return -ENOMEM;
> > >>       }
> > >>
> > >> -     pd->clk = clk_get(&dev->dev, "peripheral_clk");
> > >
> > > I think that is working correctly and there isn't really any
> > > need to change this. The clk_get is supplied the device that
> > > it needs the clock for, and the name of the clock needed.
> > 
> > Right, we could handle this "under the hood" of the clock frame work
> > implementation, or we could deal with it together with the rest of the
> > platform data and have one unique string per hardware block. On SuperH
> > Mobile we currently have one shared clock implementation that supports
> > multiple processors. Which clock that is assigned to what hardware
> > block is currently handled by per-cpu platform data, and that's where
> > this patch comes in.

The basic problem is that you're using names to identify clock sources,
not clock consumers.  If you consult the API documentation, it is made
pretty clear that using the ID string to identify clock sources is wrong:

 * clk_get - lookup and obtain a reference to a clock producer.
 * @dev: device for clock "consumer"
 * @id: clock comsumer ID
 *
 * Returns a struct clk corresponding to the clock producer, or
 * valid IS_ERR() condition containing errno.  The implementation
 * uses @dev and @id to determine the clock consumer, and thereby
 * the clock producer.  (IOW, @id may be identical strings, but
 * clk_get may return different clock producers depending on @dev.)

The problem with using the ID as a clock source is what you're finding -
you have to pass names around through various structures.

Instead, the way we do this on ARM is to use the device and ID to
determine the clock source, using aliases if necessary.

So, for example, all UART clocks may be called 'UARTCLK' but may
actually be different clock sources, which are told apart by the
struct device passed in.

Really, the struct device is the _primary_ distinguishing parameter
between clock sources.  The ID is meant to distinguish between different
inputs on the device itself.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
