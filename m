Return-Path: <linux-kernel-owner+w=401wt.eu-S1422776AbXCWKIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422776AbXCWKIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 06:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422774AbXCWKIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 06:08:35 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:6145 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422773AbXCWKId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 06:08:33 -0400
Date: Fri, 23 Mar 2007 11:10:29 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Monakhov Dmitriy <dmonakhov@openvz.org>
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070323111029.4089ccfb@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <4602D137.4060402@lwfinger.net>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<1174433034.62033.16.camel@localhost>
	<20070320223643.d8cbc3f6.akpm@linux-foundation.org>
	<4601761F.4000302@lwfinger.net>
	<20070321185900.GC3801@tuxdriver.com>
	<20070321202225.GN10459@waste.org>
	<20070321233917.0393dfd1.akpm@linux-foundation.org>
	<20070322123508.3785fd30@gondolin.boeblingen.de.ibm.com>
	<4602752A.5050109@lwfinger.net>
	<20070322181019.62fe78ed@gondolin.boeblingen.de.ibm.com>
	<4602D137.4060402@lwfinger.net>
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

On Thu, 22 Mar 2007 13:55:51 -0500,
Larry Finger <larry.finger@lwfinger.net> wrote:

> Cornelia Huck wrote:
> > On Thu, 22 Mar 2007 07:23:06 -0500,
> > 
> > This would indicate that dev_uevent had been called. But how could
> > kobject_uevent then return an error without moaning about an uevent()
> > error code? Maybe the following debug patch could shed some light on
> > this (all moaning is prefixed with kobject_uevent_env, so it should be
> > easy to spot)...
> 
> I applied the debug patch, but I don't see any error codes being returned. This time I also got the
> General Protection Faults. An excerpt of the log is attached.

Hm, I think I have an idea about what happened.

The firmware class tried to suppress the first KOBJ_ADD uevent by
returning -ENODEV in firmware_uevent if FW_STATUS_READY was not set.
This only worked as long as the return code of kobject_uevent was not
checked in device_add. hack-to-make-wireless-work.patch made that first
uevent return successfully, but this possible triggered some udev rule
too early, leading to firmware load failures.

The following (completely untested) patch uses uevent_suppress to stop
the uevent from being generated during device_add. Does this work for
you?

---
 drivers/base/firmware_class.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.orig/drivers/base/firmware_class.c
+++ linux-2.6/drivers/base/firmware_class.c
@@ -333,6 +333,7 @@ static int fw_register_device(struct dev
 	f_dev->parent = device;
 	f_dev->class = &firmware_class;
 	dev_set_drvdata(f_dev, fw_priv);
+	f_dev->uevent_suppress = 1;
 	retval = device_register(f_dev);
 	if (retval) {
 		printk(KERN_ERR "%s: device_register failed\n",
@@ -385,6 +386,7 @@ static int fw_setup_device(struct firmwa
                 set_bit(FW_STATUS_READY, &fw_priv->status);
         else
                 set_bit(FW_STATUS_READY_NOHOTPLUG, &fw_priv->status);
+	f_dev->uevent_suppress = 0;
 	*dev_p = f_dev;
 	goto out;
 
