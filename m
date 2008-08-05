Return-Path: <linux-kernel-owner+w=401wt.eu-S1761538AbYHENDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761538AbYHENDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 09:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760315AbYHEND0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 09:03:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52609 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757257AbYHENDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 09:03:24 -0400
Message-ID: <48984E7D.6010603@netcom.eu>
Date: Tue, 05 Aug 2008 14:58:37 +0200
From: David Engraf <david.engraf@netcom.eu>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: "Dasgupta, Romit" <romit@ti.com>
CC: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Greg KH <greg@kroah.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] [PM] Fixes missing PM entries in sysfs without CONFIG_PM_SLEEP
References: <200808041724.24016.rjw@sisk.pl> <Pine.LNX.4.44L0.0808041143350.3818-100000@iolanthe.rowland.org> <B85A65D85D7EB246BE421B3FB0FBB593013C9AE7E8@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593013C9AE7E8@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18VUw/g6Ks0L+lWgYI3zb3WQxoT8PhVGM9xXy8
 ubqZ6VMzeRgE7Fl56SefLwzqquEZwfiydOaPiYcNTcdQyIajm6
 VHOyX3P3lRD0gvxsN3yFQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan's patch is working on my system with CONFIG_PM and without
CONFIG_PM_SLEEP/CONFIG_USB_SUSPEND. Romit, I couldn't check your patch
because I was getting errors from the patch program (maybe the tabs).

Thanks again, David Engraf

> A minor change below: Removed old goto label PMError and introduced SysFSError.
> Tested with CONFIG_PM, CONFIG_PM_SLEEP, without CONFIG_PM and ofcourse with CONFIG_USB_SUSPEND. Works fine.
>
>
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 068aa1c..9c77939 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -541,6 +541,7 @@ void device_initialize(struct device *dev)
>         spin_lock_init(&dev->devres_lock);
>         INIT_LIST_HEAD(&dev->devres_head);
>         device_init_wakeup(dev, 0);
> +       device_pm_init(dev);
>         set_dev_node(dev, -1);
>  }
>
> @@ -897,9 +898,10 @@ int device_add(struct device *dev)
>         error = bus_add_device(dev);
>         if (error)
>                 goto BusError;
> -       error = device_pm_add(dev);
> +       error = dpm_sysfs_add(dev);
>         if (error)
> -               goto PMError;
> +               goto SysFSError;
> +       device_pm_add(dev);
>         kobject_uevent(&dev->kobj, KOBJ_ADD);
>         bus_attach_device(dev);
>         if (parent)
> @@ -920,7 +922,7 @@ int device_add(struct device *dev)
>   Done:
>         put_device(dev);
>         return error;
> - PMError:
> + SysFSError:
>         bus_remove_device(dev);
>   BusError:
>         if (dev->bus)
> @@ -1007,6 +1009,7 @@ void device_del(struct device *dev)
>         struct class_interface *class_intf;
>
>         device_pm_remove(dev);
> +       dpm_sysfs_remove(dev);
>         if (parent)
>                 klist_del(&dev->knode_parent);
>         if (MAJOR(dev->devt)) {
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 3250c52..d1f752b 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -67,10 +67,8 @@ void device_pm_unlock(void)
>   *     device_pm_add - add a device to the list of active devices
>   *     @dev:   Device to be added to the list
>   */
> -int device_pm_add(struct device *dev)
> +void device_pm_add(struct device *dev)
>  {
> -       int error;
> -
>         pr_debug("PM: Adding info for %s:%s\n",
>                  dev->bus ? dev->bus->name : "No Bus",
>                  kobject_name(&dev->kobj));
> @@ -89,13 +87,8 @@ int device_pm_add(struct device *dev)
>                  */
>                 WARN_ON(true);
>         }
> -       error = dpm_sysfs_add(dev);
> -       if (!error) {
> -               dev->power.status = DPM_ON;
> -               list_add_tail(&dev->power.entry, &dpm_list);
> -       }
> +       list_add_tail(&dev->power.entry, &dpm_list);
>         mutex_unlock(&dpm_list_mtx);
> -       return error;
>  }
>
>  /**
> @@ -110,7 +103,6 @@ void device_pm_remove(struct device *dev)
>                  dev->bus ? dev->bus->name : "No Bus",
>                  kobject_name(&dev->kobj));
>         mutex_lock(&dpm_list_mtx);
> -       dpm_sysfs_remove(dev);
>         list_del_init(&dev->power.entry);
>         mutex_unlock(&dpm_list_mtx);
>  }
> diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
> index a3252c0..41f51fa 100644
> --- a/drivers/base/power/power.h
> +++ b/drivers/base/power/power.h
> @@ -1,3 +1,8 @@
> +static inline void device_pm_init(struct device *dev)
> +{
> +       dev->power.status = DPM_ON;
> +}
> +
>  #ifdef CONFIG_PM_SLEEP
>
>  /*
> @@ -11,12 +16,12 @@ static inline struct device *to_device(struct list_head *entry)
>         return container_of(entry, struct device, power.entry);
>  }
>
> -extern int device_pm_add(struct device *);
> +extern void device_pm_add(struct device *);
>  extern void device_pm_remove(struct device *);
>
>  #else /* CONFIG_PM_SLEEP */
>
> -static inline int device_pm_add(struct device *dev) { return 0; }
> +static inline void device_pm_add(struct device *dev) {}
>  static inline void device_pm_remove(struct device *dev) {}
>
>  #endif
>
>   
>> -----Original Message-----
>> From: Alan Stern [mailto:stern@rowland.harvard.edu]
>> Sent: Monday, August 04, 2008 9:15 PM
>> To: Rafael J. Wysocki
>> Cc: Dasgupta, Romit; David Engraf; Greg KH; linux-usb@vger.kernel.org; linux-
>> kernel@vger.kernel.org; Linux-pm mailing list
>> Subject: Re: [PATCH] [PM] Fixes missing PM entries in sysfs without
>> CONFIG_PM_SLEEP
>>
>> On Mon, 4 Aug 2008, Rafael J. Wysocki wrote:
>>
>>     
>>>> Do you think we will want to make device_pm_add() return an error at
>>>> some point in the future?
>>>>         
>>> Well, maybe, but not any time soon. :-)
>>>       
>> Okay, here's the updated patch.  Awaiting comments from the testers...
>>
>> Alan Stern
>>
>>
>>
>> Index: usb-2.6/drivers/base/power/power.h
>> ================================================================
>> ===
>> --- usb-2.6.orig/drivers/base/power/power.h
>> +++ usb-2.6/drivers/base/power/power.h
>> @@ -1,3 +1,8 @@
>> +static inline void device_pm_init(struct device *dev)
>> +{
>> +       dev->power.status = DPM_ON;
>> +}
>> +
>> #ifdef CONFIG_PM_SLEEP
>>
>> /*
>> @@ -11,12 +16,12 @@ static inline struct device *to_device(s
>>        return container_of(entry, struct device, power.entry);
>> }
>>
>> -extern int device_pm_add(struct device *);
>> +extern void device_pm_add(struct device *);
>> extern void device_pm_remove(struct device *);
>>
>> #else /* CONFIG_PM_SLEEP */
>>
>> -static inline int device_pm_add(struct device *dev) { return 0; }
>> +static inline void device_pm_add(struct device *dev) {}
>> static inline void device_pm_remove(struct device *dev) {}
>>
>> #endif
>> Index: usb-2.6/drivers/base/core.c
>> ================================================================
>> ===
>> --- usb-2.6.orig/drivers/base/core.c
>> +++ usb-2.6/drivers/base/core.c
>> @@ -542,6 +542,7 @@ void device_initialize(struct device *de
>>        spin_lock_init(&dev->devres_lock);
>>        INIT_LIST_HEAD(&dev->devres_head);
>>        device_init_wakeup(dev, 0);
>> +       device_pm_init(dev);
>>        set_dev_node(dev, -1);
>> }
>>
>> @@ -898,9 +899,10 @@ int device_add(struct device *dev)
>>        error = bus_add_device(dev);
>>        if (error)
>>                goto BusError;
>> -       error = device_pm_add(dev);
>> +       error = dpm_sysfs_add(dev);
>>        if (error)
>>                goto PMError;
>> +       device_pm_add(dev);
>>        kobject_uevent(&dev->kobj, KOBJ_ADD);
>>        bus_attach_device(dev);
>>        if (parent)
>> @@ -1008,6 +1010,7 @@ void device_del(struct device *dev)
>>        struct class_interface *class_intf;
>>
>>        device_pm_remove(dev);
>> +       dpm_sysfs_remove(dev);
>>        if (parent)
>>                klist_del(&dev->knode_parent);
>>        if (MAJOR(dev->devt)) {
>> Index: usb-2.6/drivers/base/power/main.c
>> ================================================================
>> ===
>> --- usb-2.6.orig/drivers/base/power/main.c
>> +++ usb-2.6/drivers/base/power/main.c
>> @@ -67,10 +67,8 @@ void device_pm_unlock(void)
>>  *     device_pm_add - add a device to the list of active devices
>>  *     @dev:   Device to be added to the list
>>  */
>> -int device_pm_add(struct device *dev)
>> +void device_pm_add(struct device *dev)
>> {
>> -       int error;
>> -
>>        pr_debug("PM: Adding info for %s:%s\n",
>>                 dev->bus ? dev->bus->name : "No Bus",
>>                 kobject_name(&dev->kobj));
>> @@ -89,13 +87,9 @@ int device_pm_add(struct device *dev)
>>                 */
>>                WARN_ON(true);
>>        }
>> -       error = dpm_sysfs_add(dev);
>> -       if (!error) {
>> -               dev->power.status = DPM_ON;
>> -               list_add_tail(&dev->power.entry, &dpm_list);
>> -       }
>> +
>> +       list_add_tail(&dev->power.entry, &dpm_list);
>>        mutex_unlock(&dpm_list_mtx);
>> -       return error;
>> }
>>
>> /**
>> @@ -110,7 +104,6 @@ void device_pm_remove(struct device *dev
>>                 dev->bus ? dev->bus->name : "No Bus",
>>                 kobject_name(&dev->kobj));
>>        mutex_lock(&dpm_list_mtx);
>> -       dpm_sysfs_remove(dev);
>>        list_del_init(&dev->power.entry);
>>        mutex_unlock(&dpm_list_mtx);
>> }
>>     
>
>   

