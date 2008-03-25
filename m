Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbYCYRx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbYCYRx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbYCYRxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:53:48 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:57174 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbYCYRxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:53:46 -0400
Date: Tue, 25 Mar 2008 10:52:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Greg Freemyer" <greg.freemyer@gmail.com>
Cc: "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Mark Lord" <lkml@rtr.ca>, "Jens Axboe" <axboe@kernel.dk>,
       "Jeff Garzik" <jgarzik@pobox.com>, "Tejun Heo" <htejun@gmail.com>,
       "Greg KH" <gregkh@suse.de>, "Linus Torvalds" <torvalds@osdl.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Message-Id: <20080325105228.26396685.randy.dunlap@oracle.com>
In-Reply-To: <87f94c370803251045h46cbdc0auc541302fbad4a3b9@mail.gmail.com>
References: <47E875AD.1000901@rtr.ca>
	<47E87942.2020409@rtr.ca>
	<1206458278.3273.5.camel@localhost.localdomain>
	<87f94c370803251045h46cbdc0auc541302fbad4a3b9@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008 13:45:35 -0400 Greg Freemyer wrote:

> On Tue, Mar 25, 2008 at 11:17 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Tue, 2008-03-25 at 00:02 -0400, Mark Lord wrote:
> >  > (resending .. forgot to copy the lists originally)
> >  >
> >  > We have a problem coming down the pipeline.
> >  >
> >  > Practically all utilities that care about it,
> >  > use ioctl(fd, HDIO_GETGEO) to determine the starting
> >  > sector offset of a hard disk partition.
> >  >
> >  > SCSI, libata, IDE, USB, Firewire.. you name it.
> >  >
> >  > The return value uses "unsigned long",
> >  > which on a 32-bit system limits drive offsets to 2TB.
> >  >
> >  > There will be single drives exceeding this limit within
> >  > the next 12 months or less, and we already have RAID arrays
> >  > that exceed 2TB.
> >  >
> >  > So.. what's the replacement for HDIO_GETGEO on 32-bits ?
> >  >
> >  > One candidate might seem to be the existing /sys/block/dev/partition/start
> >  > which I expect is already 64-bit friendly.
> >  >
> >  > But this requires about 150 lines of somewhat complex C code to access,
> >  > using only the dev_t (from stat(2) on a file) as a starting point,
> >  > or less if one relies upon the udev device name matching the sysfs device name.
> >  >
> >  > Is it time now for HDIO_GETGEO64 to make an appearance?
> >  > Similar to how the existing BLKGETSIZE64 is supplanting BLKGETSIZE ?
> >
> >  Perhaps I've missed something, but surely geometry doesn't make sense on
> >  a >2TB drive does it?  The only reason we use it on modern disks (which
> >  usually make it up specially for us) is that the DOS partition scheme
> >  requires it.  Once we're over 2TB, isn't it impossible to use DOS
> >  partitions (well, OK, unless you increase the sector size, but that's
> >  only delaying the inevitable), so we can just go with a proper disk
> >  labelling scheme and use BLKGETSIZE64 all the time.
> >
> 
> I believe GUID Partition Tables (GPTs) are the answer.
> 
> I believe one of the features of GPT is the elimination of the 32-bit
> sector restrictions.
> 
> http://en.wikipedia.org/wiki/GUID_Partition_Table
> 
> Windows VISTA 64-bit supports GPTs on data disks and new Mac OS based
> systems have been using it on internal drives for a couple years at
> least.
> 
> GPTs are part of the Extensible Firmware Interface (EFI), so they
> should be usable for PC bootable disks at some point.  (Maybe now in
> some cases?)
> 
> I'm not sure what the Linux Kernel support is for GPTs.

It's implemented.  Not sure about how well used/tested it is.

config EFI_PARTITION
	bool "EFI GUID Partition support"
	depends on PARTITION_ADVANCED
	select CRC32
	help
	  Say Y here if you would like to use hard disks under Linux which
	  were partitioned using EFI GPT.


---
~Randy
