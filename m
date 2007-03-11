Return-Path: <linux-kernel-owner+w=401wt.eu-S933278AbXCKMgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278AbXCKMgi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 08:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933281AbXCKMgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 08:36:38 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:43372 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933278AbXCKMgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 08:36:37 -0400
To: Dmitriy Monakhov <dmonakhov@sw.ru>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       James Simmons <jsimmons@infradead.org>
Subject: [PATCH] driver core: fix device_add error path
References: <20070223231426.GA20498@kroah.com>
	<11722725561867-git-send-email-gregkh@suse.de>
	<11722725592291-git-send-email-gregkh@suse.de>
	<11722725623183-git-send-email-gregkh@suse.de>
	<1172272565581-git-send-email-gregkh@suse.de>
	<1172272569255-git-send-email-gregkh@suse.de>
	<11722725722238-git-send-email-gregkh@suse.de>
	<11722725761560-git-send-email-gregkh@suse.de>
	<1172272579116-git-send-email-gregkh@suse.de> <87abyl8cqb.fsf@sw.ru>
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Sun, 11 Mar 2007 15:36:19 +0300
In-Reply-To: <87abyl8cqb.fsf@sw.ru> (Dmitriy Monakhov's message of "Sat, 10 Mar 2007 16:11:40 +0300")
Message-ID: <87veh8j6t8.fsf_-_@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitriy Monakhov <dmonakhov@sw.ru> writes:

> Greg Kroah-Hartman <gregkh@suse.de> writes:
>
>> From: James Simmons <jsimmons@infradead.org>
>>
>> When a device fails to register the class symlinks where not cleaned up.
>> This left a symlink in the /sys/class/"device"/ directory that pointed
>> to no where. This caused the sysfs_follow_link Oops I reported earlier.
>> This patch cleanups up the symlink. Please apply. Thank you.
>>
>> Signed-Off: James Simmons <jsimmons@infradead.org>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>> ---
>>  drivers/base/core.c |   31 ++++++++++++++++++++++++++++++-
>>  1 files changed, 30 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> index d04fd33..cf2a398 100644
>> --- a/drivers/base/core.c
>> +++ b/drivers/base/core.c
>> @@ -637,12 +637,41 @@ int device_add(struct device *dev)
>>  					     BUS_NOTIFY_DEL_DEVICE, dev);
>>  	device_remove_groups(dev);
>>   GroupError:
>> - 	device_remove_attrs(dev);
>> +	device_remove_attrs(dev);
>>   AttrsError:
>>  	if (dev->devt_attr) {
>>  		device_remove_file(dev, dev->devt_attr);
>>  		kfree(dev->devt_attr);
>>  	}
>> +
>> +	if (dev->class) {
>> +		sysfs_remove_link(&dev->kobj, "subsystem");
>> +		/* If this is not a "fake" compatible device, remove the
>> +		 * symlink from the class to the device. */
>> +		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
>> +			sysfs_remove_link(&dev->class->subsys.kset.kobj,
>> +					  dev->bus_id);
>> +#ifdef CONFIG_SYSFS_DEPRECATED
>> +		if (parent) {
>> +			char *class_name = make_class_name(dev->class->name,
>> +							   &dev->kobj);
>> +			if (class_name)
>> +				sysfs_remove_link(&dev->parent->kobj,
>> +						  class_name);
>> +			kfree(class_name);
>> +			sysfs_remove_link(&dev->kobj, "device");
>> +		}
>> +#endif
>> +
> <<<<< block begin
>> +		down(&dev->class->sem);
>> +		/* notify any interfaces that the device is now gone */
>> +		list_for_each_entry(class_intf, &dev->class->interfaces, node)
>> +			if (class_intf->remove_dev)
>> +				class_intf->remove_dev(dev, class_intf);
>> +		/* remove the device from the class list */
>> +		list_del_init(&dev->node);
>> +		up(&dev->class->sem);
> <<<<<< block end 
> May be i've missed something, but i'm confuesd a litle bit.
> For example if error happens while device_pm_add() we jump to label "PMError"
> and code from block above will be executed (device will be remove from list),
> but this device wasn't added to this list yet!
I've check it one more time, code it really broken!, and i think i understand how
this can happen ....
it look like full code chunck was copy-pasted from device_del(), but in case of 
device_add() error path, device was't added to dev->class->devices list yet.
Folowing patch fix this copy-paste error:

 [PATCH] driver core: fix device_add error path

 - At the moment we jump here device was't added to
   dev->class->devices list yet.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
---
 drivers/base/core.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 142c222..7d2459b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -684,15 +684,6 @@ int device_add(struct device *dev)
 #endif
 			sysfs_remove_link(&dev->kobj, "device");
 		}
-
-		down(&dev->class->sem);
-		/* notify any interfaces that the device is now gone */
-		list_for_each_entry(class_intf, &dev->class->interfaces, node)
-			if (class_intf->remove_dev)
-				class_intf->remove_dev(dev, class_intf);
-		/* remove the device from the class list */
-		list_del_init(&dev->node);
-		up(&dev->class->sem);
 	}
  ueventattrError:
 	device_remove_file(dev, &dev->uevent_attr);
-- 
1.5.0.1


