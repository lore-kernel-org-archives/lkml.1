Return-Path: <linux-kernel-owner+w=401wt.eu-S1760841AbYHENS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760841AbYHENS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 09:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbYHENSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 09:18:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57084 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbYHENSo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 09:18:44 -0400
From: "Dasgupta, Romit" <romit@ti.com>
To: David Engraf <david.engraf@netcom.eu>
CC: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Greg KH <greg@kroah.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Date: Tue, 5 Aug 2008 18:38:13 +0530
Subject: RE: [PATCH] [PM] Fixes missing PM entries in sysfs without
 CONFIG_PM_SLEEP
Thread-Topic: [PATCH] [PM] Fixes missing PM entries in sysfs without
 CONFIG_PM_SLEEP
Thread-Index: Acj2+6uLdxG1Y33iRLe4LXQkvx0jTAAAEfXw
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593013C9AEE67@dbde02.ent.ti.com>
References: <200808041724.24016.rjw@sisk.pl>
 <Pine.LNX.4.44L0.0808041143350.3818-100000@iolanthe.rowland.org>
 <B85A65D85D7EB246BE421B3FB0FBB593013C9AE7E8@dbde02.ent.ti.com>
 <48984E7D.6010603@netcom.eu>
In-Reply-To: <48984E7D.6010603@netcom.eu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think it is my mailer program that is adding the tabs.
In Alan's patch I just changed the PMError label with SysFSError.


>-----Original Message-----
>From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kernel.org]
>On Behalf Of David Engraf
>Sent: Tuesday, August 05, 2008 6:29 PM
>To: Dasgupta, Romit
>Cc: Alan Stern; Rafael J. Wysocki; Greg KH; linux-usb@vger.kernel.org; linux-
>kernel@vger.kernel.org; Linux-pm mailing list
>Subject: Re: [PATCH] [PM] Fixes missing PM entries in sysfs without
>CONFIG_PM_SLEEP
>
>Alan's patch is working on my system with CONFIG_PM and without
>CONFIG_PM_SLEEP/CONFIG_USB_SUSPEND. Romit, I couldn't check your patch
>because I was getting errors from the patch program (maybe the tabs).
>
>Thanks again, David Engraf
>
>> A minor change below: Removed old goto label PMError and introduced
>SysFSError.
>> Tested with CONFIG_PM, CONFIG_PM_SLEEP, without CONFIG_PM and
>ofcourse with CONFIG_USB_SUSPEND. Works fine.
>>
>>
>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> index 068aa1c..9c77939 100644
>> --- a/drivers/base/core.c
>> +++ b/drivers/base/core.c
>> @@ -541,6 +541,7 @@ void device_initialize(struct device *dev)
>>         spin_lock_init(&dev->devres_lock);
>>         INIT_LIST_HEAD(&dev->devres_head);
>>         device_init_wakeup(dev, 0);
>> +       device_pm_init(dev);
>>         set_dev_node(dev, -1);
>>  }
>>
>> @@ -897,9 +898,10 @@ int device_add(struct device *dev)
>>         error = bus_add_device(dev);
>>         if (error)
>>                 goto BusError;
>> -       error = device_pm_add(dev);
>> +       error = dpm_sysfs_add(dev);
>>         if (error)
>> -               goto PMError;
>> +               goto SysFSError;
>> +       device_pm_add(dev);
>>         kobject_uevent(&dev->kobj, KOBJ_ADD);
>>         bus_attach_device(dev);
>>         if (parent)
>> @@ -920,7 +922,7 @@ int device_add(struct device *dev)
>>   Done:
>>         put_device(dev);
>>         return error;
>> - PMError:
>> + SysFSError:
>>         bus_remove_device(dev);
>>   BusError:
>>         if (dev->bus)
>> @@ -1007,6 +1009,7 @@ void device_del(struct device *dev)
>>         struct class_interface *class_intf;
>>
>>         device_pm_remove(dev);
>> +       dpm_sysfs_remove(dev);
>>         if (parent)
>>                 klist_del(&dev->knode_parent);
>>         if (MAJOR(dev->devt)) {
>> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
>> index 3250c52..d1f752b 100644
>> --- a/drivers/base/power/main.c
>> +++ b/drivers/base/power/main.c
>> @@ -67,10 +67,8 @@ void device_pm_unlock(void)
>>   *     device_pm_add - add a device to the list of active devices
>>   *     @dev:   Device to be added to the list
>>   */
>> -int device_pm_add(struct device *dev)
>> +void device_pm_add(struct device *dev)
>>  {
>> -       int error;
>> -
>>         pr_debug("PM: Adding info for %s:%s\n",
>>                  dev->bus ? dev->bus->name : "No Bus",
>>                  kobject_name(&dev->kobj));
>> @@ -89,13 +87,8 @@ int device_pm_add(struct device *dev)
>>                  */
>>                 WARN_ON(true);
>>         }
>> -       error = dpm_sysfs_add(dev);
>> -       if (!error) {
>> -               dev->power.status = DPM_ON;
>> -               list_add_tail(&dev->power.entry, &dpm_list);
>> -       }
>> +       list_add_tail(&dev->power.entry, &dpm_list);
>>         mutex_unlock(&dpm_list_mtx);
>> -       return error;
>>  }
>>
>>  /**
>> @@ -110,7 +103,6 @@ void device_pm_remove(struct device *dev)
>>                  dev->bus ? dev->bus->name : "No Bus",
>>                  kobject_name(&dev->kobj));
>>         mutex_lock(&dpm_list_mtx);
>> -       dpm_sysfs_remove(dev);
>>         list_del_init(&dev->power.entry);
>>         mutex_unlock(&dpm_list_mtx);
>>  }
>> diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
>> index a3252c0..41f51fa 100644
>> --- a/drivers/base/power/power.h
>> +++ b/drivers/base/power/power.h
>> @@ -1,3 +1,8 @@
>> +static inline void device_pm_init(struct device *dev)
>> +{
>> +       dev->power.status = DPM_ON;
>> +}
>> +
>>  #ifdef CONFIG_PM_SLEEP
>>
>>  /*
>> @@ -11,12 +16,12 @@ static inline struct device *to_device(struct list_head
>*entry)
>>         return container_of(entry, struct device, power.entry);
>>  }
>>
>> -extern int device_pm_add(struct device *);
>> +extern void device_pm_add(struct device *);
>>  extern void device_pm_remove(struct device *);
>>
>>  #else /* CONFIG_PM_SLEEP */
>>
>> -static inline int device_pm_add(struct device *dev) { return 0; }
>> +static inline void device_pm_add(struct device *dev) {}
>>  static inline void device_pm_remove(struct device *dev) {}
>>
>>  #endif
>>
>>
>>> -----Original Message-----
>>> From: Alan Stern [mailto:stern@rowland.harvard.edu]
>>> Sent: Monday, August 04, 2008 9:15 PM
>>> To: Rafael J. Wysocki
>>> Cc: Dasgupta, Romit; David Engraf; Greg KH; linux-usb@vger.kernel.org; linux-
>>> kernel@vger.kernel.org; Linux-pm mailing list
>>> Subject: Re: [PATCH] [PM] Fixes missing PM entries in sysfs without
>>> CONFIG_PM_SLEEP
>>>
>>> On Mon, 4 Aug 2008, Rafael J. Wysocki wrote:
>>>
>>>
>>>>> Do you think we will want to make device_pm_add() return an error at
>>>>> some point in the future?
>>>>>
>>>> Well, maybe, but not any time soon. :-)
>>>>
>>> Okay, here's the updated patch.  Awaiting comments from the testers...
>>>
>>> Alan Stern
>>>
>>>
>>>
>>> Index: usb-2.6/drivers/base/power/power.h
>>>
>================================================================
>>> ===
>>> --- usb-2.6.orig/drivers/base/power/power.h
>>> +++ usb-2.6/drivers/base/power/power.h
>>> @@ -1,3 +1,8 @@
>>> +static inline void device_pm_init(struct device *dev)
>>> +{
>>> +       dev->power.status = DPM_ON;
>>> +}
>>> +
>>> #ifdef CONFIG_PM_SLEEP
>>>
>>> /*
>>> @@ -11,12 +16,12 @@ static inline struct device *to_device(s
>>>        return container_of(entry, struct device, power.entry);
>>> }
>>>
>>> -extern int device_pm_add(struct device *);
>>> +extern void device_pm_add(struct device *);
>>> extern void device_pm_remove(struct device *);
>>>
>>> #else /* CONFIG_PM_SLEEP */
>>>
>>> -static inline int device_pm_add(struct device *dev) { return 0; }
>>> +static inline void device_pm_add(struct device *dev) {}
>>> static inline void device_pm_remove(struct device *dev) {}
>>>
>>> #endif
>>> Index: usb-2.6/drivers/base/core.c
>>>
>================================================================
>>> ===
>>> --- usb-2.6.orig/drivers/base/core.c
>>> +++ usb-2.6/drivers/base/core.c
>>> @@ -542,6 +542,7 @@ void device_initialize(struct device *de
>>>        spin_lock_init(&dev->devres_lock);
>>>        INIT_LIST_HEAD(&dev->devres_head);
>>>        device_init_wakeup(dev, 0);
>>> +       device_pm_init(dev);
>>>        set_dev_node(dev, -1);
>>> }
>>>
>>> @@ -898,9 +899,10 @@ int device_add(struct device *dev)
>>>        error = bus_add_device(dev);
>>>        if (error)
>>>                goto BusError;
>>> -       error = device_pm_add(dev);
>>> +       error = dpm_sysfs_add(dev);
>>>        if (error)
>>>                goto PMError;
>>> +       device_pm_add(dev);
>>>        kobject_uevent(&dev->kobj, KOBJ_ADD);
>>>        bus_attach_device(dev);
>>>        if (parent)
>>> @@ -1008,6 +1010,7 @@ void device_del(struct device *dev)
>>>        struct class_interface *class_intf;
>>>
>>>        device_pm_remove(dev);
>>> +       dpm_sysfs_remove(dev);
>>>        if (parent)
>>>                klist_del(&dev->knode_parent);
>>>        if (MAJOR(dev->devt)) {
>>> Index: usb-2.6/drivers/base/power/main.c
>>>
>================================================================
>>> ===
>>> --- usb-2.6.orig/drivers/base/power/main.c
>>> +++ usb-2.6/drivers/base/power/main.c
>>> @@ -67,10 +67,8 @@ void device_pm_unlock(void)
>>>  *     device_pm_add - add a device to the list of active devices
>>>  *     @dev:   Device to be added to the list
>>>  */
>>> -int device_pm_add(struct device *dev)
>>> +void device_pm_add(struct device *dev)
>>> {
>>> -       int error;
>>> -
>>>        pr_debug("PM: Adding info for %s:%s\n",
>>>                 dev->bus ? dev->bus->name : "No Bus",
>>>                 kobject_name(&dev->kobj));
>>> @@ -89,13 +87,9 @@ int device_pm_add(struct device *dev)
>>>                 */
>>>                WARN_ON(true);
>>>        }
>>> -       error = dpm_sysfs_add(dev);
>>> -       if (!error) {
>>> -               dev->power.status = DPM_ON;
>>> -               list_add_tail(&dev->power.entry, &dpm_list);
>>> -       }
>>> +
>>> +       list_add_tail(&dev->power.entry, &dpm_list);
>>>        mutex_unlock(&dpm_list_mtx);
>>> -       return error;
>>> }
>>>
>>> /**
>>> @@ -110,7 +104,6 @@ void device_pm_remove(struct device *dev
>>>                 dev->bus ? dev->bus->name : "No Bus",
>>>                 kobject_name(&dev->kobj));
>>>        mutex_lock(&dpm_list_mtx);
>>> -       dpm_sysfs_remove(dev);
>>>        list_del_init(&dev->power.entry);
>>>        mutex_unlock(&dpm_list_mtx);
>>> }
>>>
>>
>>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-usb" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
