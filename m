Return-Path: <linux-kernel-owner+w=401wt.eu-S1761482AbXKORuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761482AbXKORuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 12:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756386AbXKORuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 12:50:10 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:27374 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbXKORuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 12:50:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=irVT5vTjG4gAa6dv2eTl7sYj1BQd3P+bMbBEtMwrs3mM2r3a4LgXtEZt69UFm1NGAhHjIpET8p2Cj84kmuDPssZupt33u/ig8kKISE/li4XHNEYd8EIRVuOsry2ta98dHmpy+YNCOC6y/a88ko6ejhAigBlj2DTxAt54tYjQbXg=
Message-ID: <3ae72650711150950k74fdb37eu108bb360a594ffe8@mail.gmail.com>
Date: Thu, 15 Nov 2007 18:50:06 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: EIP is at device_shutdown+0x32/0x60
Cc: "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alexey Dobriyan" <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
In-Reply-To: <20071115163435.GC24087@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071115091158.GB6216@localhost.sw.ru>
	 <20071115014446.f943d835.akpm@linux-foundation.org>
	 <20071115213345.B3C1.Y-GOTO@jp.fujitsu.com>
	 <20071115163435.GC24087@suse.de>
X-Google-Sender-Auth: 43cd16fe2dee669d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 15, 2007 5:34 PM, Greg KH <gregkh@suse.de> wrote:
> On Thu, Nov 15, 2007 at 09:55:34PM +0900, Yasunori Goto wrote:
> > > On Thu, 15 Nov 2007 12:11:58 +0300 Alexey Dobriyan <adobriyan@sw.ru> wrote:
> > >
> > > > Three boxes rarely oops during reboot or poweroff with 2.6.24-rc2-mm1
> > > > (1) and during 2.6.24 cycle (2):
> > > >
> > > >   kernel_restart
> > > >   sys_reboot
> > > >   [garbage]
> > > > Code: 8b 88 a8 00 00 00 85 c9 74 04 89
> > > > EIP is at device_shutdown+0x32/0x60
> > >
> > > Yes, all my test boxes did that - it's what I referred to in the releaee
> > > notes.  Greg is pondering the problem - seem he's the only person who
> > > cannot reproduce it ;)
> >
> > Fortunately, my ia64 box reproduces this oops "every time".
> > So, I could chase it.
> >
> > device_shutdown() function in drivers/base/power/shutdown.c
> > is followings.
> > -----------
> > /**
> >  * device_shutdown - call ->shutdown() on each device to shutdown.
> >  */
> > void device_shutdown(void)
> > {
> >         struct device * dev, *devn;
> >
> >         list_for_each_entry_safe_reverse(dev, devn, &devices_kset->list,
> >                                 kobj.entry) {
> >                 if (dev->bus && dev->bus->shutdown) {
> >                         dev_dbg(dev, "shutdown\n");
> >                         dev->bus->shutdown(dev);
> >                 } else if (dev->driver && dev->driver->shutdown) {
> >                         dev_dbg(dev, "shutdown\n");
> >                         dev->driver->shutdown(dev);
> >                 }
> >         }
> > }
> > --------
> > When oops occured, dev->driver pointed kset_ktype's address,
> > and dev->driver->shutdown was the address of bus_type_list.
> > So, Oops was caused by "Illegal operation fault".
> > kset_ktypes is pointed by system_kset.
> >
> > If my understanding is correct, this loop can't distinguish between
> > struct device and struct kset, but both are connected in this list,
> > right? It may be the cause of this.
>
> Hm, no, it should just be a list of devices for the kset, but I'll go
> verify that this is correct.

Care to try this:
  +       system_kset = kset_create_and_register("system", NULL,
  +                                              &devices_kset->kobj, NULL);

We should not join the kset, only use it as a parent.

Kay
