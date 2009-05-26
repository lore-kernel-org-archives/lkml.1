Return-Path: <linux-kernel-owner+w=401wt.eu-S1757642AbZEZTsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbZEZTsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbZEZTsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:48:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45338 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753978AbZEZTsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:48:33 -0400
Date: Tue, 26 May 2009 15:48:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Arjan van de Ven <arjan@linux.intel.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bug in SCSI async probing
In-Reply-To: <1243364161.2815.64.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0905261545360.9278-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009, James Bottomley wrote:

> Details?...  In theory the sd driver can be attached at any time and
> nothing should be relying on it being there when the inquiry scan
> finishes, so if there's a bug it would be exposed by async scanning, not
> really caused by it.

Provided the async scanning is implemented correctly...

> > (Which reminds me...  Are the calls in wait_scan_init() really enough?  
> > wait_for_device_probe() does async_synchronize_full() and then
> > scsi_complete_async_scans() finishes the SCSI scanning.  But if this
> > scanning involves calling sd_probe(), then more async work will be
> > queued.  Maybe a second call to wait_for_device_probe() is needed.)

You didn't respond to this point.

> None of this really got reviewed through the SCSI list, so I'll let
> Arjan answer.
> 
> > And why is it that the "out_free_index:" code in sd_probe() acquires 
> > sd_index_lock but the corresponding code in sd_probe_async() doesn't?
> 
> This one looks to be a mismerge between the async tree and the SCSI
> tree.

Well then, how does this patch look?

Alan Stern



Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -1948,7 +1948,6 @@ static void sd_probe_async(void *data, a
 	if (sdp->removable)
 		gd->flags |= GENHD_FL_REMOVABLE;
 
-	dev_set_drvdata(dev, sdkp);
 	add_disk(gd);
 	sd_dif_config_host(sdkp);
 
@@ -1958,7 +1957,9 @@ static void sd_probe_async(void *data, a
 	return;
 
  out_free_index:
+	spin_lock(&sd_index_lock);
 	ida_remove(&sd_index_ida, index);
+	spin_unlock(&sd_index_lock);
 }
 
 /**
@@ -2019,6 +2020,7 @@ static int sd_probe(struct device *dev)
 	if (error)
 		goto out_free_index;
 
+	dev_set_drvdata(dev, sdkp);
 	sdkp->device = sdp;
 	sdkp->driver = &sd_template;
 	sdkp->disk = gd;
@@ -2057,8 +2059,13 @@ static int sd_remove(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
-	device_del(&sdkp->dev);
-	del_gendisk(sdkp->disk);
+	/* Wait for sd_probe_async to finish */
+	async_synchronize_full();
+
+	if (device_is_registered(&sdkp->dev)) {
+		device_del(&sdkp->dev);
+		del_gendisk(sdkp->disk);
+	}
 	sd_shutdown(dev);
 
 	mutex_lock(&sd_ref_mutex);

