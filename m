Return-Path: <linux-kernel-owner+w=401wt.eu-S1756481AbYCEQ1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbYCEQ1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYCEQ1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:27:07 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41649 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752632AbYCEQ1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:27:04 -0500
Date: Wed, 5 Mar 2008 11:27:03 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] PM: Make PM core handle device registrations
 concurrent with suspend/hibernation
In-Reply-To: <200803050215.31195.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803051118060.4750-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008, Rafael J. Wysocki wrote:

> -void device_pm_add(struct device *dev)
> +int device_pm_add(struct device *dev)
>  {
> +	int error = 0;
> +
>  	pr_debug("PM: Adding info for %s:%s\n",
>  		 dev->bus ? dev->bus->name : "No Bus",
>  		 kobject_name(&dev->kobj));
>  	mutex_lock(&dpm_list_mtx);
> -	list_add_tail(&dev->power.entry, &dpm_active);
> +	if (dev->parent && dev->parent->power.sleeping) {
> +		WARN_ON(true);

I would prefer to put a dev_warn() line here, so that people reading
the kernel log can easily tell which device caused the problem and what
sort of problem it is.  Something like this:

		dev_warn(dev, "device added while parent %s is asleep\n",
				dev->parent->bus_id);
		WARN_ON(true);

> @@ -426,6 +406,12 @@ static int dpm_suspend(pm_message_t stat
>  		struct list_head *entry = dpm_active.prev;
>  		struct device *dev = to_device(entry);
>  
> +		if (dev->parent && dev->parent->power.sleeping) {
> +			WARN_ON(true);
> +			error = -EAGAIN;
> +			break;

Again, a dev_warn() would be appropriate.

And you might consider taking out the "error = -EAGAIN" and the
"break".  When this occurs it doesn't mean that devices were suspended
in the wrong order; it means that the ordering of the parent pointers
fails to match the ordering of dpm_active.  The only way for this to
happen is if the parent pointers are messed up by device_move() --
dpm_active will still be correct.

The rest of the patch looks fine.

Alan Stern

