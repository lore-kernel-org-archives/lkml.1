Return-Path: <linux-kernel-owner+w=401wt.eu-S935281AbXEIG10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935281AbXEIG10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 02:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934867AbXEIG1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 02:27:17 -0400
Received: from rosesmtp04.adp.com ([170.146.91.26]:2229 "EHLO
	rosesmtp04.adp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934666AbXEIG1P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 02:27:15 -0400
X-Greylist: delayed 140922 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 May 2007 02:27:15 EDT
X-Server-Uuid: 44418BB9-D913-4AA8-A168-EE33603A6708
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [00/17] Large Blocksize Support V3
Date: Mon, 7 May 2007 11:17:55 -0400
Message-ID: <69C45F7F884EF94DBB8D939CA5D53514012B6B0B@BWEXCVS02.ES.AD.ADP.COM>
In-Reply-To: <m13b29ktpg.fsf@ebiederm.dsl.xmission.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [00/17] Large Blocksize Support V3
Thread-Index: AceQduvc4Pxr43TbTj6uKKXZ36nAmAAQFhkw
References: <20070424222105.883597089@sgi.com><20070426190438.3a856220.akpm@linux-foundation.org><20070427022731.GF65285596@melbourne.sgi.com><20070426195357.597ffd7e.akpm@linux-foundation.org><20070427042046.GI65285596@melbourne.sgi.com><20070426221528.655d79cb.akpm@linux-foundation.org><20070427060921.GA77450368@melbourne.sgi.com><20070427000403.6013d1fa.akpm@linux-foundation.org><20070427080321.GG32602149@melbourne.sgi.com><m1ejlwu346.fsf@ebiederm.dsl.xmission.com><20070507045835.GU32602149@melbourne.sgi.com>
 <m13b29ktpg.fsf@ebiederm.dsl.xmission.com>
From: "Weigert, Daniel" <Daniel_Weigert@adp.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, "David Chinner" <dgc@sgi.com>
cc: "Andrew Morton" <akpm@linux-foundation.org>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, "Mel Gorman" <mel@skynet.ie>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Badari Pulavarty" <pbadari@gmail.com>,
       "Maxim Levitsky" <maximlevitsky@gmail.com>
X-OriginalArrivalTime: 07 May 2007 15:18:02.0668 (UTC)
 FILETIME=[E7909EC0:01C790BA]
X-WSS-ID: 6A219CB117C6620244-01-01
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just to stick my two cents in here:

The definition of what is meant by "large" filesystems has to change
with the advances in disk drive technology.  In the not too distant
past, a "large" single filesystem was 100 GB. There are now consumer
grade disks on the market with 1 TB available in a single unit.  I don't
know about you guys, but that scares the crap out of me, in terms of
dealing with that much space on a desktop machine.  Efficiently dealing
with transferring that much data on a desktop (never mind server) means
re-thinking the limitations of the I/O subsystems.  What was once the
realm of the data center is now the realm of the living room.  Large
data sets are becoming more commonplace (HD Movies, audio files, etc)
with each passing day, and there is no end in sight in the progression.
In addition, with the release of specs recently about larger sector
sizes for disk drives (2048 bytes, or larger), this is going to become a
pressing need for the general case, not just the extremely large
servers, or HPC machines and clusters.  Already there is no efficient
way to back up that much space, in a reasonable time, except to have
another disk of a similar or larger size to back up to.  Anything we can
do to make disk I/O *Faster* is a win.

I recognize that there is a huge issue in dealing with sub block size
files.  The trade off of small files VS large blocks is now a non
trivial problem.  Once disk sector sizes increase, the problems will
have to be dealt with in a more intelligent manner, possibly dividing
sectors into smaller logical blocks for small files? Maybe filesystems
that can understand multiple block sizes? 

Well, we do live in interesting times; we just have to make the most of
it.

Dan Weigert

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Eric W.
Biederman
Sent: Monday, May 07, 2007 2:56 AM
To: David Chinner
Cc: Andrew Morton; clameter@sgi.com; linux-kernel@vger.kernel.org; Mel
Gorman; William Lee Irwin III; Jens Axboe; Badari Pulavarty; Maxim
Levitsky
Subject: Re: [00/17] Large Blocksize Support V3

David Chinner <dgc@sgi.com> writes:

> Both. To many things can happen asynchroonously to a page that it
> makes it just about impossible to predict all the potential race
> conditions that are involved. complexity arose from trying to fix
> the races that were uncovered without breaking everything else...

Ok.

>> Until we code review and implementation that does page aggregation
for
>> linux we can't say how nasty it would be.
>
> We already have an implementation - I've pointed it out several times
> now: see fs/xfs/linux-2.6/xfs_buf.[ch].
>
> There are a lot of nasties in there....

Yes, and but it isn't a generic implementation in mm/filemap.c,
it is a compatibility layer.  It lives with the current deficiencies
instead of removes them.

>> >> You're addressing Christoph's straw man here.
>> >
>> > No, I'm speaking from years of experience working on a
>> > page/buffer/chunk cache capable of using both large pages and
>> > aggregating multiple pages. It has, at times, almost driven me
>> > insane and I don't want to go back there.
>> 
>> The suggestion seems to be to always aggregate pages (to handle
>> PAGE_SIZE < block size), and not to even worry about the fact
>> that it happens that the pages you are aggregating are physically
>> contiguous.  The memory allocator and the block layer can worry
>> about that.  It isn't something the page cache or filesystems
>> need to pay attention to.
>
> perfomrance problems in using discontigous pages 
Small scatter lists?

> and needing to vmap() them says otherwise....
Always?

Ugh.  I just realized looking at the xfs code that it doesn't
work in the presence of high memory, at least not with 4K pages.

>> I suspect the implementation in linux would be sufficiently different
>> that it would not be prone to the same problems.  Among other things
>> we are already do most things on a range of page addresses, so we
>> would seem to have most of the infrastructure already.
>
> Filesystems don't typically do this - they work on blocks and assume
> that a block can be directly referenced.

But that is how mm/filemap.c works.  The calls into the filesystem
can be per multi-page group as they are current per page.  The point
is that the existing in kernel abstraction  is already larger then a
page for doing the work.

>> Given that small block sizes give us better storage efficiency,
>> which means less disk bandwidth used, which means less time
>> to get the data off of a slow disk (especially if you can
>> put multiple files you want simultaneously in that same space).
>> I'm not convinced that large block sizes are a clear disk performance
>> advantage, so we should not neglect the small file sizes.
>
> Hmmm - we're not talking about using 64k block size filesystems to
> store lots of little files or using them on small, slow disks.
> We're looking at optimising for multi-petabyte filesystems with
> multi-terabyte sized files sustaining throughput of tens to hundreds
> of GB/s to/from hundreds to thousands of disk.
>
> I certinaly don't consider 64k block size filesystems as something
> suitable for desktop use - maybe PVRs would benefit, but this
> is not something you'd use for your kernel build environment on a
> single disk in a desktop system....

Yes.  You are talking about only fixing the kernel for your giant
64K block filesystems that are only interesting on peta-byte arrays.

I am pointing out that the other fixes that have been discussed.
Optimistic contiguous page allocation and a larger linux scatter
gather list.  Are interesting on much smaller filesystem and machine
sizes where small files are still interesting.  Making them generally
better improvements for linux.

If you only improve the giant peta-byte raid cases 99% of linux users
simply don't care, and so the code isn't very interesting.

Eric
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel"
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
-----------------------------------------
This message and any attachments are intended only for the use of
the addressee and may contain information that is privileged and
confidential. If the reader of the message is not the intended
recipient or an authorized representative of the intended
recipient, you are hereby notified that any dissemination of this
communication is strictly prohibited. If you have received this
communication in error, notify the sender immediately by return
email and delete the message and any attachments from your system.

