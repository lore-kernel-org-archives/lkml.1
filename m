Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbZHCJ0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbZHCJ0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 05:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbZHCJ0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 05:26:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:56539 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529AbZHCJ0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 05:26:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,313,1246863600"; 
   d="scan'208";a="480201921"
Subject: Re: [PATCH V2 4/4] i8042: support async suspend and shutdown
From: Zhang Rui <rui.zhang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, "dtor@mail.ru" <dtor@mail.ru>
In-Reply-To: <20090724071411.GB10760@elf.ucw.cz>
References: <1248404532.2670.112.camel@rzhang-dt>
	 <20090724071411.GB10760@elf.ucw.cz>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 17:26:30 +0800
Message-Id: <1249291590.2670.263.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-24 at 15:14 +0800, Pavel Machek wrote:
> On Fri 2009-07-24 11:02:12, Zhang Rui wrote:
> > 
> > i8042 controller support device async actions.
> > 
> > If boot option "dev_async_action" is added,
> > i8042 controller and its child devices can be
> > suspended/shutdown asynchronously.
> > 
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > ---
> >  drivers/input/serio/i8042.c |   10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6/drivers/input/serio/i8042.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/input/serio/i8042.c
> > +++ linux-2.6/drivers/input/serio/i8042.c
> > @@ -1285,14 +1285,21 @@ static int __init i8042_init(void)
> >  		goto err_unregister_driver;
> >  	}
> >  
> > -	err = platform_device_add(i8042_platform_device);
> > +	err = dev_async_register(&i8042_platform_device->dev,
> > +			DEV_ASYNC_SUSPEND | DEV_ASYNC_SHUTDOWN);
> >  	if (err)
> >  		goto err_free_device;
> >  
> > +	err = platform_device_add(i8042_platform_device);
> > +	if (err)
> > +		goto err_dev_async_unregister;
> > +
> >  	panic_blink = i8042_panic_blink;
> >  
> >  	return 0;
> >  
> > + err_dev_async_unregister:
> > +	dev_async_unregister(&i8042_platform_device->dev);
> >   err_free_device:
> >  	platform_device_put(i8042_platform_device);
> >   err_unregister_driver:
> 
> I still do not like the interface: manually unregistering seems to be
> ugly & error prone.
> 
hmm, yes, we can check device->dev_async and unregister it in driver
core, at device_unregister time.

then I think we should rename the interfaces to:
device_enable_async_action(dev, type),
and device_disable_async_action(dev)
so that they are more like driver core helper functions.
what do you think?

thanks,
rui
> > @@ -1305,6 +1312,7 @@ static int __init i8042_init(void)
> >  
> >  static void __exit i8042_exit(void)
> >  {
> > +	dev_async_unregister(&i8042_platform_device->dev);
> >  	platform_device_unregister(i8042_platform_device);
> >  	platform_driver_unregister(&i8042_driver);
> >  	i8042_platform_exit();
> > 
> 

