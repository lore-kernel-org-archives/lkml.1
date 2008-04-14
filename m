Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbYDNKRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbYDNKRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 06:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYDNKRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 06:17:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59499 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbYDNKRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:17:20 -0400
Date: Mon, 14 Apr 2008 11:17:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Re: [PATCH 4/4 v2] [RFC] UIO: generic platform driver
Message-ID: <20080414101701.GE1540@flint.arm.linux.org.uk>
References: <20080411062106.GA18096@digi.com> <20080411092158.GB31625@digi.com> <20080411103346.GC3185@local> <20080411110358.GC19973@digi.com> <20080411111703.GD3185@local> <20080411112543.GA23221@digi.com> <20080412131646.GF9669@flint.arm.linux.org.uk> <20080414074858.GA22694@digi.com> <20080414093714.GD1540@flint.arm.linux.org.uk> <20080414095445.GA19413@digi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080414095445.GA19413@digi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 11:54:45AM +0200, Uwe Kleine-König wrote:
> Hi Russell,
> 
> Russell King - ARM Linux wrote:
> > On Mon, Apr 14, 2008 at 09:48:58AM +0200, Uwe Kleine-König wrote:
> > > > > > > > But what about this:
> > > > > > > > 
> > > > > > > > ERROR: "clk_get" [drivers/uio/uio_pdrv.ko] undefined!
> > > > > > > > ERROR: "clk_enable" [drivers/uio/uio_pdrv.ko] undefined!
> > > > > > > > ERROR: "clk_disable" [drivers/uio/uio_pdrv.ko] undefined!
> > > > > > > > ERROR: "clk_put" [drivers/uio/uio_pdrv.ko] undefined!
> > > > > > > > 
> > > > > > > > Do you have any extra patches applied?
> > > > > > > Yes I have, but nothing special.  This is part of a generic API defined
> > > > > > > in include/linux/clk.h.  One of it's use it to abstract away some
> > > > > > > platform dependencies.  There are several architectures that define
> > > > > > > it[1].
> > > > > > 
> > > > > > I know. Unfortunately, I tested on x86_64, and it doesn't compile.
> > > > > > If it's depending on something, then this dependency should be added in
> > > > > > Kconfig. If it can be selected in the configuration, I expect it to
> > > > > > compile (and work).
> > > > > Maybe adding a dummy implementation that is compiled for machines that
> > > > > don't provide a native one.  Currently there is no cpp symbol that tells
> > > > > if an machine supports the API.
> > > > > 
> > > > > @Russell: Do you have an opinion regarding this!?
> > > > 
> > > > Only that the kernels Kconfig is turning into a real complicated mess
> > > > of dependencies IMHO.
> > > > 
> > > > We could add a HAVE_CLK and add that to the dependency of all the drivers
> > > > which use linux/clk.h.  The problem will be finding all those drivers and
> > > > their corresponding Kconfig entries.
> > > > 
> > > > My feeling is that we're just going to end up creating another Kconfig
> > > > symbol which folk half-heartedly use.
> > >
> > > I don't like that either.  What do you think about the patch below?
> > > It doesn't introduce a new symbol that needs much care and attention.
> > > This way the clk API is available on all configurations provided that 
> > > CONFIG_DUMMY_CLK is set correctly.  If CONFIG_DUMMY_CLK is set wrong it
> > > should result in a compile error.  Either because there are two
> > > implementations of clk_get or none.
> > 
> > Hang on.  I'm lost.  What are we talking about here?  I thought the
> > thread was about the one liner patch for UIO to arch/arm/Kconfi
> > (which still hasn't hit the patch system so is still on target for
> > being missed...)
> No, the topic here is a generic uio platform driver.  It uses the clk
> API and Hans criticised that is doesn't compile on x86 (because there is
> no implementation of the clk API).  So I suggested to implement a dummy
> for that.
> 
> This is completly independant of the inclusion of drivers/uio/Kconfig in
> arch/arm/Kconfig.  I will send a patch for that.
> 
> > What's this drivers/uio/uio_pdrv.ko module, and why doesn't it appear
> > in the LKML archive of this thread?
> Don't know why lkml.org didn't link these.  The start of the thread can
> be found at
> 
> 	http://lkml.org/lkml/2008/4/10/110

Thanks.  Well, tbh, I don't know which way to go on this.  Each of the
suggested ways have their downsides.

However:

+       pdata->clk = clk_get(&pdev->dev, DRIVER_NAME);

seems wrong - "uio" as a clock name?

+               /* XXX: better use dev_dbg, but which device should I use?
+                * info->uio_dev->dev isn't accessible here as struct uio_device+                * is opaque.
+                */

why not store a copy of 'dev' in struct uio_platdata ?

+       uiomem = &uioinfo->mem[0];
+       for (i = 0; i < pdev->num_resources; ++i) {
...
+               ++uiomem;
+       }

Who's to say there's pdev->num_resources entries in the 'mem' array?
Shouldn't this loop also be limited to MAX_UIO_MAPS iterations (or
maybe complain if there's more than MAX_UIO_MAPS)?

+/* XXX: I thought there already exists something like STRINGIFY, but I could not
+ * find it ...
+ */
+#ifndef STRINGIFY
+#define STRINGIFY(x) __STRINGIFY_HELPER(x)
+#define __STRINGIFY_HELPER(x) #x
+#endif

#include <linux/stringify.h> ?
