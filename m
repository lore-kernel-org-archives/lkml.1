Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbYAEUJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbYAEUJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 15:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756520AbYAEUIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 15:08:49 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1088 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756189AbYAEUIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 15:08:47 -0500
Date: Sat, 5 Jan 2008 15:08:46 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] PM: Acquire device locks on suspend
In-Reply-To: <200801051936.22307.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0801051455320.26040-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jan 2008, Rafael J. Wysocki wrote:

> Greg, Andrew,
> 
> The appended patch is a replacement for
> gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch that deadlocked
> suspend and hibernation on some systems.
> 
> Please consider for applying.

This warning message:

> @@ -905,6 +915,13 @@ void device_del(struct device * dev)
>  	struct device * parent = dev->parent;
>  	struct class_interface *class_intf;
>  
> +	if (pm_sleep_lock()) {
> +		dev_warn(dev, "Illegal %s during suspend\n", __FUNCTION__);
> +		dump_stack();
> +	} else {

will unavoidably be triggered by this code:

> +void device_pm_destroy_suspended(struct device *dev)
> +{
> +	pr_debug("PM: Removing suspended device %s:%s\n",
> +		 dev->bus ? dev->bus->name : "No Bus",
> +		 kobject_name(&dev->kobj));
> +	mutex_lock(&dpm_list_mtx);
> +	list_del_init(&dev->power.entry);
> +	mutex_unlock(&dpm_list_mtx);
> +	up(&dev->sem);
> +	device_unregister(dev);
> +}

since the call to device_del() will occur while the pm_sleep_rwsem is
still locked for writing.  That's why I suggested not unregistering
these devices until after everything else has been resumed and the
rwsem has been dropped.

Another thing to watch out for: Just in case somebody ends up calling
destroy_suspended_device(dev) from within dev's own resume method, you 
should interchange the resume_device() and the list_move_tail() 
calls in dpm_resume().

Alan Stern



