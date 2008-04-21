Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbYDUWBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbYDUWBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 18:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYDUWBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 18:01:44 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:7885 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbYDUWBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 18:01:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YJgru1fZ8OOs64GrODCY3gmrpw/g8J+dTlh4DwWGpPyVq/TPvxQe781eiABgRm6TD6mKjCE4+4DtYnjw8CiCtnHDJZTAvYHW2uRRBNgOTtWlSu8vKfMtiQ+RK4uZTYU902FQX6vBX9URz9O4l84cfh4+KmWzxJ0b1s0Bw++UANk=
Message-ID: <a44ae5cd0804211501s7c269239qfee76726e3627d6b@mail.gmail.com>
Date: Mon, 21 Apr 2008 18:01:43 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Frederik Deweerdt" <deweerdt@free.fr>
Subject: Re: 2.6.25-mm1 -- WARNING: at fs/sysfs/dir.c:427 sysfs_add_one+0x33/0x9a()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Greg KH" <gregkh@suse.de>,
       "Kay Sievers" <kay.sievers@vrfy.org>
In-Reply-To: <20080421210146.GK7134@slug>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <a44ae5cd0804181124s772fa61bp22035c2b758471b1@mail.gmail.com>
	 <a44ae5cd0804211156n40e2a71cw25c3114db2f58d17@mail.gmail.com>
	 <20080421210146.GK7134@slug>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m3LM1xEB010287

On Mon, Apr 21, 2008 at 5:01 PM, Frederik Deweerdt <deweerdt@free.fr> wrote:> On Mon, Apr 21, 2008 at 02:56:52PM -0400, Miles Lane wrote:>  > Is anyone interesting in following up on this?>  >>  Doesn't this>  http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-04/msg06990.html>  fixes it?
That patch seems to have some problems:http://groups.google.com/group/linux.kernel/browse_thread/thread/a9cfeae4ce67ee8e/2118788c3c81b2f3?#2118788c3c81b2f3Should I apply this instead or as well?
From: Kay Sievers <kay.siev...@vrfy.org>Subject: sysfs: fix duplicated device number registration in /sys/dev/
If the parent device has the same dev_t, we skip the registrationfor the device number at /sys/dev.
Cc: Dan Williams <dan.j.willi...@intel.com>Cc: Greg KH <g...@kroah.com>ï»¿Cc: Andrew Morton <a...@linux-foundation.org>Signed-off-by: Kay Sievers <kay.siev...@vrfy.org>---
 core.c |   17 +++++++++++------ 1 file changed, 11 insertions(+), 6 deletions(-)
diff --git a/drivers/base/core.c b/drivers/base/core.cindex de925f8..afedadb 100644--- a/drivers/base/core.c+++ b/drivers/base/core.c@@ -821,10 +821,13 @@ int device_add(struct device *dev)                if (error)                        goto ueventattrError;
-               format_dev_t(devt_str, dev->devt);-               error = sysfs_create_link(kobj, &dev->kobj, devt_str);-               if (error)-                       goto devtattrError;+               /* do not create /sys/dev/ entry if parent already did */+               if (!(dev->parent && dev->parent->devt == dev->devt)) {+                       format_dev_t(devt_str, dev->devt);+                       error = sysfs_create_link(kobj, &dev->kobj, devt_str);+                       if (error)+                               goto devtattrError;+               }        }
        error = device_add_class_symlinks(dev);@@ -950,8 +953,10 @@ void device_del(struct device *dev)        if (parent)                klist_del(&dev->knode_parent);        if (MAJOR(dev->devt)) {-               format_dev_t(devt_str, dev->devt);-               sysfs_remove_link(device_to_dev_kobj(dev), devt_str);+               if (!(parent && parent->devt == dev->devt)) {+                       format_dev_t(devt_str, dev->devt);+                       sysfs_remove_link(device_to_dev_kobj(dev), devt_str);+               }                device_remove_file(dev, &devt_attr);        }        if (dev->class) {
--ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
