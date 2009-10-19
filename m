Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbZJSRVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbZJSRVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 13:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757020AbZJSRVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 13:21:51 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:28394 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352AbZJSRVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 13:21:49 -0400
Date: Mon, 19 Oct 2009 11:21:38 -0600
From: Alex Chiang <achiang@hp.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: lenb@kernel.org, shaohua.li@intel.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 1/6] ACPI: dock: convert sysfs attributes to an
	attribute_group
Message-ID: <20091019172138.GB23948@ldl.fc.hp.com>
References: <20091016211323.12126.58457.stgit@bob.kio> <20091016211459.12126.60739.stgit@bob.kio> <20091018071630.GC3935@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091018071630.GC3935@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

* Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> On Fri, Oct 16, 2009 at 03:14:59PM -0600, Alex Chiang wrote:
> > As suggested by Dmitry Torokhov, convert the individual sysfs
> > attributes into an attribute group.
> > 
> > This change eliminates quite a bit of copy/paste code in the
> > error handling paths.
> > 
> 
> Looks much better, one more suggestion though:
> 
> > +err_unregister:
> > +	printk(KERN_ERR "%s encountered error %d\n", __func__, ret);
> 
> If you want to print error this it should probably go down, right before
> "return ret".

This is true for this patch, 1/6... but by the end of the series,
the problem has resolved itself.

I agree that it's sloppy to have this bit of inconsistency in the
middle of the patch series, but I'm reluctant to spin the entire
series again, for sake of a printk.

> > +	sysfs_remove_group(&dock_device->dev.kobj, &dock_attribute_group);
> 
> It begs another label right here. There are cases when yo0u already
> registered the platform device but haven't added the sysfs group, right?

This isn't quite true. In this patch, 1/6, our sequence goes:

	platform_device_register_simple()
	platform_device_add_data()
	/* twiddle some state in the platform device, no error paths though */
	sysfs_create_group()

Arguably, the platform_device_add_data() call could fail with
-ENOMEM, but the code today doesn't deal with that error
condition, and I didn't touch the platform_device_add_data()
line.

So really, there are no other exit paths between registering the
platform device and adding the sysfs group.

By the end of the patch series, I combine the _register_simple()
call with the _add_data() call and the final sequence looks like
this:

	if (platform_device_register_data() == error)
		return error;

	/* twiddle local state in platform device */

	if (sysfs_create_group())
		goto err_unregister;

	/* other stuff */

	err_unregister:
		printk(KERN_ERR "%s encountered error %d\n", __func__, ret);
		sysfs_remove_group(&dd->dev.kobj, &dock_attribute_group);
		platform_device_unregister(dd);
		return ret;

Checking other callsites of sysfs_remove_group(), it seems to be
valid to call that API even if the creation step failed.

Basically, I don't see the necessity of adding another label.

Below is the final end state of dock_add(). Hopefully the code is
a lot clearer than before. If there are still semantic issues,
please let me know and I'll happily respin.

Thanks.

/ac

static int dock_add(acpi_handle handle)
{
	int ret, id;
	struct dock_station ds, *dock_station;
	struct platform_device *dd;

	id = dock_station_count;
	dd = platform_device_register_data(NULL, "dock", id, &ds, sizeof(ds));
	if (IS_ERR(dd))
		return PTR_ERR(dd);

	dock_station = dd->dev.platform_data;

	dock_station->handle = handle;
	dock_station->dock_device = dd;
	dock_station->last_dock_time = jiffies - HZ;

	mutex_init(&dock_station->hp_lock);
	spin_lock_init(&dock_station->dd_lock);
	INIT_LIST_HEAD(&dock_station->sibling);
	INIT_LIST_HEAD(&dock_station->hotplug_devices);
	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);
	INIT_LIST_HEAD(&dock_station->dependent_devices);

	/* we want the dock device to send uevents */
	dev_set_uevent_suppress(&dd->dev, 0);

	if (is_dock(handle))
		dock_station->flags |= DOCK_IS_DOCK;
	if (is_ata(handle))
		dock_station->flags |= DOCK_IS_ATA;
	if (is_battery(handle))
		dock_station->flags |= DOCK_IS_BAT;

	ret = sysfs_create_group(&dd->dev.kobj, &dock_attribute_group);
	if (ret)
		goto err_unregister;

	/* Find dependent devices */
	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT, ACPI_UINT32_MAX,
			    find_dock_devices, dock_station, NULL);

	/* add the dock station as a device dependent on itself */
	ret = add_dock_dependent_device(dock_station, handle);
	if (ret)
		goto err_unregister;

	dock_station_count++;
	list_add(&dock_station->sibling, &dock_stations);
	return 0;

err_unregister:
	printk(KERN_ERR "%s encountered error %d\n", __func__, ret);
	sysfs_remove_group(&dd->dev.kobj, &dock_attribute_group);
	platform_device_unregister(dd);
	return ret;
}
