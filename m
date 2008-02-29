Return-Path: <linux-kernel-owner+w=401wt.eu-S1759328AbYB2O14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328AbYB2O14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 09:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760007AbYB2O1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 09:27:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59423 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759539AbYB2O1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 09:27:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer removal
Date: Fri, 29 Feb 2008 15:26:08 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0802281741030.2180-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802281741030.2180-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802291526.08522.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 28 of February 2008, Alan Stern wrote:
> Rafael:

Hi,

> Here's my patch.  It doesn't include the timers for deadlock debugging, 
> but it does include all the other stuff we've been talking about.  My 
> base probably isn't quite in sync with yours, so this may not apply 
> cleanly on your system.  But the divergences should be small.
> 
> Incidentally, there seemed to be a bug in your dpm_suspend() -- the 
> dpm_list_mtx needs to be reacquired before the error checking.  This
> patch fixes that.  It also removes pm_sleep_rwsem, which isn't used 
> any more.
> 
> We should think about device_pm_schedule_removal().  It won't work
> right if a suspend method calls it for the device being suspended, 
> because the device gets moved to the dpm_off list after the method 
> runs.
> 
> Index: usb-2.6/Documentation/power/devices.txt
> ===================================================================
> --- usb-2.6.orig/Documentation/power/devices.txt
> +++ usb-2.6/Documentation/power/devices.txt
> @@ -192,11 +192,27 @@ used to resume those devices.
>  
>  The ordering of the device tree is defined by the order in which devices
>  get registered:  a child can never be registered, probed or resumed before
> -its parent; and can't be removed or suspended after that parent.
> +its parent; and can't be removed or suspended after that parent.  This
> +means that special care is needed when calling device_move(); currently
> +the kernel does not adjust its suspend and resume ordering to match the
> +new device tree.
>  
>  The policy is that the device tree should match hardware bus topology.
>  (Or at least the control bus, for devices which use multiple busses.)
>  
> +There is an unavoidable race between the PM core suspending all the
> +children of a device and the device's driver registering new children.
> +As a result, it is possible that the core may try to suspend a device
> +without first having suspended all of the device's children.  Drivers
> +must check for this; a suspend method should return -EBUSY if there are
> +unsuspended children.  (The child->power.sleeping field can be used
> +for this check.)  In addition, it is illegal to register a child device

s/illegal/invalid/

> +below a suspended parent; hence suspend methods must synchronize with
> +other kernel threads that may attempt to add new children.  The suspend
> +method must prevent new registrations and wait for concurrent registrations
> +to complete before it returns.  New children may be added once more when
> +the resume method runs.
> +
>  Suspending Devices
>  ------------------
> @@ -387,7 +403,9 @@ while the system was powered off, whenev
>  PCMCIA, MMC, USB, Firewire, SCSI, and even IDE are common examples of busses
>  where common Linux platforms will see such removal.  Details of how drivers
>  will notice and handle such removals are currently bus-specific, and often
> -involve a separate thread.
> +involve a separate thread.  Currently the kernel does not allow a suspend
> +or resume method to directly unregister the device being suspended or
> +resumed.
>  
>  
>  Note that the bus-specific runtime PM wakeup mechanism can exist, and might
> Index: usb-2.6/include/linux/pm.h
> ===================================================================
> --- usb-2.6.orig/include/linux/pm.h
> +++ usb-2.6/include/linux/pm.h
> @@ -180,8 +180,20 @@ typedef struct pm_message {
>  #define PMSG_HIBERNATE	((struct pm_message){ .event = PM_EVENT_HIBERNATE, })
>  #define PMSG_ON		((struct pm_message){ .event = PM_EVENT_ON, })
>  
> +/* This records which method calls have been made, not the device's
> + * actual power state.  It is read-only to drivers.
> + */
> +enum pm_sleep_state {

I'd call it dev_pm_state, in analogy with dev_pm_info etc.

> +	PM_AWAKE,		/* = 0, normal situation */
> +	PM_SLEEPING,		/* suspend method is running */
> +	PM_ASLEEP,		/* suspend method has returned */
> +	PM_WAKING,		/* resume method is running */
> +	PM_GONE,		/* device has been unregistered */
> +};
> +
>  struct dev_pm_info {
>  	pm_message_t		power_state;
> +	enum pm_sleep_state	sleeping;

In fact 'sleeping' doesn't look good in this context.  'pm_state' seems
better to me (although it is confusingly similar to 'power_state', we're going
to get rid of the latter anyway).

>  	unsigned		can_wakeup:1;
>  #ifdef	CONFIG_PM_SLEEP
>  	unsigned		should_wakeup:1;
> Index: usb-2.6/drivers/base/power/power.h
> ===================================================================
> --- usb-2.6.orig/drivers/base/power/power.h
> +++ usb-2.6/drivers/base/power/power.h
> @@ -11,28 +11,18 @@ static inline struct device *to_device(s
>  	return container_of(entry, struct device, power.entry);
>  }
>  
> -extern void device_pm_add(struct device *);
> +extern int device_pm_add(struct device *);
>  extern void device_pm_remove(struct device *);
> -extern int pm_sleep_lock(void);
> -extern void pm_sleep_unlock(void);
>  
>  #else /* CONFIG_PM_SLEEP */
>  
>  
> -static inline void device_pm_add(struct device *dev)
> -{
> -}
> -
> -static inline void device_pm_remove(struct device *dev)
> -{
> -}
> -
> -static inline int pm_sleep_lock(void)
> +static inline int device_pm_add(struct device *dev)
>  {
>  	return 0;
>  }
>  
> -static inline void pm_sleep_unlock(void)
> +static inline void device_pm_remove(struct device *dev)
>  {
>  }
>  
> Index: usb-2.6/drivers/base/power/main.c
> ===================================================================
> --- usb-2.6.orig/drivers/base/power/main.c
> +++ usb-2.6/drivers/base/power/main.c
> @@ -54,7 +54,9 @@ static LIST_HEAD(dpm_destroy);
>  
>  static DEFINE_MUTEX(dpm_list_mtx);
>  
> -static DECLARE_RWSEM(pm_sleep_rwsem);
> +/* Protected by dpm_list_mtx */
> +static bool child_added_while_parent_suspends; 

I don't like this name, but I have no better idea at the moment.

> +static bool all_devices_asleep;
>  
>  int (*platform_enable_wakeup)(struct device *dev, int is_on);
>  
> @@ -62,14 +64,37 @@ int (*platform_enable_wakeup)(struct dev
>   *	device_pm_add - add a device to the list of active devices
>   *	@dev:	Device to be added to the list
>   */
> -void device_pm_add(struct device *dev)
> +int device_pm_add(struct device *dev)
>  {
> +	int rc = 0;
> +
>  	pr_debug("PM: Adding info for %s:%s\n",
>  		 dev->bus ? dev->bus->name : "No Bus",
>  		 kobject_name(&dev->kobj));
>  	mutex_lock(&dpm_list_mtx);
> -	list_add_tail(&dev->power.entry, &dpm_active);
> +	if (dev->parent) {

Hmm.

Suppose we add a mutex to dev_pm_info, say pm_mtx, and require it to be:
(1) taken by suspend_device(dev) (at the beginning)
(2) released by resume_device(dev) (at the end)
(3) taken (and released) by device_pm_add() if dev is the parent of the device
    being added.

In that case, device_pm_add() will block on attepmpts to register devices whose
parents are suspended (or suspending) and we're done.  At least so it would
seem.

> +		switch (dev->parent->power.sleeping) {
> +		case PM_SLEEPING:
> +			child_added_while_parent_suspends = true;
> +			break;
> +		case PM_ASLEEP:
> +			dev_err(dev, "added while parent '%s' is asleep\n",
> +					dev->parent->bus_id);
> +			rc = -EHOSTDOWN;
> +			break;
> +		default:
> +			break;
> +		}
> +	} else if (all_devices_asleep) {
> +		dev_err(dev, "added while all devices are asleep\n");
> +		rc = -ENETDOWN;
> +	}

The error codes are a bit unusual, but whatever.

> +	if (rc == 0)
> +		list_add_tail(&dev->power.entry, &dpm_active);
> +	else
> +		dump_stack();
>  	mutex_unlock(&dpm_list_mtx);
> +	return rc;
>  }
>  
>  /**
> @@ -86,6 +111,7 @@ void device_pm_remove(struct device *dev
>  	mutex_lock(&dpm_list_mtx);
>  	dpm_sysfs_remove(dev);
>  	list_del_init(&dev->power.entry);
> +	dev->power.sleeping = PM_GONE;
>  	mutex_unlock(&dpm_list_mtx);
>  }
>  
> @@ -107,31 +133,6 @@ void device_pm_schedule_removal(struct d
>  }
>  EXPORT_SYMBOL_GPL(device_pm_schedule_removal);
>  
> -/**
> - *	pm_sleep_lock - mutual exclusion for registration and suspend
> - *
> - *	Returns 0 if no suspend is underway and device registration
> - *	may proceed, otherwise -EBUSY.
> - */
> -int pm_sleep_lock(void)
> -{
> -	if (down_read_trylock(&pm_sleep_rwsem))
> -		return 0;
> -
> -	return -EBUSY;
> -}
> -
> -/**
> - *	pm_sleep_unlock - mutual exclusion for registration and suspend
> - *
> - *	This routine undoes the effect of device_pm_add_lock
> - *	when a device's registration is complete.
> - */
> -void pm_sleep_unlock(void)
> -{
> -	up_read(&pm_sleep_rwsem);
> -}
> -
>  
>  /*------------------------- Resume routines -------------------------*/
>  
> @@ -242,14 +243,18 @@ static int resume_device(struct device *
>  static void dpm_resume(void)
>  {
>  	mutex_lock(&dpm_list_mtx);
> +	all_devices_asleep = false;
>  	while(!list_empty(&dpm_off)) {
>  		struct list_head *entry = dpm_off.next;
>  		struct device *dev = to_device(entry);
>  
>  		list_move_tail(entry, &dpm_active);
> +		dev->power.sleeping = PM_WAKING;
>  		mutex_unlock(&dpm_list_mtx);
>  		resume_device(dev);
>  		mutex_lock(&dpm_list_mtx);
> +		if (dev->power.sleeping != PM_GONE)
> +			dev->power.sleeping = PM_AWAKE;
>  	}
>  	mutex_unlock(&dpm_list_mtx);
>  }
> @@ -285,7 +290,6 @@ void device_resume(void)
>  	might_sleep();
>  	dpm_resume();
>  	unregister_dropped_devices();
> -	up_write(&pm_sleep_rwsem);
>  }
>  EXPORT_SYMBOL_GPL(device_resume);
>  
> @@ -421,9 +425,18 @@ static int dpm_suspend(pm_message_t stat
>  		struct list_head *entry = dpm_active.prev;
>  		struct device *dev = to_device(entry);
>  
> +		dev->power.sleeping = PM_SLEEPING;
> +		child_added_while_parent_suspends = false;
>  		mutex_unlock(&dpm_list_mtx);
>  		error = suspend_device(dev, state);
> +		mutex_lock(&dpm_list_mtx);
>  		if (error) {
> +			if (dev->power.sleeping != PM_GONE)
> +				dev->power.sleeping = PM_AWAKE;
> +			if (error == -EBUSY && entry != dpm_active.prev)
> +				continue;	/* A child was added before
> +						 * the device could suspend
> +						 */
>  			printk(KERN_ERR "Could not suspend device %s: "
>  					"error %d%s\n",
>  					kobject_name(&dev->kobj),
> @@ -433,10 +446,24 @@ static int dpm_suspend(pm_message_t stat
>  					""));
>  			break;
>  		}
> -		mutex_lock(&dpm_list_mtx);
> -		if (!list_empty(&dev->power.entry))
> -			list_move(&dev->power.entry, &dpm_off);
> +		if (dev->power.sleeping != PM_GONE) {
> +			if (child_added_while_parent_suspends) {
> +				dev_err(dev, "suspended while a child "
> +						"was added\n");
> +				dev->power.sleeping = PM_WAKING;
> +				mutex_unlock(&dpm_list_mtx);

This seems to be a weak spot.  The resuming of the device at this point need
not work correctly, given that the system's target state is still a sleep
state.

> +				resume_device(dev);
> +				mutex_lock(&dpm_list_mtx);
> +				if (dev->power.sleeping != PM_GONE)
> +					dev->power.sleeping = PM_AWAKE;
> +			} else {
> +				dev->power.sleeping = PM_ASLEEP;
> +				list_move(&dev->power.entry, &dpm_off);
> +			}
> +		}
>  	}
> +	if (!error)
> +		all_devices_asleep = true;
>  	mutex_unlock(&dpm_list_mtx);
>  
>  	return error;
> @@ -454,7 +481,6 @@ int device_suspend(pm_message_t state)
>  	int error;
>  
>  	might_sleep();
> -	down_write(&pm_sleep_rwsem);
>  	error = dpm_suspend(state);
>  	if (error)
>  		device_resume();
> Index: usb-2.6/drivers/base/core.c
> ===================================================================
> --- usb-2.6.orig/drivers/base/core.c
> +++ usb-2.6/drivers/base/core.c
> @@ -815,10 +815,12 @@ int device_add(struct device *dev)
>  	error = dpm_sysfs_add(dev);
>  	if (error)
>  		goto PMError;
> -	device_pm_add(dev);
>  	error = bus_add_device(dev);
>  	if (error)
>  		goto BusError;
> +	error = device_pm_add(dev);
> +	if (error)
> +		goto PMAddError;
>  	kobject_uevent(&dev->kobj, KOBJ_ADD);
>  	bus_attach_device(dev);
>  	if (parent)
> @@ -838,8 +840,9 @@ int device_add(struct device *dev)
>   Done:
>  	put_device(dev);
>  	return error;
> + PMAddError:
> +	bus_remove_device(dev);
>   BusError:
> -	device_pm_remove(dev);
>  	dpm_sysfs_remove(dev);
>   PMError:
>  	if (dev->bus)

Well, I wish it could be simpler ...

Thanks,
Rafael
