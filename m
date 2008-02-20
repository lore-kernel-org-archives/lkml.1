Return-Path: <linux-kernel-owner+w=401wt.eu-S1763764AbYBTWY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763764AbYBTWY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbYBTWYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:24:17 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43730 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751030AbYBTWYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:24:16 -0500
Date: Wed, 20 Feb 2008 17:24:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
In-Reply-To: <200802202315.49032.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0802201721080.24031-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008, Rafael J. Wysocki wrote:

> Well, below is an uncompiled and untested but illustrating the idea that
> might allow people not to bother with device_pm_schedule_removal()
> explicitly and can fix the issue at hand.
> 
> [There are some cases that need handling and are not covered here.]
> 
> Please have a look.
> 
> Thanks,
> Rafael

> +static struct task_struct *suspending_task;
> +static DEFINE_MUTEX(suspending_task_mtx);

I suspect you don't really need this mutex.

> +bool in_suspend_context(void)
> +{
> +	bool result;
> +
> +	mutex_lock(&suspending_task_mtx);
> +	result = (suspending_task == current);
> +	mutex_unlock(&suspending_task_mtx);
> +	return result;
> +}

If suspending_task == current then you are guaranteed to be serialized, 
because everything a single task does is serial.

> @@ -1162,7 +1162,10 @@ void device_destroy(struct class *class,
>  	dev = class_find_device(class, &devt, __match_devt);
>  	if (dev) {
>  		put_device(dev);
> -		device_unregister(dev);
> +		if (in_suspend_context())
> +			device_pm_schedule_removal(dev);
> +		else
> +			device_unregister(dev);
>  	}
>  }

But what about device_del()?  Can a similar change be made there?

Alan Stern

