Return-Path: <linux-kernel-owner+w=401wt.eu-S1751209AbXBMItJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbXBMItJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 03:49:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbXBMItJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 03:49:09 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:8956 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbXBMItH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 03:49:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CZlctb9Uas/c/yhyjVBgGvz+grbPFFrUkDxUwdIChYjGn6Qchg/ARVZHeqtAB82tOUU0CvNSFTquWlXyHBDkvQ2yj5Kap7S4Ipl2WjaHAcCCVZeAFKdRjDWO19+LZbhbo0XF3KJlI6LykVIAdhvDmWaF3diV8JoDwpozWr8xBhY=
Message-ID: <1a297b360702130049k59a12964i17eaf64bed83a137@mail.gmail.com>
Date: Tue, 13 Feb 2007 12:49:04 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [v4l-dvb-maintainer] dvb shared datastructure bug?
Cc: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1171352878.12771.30.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1171352878.12771.30.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/07, Arjan van de Ven <arjan@infradead.org> wrote:
> Hi,
>
> while working on the last pieces of the file_ops constantification, DVB
> is the small village in France that is holding the Romans at bay... but
> I think I found the final flaw in it now:
>
>        *pdvbdev = dvbdev = kmalloc(sizeof(struct dvb_device), GFP_KERNEL);
>
>         if (!dvbdev) {
>                 mutex_unlock(&dvbdev_register_lock);
>                 return -ENOMEM;
>         }
>
>         memcpy(dvbdev, template, sizeof(struct dvb_device));
>         dvbdev->type = type;
>         dvbdev->id = id;
>         dvbdev->adapter = adap;
>         dvbdev->priv = priv;
>
>         dvbdev->fops->owner = adap->module;
>
>
> this is the place in DVB that is writing to a struct file_operations.
> But as with almost all such cases in the kernel, this one is buggy:
> While the code nicely copies a template dvbdev, that template only has a
> pointer to a *shared* fops struct, the copy doesn't help that. So this
> code is overwriting the fops owner field for ALL active devices, not
> just the ones the copy of the template is for....

While working on a new device node, i stumbled across a similar issue
where attaching the frontend failed due to some sort of memory
corruption. This was seen as all the callbacks suddenly just vanished,
eventhough it existed in the driver

At that point, i figured it could be something due to an error at my
side , since the device that i was working was a bit complex and had
API changes as well.

Thanks for pointing it out. It looks like the issue sounds similar.

regards,
Manu
