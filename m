Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbYCXUPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbYCXUPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 16:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbYCXUPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 16:15:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48107 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751795AbYCXUO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 16:14:59 -0400
Date: Mon, 24 Mar 2008 16:14:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation
 callbacks (rev. 3)
In-Reply-To: <200803241839.39469.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803241519090.24400-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2008, Rafael J. Wysocki wrote:

> Hi,
> 
> This is the 3rd revision of the patch introducing new callbacks for suspend
> and hibernation.  It has been tested on x86-64.
...
> * The registrations of parentless devices are disabled before the first
>   ->prepare() method is called and enabled before the first ->resume() method
>   is called

It would be okay to wait until after the last prepare() method is
called.  I don't know if it makes any difference in the end, however.

> +enum dpm_state {
> +	DPM_ON,
> +	DPM_RESUMING,
> +	DPM_SUSPENDING,
> +	DPM_OFF,
> +	DPM_OFF_IRQ,
> +};

Can we also have a DPM_PREPARING state, set when ->prepare() is about
to be called?  The PM core wouldn't make use of it but some drivers
would.  (I can't think of any use at all for the analogous
DPM_COMPLETING state, however.)

> @@ -68,22 +59,30 @@ int device_pm_add(struct device *dev)
...
> +	if (dev->parent) {
> +		if (dev->parent->power.status > DPM_RESUMING) {

Clearer to say: if (dev->parent->power.status >= DPM_SUSPENDING) {

...
> +	} else if (transition_started) {
> +		/*
> +		 * We refuse to register parentless devices while a PM
> +		 * transition is in progress in order to avoid leaving them
> +		 * unhandled down the road
> +		 */

Log a warning here?  If this ever happened, it would be the sort of 
unexpected regression that people get all excited about.

> +		goto Refuse;
>  	}
...

> +static void dpm_resume(pm_message_t state)
> +{
> +	struct list_head list;
> +
> +	INIT_LIST_HEAD(&list);
> +	mutex_lock(&dpm_list_mtx);
> +	transition_started = false;
> +	while (!list_empty(&dpm_list)) {
> +		struct device *dev = to_device(dpm_list.next);
> +
> +		if (dev->power.status > DPM_SUSPENDING) {

Clearer to say: if (dev->power.status >= DPM_OFF) {

Note that if dev->power.status is equal to DPM_SUSPENDING then you 
don't want to call resume_device(), but you still do want to change 
dev->power.status to DPM_RESUMING so that new children can be 
registered.

> +			dev->power.status = DPM_RESUMING;
> +			get_device(dev);
> +			mutex_unlock(&dpm_list_mtx);
> +
> +			resume_device(dev, state);
> +
> +			mutex_lock(&dpm_list_mtx);
> +			put_device(dev);
> +		}
> +		if (!list_empty(&dev->power.entry))
> +			list_move_tail(&dev->power.entry, &list);

A little problem here: You refer to dev after calling put_device().

> +	}
> +	list_splice(&list, &dpm_list);

This isn't the way I imagined doing it (your extra "list"), but it's 
fine.

...
> +static void dpm_complete(pm_message_t state)
>  {
...
> +			complete_device(dev, state);
> +
> +			mutex_lock(&dpm_list_mtx);
> +			put_device(dev);
> +		}
> +		if (!list_empty(&dev->power.entry))
> +			list_move(&dev->power.entry, &list);

Same problem with use-after-put.  Also present in dpm_prepare().

>  	}
> +	list_splice(&list, &dpm_list);
>  	mutex_unlock(&dpm_list_mtx);
>  }

...
>  static int dpm_suspend(pm_message_t state)
>  {
...
>  		error = suspend_device(dev, state);
> +
>  		mutex_lock(&dpm_list_mtx);
> +		put_device(dev);
>  		if (error) {
>  			printk(KERN_ERR "Could not suspend device %s: "
> -					"error %d%s\n",
> -					kobject_name(&dev->kobj),
> -					error,
> -					(error == -EAGAIN ?
> -					" (please convert to suspend_late)" :
> -					""));
> -			dev->power.sleeping = false;
> +				"error %d\n", kobject_name(&dev->kobj), error);
> +			list_splice_init(&dpm_list, &list);
>  			break;
>  		}
> -		if (!list_empty(&dev->power.entry))
> -			list_move(&dev->power.entry, &dpm_off);
> +		if (!list_empty(&dev->power.entry)) {
> +			dev->power.status = DPM_OFF;
> +			list_move(&dev->power.entry, &list);
> +		}

Use-after-put again.

>  	}
> -	if (!error)
> -		all_sleeping = true;
> +	list_splice(&list, &dpm_list);

Instead you could eliminate the list_splice_init() above and put here:

	list_splice(&list, dpm_list->prev);

This will move the entries from list to the end of dpm_list.

>  	mutex_unlock(&dpm_list_mtx);
> +	return error;
> +}

On the whole it looks quite good.

Alan Stern

