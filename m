Return-Path: <linux-kernel-owner+w=401wt.eu-S1765965AbXGPPNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765965AbXGPPNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 11:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760358AbXGPPNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 11:13:06 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:63439 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760344AbXGPPNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 11:13:05 -0400
Date: Mon, 16 Jul 2007 17:12:34 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 2/10] sysdev: add error check in sysdev_register()
Message-ID: <20070716171234.2bc31be8@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070716135138.GB2040@APFDCB5C>
References: <20070716134855.GA1858@APFDCB5C>
	<20070716135138.GB2040@APFDCB5C>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 22:51:38 +0900,
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> This patch enables to catch the errors returned by add() procedure of
> sysdev driver in sysdev_register.

> @@ -253,23 +254,50 @@ int sysdev_register(struct sys_device * 
> 
>  		/* Notify global drivers */
>  		list_for_each_entry(drv, &sysdev_drivers, entry) {
> -			if (drv->add)
> -				drv->add(sysdev);
> +			if (drv->add) {
> +				error = drv->add(sysdev);
> +				if (error)
> +					goto error_sysdev;
> +			}
> +			added_sysdev++;
>  		}

This looks asymmetric to me. Imagine we have a device/driver
combination for which drv->add will return -ESOMEERROR. Now, it depends
on the order:

1. The device is registered when the driver is already registered:
registration of the device will fail.

2. The driver is registered when the device is already registered:
driver registration will succeed, and the device will stay registered.

I'm not sure if that is what we really want.
