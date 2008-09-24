Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbYIXPwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbYIXPwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 11:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbYIXPwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 11:52:15 -0400
Received: from mail-relay-04.mailcluster.net ([77.221.130.216]:49167 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752415AbYIXPwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 11:52:15 -0400
X-Greylist: delayed 1706 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2008 11:52:14 EDT
Message-ID: <48DA5B85.7090102@vlnb.net>
Date: Wed, 24 Sep 2008 19:23:49 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Patterson <andrew.patterson@hp.com>
CC: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
       andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com,
       jmoyer@redhat.com
Subject: Re: [PATCH 0/6] detect online disk resize
References: <20080829231254.25065.66052.stgit@bluto.andrew>
In-Reply-To: <20080829231254.25065.66052.stgit@bluto.andrew>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew Patterson wrote:
> This is version 2 of a patch series I submitted back in May 2008. This
> version now checks for device size changes in the rescan_partitions()
> routine.  Which in turn is called when a device is opened and in the
> BLKRRPART ioctl.
> 
> I am resubmitting this patch series as I got little response the
> previous time.  Al Viro has told me offline that he would look at it this
> time.
> 
> This patch series handles online disk resizes that are currently not
> completely recognized by the kernel using the existing revalidate_disk
> routines.  An online resize can occur when growing or shrinking a
> Fibre Channel LUN or perhaps by adding a disk to an existing RAID
> volume.
> 
> The kernel currently recognizes a device size change when the
> lower-level revalidate_disk routines are called; however, the block
> layer does not use the new size while it has any current openers on
> the device. So, for example, if LVM has an volume open on the device,
> you will generally not see the size change until after a reboot. We
> fix this problem by creating a wrapper to be used with lower-level
> revalidate_disk routines.  This wrapper first calls the lower-level
> driver's revalidate_disk routine. It then compares the gendisk
> capacity to the block devices inode size. If there is a difference, we
> adjust the block device's size. If the size has changed, we then flush
> the disk for safety. The size is also checked in rescan_partitions
> which is called when the device is opened or when the BLKRRPART ioctl
> is called.
> 
> There are several ways to "kick off" a device size change:
> 
> 1. For SCSI devices do:
> 
>   # echo 1 > /sys/class/scsi_device/<device>/device/rescan
> 
>   or
> 
>   # blockdev --rereadpt <device file>
> 
> 2. Other devices (not device mapper)
> 
>   # blockdev --rereadpt <device file>

It would be great if you extend this functionality to automatic resizing 
by handling "CAPACITY DATA HAS CHANGED" Unit Attention. If necessary, I 
can assist in testing by adding online virtual disks resize feature 
together with generation of that UA in SCST (http://scst.sf.net). (It's 
not been implemented yet, because no known initiators so far have been 
able to use this feature.)

Vlad

