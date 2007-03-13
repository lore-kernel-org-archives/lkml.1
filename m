Return-Path: <linux-kernel-owner+w=401wt.eu-S1030687AbXCMPA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030687AbXCMPA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030700AbXCMPA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:00:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41672 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030687AbXCMPAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:00:24 -0400
Date: Tue, 13 Mar 2007 11:00:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Hugh Dickins <hugh@veritas.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Oliver Neukum <oneukum@suse.de>, Maneesh Soni <maneesh@in.ibm.com>,
       <gregkh@suse.de>, Richard Purdie <rpurdie@rpsys.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
In-Reply-To: <1173735075.5936.139.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0703131046030.2509-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue. 6 Mar 2007, Hugh Dickins wrote:

> But suspend to RAM still hanging, unless I "chmod a-x /usr/sbin/docker"
> on SuSE 10.2: docker undock tries to unregister /sys/block/sr0 and hangs:
> 
> 60x60         D B0415080     0 10778  10771                     (NOTLB)
>        e8227e04 00000086 e80c60b0 b0415080 ef3f5454 b041dc20 ef3f5430 00000001 
>        e80c60b0 72af360e 00000085 00001941 e80c61bc e8227e00 b01606bf ef47d3c0 
>        ed07c1dc ed07c1e4 00000246 e8227e30 b02f6ef0 e80c60b0 00000001 e80c60b0 
> Call Trace:
>  [<b02f6ef0>] __down+0xaa/0xb8
>  [<b02f6de6>] __down_failed+0xa/0x10
>  [<b0180529>] sysfs_drop_dentry+0xa2/0xda
>  [<b01819b3>] __sysfs_remove_dir+0x6d/0xf8
>  [<b0181a53>] sysfs_remove_dir+0x15/0x20
>  [<b01d49a9>] kobject_del+0x16/0x22
>  [<b0230041>] device_del+0x1c9/0x1e2
>  [<b025705a>] __scsi_remove_device+0x43/0x7a
>  [<b02570b0>] scsi_remove_device+0x1f/0x2b
>  [<b0256a44>] sdev_store_delete+0x16/0x1b
>  [<b022f0a0>] dev_attr_store+0x32/0x34
>  [<b0180931>] flush_write_buffer+0x37/0x3d
>  [<b0180995>] sysfs_write_file+0x5e/0x82
>  [<b01507f5>] vfs_write+0xa7/0x150
>  [<b0150950>] sys_write+0x47/0x6b
>  [<b0103d56>] sysenter_past_esp+0x5f/0x85
>               /usr/lib/dockutils/hooks/thinkpad/60x60 undock
>               /usr/lib/dockutils/dockhandler undock
>               /usr/sbin/docker undock
>               /etc/pm/hooks/23dock suspend
> 
> This comes from Oliver's commit 94bebf4d1b8e7719f0f3944c037a21cfd99a4af7
> Driver core: fix race in sysfs between sysfs_remove_file() and read()/write()
> in 2.6.21-rc1.  It looks to me like sysfs_write_file downs buffer->sem
> while calling flush_write_buffer, and flushing that particular write
> buffer entails downing buffer->sem in orphan_all_buffers.
> 
> Suspend no longer deadlocks with the following silly patch, but I expect
> this either pokes a small hole in your scheme, or renders it pointless.
> Maybe that commit needs to be reverted, or maybe you can see how to fix
> it up for -rc3.
> 
> Thanks,
> Hugh
> 
> --- 2.6.21-rc2-git5/fs/sysfs/inode.c	2007-02-28 08:30:26.000000000 
> +0000
> +++ linux/fs/sysfs/inode.c	2007-03-06 18:03:13.000000000 +0000
> @@ -227,11 +227,8 @@ static inline void orphan_all_buffers(st
>  
>  	mutex_lock_nested(&node->i_mutex, I_MUTEX_CHILD);
>  	if (node->i_private) {
> -		list_for_each_entry(buf, &set->associates, associates) {
> -			down(&buf->sem);
> +		list_for_each_entry(buf, &set->associates, associates)
>  			buf->orphaned = 1;
> -			up(&buf->sem);
> -		}
>  	}
>  	mutex_unlock(&node->i_mutex);
>  }

Hugh, there has been a long discussion among several people concerning 
this issue.  See for example this thread:

http://marc.info/?t=117335935200001&r=1&w=2

and also:

http://marc.info/?l=linux-kernel&m=117355959020831&w=2

The consensus is that we would be better off keeping Oliver's original 
patch without your silly change, and instead fixing the particular method 
call that deadlocked.  Can you please try out the patch below with 
everything else as it was before?  It should solve your problem.

Alan Stern


Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -452,10 +452,39 @@ store_rescan_field (struct device *dev, 
 }
 static DEVICE_ATTR(rescan, S_IWUSR, NULL, store_rescan_field);
 
+/* An attribute method cannot unregister itself, so this workaround for
+ * sdev_store_delete() is necessary.
+ */
+struct sdev_work_struct {
+	struct scsi_device *sdev;
+	struct work_struct work;
+};
+
+static void sdev_store_delete_work(struct work_struct *work)
+{
+	struct sdev_work_struct *sdw = container_of(work,
+			struct sdev_work_struct, work);
+
+	scsi_remove_device(sdw->sdev);
+	scsi_device_put(sdw->sdev);
+	kfree(sdw);
+}
+
 static ssize_t sdev_store_delete(struct device *dev, struct device_attribute *attr, const char *buf,
 				 size_t count)
 {
-	scsi_remove_device(to_scsi_device(dev));
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct sdev_work_struct *sdw;
+
+	sdw = kmalloc(sizeof(*sdw), GFP_KERNEL);
+	if (!sdw)
+		return -ENOMEM;
+	sdw->sdev = sdev;
+	INIT_WORK(&sdw->work, sdev_store_delete_work);
+	if (scsi_device_get(sdev) != 0)
+		kfree(sdw);
+	else
+		schedule_work(&sdw->work);
 	return count;
 };
 static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);

