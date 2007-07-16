Return-Path: <linux-kernel-owner+w=401wt.eu-S1763647AbXGPQSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763647AbXGPQSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758890AbXGPQSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:18:24 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:14171 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758823AbXGPQSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:18:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cx/bU/b/tMGOlAC+p+zTbRBgb/2tpR78yRZqRooUY5hQwh8YzUXEemGHrFzPuUvpny2fT0610rx2t/D8R6ZhTFpzHPMlsvecO/bAO7ADa0GElJOM80GoT8+I+kjDlJhesadrBEyIbwIVcEpQ/RrDdhfXicNGPf2381BPcKF096A=
Message-ID: <961aa3350707160918n3b95227fw524c39248ff63a3b@mail.gmail.com>
Date: Tue, 17 Jul 2007 01:18:22 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Cornelia Huck" <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH 2/10] sysdev: add error check in sysdev_register()
Cc: linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>
In-Reply-To: <20070716171234.2bc31be8@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070716134855.GA1858@APFDCB5C> <20070716135138.GB2040@APFDCB5C>
	 <20070716171234.2bc31be8@gondolin.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/17, Cornelia Huck <cornelia.huck@de.ibm.com>:
> On Mon, 16 Jul 2007 22:51:38 +0900,
> Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
> > This patch enables to catch the errors returned by add() procedure of
> > sysdev driver in sysdev_register.
>
> > @@ -253,23 +254,50 @@ int sysdev_register(struct sys_device *
> >
> >               /* Notify global drivers */
> >               list_for_each_entry(drv, &sysdev_drivers, entry) {
> > -                     if (drv->add)
> > -                             drv->add(sysdev);
> > +                     if (drv->add) {
> > +                             error = drv->add(sysdev);
> > +                             if (error)
> > +                                     goto error_sysdev;
> > +                     }
> > +                     added_sysdev++;
> >               }
>
> This looks asymmetric to me. Imagine we have a device/driver
> combination for which drv->add will return -ESOMEERROR. Now, it depends
> on the order:
>
> 1. The device is registered when the driver is already registered:
> registration of the device will fail.
>
> 2. The driver is registered when the device is already registered:
> driver registration will succeed, and the device will stay registered.
>
> I'm not sure if that is what we really want.

Thanks, I didn't realize the asymmetry.
I think we need to add same check to sysdev_driver_register().
But I need to check every sysdev driver's add() functions before
making this change. So this patch dropped from this series of patches
for now.
