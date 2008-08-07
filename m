Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbYHGEcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbYHGEcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 00:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYHGEcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 00:32:10 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:50134 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbYHGEcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 00:32:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=klU60Jz2vXQpoqlqapWV/ubKOIYy8h11ealoOSJrP8Ok+2WvqYO8hZ56tju3ACVLai
         FAnZVPYIwmm+ti5KD8IXpRAlDT56v0HNIOeGxSGuJy6enCiDOD2k+fZq34qBx7DMMod1
         oEUN6msdgZox8L8j/rG9PDfSfGdWE2ofaOSug=
Message-ID: <3ae3aa420808062132x52860092p9dee56705ba99a3@mail.gmail.com>
Date: Wed, 6 Aug 2008 23:32:06 -0500
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: amd64 sata_nv (massive) memory corruption
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "John Stoffel" <john@stoffel.org>,
       "Alistair John Strachan" <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <yq1fxphfs2y.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420808011030weadc61fvf6f850f0a4cfcb3e@mail.gmail.com>
	 <18580.48861.657366.629904@stoffel.org>
	 <3ae3aa420808021501k2e871dc0y344dd7f9a7b80614@mail.gmail.com>
	 <18581.6873.353028.695909@stoffel.org>
	 <3ae3aa420808031523i1d9559d9i19dd5fcc9d5719c7@mail.gmail.com>
	 <20080803231628.1361b75f@lxorguk.ukuu.org.uk>
	 <3ae3aa420808051002n2438c0f6g82fb783b5102d149@mail.gmail.com>
	 <20080805182119.75913fa3@lxorguk.ukuu.org.uk>
	 <3ae3aa420808061433i3d90c3dcgfb40d953da2941c8@mail.gmail.com>
	 <yq1fxphfs2y.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/6 Martin K. Petersen <martin.petersen@oracle.com>:
>>>>>> "Linas" == Linas Vepstas <linasvepstas@gmail.com> writes:
>
> [I got added to the CC: late in the game so I don't have the
> background this discussion]

You haven't missed anything, other than I've had my
umpteenth instance of data corruption in some years,
and am up to my eyeballs in consumer-grade hardware
from which I would like to get enterprise-grade reliability.
Of course, being a cheapskate is what gets me into this
mess.

> ZFS and btrfs both support redundancy within the filesystem.  They can
> fetch the good copy and fix the bad one.  And they have much more
> context available for recovery than a RAID would.

My problem is that the corruption I see is "silent": so
redundancy is useless, as I cannot distinguish good blocks
from bad.   I'm running RAID, one of the two disks returns
bad data.  Without checksums, I can't tell which version of
a block is the good one.

> Linas> I assume that a device mapper can alter the number of blocks-in
> Linas> to the number of blocks-out; that it doesn't have to be
> Linas> 1-1. Then for every 10 sectors of data, it would use 11 sectors
> Linas> of storage, one holding the checksum.  I'm very naive about how
> Linas> the block layer works, so I don't know what snags there might
> Linas> be.
>
> I did a proof of concept of this a couple of years ago ago.  And
> performance was pretty poor.

Yes, I'm not surprised. For a home-use system, though,
I think I'm ready to sacrifice performance in exchange for
reliability.  Much of what I do does not hit the disk hard.

There is also in interesting possibility that offers a middle
ground between raw performance and safety: instead of
verifying  checksums on *every* read access, it could be
enough to verify only every so often -- say, only one out
of every 10 reads, or maybe triggered by a cron job in
the middle of the night: turn on verification, touch a bunch
of files for an hour or two, turn off verification before 6AM.
This would be enough to trigger timely ill-health warnings,
without impacting daytime use.  (Much as I dislike the
corruption I suffered, I dislike even more that I had no
warning of it)

> The elegant part about filesystem checksums is that they are stored in
> the metadata blocks which are read anyway.

Yes.

> So there are no additional
> seeks, nor read-modify-write on a 10 sector + 1 blob of data.

I guess that, instead of writing 10+1 sectors, with the seek
penalty, it might be faster to copy data in the kernel, so as
to be able to store the checksum in the same sector as the
data.

> So, yes.  You need special hardware.  Controller and disk need to
> support DIX and DIF respectively.  This has been in the works for a
> while and hardware is starting to materialize.  Expect this to become
> standard fare in the SCSI/SAS/FC market segment.

Yes, well, my HBA is soldered onto my MB, and I'm buying
$80 hard drives one at a time at Frye's electronics, so it could
be 5-10 years before DIX/DIF trickles down to consumer-grade
electronics.  And I don't want to wait 5-10 years ...

Thus, a "tactical" solution seems to be pure-software
check-summing in a kernel device-mapper module,
performance be damned.

--linas
