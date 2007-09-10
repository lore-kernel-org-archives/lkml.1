Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbXIJF3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbXIJF3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 01:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbXIJF2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 01:28:53 -0400
Received: from mxsf00.insightbb.com ([74.128.0.70]:36202 "EHLO
	mxsf00.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbXIJF2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 01:28:52 -0400
X-IronPort-AV: E=Sophos;i="4.20,229,1186372800"; 
   d="scan'208";a="28462088"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FADhz5EZKjlCP/2dsb2JhbACBXQ
X-IronPort-AV: E=Sophos;i="4.20,229,1186372800"; 
   d="scan'208";a="76689738"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: sysfs change of input/event devices in 2.6.23rc breaks udev
Date: Mon, 10 Sep 2007 01:28:47 -0400
User-Agent: KMail/1.9.3
Cc: Anssi Hannula <anssi.hannula@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
References: <46E2D712.1010402@gmail.com> <3ae72650709091603o57c976d1q8a1b5492ef041186@mail.gmail.com>
In-Reply-To: <3ae72650709091603o57c976d1q8a1b5492ef041186@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709100128.48595.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 September 2007 19:03, Kay Sievers wrote:
> On 9/8/07, Anssi Hannula <anssi.hannula@gmail.com> wrote:
> >
> > However, the change that broke id_path of udev is that
> > /sys/class/input/event5/device is now a symlink to the inputX directory
> > instead of being the same as the device symlink in inputX directory,
> > i.e. to ../../../devices/platform/pcspkr in this case.
> >
> > Udev id_path uses that directory to construct the ID_PATH variable.
> > Should the sysfs structure be reverted or should udev be adapted to
> > handle traversing /device symlink twice? I think the former, as there
> > should be considerably more time to adapt udev for coming changes in sysfs.
> 
> Udev's path_id script is too dumb to follow the "device" link of
> stacked class devices in the CONFIG_SYSFS_DEPRECATED=y layout. Does
> this change fix it for you?
>   http://git.kernel.org/?p=linux/hotplug/udev.git;a=commitdiff_plain;h=b1ac36ff5e3756cefc79967a26280056da31bf6f
> 

Hmm, fixing udev is good but users will not get the change in time. I think we
need to adjust SYSFS_DEPRECATED code to produce old results. Something like the
patch below. I wonder what Greg would think...

-- 
Dmitry

Driver core: fix deprectated sysfs structure for nested class devices

Nested class devices used to have 'device' symlink point to a real
(physical) device instead of a parent class device. When converting
subsystems to struct device we need to keep doing what class devices
did if CONFIG_SYSFS_DEPRECATED is Y, otherwise parts of udev break.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/base/core.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

Index: work/drivers/base/core.c
===================================================================
--- work.orig/drivers/base/core.c
+++ work/drivers/base/core.c
@@ -679,14 +679,26 @@ static int device_add_class_symlinks(str
 			goto out_subsys;
 	}
 	if (dev->parent) {
-		error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
-					  "device");
-		if (error)
-			goto out_busid;
 #ifdef CONFIG_SYSFS_DEPRECATED
 		{
-			char * class_name = make_class_name(dev->class->name,
-								&dev->kobj);
+			struct device *parent = dev->parent;
+			char *class_name;
+
+			/*
+			 * In old sysfs stacked class devices had 'device'
+			 * link pointing to real device instead of parent
+			 */
+			while (parent->class && !parent->bus && parent->parent)
+				parent = parent->parent;
+
+			error = sysfs_create_link(&dev->kobj,
+						  &parent->kobj,
+						  "device");
+			if (error)
+				goto out_busid;
+
+			class_name = make_class_name(dev->class->name,
+							&dev->kobj);
 			if (class_name)
 				error = sysfs_create_link(&dev->parent->kobj,
 							&dev->kobj, class_name);
@@ -694,6 +706,11 @@ static int device_add_class_symlinks(str
 			if (error)
 				goto out_device;
 		}
+#else
+		error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
+					  "device");
+		if (error)
+			goto out_busid;
 #endif
 	}
 	return 0;
