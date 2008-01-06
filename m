Return-Path: <linux-kernel-owner+w=401wt.eu-S1759015AbYAFRGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015AbYAFRGv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 12:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755759AbYAFRGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 12:06:43 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1154 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754577AbYAFRGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 12:06:42 -0500
Date: Sun, 6 Jan 2008 12:06:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] PM: Acquire device locks on suspend
In-Reply-To: <200801061419.52277.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0801061203510.7367-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2008, Rafael J. Wysocki wrote:

> > If you can figure out a way to disable the warning in device_del() for 
> > just the one device being unregistered by 
> > device_pm_destroy_suspended(),
> 
> Something like this, perhaps:
> 
> @@ -905,6 +915,18 @@ void device_del(struct device * dev)
>  	struct device * parent = dev->parent;
>  	struct class_interface *class_intf;
>  
> +	if (down_trylock(&dev->sem)) {
> +		if (pm_sleep_lock()) {
> +			dev_warn(dev, "Illegal %s during suspend\n",
> +				__FUNCTION__);
> +			dump_stack();
> +		} else {
> +			pm_sleep_unlock();
> +		}
> +	} else {
> +		up(&dev->sem);
> +	}
> +
>  	if (parent)
>  		klist_del(&dev->knode_parent);
>  	if (MAJOR(dev->devt))

Bizarre, but it should work.  Be sure to include plenty of explanatory 
comments -- otherwise nobody will be able to figure it out!  :-)

Alan Stern

