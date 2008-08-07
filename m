Return-Path: <linux-kernel-owner+w=401wt.eu-S1757672AbYHGDEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672AbYHGDEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 23:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbYHGDEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 23:04:46 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:34508 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYHGDEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 23:04:45 -0400
To: linasvepstas@gmail.com
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       "John Stoffel" <john@stoffel.org>,
       "Alistair John Strachan" <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: amd64 sata_nv (massive) memory corruption
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <3ae3aa420808011030weadc61fvf6f850f0a4cfcb3e@mail.gmail.com>
	<200808012319.05038.alistair@devzero.co.uk>
	<3ae3aa420808011951l58da4010r1ff0876f255565b0@mail.gmail.com>
	<18580.48861.657366.629904@stoffel.org>
	<3ae3aa420808021501k2e871dc0y344dd7f9a7b80614@mail.gmail.com>
	<18581.6873.353028.695909@stoffel.org>
	<3ae3aa420808031523i1d9559d9i19dd5fcc9d5719c7@mail.gmail.com>
	<20080803231628.1361b75f@lxorguk.ukuu.org.uk>
	<3ae3aa420808051002n2438c0f6g82fb783b5102d149@mail.gmail.com>
	<20080805182119.75913fa3@lxorguk.ukuu.org.uk>
	<3ae3aa420808061433i3d90c3dcgfb40d953da2941c8@mail.gmail.com>
Date: Wed, 06 Aug 2008 22:59:33 -0400
In-Reply-To: <3ae3aa420808061433i3d90c3dcgfb40d953da2941c8@mail.gmail.com> (Linas Vepstas's message of "Wed\, 6 Aug 2008 16\:33\:04 -0500")
Message-ID: <yq1fxphfs2y.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Linas" == Linas Vepstas <linasvepstas@gmail.com> writes:

[I got added to the CC: late in the game so I don't have the
background this discussion]

Linas> My objection to fs-layer checksums (e.g. in some user-space
Linas> file system) is that it doesn't leverage the extra info that
Linas> RAID has.  If a block is bad, RAID can probably fetch another
Linas> one that is good. You can't do this at the file-system level.

ZFS and btrfs both support redundancy within the filesystem.  They can
fetch the good copy and fix the bad one.  And they have much more
context available for recovery than a RAID would.


Linas> I assume that a device mapper can alter the number of blocks-in
Linas> to the number of blocks-out; that it doesn't have to be
Linas> 1-1. Then for every 10 sectors of data, it would use 11 sectors
Linas> of storage, one holding the checksum.  I'm very naive about how
Linas> the block layer works, so I don't know what snags there might
Linas> be.

I did a proof of concept of this a couple of years ago ago.  And
performance was pretty poor.  I also have a commercial device that
implements DIF on a SATA drive by doing the same thing.  It also
suffers.  It works reasonably well for what it was designed for,
namely RAID arrays where there is much more control over I/O staging
than we can provide in a general purpose operating system.

The elegant part about filesystem checksums is that they are stored in
the metadata blocks which are read anyway.  So there are no additional
seeks, nor read-modify-write on a 10 sector + 1 blob of data.


Linas> I'm googling, but I don't see anything.  However, I now see,
Linas> for the first time, pending workd for 2.6.27 for a field in bio
Linas> called "blk_integrity". I cannot figure out if this work
Linas> requires special-whiz-bang disk drives to be purchased.

There are two parts to this:

1. SCSI Data Integrity Field or DIF adds 8 bytes of stuff (referred to
as protection information) to each sector.  The contents of each
8-byte tuple is well-defined.

2. Data Integrity Extensions is a set of knobs that allow us to DMA
the DIF protection information to and from host memory.  That enables
us to provide end-to-end data integrity protection.

We can generate the protection information either up in the
application, attach it in a library or inside the kernel.  HBAs, RAID
heads, disk drives and potentially SAN switches can verify the
integrity of the I/O before it gets passed on in the stack.

So, yes.  You need special hardware.  Controller and disk need to
support DIX and DIF respectively.  This has been in the works for a
while and hardware is starting to materialize.  Expect this to become
standard fare in the SCSI/SAS/FC market segment.

The T13 committee is currently working on a proposal called External
Path Protection which is essentially DIF for ATA.  Will probably
happen in nearline drives first.


Linas> Also, it seems to be limited to 8 bytes of checksums per 512
Linas> byte block? This is reasonable for checksumming, I guess, but
Linas> one could get even fancier and run ECC-type sums, if one could
Linas> store, say, an addtional 50 bytes for every 512 bytes. I'm
Linas> cc'ing Martin Petersen, the developer, for comments.

The 8-byte DIF tuple is split into 3 sections:

 - a 16-bit CRC of the 512 bytes of data

 - a 16-bit application tag

 - a 32-bit reference tag that in most cases needs to match the lower
   32 bits of the sector LBA

The neat thing about DIF is that all nodes in the I/O path can verify
the contents.  I.e. the drive can check that the CRC and LBA match the
data before it physically writes to disk.  This allows us to catch
corruptions up front instead of when data is eventually read back.

So I mainly consider DIX/DIF a means to protect data integrity while
the I/O is in flight.

However, there is one feature that is of benefit in a more persistent
manner, namely the application tag.  This gives us two bytes of extra
storage per sector.  Given the small size it has very limited use at
the sector level.  However, I have implemented it so that filesystems
can attach whatever they please, and the SCSI layer will interleave
the (meta-?)metadata attached to a logical block between the physical
sectors (This obviously implies FS block size > sector size and that's
about to change with 4KB sectors.  There's work in progress to allow 8
bytes of DIF per 512 bytes of data regardless of physical sector size,
though).

The application tag space can be used to attach checksums to
filesystem logical blocks without changing the on-disk format.  Or
DM/MD can use the extra space for their own housekeeping (and signal
to the filesystems that the app tag is not available).

DIF/DIX are somewhat convoluted and hard to cover in an email.  I
suggest you read my recent OLS paper and my "Proactively Preventing
Data Corruption" article.  Both can be found at the URL below.

  http://oss.oracle.com/projects/data-integrity/documentation/

-- 
Martin K. Petersen	Oracle Linux Engineering
