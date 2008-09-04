Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYIDOZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYIDOZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 10:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYIDOZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 10:25:27 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:9521 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbYIDOZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:25:26 -0400
Subject: Re: [PATCH 0/6] detect online disk resize
From: Andrew Patterson <andrew.patterson@hp.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com,
       jmoyer@redhat.com
In-Reply-To: <20080904072651.GX20055@kernel.dk>
References: <20080829231254.25065.66052.stgit@bluto.andrew>
	 <20080904072651.GX20055@kernel.dk>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 08:25:00 -0600
Message-Id: <1220538300.6601.21.camel@grinch>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-04 at 09:26 +0200, Jens Axboe wrote:
> On Fri, Aug 29 2008, Andrew Patterson wrote:
> > This is version 2 of a patch series I submitted back in May 2008. This
> > version now checks for device size changes in the rescan_partitions()
> > routine.  Which in turn is called when a device is opened and in the
> > BLKRRPART ioctl.
> > 
> > I am resubmitting this patch series as I got little response the
> > previous time.  Al Viro has told me offline that he would look at it this
> > time.
> > 
> > This patch series handles online disk resizes that are currently not
> > completely recognized by the kernel using the existing revalidate_disk
> > routines.  An online resize can occur when growing or shrinking a
> > Fibre Channel LUN or perhaps by adding a disk to an existing RAID
> > volume.
> > 
> > The kernel currently recognizes a device size change when the
> > lower-level revalidate_disk routines are called; however, the block
> > layer does not use the new size while it has any current openers on
> > the device. So, for example, if LVM has an volume open on the device,
> > you will generally not see the size change until after a reboot. We
> > fix this problem by creating a wrapper to be used with lower-level
> > revalidate_disk routines.  This wrapper first calls the lower-level
> > driver's revalidate_disk routine. It then compares the gendisk
> > capacity to the block devices inode size. If there is a difference, we
> > adjust the block device's size. If the size has changed, we then flush
> > the disk for safety. The size is also checked in rescan_partitions
> > which is called when the device is opened or when the BLKRRPART ioctl
> > is called.
> > 
> > There are several ways to "kick off" a device size change:
> > 
> > 1. For SCSI devices do:
> > 
> >   # echo 1 > /sys/class/scsi_device/<device>/device/rescan
> > 
> >   or
> > 
> >   # blockdev --rereadpt <device file>
> > 
> > 2. Other devices (not device mapper)
> > 
> >   # blockdev --rereadpt <device file>
> > 
> > I have tested this patch on SCSI and SmartArray (cciss)
> > devices. Device mapper still does not recognize device size changes
> > until the device is restarted.
> > 
> > Jeff Moyer and Andy Ryan have done some light testing on the previous
> > version of this series.
> > 
> > This patch set has been tested with scsi-misc-2.6. It also applies to
> > linux-next with some minor, obvious changes.
> 
> This version looks sane to me. Care to resend against for-2.6.28 of the
> block repo?

Will do.  Thanks

Andrew

