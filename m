Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbZFYIC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbZFYIC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 04:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbZFYIB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 04:01:57 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:52927 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZFYIBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 04:01:55 -0400
To: NeilBrown <neilb@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out of the 'queue' sysfs directory.
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <19010.62951.886231.96622@notabene.brown>
Date: Thu, 25 Jun 2009 04:00:51 -0400
In-Reply-To: <19010.62951.886231.96622@notabene.brown> (Neil Brown's message
	of "Thu, 25 Jun 2009 13:58:31 +1000")
Message-ID: <yq11vp8spxo.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4A432EB8.0234:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Neil" == Neil Brown <neilb@suse.de> writes:

Neil,

Neil>  Of these:

Neil>    max_hw_sectors_kb, nr_requests, rq_affinity, iosched/,
Neil>    max_sectors_kb scheduler nomerges rotational

Neil>  are really only relevant to the elevator code and those devices
Neil>  that used that code (ide, scsi, etc).

I'm not sure I completely agree with putting rotational in that bucket.
It affects the choice of allocation policy in btrfs, for instance.



Neil>  Of the others:
Neil>    hw_sector_size - is applicable to all block devices, and could
Neil>                       reasonably be placed one level up in the
Neil>                       device directory (along side 'size').

hw_sector_size is deprecated.  It's now split into logical and
physical_block_size.


Neil>  Adding a number of extra fields such as minimum_io_size,
Neil>  optimal_io_size etc to '/queue' seems to increase the number of
Neil>  aberrations and enforces md and dm device to have a /queue which
Neil>  is largely irrelevant.

You seem to be hung up on the fact that you don't queue things.  I think
that's beside the point.  You *do* have a request_queue thanks to
calling blk_queue_make_request() in md.c.  And there is more to
request_queue than the values you brought up.  Like the callback
functions.  I'm not saying that all the values in request_queue apply to
MD, but I really don't understand what all the fuss is about.  Other
than the presence of the string "queue" in the choice of naming.

Anyway.  If you look at the request_queue in the current tree you'll see
that the very limits we are discussing are contained in a separate
struct.  We can easily move that somewhere else at a later date if that
is deemed the right thing to do.


Neil>    I have suggested to Martin that 2 are enough.  

I think I have covered this in a separate mail.  You are mixing up
hardware limitations and I/O hints on the grounds that they went in as
part of the same patch set and live in the same place.

fdisk/mdadm/dmsetup need to use physical_block_size and alignment_offset
to prevent us from misaligning when setting up partitions and virtual
block devices.  Also, when stacking devices I need to know these values
to ensure that the I/O hints set by MD/DM don't conflict with the
underlying hardware limitations.  There are also special cases like
shared disk setups and filesystem journal padding that may need to know
details of the hardware atomicity.

mkfs.* can leverage minimum_io_size and optimal_io_size hints to choose
block sizes and to lay out data structures on stripe boundaries.  Just
like we're doing today except using a common interface for all block
devices instead of poking at MD and LVM internals.


logical_block_size, physical_block_size and alignment_offset are
hardware limits that need to be honored when creating a (virtual) block
device or partition.

The minimum/optimal write sizes are hints to the *user* of the block
device about how to lay out things.  If you look at my MD patch you'll
see that I only set the I/O hints.  The hardware settings are off limits
for MD.


I don't particularly care whether we store the values in queue/,
topology/, metrics/, limits/ or in the device root.  Nor whether we call
it minimum_write_size instead of minimum_io_size.  I'll be happy to roll
up a renaming patch...

-- 
Martin K. Petersen	Oracle Linux Engineering
