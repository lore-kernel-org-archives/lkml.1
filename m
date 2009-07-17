Return-Path: <linux-kernel-owner+w=401wt.eu-S933948AbZGQBul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948AbZGQBul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 21:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757603AbZGQBuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 21:50:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:37068 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757613AbZGQBuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 21:50:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,414,1243839600"; 
   d="scan'208";a="708568971"
Subject: Re: [PATCH 8/8] i8042: support device async suspend & shutdown
From: Zhang Rui <rui.zhang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <20090715003716.GE2360@ucw.cz>
References: <1247643522.26272.83.camel@rzhang-dt>
	 <20090715003716.GE2360@ucw.cz>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 09:51:28 +0800
Message-Id: <1247795488.26272.227.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 08:37 +0800, Pavel Machek wrote:
> On Wed 2009-07-15 15:38:42, Zhang Rui wrote:
> > 
> > i8042 controller support device async actions.
> > 
> > If boot option "dev_async_action" is added,
> > i8042 controller and its child devices can be
> > suspended/resumed/shutdown asynchronously.
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
> > @@ -1284,14 +1284,21 @@ static int __init i8042_init(void)
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
> 
> 
> >   err_free_device:
> >  	platform_device_put(i8042_platform_device);
> >   err_unregister_driver:
> > @@ -1304,6 +1311,7 @@ static int __init i8042_init(void)
> >  
> >  static void __exit i8042_exit(void)
> >  {
> > +	dev_async_unregister(&i8042_platform_device->dev);
> >  	platform_device_unregister(i8042_platform_device);
> >  	platform_driver_unregister(&i8042_driver);
> >  	i8042_platform_exit();
> 
> Could we get the core to do async_unregister during device_unregister?
> 
yes, we can.
I think it's a little strange that drivers need to invoke
dev_async_register to register an async device group, but don't need to
call dev_async_unregister to unregister it.

> Or maybe better, just add flags during device_add?
> 
Many devices don't know if they support async actions or not during
device initialization time, like PCI and ACPI devices.
If we want to create an async group for a PCI device, we have to call
dev_async_register in the specified PCI device driver, rather than in
the PCI bus scan stage.

thanks,
rui

