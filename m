Return-Path: <linux-kernel-owner+w=401wt.eu-S932207AbZJAMfC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbZJAMfC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 08:35:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932175AbZJAMfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 08:35:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173AbZJAMfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 08:35:00 -0400
Date: Thu, 1 Oct 2009 14:32:13 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 31/34] move virtrng_remove to .devexit.text
Message-ID: <20091001123213.GL5718@redhat.com>
References: <20091001082607.GA2181@pengutronix.de> <1254385718-14254-31-git-send-email-u.kleine-koenig@pengutronix.de> <200910011044.48293.borntraeger@de.ibm.com> <20091001091218.GE5718@redhat.com> <20091001093106.GA6386@pengutronix.de> <20091001094518.GI5718@redhat.com> <20091001101727.GC6386@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091001101727.GC6386@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 12:17:27PM +0200, Uwe Kleine-König wrote:
> Hello,
> 
> On Thu, Oct 01, 2009 at 11:45:18AM +0200, Michael S. Tsirkin wrote:
> > On Thu, Oct 01, 2009 at 11:31:06AM +0200, Uwe Kleine-König wrote:
> > > Hello,
> > > 
> > > On Thu, Oct 01, 2009 at 11:12:18AM +0200, Michael S. Tsirkin wrote:
> > > > On Thu, Oct 01, 2009 at 10:44:48AM +0200, Christian Borntraeger wrote:
> > > > > Am Donnerstag 01 Oktober 2009 10:28:35 schrieb Uwe Kleine-König:
> > > > > > The function virtrng_remove is used only wrapped by __devexit_p so define
> > > > > > it using __devexit.
> > > > > > 
> > > > > > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > > > > Acked-by: Sam Ravnborg <sam@ravnborg.org>
> > > > > > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > > > > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > > > > Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> > > > > 
> > > > > Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > > > 
> > > > FWIW
> > > > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > > ok
> > > 
> > > > > It seems that there are similar changes possible in other virtio drivers (e.g. 
> > > > > virtio_net). 
> > > http://thread.gmane.org/gmane.linux.kernel/896297/focus=896309
> > > 
> > > > Yes, and more importantly drivers/virtio/virtio.c as well.
> > > Hm, I don't see it:
> > > 
> > > 	$ git grep -E '__(dev)?exit_p' linus/master:drivers/virtio/virtio.c
> > > 
> > > 	$
> > > 
> > > Well, you could add something, but adding __devexit is a noop for most
> > > kernels.  It matters only if you don't have CONFIG_HOTPLUG.
> > 
> > And MODULE.
> Well, discarding does not really depend on CONFIG_MODULE.
> .devexit sections are only discarded from vmlinux (and not modules) and
> only if CONFIG_HOTPLUG=n.  So my statement could be extended to:
> 
> Adding __devexit is a noop for most kernels. It matters only if you
> don't have CONFIG_HOTPLUG and then only for code that is not compiled as
> a module.
> 
> > > In this series I only addressed drivers that use __{,dev}exit and
> > > __{,dev}exit_p inconsistenly.  I.e. my script greps for __{,dev}exit_p
> > > and checks the prototype of the wrapped function.  I have another
> > > script that does a similar check for platform_devices in general.  This
> > > one also notices if you have a __devexit function that isn't wrapped by
> > > __devexit_p.
> > 
> > Can we teach sparse about this?
> I don't know much about sparse, better ask on linux-sparse.
>  
> > > So if you want to see drivers/virtio/virtio.c improving, send patches
> > > yourself :-)
> > 
> > Here's my reasoning:
> > include/linux/virtio.h defines virtio_driver, and remove pointer
> > there is only used on hot-unplug or module removal.
> > This is the only reason I see that we can make device removal as devexit.
> > So we can make all of them devexit then?
> Exactly the same applies to platform_drivers.  The remove callback is
> only called if the driver is unregistered or the device is unbound.
> 
> But note it's not an error in general to use a .text function as remove
> callback.  E.g. take drivers/gpio/twl4030-gpio.c.  gpio_twl4030_remove
> is used in gpio_twl4030_probe which is defined using __devinit.  So
> using __devexit for gpio_twl4030_remove is wrong.  (So there is a bug,
> as gpio_twl4030_remove uses __devexit.)  I didn't try, but as far as I
> understand this will result in a compile error if the driver is built-in
> with HOTPLUG=n.

Wait a second.
As far as I understand, __devexit makes it possible to remove code if
hotplug is off.

At least for static functions, it's enough to mark their only use
as _devexit_p, and compiler will remove the text as it's unused.

Isn't that right?

If so, what, again, was the motivation for the patches that added
__devexit to functions that were already used with __devexit_p?


> Best regards
> Uwe
> 
> -- 
> Pengutronix e.K.                              | Uwe Kleine-König            |
> Industrial Linux Solutions                    | http://www.pengutronix.de/  |
