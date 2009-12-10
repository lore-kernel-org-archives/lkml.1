Return-Path: <linux-kernel-owner+w=401wt.eu-S1760914AbZLJPbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914AbZLJPbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 10:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760801AbZLJPbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 10:31:06 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:54646 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754000AbZLJPbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 10:31:04 -0500
Date: Thu, 10 Dec 2009 10:31:10 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <200912100018.19723.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0912101010090.2825-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009, Rafael J. Wysocki wrote:

> > How about CONFIG_PROVE_LOCKING?  If lockdep really does start 
> > complaining then switching to completions would be a simple way to 
> > appease it.
> 
> Ah, that one is not set.  I guess I'll try it later, although I've already
> decided to use completions anyway.

You should see how badly lockdep complains about the rwsems.  If it 
really doesn't like them then using completions makes sense.

> Index: linux-2.6/drivers/base/power/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/main.c
> +++ linux-2.6/drivers/base/power/main.c
> @@ -56,6 +58,7 @@ static bool transition_started;
>  void device_pm_init(struct device *dev)
>  {
>  	dev->power.status = DPM_ON;
> +	init_completion(&dev->power.completion);
>  	pm_runtime_init(dev);
>  }

You need a matching complete_all() in device_pm_remove(), in case 
someone else is waiting for the device when it gets unregistered.

> +/**
> + * dpm_synchronize - Wait for PM callbacks of all devices to complete.
> + */
> +static void dpm_synchronize(void)
> +{
> +	struct device *dev;
> +
> +	async_synchronize_full();
> +
> +	mutex_lock(&dpm_list_mtx);
> +	list_for_each_entry(dev, &dpm_list, power.entry)
> +		INIT_COMPLETION(dev->power.completion);
> +	mutex_unlock(&dpm_list_mtx);
> +}

I agree with Linus, initializing the completions here is weird.  You
should initialize them just before using them.

> @@ -683,6 +786,7 @@ static int dpm_suspend(pm_message_t stat
>  
>  	INIT_LIST_HEAD(&list);
>  	mutex_lock(&dpm_list_mtx);
> +	pm_transition = state;
>  	while (!list_empty(&dpm_list)) {
>  		struct device *dev = to_device(dpm_list.prev);
>  
> @@ -697,13 +801,18 @@ static int dpm_suspend(pm_message_t stat
>  			put_device(dev);
>  			break;
>  		}
> -		dev->power.status = DPM_OFF;
>  		if (!list_empty(&dev->power.entry))
>  			list_move(&dev->power.entry, &list);
>  		put_device(dev);
> +		error = atomic_read(&async_error);
> +		if (error)
> +			break;
>  	}
>  	list_splice(&list, dpm_list.prev);

Here's something you might want to do in a later patch.  These awkward 
list-pointer manipulations can be simplified as follows:

static bool dpm_iterate_forward;
static struct device *dpm_next;

In device_pm_remove():

	mutex_lock(&dpm_list_mtx);
	if (dev == dpm_next)
		dpm_next = to_device(dpm_iterate_forward ?
			dev->power.entry.next : dev->power.entry.prev);
	list_del_init(&dev->power.entry);
	mutex_unlock(&dpm_list_mtx);

In dpm_resume():

	dpm_iterate_forward = true;
	list_for_each_entry_safe(dev, dpm_next, dpm_list, power.entry) {
		...

In dpm_suspend():

	dpm_iterate_forward = false;
	list_for_each_entry_safe_reverse(dev, dpm_next, dpm_list, 
			power.entry) {
		...

Whether this really is better is a matter of opinion; I like it.

Alan Stern

