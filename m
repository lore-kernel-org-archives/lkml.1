Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbXENIGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbXENIGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 04:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbXENIGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 04:06:11 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:46344 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbXENIGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 04:06:10 -0400
Date: Mon, 14 May 2007 10:06:07 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: bbpetkov@yahoo.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] driver core: fix warning of temporarily unused
 multithreaded probing function (was: Re: Linux 2.6.22-rc1)
Message-ID: <20070514100607.5ed91646@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070513094752.GA5232@gollum.tnic>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	<20070513094752.GA5232@gollum.tnic>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007 11:47:53 +0200,
Borislav Petkov <bbpetkov@yahoo.de> wrote:

> if I'm not mistaken, despite the PCI_MULTITHREAD_PROBE removal,
> Cornelia Huck wanted to keep driver-core-per-subsystem-multithreaded-probing.patch:
> 
> <quote>
> > Wouldn't per-subsystem multithreaded probing just expose bugs that
> > could also be exposed on SMP systems?
> 
> Yes, it would be the same.
> </quote>

Hm, I don't think I'll follow up with this - we need a different
approach, I guess.

> However, device_probe_drivers() remains temporarily unused, so we either
> suppress the compiler warning or remove the whole function altogether. The
> following patch does the first.

I'd prefer to kill device_probe_drivers(). If we really need something
like this sometime in the future, we can easily resurrect it.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/base/dd.c |   13 -------------
 1 file changed, 13 deletions(-)

--- linux-2.6.orig/drivers/base/dd.c
+++ linux-2.6/drivers/base/dd.c
@@ -207,19 +207,6 @@ static int __device_attach(struct device
 	return driver_probe_device(drv, dev);
 }
 
-static int device_probe_drivers(void *data)
-{
-	struct device *dev = data;
-	int ret = 0;
-
-	if (dev->bus) {
-		down(&dev->sem);
-		ret = bus_for_each_drv(dev->bus, NULL, dev, __device_attach);
-		up(&dev->sem);
-	}
-	return ret;
-}
-
 /**
  *	device_attach - try to attach device to a driver.
  *	@dev:	device.
