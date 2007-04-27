Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbXD0Vky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbXD0Vky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757352AbXD0Vky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:40:54 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51128 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757349AbXD0VkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:40:18 -0400
Date: Fri, 27 Apr 2007 22:43:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: torvalds@osdl.org
Subject: BAD PATCH: IDE: remove rwsem use from ide-proc core
Message-ID: <20070427224334.1aa1ed4b@the-village.bc.nu>
In-Reply-To: <200704272059.l3RKxQBF024043@hera.kernel.org>
References: <200704272059.l3RKxQBF024043@hera.kernel.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -	down_read(&dev->bus->subsys.rwsem);
>  	if (dev->driver) {
>  		ide_drv = container_of(dev->driver, ide_driver_t, gen_driver);
>  		len = sprintf(page, "%s version %s\n",
>  				dev->driver->name, ide_drv->version);
>  	} else
>  		len = sprintf(page, "ide-default version 0.9.newide\n");
> -	up_read(&dev->bus->subsys.rwsem);
>  	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);

The semaphore is used to ensure dev->driver doesn't change under us. This
patch appears to remove the neccessary locking without replacing it with
anything viable. A local lock would do but the simple removal appears to
be unsafe.


> @@ -327,7 +325,6 @@ static int ide_replace_subdriver(ide_drive_t *drive, const char *driver)
>  	int ret = 1;
>  	int err;
>  
> -	down_write(&dev->bus->subsys.rwsem);
>  	device_release_driver(dev);
>  	/* FIXME: device can still be in use by previous driver */
>  	strlcpy(drive->driver_req, driver, sizeof(drive->driver_req));
> @@ -345,7 +342,6 @@ static int ide_replace_subdriver(ide_drive_t *drive, const char *driver)
>  	}
>  	if (dev->driver && !strcmp(dev->driver->name, driver))
>  		ret = 0;
> -	up_write(&dev->bus->subsys.rwsem);

