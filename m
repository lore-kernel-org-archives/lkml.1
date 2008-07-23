Return-Path: <linux-kernel-owner+w=401wt.eu-S1751772AbYGWJHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbYGWJHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 05:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbYGWJHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 05:07:33 -0400
Received: from smtp1.versatel.nl ([62.58.50.88]:53465 "EHLO smtp1.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbYGWJHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 05:07:32 -0400
Message-ID: <4886F6BF.6070900@hhs.nl>
Date: Wed, 23 Jul 2008 11:15:43 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: fs/char_dev.c memory leak (broken reference counting)
References: <4886F47A.3090102@hhs.nl>
In-Reply-To: <4886F47A.3090102@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans de Goede wrote:

<snip>

> And here is the problem when the fd refering to the character device 
> gets closed, no-one does a kobj_put. chrdev_open replace the file's f_op 
> pointer with the device driver fops, so the only fops release which will 
> get called is that of the device driver, cdev_put (which will call 
> kobj_put on the kobj) is exported, so device driver release methods 
> could and I guess should call cdev_put, but under drivers/char there is 
> not a single driver calling cdev_put !!
> 
> So unless I'm missing something the kojb release callback never gets 
> called.
> 

Never mind, I just found out that cdev_put gets called from __fput() in 
fs/file_table.c, thats somewhat convoluted if I may say so, I think atleast a 
comment in char_dev.c explaining this would be in order.

So that only leaves this part of my mail:

> ###
> 
> While on this topic in case of an usb device whose driver exports an 
> chardev to userspace, the device can be disconnected while the chardev 
> is still open. Currently usb-chardev drivers need to do their own 
> reference counting in their open / release fops to make sure their 
> device structure stays around until the last user has closed the device.
> 
> The reference counting in cdev is almost an 
> exact duplicate of the ref counting done in the device driver, thus I 
> would like to propose to add a release function ptr to the cdev struct 
> which if not NULL gets called from the cdev kobj release handler, then 
> then device driver no longer has to duplicate the ref counting.
> 
> This esp seems to make sense in cases where the device driver uses 
> cdev_init, as then the cdev structure could currently be freed by the 
> device driver (in case of hot unplug) without it knowing for sure that 
> there are no more users of the cdev structure. For example even when the 
> device driver does its own ref counting in the open / release fops, 
> there could still be some users in the form of open cdev sysfs files.
> 

I would still very much like to see this release callback get added, if there 
are no objections I'll do a patch for this.

Regards,

Hans

p.s.

Please keep me in the CC, I'm not subscribed to the kernel mailinglist.

