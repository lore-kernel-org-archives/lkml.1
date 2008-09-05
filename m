Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYIEImH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYIEImH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 04:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbYIEIlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 04:41:55 -0400
Received: from edu.joroinen.fi ([194.89.68.130]:38815 "EHLO edu.joroinen.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbYIEIly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 04:41:54 -0400
X-Greylist: delayed 1241 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2008 04:41:53 EDT
Date: Fri, 5 Sep 2008 11:21:10 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
       andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com,
       jmoyer@redhat.com
Subject: Re: [PATCH 0/6] detect online disk resize
Message-ID: <20080905082110.GN13941@edu.joroinen.fi>
References: <20080904202714.10456.88061.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904202714.10456.88061.stgit@bob.kio>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 02:27:15PM -0600, Andrew Patterson wrote:
> Resubmitting this patch against Jens's linux-2.6-block:for-2.6.28 repo.
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
> 
> I have tested this patch on SCSI and SmartArray (cciss)
> devices. Device mapper still does not recognize device size changes
> until the device is restarted.
> 

Hello and thanks for the patch! 

How about device mapper.. what's needed to make it detect/support online resizes?
I'm specificly interested in online resizing (growing) dm-multipath devices.. 

Basicly I'd like to have LVM PV on dm-multipath device.. so first I need to
get the actual disks resized, then dm-multipath device, and finally run pvresize.

I know dm-multipath part can be done atm using this (hacky) method:
https://www.redhat.com/archives/dm-devel/2008-August/msg00033.html

-- Pasi
