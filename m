Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbZFYRj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbZFYRj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 13:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbZFYRjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 13:39:15 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:34954 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbZFYRjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 13:39:13 -0400
To: "NeilBrown" <neilb@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       "Mike Snitzer" <snitzer@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Alasdair G Kergon" <agk@redhat.com>, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "device-mapper development" <dm-devel@redhat.com>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out  of the 'queue' sysfs directory.
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <19010.62951.886231.96622@notabene.brown>
	<yq11vp8spxo.fsf@sermon.lab.mkp.net>
	<125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
Date: Thu, 25 Jun 2009 13:38:40 -0400
In-Reply-To: <125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
	(NeilBrown's message of "Thu, 25 Jun 2009 21:07:37 +1000 (EST)")
Message-ID: <yq1k530qkm7.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4A43B625.00D3:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Neil" == NeilBrown  <neilb@suse.de> writes:

[rotational flag]

Neil> So I asked git why it as added, and it pointed to
Neil>   commit 1308835ffffe6d61ad1f48c5c381c9cc47f683ec

Neil> which suggests that it was added so that user space could tell the
Neil> kernel whether the device was rotational, rather than the other
Neil> way around.

There's an option to do it via udev for broken devices that don't report
it.  But both SCSI and ATA have a setting that gets queried and the
queue flag set accordingly.


Neil> Also, I think you seem to be treating the read-modify-write
Neil> behaviour of a 4K-sector hard drive as different-in-kind to the
Neil> read-modify-write behaviour of raid5.  I cannot see that.  In both
Neil> cases an error can cause unexpected corruption and in both cases
Neil> getting the alignment right helps throughput a lot.

If you get a write error on a RAID5 component you are able to
reconstruct and remap the stripe given the cache and the remaining
drives.

If you get a write error on a 4KB phys/512 byte logical drive the result
is undefined.  In a single machine setting you can treat the 4KB block
as suspect.  In a clustered setting, however, the other machines will
unknowingly be reading garbage.

I realize this is moot in the context of MD given that it doesn't
support shared storage.  But MD is not the only virtual block device
driver that I need to support with the topology bits.


Neil> So the only difference between these two values is the size.  If
Neil> one is 4K and one is 40Meg and you have 512bytes of data that you
Neil> want to write as safely as possibly, you might pad it to 4K, but
Neil> you wont pad it to 40Meg.  If you have 32Meg of data that you want
Neil> to write as safely as you can, you may well pad it to 40Meg,
Neil> rather than say "it is a multiple of 4K, that is enough for me".
Neil> So: the difference is only in the size.

Yep.  I call the lower boundary minimum_io_size and the upper boundary
optimal_io_size.

People have been putting filesystems and databases on top of RAID
devices for ages.  And generally the best practice has been to align and
write in multiples of the chunk size and try to write full stripe
widths.

Given the requirement for read-modify-write on RAID[456] I can
understand your predisposition to set minimum_io_size to the stripe
width.  However, I'm not really sure that's what the user wants.  Given
the stripe cache I'm also not convinced the performance impact of the MD
RAID[456] RMW cycle is as bad as that of the disk drive.  So I set
minimum_io_size to the chunk size in my patch.

If you can come up with better names for minimum and optimal then that's
ok with me.  SCSI uses the term granularity.  I used that for a while in
my patches but most people thought that was really weird.  Minimum and
optimal seemed easier to grasp.  Maximum also exists in the storage
device context but is literally the largest I/O the device can receive.

And just to make it clear: I completely agree with your argument that
which knob to choose is I/O size dependent.  My beef with your proposal
is that I believe the length of the list should be 2.

How we do report this stuff is really something I'd like the FS guys to
comment on, though.  The knobs we have now correspond to what's
currently used by XFS (libdisk) and indirectly by ext2+.

-- 
Martin K. Petersen	Oracle Linux Engineering
