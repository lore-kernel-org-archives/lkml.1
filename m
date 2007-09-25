Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbXIYIBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbXIYIBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbXIYIBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:01:44 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:18110 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbXIYIBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:01:43 -0400
Date: Tue, 25 Sep 2007 10:01:09 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <htejun@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
       ebiederm@xmission.com, greg@kroah.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] module: implement module_inhibit_unload()
Message-ID: <20070925100109.4353dd57@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1190695118.27805.307.camel@localhost.localdomain>
References: <25380.1190671205@lwn.net>
	<46F845B2.7030002@gmail.com>
	<1190677332.27805.229.camel@localhost.localdomain>
	<46F86727.4050004@gmail.com>
	<1190686320.27805.258.camel@localhost.localdomain>
	<46F874DB.5070205@gmail.com>
	<1190690493.27805.263.camel@localhost.localdomain>
	<46F8822D.2010003@gmail.com>
	<1190695118.27805.307.camel@localhost.localdomain>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 14:38:38 +1000,
Rusty Russell <rusty@rustcorp.com.au> wrote:

> Have you tested that *this* path works?  Let's take your first change as
> an example:
> 
> +       mutex_lock(&gdev->reg_mutex);
> +       __ccwgroup_remove_symlinks(gdev);
> +       device_unregister(dev);
> +       mutex_unlock(&gdev->reg_mutex);
> 
> Now, are you sure that calling cleanup_ccwgroup just after
> device_unregister() works?
> 
> static void __exit
> cleanup_ccwgroup (void)
> {
> 	bus_unregister (&ccwgroup_bus_type);
> }
> 

ccwgroup is a bit special. The ccwgroup drivers (say, qeth) will
unregister their ccwgroup_driver in their exit function. ccwgroup will
then unregister all devices bound to this driver (a ccwgroup device
without a driver does not make sense, since they are artifically
created by writing to a 'group' attribute provided by the driver). This
makes sure that ccwgroup cannot be unloaded while there are still
devices on the bus, so your example won't hit.

> > I think it's too much work for the
> > users of the API and it will be easy to pass the wrong @owner and go
> > unnoticed.
> 
> But your shortcut insists that all module authors be aware that
> functions can be running after exit() is called.  That's a recipe for
> instability and disaster.

There are already problems like this with ->release().

<And no, I still haven't gotten around to testing and reviewing all
those patchsets, sorry>
