Return-Path: <linux-kernel-owner+w=401wt.eu-S637745AbXDSNqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637745AbXDSNqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 09:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161504AbXDSNqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 09:46:12 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:41038 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161505AbXDSNqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 09:46:11 -0400
Date: Thu, 19 Apr 2007 15:48:49 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Tejun Heo" <htejun@gmail.com>, "Alan Stern" <stern@rowland.harvard.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Greg K-H" <greg@kroah.com>, "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Message-ID: <20070419154849.2e722762@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <d120d5000704190613h178ad644h53ad817db2950426@mail.gmail.com>
References: <Pine.LNX.4.44L0.0704181032060.12246-100000@iolanthe.rowland.org>
	<46263A82.1030703@gmail.com>
	<d120d5000704180941pe2ab181xb5eab63b7cc1b297@mail.gmail.com>
	<20070419145133.2f7ed45a@gondolin.boeblingen.de.ibm.com>
	<d120d5000704190613h178ad644h53ad817db2950426@mail.gmail.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 09:13:43 -0400,
"Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:

> Because they are managed by 2 different entities. the struct device
> objects are managed by device core and driver-specific objects are
> managed by their respective driver.

Not sure if I understand you here. My view of this was always that the
embedding object was kind of an extended device and that the relevant
driver/subsystem managed it through the driver core infrastructure.

> 
> > > Pretty much drivers have 2 options:
> > >
> > > struct my_device {
> > >         void *private_data;
> > >         struct device dev;
> > > };
> > >
> > > In this case ->release must live in a subsystem code; individual
> > > drivers kfree(my_dev->private) and do any additional cleanup after
> > > calling device_unregister(&my_dev->dev);
> >
> > They must do this in the ->remove callback.
> 
> Why? If the driver truly stops hardware then any driver-specific data
> is not needed. With sysfs severing access to removed attributes there
> is no need to gave "global release", cleanup can be done in stages.

I think I meant the same thing :) Freeing the data in the ->release
callback is obviously too late. Freeing it in the ->remove callback
means that the device is no longer really used (and can't be looked up
any more); only some further refrences may linger (and those are of no
consequence with the sysfs disconnect).
