Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbZEQGd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbZEQGd2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 02:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZEQGdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 02:33:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53510 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbZEQGdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 02:33:18 -0400
Date: Sun, 17 May 2009 08:32:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.30-rc6: Reported regressions from 2.6.29
Message-ID: <20090517063234.GA1583@elte.hu>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <alpine.LFD.2.01.0905161644350.3301@localhost.localdomain> <ac3eb2510905161715m7d42879bqdc0d59c465521e99@mail.gmail.com> <1242522109.2635.6.camel@poy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242522109.2635.6.camel@poy>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Sun, 2009-05-17 at 02:15 +0200, Kay Sievers wrote:
> > On Sun, May 17, 2009 at 02:01, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > 
> > >        [   10.428691] Error: Driver 'rtc_cmos' is already registered, aborting...
> > >
> > > but the driver doesn't really care whether that succeeded or not, but then
> > > the platform_driver_probe fails (because the thing is already in use), so
> > > then it ends up unregistering something that never got registered in the
> > > first place.
> > >
> > > I think this is strictly speaking a bug in driver_unregister(), which is
> > > too fragile. If you unregister a drivert that wasn't registered, we
> > > shouldn't oops.
> > >
> > > But we could certainly do it at the rtc-cmos.c level too, and just not
> > > unregister it if the registration failed. My gut feel is that we should
> > > aim for the core driver helpers to be less fragile, though - we'll always
> > > have driver bugs.
> > 
> > In:
> >  driver_remove_file()
> > we try to access the private part:
> >  sysfs_remove_file(&drv->p->kobj, ...
> > and that is NULL, for an unregistered driver, I would expect.
> > 
> > I'm looking into it.
> 
> This makes the oops in the driver-core, caused by the rtc driver
> unregister, go away. The original issue is also fixed in the rtc driver
> itself.
> 
> Thanks,
> Kay
> 
> 
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: Driver Core: do not oops when driver_unregister() is called for unregistered drivers
> 
> Handle the case someone tries to unregister a non-registered driver
> more gracefully.
> 
>   Error: Driver 'rtc_cmos' is already registered, aborting...
>   BUG: unable to handle kernel NULL pointer dereference at 00000018
>   [<c01e16ba>] sysfs_remove_file+0x1/0xf
> 
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>

please also put in a proper Reported-by.

> ---
> 
>  driver.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- a/drivers/base/driver.c
> +++ b/drivers/base/driver.c
> @@ -257,6 +257,8 @@ EXPORT_SYMBOL_GPL(driver_register);
>   */
>  void driver_unregister(struct device_driver *drv)
>  {
> +	if (!drv || !drv->p)
> +		return;

I think it would be reasonable to also emit a:

	 WARN_ONCE(1, "unexpected driver unregister!\n");

here - as long as all such cases are a bug. As the imbalance (and a 
bug) is really at the rtc-cmos driver level too and we should not 
condone such pattern, silently.

( Not crashing in the driver core when we can avoid it is nice to 
  have too, of course. )

	Ingo
