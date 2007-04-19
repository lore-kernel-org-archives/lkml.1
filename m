Return-Path: <linux-kernel-owner+w=401wt.eu-S637749AbXDSMtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637749AbXDSMtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 08:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637747AbXDSMtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 08:49:05 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:20929 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031249AbXDSMtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 08:49:03 -0400
Date: Thu, 19 Apr 2007 14:51:33 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Tejun Heo" <htejun@gmail.com>, "Alan Stern" <stern@rowland.harvard.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Greg K-H" <greg@kroah.com>, "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Message-ID: <20070419145133.2f7ed45a@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <d120d5000704180941pe2ab181xb5eab63b7cc1b297@mail.gmail.com>
References: <Pine.LNX.4.44L0.0704181032060.12246-100000@iolanthe.rowland.org>
	<46263A82.1030703@gmail.com>
	<d120d5000704180941pe2ab181xb5eab63b7cc1b297@mail.gmail.com>
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

On Wed, 18 Apr 2007 12:41:36 -0400,
"Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:

> I am still do not understand why this is needed. Would it not be
> simplier just to use a reference to struct device instead of embedding
> it in a larger structure if their lifetimes are different and one does
> not have a subsystem that takes care of releasing logic.

Why are their lifetimes different? Usually, if I hold on to the device,
I also want to be able to use the structure that embeds the device.
 
> Pretty much drivers have 2 options:
> 
> struct my_device {
>         void *private_data;
>         struct device dev;
> };
> 
> In this case ->release must live in a subsystem code; individual
> drivers kfree(my_dev->private) and do any additional cleanup after
> calling device_unregister(&my_dev->dev);

They must do this in the ->remove callback.

> 
> Second option:
> 
> struct my_device {
>         type member1;
>         type member2;
> 
>        struct device *dev;
> };
> 
> dev is coming from _device_create(). Driver core takes care of
> releasing dev structure; driver does cleanup of my_device.

device_create() would need to not expect a class then, or it's not
universally usable. Also, the driver would need a method to get back
from the device to my_device. We're practically back at the first
option again, only that now the ->release function is sitting in the
driver core instead of the subsystem.

> With current sysfs orphaning attributes upon removal request there is
> no issue of accessing driver-private data through references obtained
> via ether embedded or referenced dev structure so everything is fine.

Discoupling of sysfs and kobject lifetime rules definetly eliminates a
lot of issues.
