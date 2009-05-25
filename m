Return-Path: <linux-kernel-owner+w=401wt.eu-S1757034AbZEYCGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbZEYCGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 22:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbZEYCGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 22:06:12 -0400
Received: from netrider.rowland.org ([192.131.102.5]:57145 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753756AbZEYCGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 22:06:11 -0400
Date: Sun, 24 May 2009 22:06:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
In-Reply-To: <1243178448.4035.12.camel@poy>
Message-ID: <Pine.LNX.4.44L0.0905242154560.15195-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 May 2009, Kay Sievers wrote:

> On Sun, 2009-05-24 at 07:17 -0700, Eric W. Biederman wrote:
> 
> > Most of these look like attributes, for which the non-empty directory
> > removal was correct.  Although I am puzzled by why we missed them.
> 
> Yes, most of them are attributes. I have USB hubs here with lots of
> devices connected, setups I use for udev testing, so this might trigger
> things that usually don't happen.
> 
> > host4/target4:0:0 worries me.  I don't have my head wrapped around
> > what that is yet.  But is looks like is a directory (which we currently
> > do not handle correctly), and even more it looks like that is quite
> > possibly two kobjects in a parent/child situation where the child
> > was not removed when the child was.
> > 
> > It definitely warrants more investigation.
> 
> It seems like a real bug. We get:
>   dir:   host5/target5:0:0
> 
> and we removed a parent from an active child, and the device path misses
> all its parents:
>   'target7:0:0' (ffff880124eb1158): fill_kobj_path: path = '/host7/target7:0:0'
> 
> it gets cleaned up:
>   'target7:0:0': free name
> 
> but it should still be fixed in the user. Adding Alan Stern, maybe he
> has an idea what's going on here.
> 
> Note, that it is hard to reproduce, It only happens with a frequent
> connect/disconnects on a hub full of devices. But it still seems like a
> real bug in the USB device cleanup logic. At the end of this mail is the
> log of all files which did exist at cleanup.

This looks like a bug I found almost two weeks ago.  The bug was
introduced by Arjan as part of his async conversion (the async routine
runs without acquiring one of the mutexes held by its caller).  The
result is a race in the sd driver -- no connection with USB, by the way
-- so it's a little difficult to trigger.  I posted a patch, but the
reporter never said whether or not the patch fixed the problem.  Hence
the patch hasn't been submitted.

Here it is for you to try out.

Alan Stern



Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -1892,12 +1892,16 @@ static int sd_format_disk_name(char *pre
 static void sd_probe_async(void *data, async_cookie_t cookie)
 {
 	struct scsi_disk *sdkp = data;
-	struct scsi_device *sdp;
+	struct scsi_device *sdp = sdkp->device;
+	struct Scsi_Host *shost = sdp->host;
 	struct gendisk *gd;
 	u32 index;
 	struct device *dev;
 
-	sdp = sdkp->device;
+	mutex_lock(&shost->scan_mutex);
+	if (!scsi_host_scan_allowed(shost))
+		goto out_unlock_host;
+
 	gd = sdkp->disk;
 	index = sdkp->index;
 	dev = &sdp->sdev_gendev;
@@ -1915,8 +1919,10 @@ static void sd_probe_async(void *data, a
 	sdkp->dev.class = &sd_disk_class;
 	dev_set_name(&sdkp->dev, dev_name(&sdp->sdev_gendev));
 
-	if (device_add(&sdkp->dev))
-		goto out_free_index;
+	if (device_add(&sdkp->dev)) {
+		ida_remove(&sd_index_ida, index);
+		goto out_unlock_host;
+	}
 
 	get_device(&sdp->sdev_gendev);
 
@@ -1955,10 +1961,8 @@ static void sd_probe_async(void *data, a
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
 
-	return;
-
- out_free_index:
-	ida_remove(&sd_index_ida, index);
+ out_unlock_host:
+	mutex_unlock(&shost->scan_mutex);
 }
 
 /**

