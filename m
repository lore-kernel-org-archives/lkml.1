Return-Path: <linux-kernel-owner+w=401wt.eu-S934052AbZGQCju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052AbZGQCju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 22:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934016AbZGQCjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 22:39:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37025 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934007AbZGQCjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 22:39:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 8/8] i8042: support device async suspend & shutdown
Date: Fri, 17 Jul 2009 04:40:15 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc3-rjw; KDE/4.2.4; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <1247643522.26272.83.camel@rzhang-dt> <20090715003716.GE2360@ucw.cz> <1247795488.26272.227.camel@rzhang-dt>
In-Reply-To: <1247795488.26272.227.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907170440.16678.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 July 2009, Zhang Rui wrote:
> On Wed, 2009-07-15 at 08:37 +0800, Pavel Machek wrote:
> > On Wed 2009-07-15 15:38:42, Zhang Rui wrote:
> > > 
> > > i8042 controller support device async actions.
> > > 
> > > If boot option "dev_async_action" is added,
> > > i8042 controller and its child devices can be
> > > suspended/resumed/shutdown asynchronously.
> > > 
> > > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > > ---
> > >  drivers/input/serio/i8042.c |   10 +++++++++-
> > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > > 
> > > Index: linux-2.6/drivers/input/serio/i8042.c
> > > ===================================================================
> > > --- linux-2.6.orig/drivers/input/serio/i8042.c
> > > +++ linux-2.6/drivers/input/serio/i8042.c
> > > @@ -1284,14 +1284,21 @@ static int __init i8042_init(void)
> > >  		goto err_unregister_driver;
> > >  	}
> > >  
> > > -	err = platform_device_add(i8042_platform_device);
> > > +	err = dev_async_register(&i8042_platform_device->dev,
> > > +			DEV_ASYNC_SUSPEND | DEV_ASYNC_SHUTDOWN);
> > >  	if (err)
> > >  		goto err_free_device;
> > >  
> > > +	err = platform_device_add(i8042_platform_device);
> > > +	if (err)
> > > +		goto err_dev_async_unregister;
> > > +
> > >  	panic_blink = i8042_panic_blink;
> > >  
> > >  	return 0;
> > >  
> > > + err_dev_async_unregister:
> > > +	dev_async_unregister(&i8042_platform_device->dev);
> > 
> > 
> > >   err_free_device:
> > >  	platform_device_put(i8042_platform_device);
> > >   err_unregister_driver:
> > > @@ -1304,6 +1311,7 @@ static int __init i8042_init(void)
> > >  
> > >  static void __exit i8042_exit(void)
> > >  {
> > > +	dev_async_unregister(&i8042_platform_device->dev);
> > >  	platform_device_unregister(i8042_platform_device);
> > >  	platform_driver_unregister(&i8042_driver);
> > >  	i8042_platform_exit();
> > 
> > Could we get the core to do async_unregister during device_unregister?
> > 
> yes, we can.
> I think it's a little strange that drivers need to invoke
> dev_async_register to register an async device group, but don't need to
> call dev_async_unregister to unregister it.
> 
> > Or maybe better, just add flags during device_add?
> > 
> Many devices don't know if they support async actions or not during
> device initialization time, like PCI and ACPI devices.
> If we want to create an async group for a PCI device, we have to call
> dev_async_register in the specified PCI device driver, rather than in
> the PCI bus scan stage.

That is quite a big design issue, IMO.

Did you consider any other approach to this?

Best,
Rafael
