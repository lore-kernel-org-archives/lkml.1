Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbZGPOo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbZGPOo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757597AbZGPOo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:44:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47082 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757579AbZGPOo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:44:56 -0400
Date: Thu, 16 Jul 2009 10:44:39 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christian =?iso-8859-1?Q?Borntr=E4ger?= <borntraeger@de.ibm.com>
Cc: Alasdair G Kergon <agk@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: regression post 2.6.30: device mapper fails on some logical
	volumes
Message-ID: <20090716144438.GA8257@redhat.com>
References: <200907151852.15121.borntraeger@de.ibm.com> <20090715214051.GB6399@redhat.com> <200907160736.09885.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200907160736.09885.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16 2009 at  1:36am -0400,
Christian Bornträger <borntraeger@de.ibm.com> wrote:

> Am Mittwoch 15 Juli 2009 23:40:52 schrieb Mike Snitzer:
> 
> >
> > > [    6.048168] device-mapper: table: 253:59: target device dasde1 is
> > > misaligned
> >
> > Christian,
> >
> > Which kernel are you using?  I believe these warnings have been fixed
> > with this commit (which should be part of 2.6.31-rc2):
> > ea9df47cc92573b159ef3b4fda516c32cba9c4fd
> >
> > Mike
> 
> Mike,
> 
> I see the problem with 2.6.31-rc3. Given the content of patch ea9df4...it might 
> be of interest that my dasd devices have a hard sector size of 4k:
> 
> $ sudo blockdev --getss /dev/dasdf1
> 4096
> $ sudo blockdev --getbsz /dev/dasdf1
> 4096
> 
> Since I always get confused by the internal 512 bytes vs. hard sector size vs. 
> block size vs. file system block size I dont know if that is important.

These "target device dasde1 is misaligned" warnings are a function of
device-mapper now being topology-aware.  This means that your LVs are
likely misaligned relative to the underlying hardware.

Moving forward it would likely be wise if we were to add a bit more
contextual information to the warning so we'd know _why_ a device was
deemed "misaligned".

So you know these dasd devices to use an internal (aka
physical_block_size) of 512 bytes?  And a logical_block_size (aka hard
sect size) of 4096 bytes?  That would be strange; I'm only aware of the
opposite being possible (physical_block_size=4096,
logical_block_size=512).

In any case, the reason for your "aisaligned" warnings could be that
you're using partitions with start offsets into the underlying dasd
device that aren't aligned on a 4k boundary.

Please provide the output from the following commands:

pvs -o +pe_start /dev/dasdf1

I'm not sure of the /sys/block/ device names that are associated with
/dev/dasdf1, maybe dasdf is the entire device and dasdf1 is a partition?

So along the lines of these commands (relative to sda6):
cat /sys/block/sda/sda6/alignment_offset
cat /sys/block/sda/queue/physical_block_size
cat /sys/block/sda/queue/logical_block_size

maybe these are applicable to dasdf1?:
cat /sys/block/dasdf/dasdf1/alignment_offset
cat /sys/block/dasdf/queue/physical_block_size
cat /sys/block/dasdf/queue/logical_block_size

It would also be great if you could provide the "dmsetup table"
output associated the dasdf1 device.  Are you just using linear DM
mappings?

Thanks,
Mike

p.s. I'm out of the office for a few more days but when I'm back I can
look to try to reproduce on dasd devices on s390 hardware (if we're
unable to make progress with you sharing the above info).
