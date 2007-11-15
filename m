Return-Path: <linux-kernel-owner+w=401wt.eu-S1761680AbXKOSSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761680AbXKOSSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbXKOSSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:18:47 -0500
Received: from ns1.suse.de ([195.135.220.2]:52439 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755894AbXKOSSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:18:46 -0500
Date: Thu, 15 Nov 2007 10:18:34 -0800
From: Greg KH <gregkh@suse.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: EIP is at device_shutdown+0x32/0x60
Message-ID: <20071115181834.GE24531@suse.de>
References: <20071115091158.GB6216@localhost.sw.ru> <20071115014446.f943d835.akpm@linux-foundation.org> <20071115213345.B3C1.Y-GOTO@jp.fujitsu.com> <20071115163435.GC24087@suse.de> <3ae72650711150950k74fdb37eu108bb360a594ffe8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ae72650711150950k74fdb37eu108bb360a594ffe8@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 06:50:06PM +0100, Kay Sievers wrote:
> On Nov 15, 2007 5:34 PM, Greg KH <gregkh@suse.de> wrote:
> > On Thu, Nov 15, 2007 at 09:55:34PM +0900, Yasunori Goto wrote:
> > > > On Thu, 15 Nov 2007 12:11:58 +0300 Alexey Dobriyan <adobriyan@sw.ru> wrote:
> > > >
> > > > > Three boxes rarely oops during reboot or poweroff with 2.6.24-rc2-mm1
> > > > > (1) and during 2.6.24 cycle (2):
> > > > >
> > > > >   kernel_restart
> > > > >   sys_reboot
> > > > >   [garbage]
> > > > > Code: 8b 88 a8 00 00 00 85 c9 74 04 89
> > > > > EIP is at device_shutdown+0x32/0x60
> > > >
> > > > Yes, all my test boxes did that - it's what I referred to in the releaee
> > > > notes.  Greg is pondering the problem - seem he's the only person who
> > > > cannot reproduce it ;)
> > >
> > > Fortunately, my ia64 box reproduces this oops "every time".
> > > So, I could chase it.
> > >
> > > device_shutdown() function in drivers/base/power/shutdown.c
> > > is followings.
> > > -----------
> > > /**
> > >  * device_shutdown - call ->shutdown() on each device to shutdown.
> > >  */
> > > void device_shutdown(void)
> > > {
> > >         struct device * dev, *devn;
> > >
> > >         list_for_each_entry_safe_reverse(dev, devn, &devices_kset->list,
> > >                                 kobj.entry) {
> > >                 if (dev->bus && dev->bus->shutdown) {
> > >                         dev_dbg(dev, "shutdown\n");
> > >                         dev->bus->shutdown(dev);
> > >                 } else if (dev->driver && dev->driver->shutdown) {
> > >                         dev_dbg(dev, "shutdown\n");
> > >                         dev->driver->shutdown(dev);
> > >                 }
> > >         }
> > > }
> > > --------
> > > When oops occured, dev->driver pointed kset_ktype's address,
> > > and dev->driver->shutdown was the address of bus_type_list.
> > > So, Oops was caused by "Illegal operation fault".
> > > kset_ktypes is pointed by system_kset.
> > >
> > > If my understanding is correct, this loop can't distinguish between
> > > struct device and struct kset, but both are connected in this list,
> > > right? It may be the cause of this.
> >
> > Hm, no, it should just be a list of devices for the kset, but I'll go
> > verify that this is correct.
> 
> Care to try this:
>   +       system_kset = kset_create_and_register("system", NULL,
>   +                                              &devices_kset->kobj, NULL);
> 
> We should not join the kset, only use it as a parent.

ARGH!

<snip loads of curse words...>

that should do it, let me go test.

Actually, once that is changed, the whole kset_create_and_register can
drop that last argument, we never want to create a kset as part of
another one...

The kset's kobject should not belong to any kset at all, I really messed
that one up.

Yet another reason why this patchset really matters, this crap isn't
even understood well by the people trying to maintain it...

greg k-h
