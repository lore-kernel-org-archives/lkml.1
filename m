Return-Path: <linux-kernel-owner+w=401wt.eu-S934133AbXCVRIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934133AbXCVRIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 13:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934131AbXCVRIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 13:08:25 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:33563 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934128AbXCVRIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 13:08:23 -0400
Date: Thu, 22 Mar 2007 18:10:19 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Monakhov Dmitriy <dmonakhov@openvz.org>
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070322181019.62fe78ed@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <4602752A.5050109@lwfinger.net>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<1174433034.62033.16.camel@localhost>
	<20070320223643.d8cbc3f6.akpm@linux-foundation.org>
	<4601761F.4000302@lwfinger.net>
	<20070321185900.GC3801@tuxdriver.com>
	<20070321202225.GN10459@waste.org>
	<20070321233917.0393dfd1.akpm@linux-foundation.org>
	<20070322123508.3785fd30@gondolin.boeblingen.de.ibm.com>
	<4602752A.5050109@lwfinger.net>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 07:23:06 -0500,
Larry Finger <larry.finger@lwfinger.net> wrote:

> Cornelia Huck wrote:
> > On Wed, 21 Mar 2007 23:39:17 -0800,
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> >> On Wed, 21 Mar 2007 15:22:25 -0500 Matt Mackall <mpm@selenic.com> wrote:
> >>
> >>> With the latest -mm, I'm now getting this:
> >>>
> >>> Mar 21 15:06:52 cinder kernel: ipw2200: Detected Intel PRO/Wireless
> >>> 2200BG Network Connection
> >>> Mar 21 15:06:52 cinder kernel: firmware_loading_store: unexpected
> >>> value (0)
> >>> Mar 21 15:06:52 cinder kernel: ipw2200: ipw2200-bss.fw
> >>> request_firmware failed:
> >>> Reason -2
> >>> Mar 21 15:06:52 cinder kernel: ipw2200: Unable to load firmware: -2
> >>> Mar 21 15:06:52 cinder kernel: ipw2200: failed to register network
> >>> device
> >> The firmware loading bug is caused by
> >> driver-core-handles-kobject_uevent-failure-while-device_add.patch
> > 
> > Hm, this patch looks sane. It might be a good idea to enable
> > CONFIG_DEBUG_KOBJECT and find out why kobject_uevent() actually fails
> > in this case...
> 
> Attached is the appropriate portion of /var/log/messages with Kobject debugging enabled.

> Mar 22 07:01:42 larrylap2 kernel: kobject 0000:01:00.0: registering. parent: firmware, set: devices
> Mar 22 07:01:42 larrylap2 kernel: kobject_uevent_env
> Mar 22 07:01:42 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
> Mar 22 07:01:42 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
> Mar 22 07:01:42 larrylap2 kernel: kobject_uevent_env
> Mar 22 07:01:42 larrylap2 ntpd[3434]: frequency initialized -31.513 PPM from /var/lib/ntp/drift/ntp.drift
> Mar 22 07:01:43 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
> Mar 22 07:01:43 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
> Mar 22 07:01:43 larrylap2 kernel: firmware_loading_store: unexpected value (0)
> Mar 22 07:01:43 larrylap2 kernel: kobject_uevent_env
> Mar 22 07:01:43 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
> Mar 22 07:01:43 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
> Mar 22 07:01:43 larrylap2 kernel: kobject 0000:01:00.0: cleaning up

(Repeating several times)

This would indicate that dev_uevent had been called. But how could
kobject_uevent then return an error without moaning about an uevent()
error code? Maybe the following debug patch could shed some light on
this (all moaning is prefixed with kobject_uevent_env, so it should be
easy to spot)...

---
 lib/kobject_uevent.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- linux-2.6.orig/lib/kobject_uevent.c
+++ linux-2.6/lib/kobject_uevent.c
@@ -85,11 +85,11 @@ int kobject_uevent_env(struct kobject *k
 	int retval = 0;
 	int j;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s: %s\n", __FUNCTION__, kobject_name(kobj));
 
 	action_string = action_to_string(action);
 	if (!action_string) {
-		pr_debug("kobject attempted to send uevent without action_string!\n");
+		pr_debug("%s: kobject attempted to send uevent without action_string!\n", __FUNCTION__);
 		return -EINVAL;
 	}
 
@@ -101,7 +101,7 @@ int kobject_uevent_env(struct kobject *k
 		} while (!top_kobj->kset && top_kobj->parent);
 	}
 	if (!top_kobj->kset) {
-		pr_debug("kobject attempted to send uevent without kset!\n");
+		pr_debug("%s: kobject attempted to send uevent without kset!\n", __FUNCTION__);
 		return -EINVAL;
 	}
 
@@ -111,7 +111,7 @@ int kobject_uevent_env(struct kobject *k
 	/*  skip the event, if the filter returns zero. */
 	if (uevent_ops && uevent_ops->filter)
 		if (!uevent_ops->filter(kset, kobj)) {
-			pr_debug("kobject filter function caused the event to drop!\n");
+			pr_debug("%s: kobject filter function caused the event to drop!\n", __FUNCTION__);
 			return 0;
 		}
 
@@ -121,18 +121,20 @@ int kobject_uevent_env(struct kobject *k
 	else
 		subsystem = kobject_name(&kset->kobj);
 	if (!subsystem) {
-		pr_debug("unset subsytem caused the event to drop!\n");
+		pr_debug("%s: unset subsytem caused the event to drop!\n", __FUNCTION__);
 		return 0;
 	}
 
 	/* environment index */
 	envp = kzalloc(NUM_ENVP * sizeof (char *), GFP_KERNEL);
-	if (!envp)
+	if (!envp) {
+		pr_debug("%s: couldn't alloc envp\n", __FUNCTION__);
 		return -ENOMEM;
-
+	}
 	/* environment values */
 	buffer = kmalloc(BUFFER_SIZE, GFP_KERNEL);
 	if (!buffer) {
+		pr_debug("%s: couldn't alloc buffer\n", __FUNCTION__);
 		retval = -ENOMEM;
 		goto exit;
 	}
@@ -140,6 +142,7 @@ int kobject_uevent_env(struct kobject *k
 	/* complete object path */
 	devpath = kobject_get_path(kobj, GFP_KERNEL);
 	if (!devpath) {
+		pr_debug("%s: couldn't get kobject path\n", __FUNCTION__);
 		retval = -ENOENT;
 		goto exit;
 	}
@@ -221,6 +224,7 @@ exit:
 	kfree(devpath);
 	kfree(buffer);
 	kfree(envp);
+	pr_debug("%s: returning %d\n", __FUNCTION__, retval);
 	return retval;
 }
 
