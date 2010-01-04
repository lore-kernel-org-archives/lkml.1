Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022Ab0ADTn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab0ADTn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 14:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011Ab0ADTn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 14:43:26 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:59158 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab0ADTnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 14:43:22 -0500
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: drm_vm.c:drm_mmap: possible circular locking dependency detected
References: <m11victac1.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>
	<m1fx6rtu31.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912311043330.11961@localhost.localdomain>
	<m11vi9c0td.fsf@fess.ebiederm.org> <4B3EB687.7000005@kernel.org>
	<m17hs0xjmn.fsf@fess.ebiederm.org> <4B3FE586.7020109@kernel.org>
	<20100103074745.GA2314@core.coreip.homeip.net>
	<m1tyv3sbg4.fsf@fess.ebiederm.org>
	<20100104185755.GB2597@core.coreip.homeip.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 04 Jan 2010 11:43:10 -0800
In-Reply-To: <20100104185755.GB2597@core.coreip.homeip.net> (Dmitry Torokhov's message of "Mon\, 4 Jan 2010 10\:57\:55 -0800")
Message-ID: <m14on1fygh.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:

> On Sun, Jan 03, 2010 at 02:57:15AM -0800, Eric W. Biederman wrote:
>> Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:
>> 
>> >
>> > Overall I am not concerned about lockdep bitching about serio because it
>> > still bitches if you simply reload psmouse on a box with Synaptics with a
>> > pass-through port even though there are nested annotations and it is
>> > silent first time around.
>> 
>> This is a new lockdep annotation, and looking into it this appears to
>> be a true possible deadlock in the serio/sysfs interactions.
>> 
>> We have serio_pin_driver() called from all of the sysfs attributes
>> which does:
>>    mutex_lock(&serio->drv_mutex);
>> 
>> We have serio_disconnect_driver() called on an unplug which does:
>>    mutex_lock(&serio->drv_mutex);
>> 
>> The deadlock potential is if someone reads say the psmouse rate
>> sysfs file while the mouse is being unplugged.  There is a race
>> such that we can have:
>> 
>> 						  sysfs_read_file()
>>                                                     fill_read_buffer()
>> 						       sysfs_get_active_two()
>> 							 psmouse_attr_show_helper()
>>                                         		   serio_pin_driver()
>> serio_disconnect_driver()		
>>   mutex_lock(&serio->drv_mutex);		
>> 				<----------------->	   mutex_lock(&serio_drv_mutex);
>>     psmouse_disconnect()
>>       sysfs_remove_group(... psmouse_attr_group);
>> 	....
>> 	sysfs_deactivate(); 
>> 	  wait_for_completion();
>> 
>> 
>> So it is unlikely but possible to deadlock by accessing a serio
>> attribute of a serio device that is being removed.
>
> Hmm, I guess I was too quick dismissing lockdep complaints here. Now
> that sysfs remove waits deadlock indeed is possible. Actually the locks
> on serio->drv_mutex in attributes were added to make sure we don't
> access device that was unbound from the driver through stale sysfs
> attributes.

Cool.  So we have solved the problem generically but we have left over
layer specific solutions.  That seems like a good problem to have.

>> What to do about it is another question.
>
> I think we should simply not take serio->drv_mutex in attributes and use
> driver-private mutex to serialize "set" methods that may alter device
> state.

Do you have any ideas what those might be?  It looks like we are only
talking about psmouse and atkbd.  So the audit for this chunk should
not be too bad.

The psmouse code already has a mutex on it's set operations only the
atkbd does not.  The atkbd code does do a driver stop/start, which is
similar (but race prone without the serio->drv_mutex).

Except for the lack of atkbd_enable/disable locking the patch below should
be good.  Opinions from someone who knows the serio code better than I do
would be helpful.

Eric


---

From: Eric W. Biederman <ebiederm@xmission.com>
Subject: [PATCH] serio:  Remove uneeded and deadlock prone serio_pin_driver

sysfs_remove_group waits for sysfs attributes to be removed
so we don't need to take a mutex in each of the attributes to
prevent remove while the code in the attribute is running.

This removes a theoretical deadlock possibility of a keyboard
or mouse hotplug and someone accessing a sysfs attribute.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/input/keyboard/atkbd.c     |   27 +--------------------------
 drivers/input/mouse/psmouse-base.c |   32 +++-----------------------------
 include/linux/serio.h              |   19 -------------------
 3 files changed, 4 insertions(+), 74 deletions(-)

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index a357357..7200100 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1234,22 +1234,8 @@ static ssize_t atkbd_attr_show_helper(struct device *dev, char *buf,
 				ssize_t (*handler)(struct atkbd *, char *))
 {
 	struct serio *serio = to_serio_port(dev);
-	int retval;
-
-	retval = serio_pin_driver(serio);
-	if (retval)
-		return retval;
 
-	if (serio->drv != &atkbd_drv) {
-		retval = -ENODEV;
-		goto out;
-	}
-
-	retval = handler((struct atkbd *)serio_get_drvdata(serio), buf);
-
-out:
-	serio_unpin_driver(serio);
-	return retval;
+	return handler((struct atkbd *)serio_get_drvdata(serio), buf);
 }
 
 static ssize_t atkbd_attr_set_helper(struct device *dev, const char *buf, size_t count,
@@ -1259,22 +1245,11 @@ static ssize_t atkbd_attr_set_helper(struct device *dev, const char *buf, size_t
 	struct atkbd *atkbd;
 	int retval;
 
-	retval = serio_pin_driver(serio);
-	if (retval)
-		return retval;
-
-	if (serio->drv != &atkbd_drv) {
-		retval = -ENODEV;
-		goto out;
-	}
-
 	atkbd = serio_get_drvdata(serio);
 	atkbd_disable(atkbd);
 	retval = handler(atkbd, buf, count);
 	atkbd_enable(atkbd);
 
-out:
-	serio_unpin_driver(serio);
 	return retval;
 }
 
diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index fd0bc09..59754d3 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -1447,24 +1447,10 @@ ssize_t psmouse_attr_show_helper(struct device *dev, struct device_attribute *de
 	struct serio *serio = to_serio_port(dev);
 	struct psmouse_attribute *attr = to_psmouse_attr(devattr);
 	struct psmouse *psmouse;
-	int retval;
-
-	retval = serio_pin_driver(serio);
-	if (retval)
-		return retval;
-
-	if (serio->drv != &psmouse_drv) {
-		retval = -ENODEV;
-		goto out;
-	}
 
 	psmouse = serio_get_drvdata(serio);
 
-	retval = attr->show(psmouse, attr->data, buf);
-
-out:
-	serio_unpin_driver(serio);
-	return retval;
+	return attr->show(psmouse, attr->data, buf);
 }
 
 ssize_t psmouse_attr_set_helper(struct device *dev, struct device_attribute *devattr,
@@ -1475,18 +1461,9 @@ ssize_t psmouse_attr_set_helper(struct device *dev, struct device_attribute *dev
 	struct psmouse *psmouse, *parent = NULL;
 	int retval;
 
-	retval = serio_pin_driver(serio);
-	if (retval)
-		return retval;
-
-	if (serio->drv != &psmouse_drv) {
-		retval = -ENODEV;
-		goto out_unpin;
-	}
-
 	retval = mutex_lock_interruptible(&psmouse_mutex);
 	if (retval)
-		goto out_unpin;
+		goto out;
 
 	psmouse = serio_get_drvdata(serio);
 
@@ -1516,8 +1493,7 @@ ssize_t psmouse_attr_set_helper(struct device *dev, struct device_attribute *dev
 
  out_unlock:
 	mutex_unlock(&psmouse_mutex);
- out_unpin:
-	serio_unpin_driver(serio);
+ out:
 	return retval;
 }
 
@@ -1579,9 +1555,7 @@ static ssize_t psmouse_attr_set_protocol(struct psmouse *psmouse, void *data, co
 		}
 
 		mutex_unlock(&psmouse_mutex);
-		serio_unpin_driver(serio);
 		serio_unregister_child_port(serio);
-		serio_pin_driver_uninterruptible(serio);
 		mutex_lock(&psmouse_mutex);
 
 		if (serio->drv != &psmouse_drv) {
diff --git a/include/linux/serio.h b/include/linux/serio.h
index e2f3044..813d26c 100644
--- a/include/linux/serio.h
+++ b/include/linux/serio.h
@@ -136,25 +136,6 @@ static inline void serio_continue_rx(struct serio *serio)
 	spin_unlock_irq(&serio->lock);
 }
 
-/*
- * Use the following functions to pin serio's driver in process context
- */
-static inline int serio_pin_driver(struct serio *serio)
-{
-	return mutex_lock_interruptible(&serio->drv_mutex);
-}
-
-static inline void serio_pin_driver_uninterruptible(struct serio *serio)
-{
-	mutex_lock(&serio->drv_mutex);
-}
-
-static inline void serio_unpin_driver(struct serio *serio)
-{
-	mutex_unlock(&serio->drv_mutex);
-}
-
-
 #endif
 
 /*
-- 
1.6.5.2.143.g8cc62

