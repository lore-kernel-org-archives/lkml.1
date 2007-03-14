Return-Path: <linux-kernel-owner+w=401wt.eu-S932325AbXCNSmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbXCNSmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 14:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932504AbXCNSmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 14:42:00 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:12850 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325AbXCNSl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 14:41:58 -0400
Date: Wed, 14 Mar 2007 19:43:37 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Oliver Neukum <oneukum@suse.de>, Maneesh Soni <maneesh@in.ibm.com>,
       <gregkh@suse.de>, Richard Purdie <rpurdie@rpsys.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
Message-ID: <20070314194337.5d439dab@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0703141048530.3112-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.64.0703131418300.9690@woody.linux-foundation.org>
	<Pine.LNX.4.44L0.0703141048530.3112-100000@iolanthe.rowland.org>
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

On Wed, 14 Mar 2007 12:12:37 -0400 (EDT),
Alan Stern <stern@rowland.harvard.edu> wrote:

> This seems more elegant (not yet tested).  Cornelia, does it look okay to 
> you?

Works for me (grouping & ungrouping ctc) and looks sane. Some more
comments below.


> +struct other_task_struct {
> +	struct kobject 		*kobj;
> +	void			(*func)(void *);
> +	void			*data;
> +	struct work_struct	work;
> +};
> +
> +static void other_task_work(struct work_struct *work)
> +{
> +	struct other_task_struct *ots = container_of(work,
> +			struct other_task_struct, work);
> +
> +	(ots->func)(ots->data);
> +	kobject_put(ots->kobj);
> +	kfree(ots);
> +}

The naming seems a bit unintuitive, but I don't have a good
alternative idea. Perhaps sysfs_work_struct, sysfs_delayed_work()?

> +
> +/**
> + * sysfs_access_in_other_task - delay access from an attribute method.
> + * @kobj: object we're acting for.
> + * @func: callback function to invoke later.
> + * @data: argument to pass to @func.
> + *
> + * sysfs attribute methods must not unregister themselves or their parent
> + * kobject (which would amount to the same thing).  Attempts to do so will
> + * deadlock, since unregistration is mutually exclusive with driver
> + * callbacks.
> + *
> + * Instead methods can call this routine, which will attempt to allocate
> + * and schedule a workqueue request to carry out the requested function
> + * in the workqueue's process context.
> + *
> + * Returns 0 if the request was submitted, -ENOMEM if storage could not
> + * be allocated.
> + */
> +int sysfs_access_in_other_task(struct kobject *kobj, void (*func)(void *),
> +		void *data)

sysfs_delay_access()?


> +/**
> + * device_access_in_other_task - delay access from an attribute method.
> + * @dev: device.
> + * @func: callback function to invoke later.
> + *
> + * Attribute methods must not unregister themselves or their parent device
> + * (which would amount to the same thing).  Attempts to do so will deadlock,
> + * since unregistration is mutually exclusive with driver callbacks.
> + *
> + * Instead methods can call this routine, which will attempt to allocate
> + * and schedule a workqueue request to carry out the requested function
> + * in the workqueue's process context.
> + *
> + * Returns 0 if the request was submitted, -ENOMEM if storage could not
> + * be allocated.
> + */
> +int device_access_in_other_task(struct device *dev,
> +		void (*func)(struct device *))
> +{
> +	return sysfs_access_in_other_task(&dev->kobj,
> +			(void (*)(void *)) func, dev);
> +}
> +EXPORT_SYMBOL_GPL(device_access_in_other_task);

device_delay_access()?

