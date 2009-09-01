Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbZIAFTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbZIAFTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 01:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbZIAFTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 01:19:54 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:59381 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZIAFTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 01:19:53 -0400
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: Data integrity built into the storage stack
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <87f94c370908291423ub92922ft2cceab9e34ac6207@mail.gmail.com>
Date: Tue, 01 Sep 2009 01:19:49 -0400
In-Reply-To: <87f94c370908291423ub92922ft2cceab9e34ac6207@mail.gmail.com>
	(Greg Freemyer's message of "Sat, 29 Aug 2009 17:23:50 -0400")
Message-ID: <yq1hbvntf62.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4A9CAEF7.00AB:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Greg" == Greg Freemyer <greg.freemyer@gmail.com> writes:

Greg> We already have the scsi data integrity patches that went in last
Greg> winter and I believe fit into the storage stack below the
Greg> filesystem layer.

The filesystems can actually use it.  It's exposed at the bio level.


Greg> I do believe there is a patch floating around for device mapper to
Greg> add some integrity capability.

The patch is in mainline.  It allows passthrough so the filesystems can
access the integrity features.  But DM itself doesn't use any of them,
it merely acts as a conduit.

DIF is inherently tied to storage device's logical blocks.  These are
likely to be smaller than the blocks we're interested in protecting.
However, you could conceivably use the application tag space to add a
checksum with filesystem or MD/DM blocking size granularity.  All the
hooks are there.

The application tag space is pretty much only available on disk
drives--array vendors use it for internal purposes.  But in the MD/DM
case we're likely to run on raw disk so that's probably ok.

That said, I really think btrfs is the right answer to many of the
concerns raised in this thread.  Everything is properly checksummed and
can be verified at read time.

The strength of DIX/DIF is that we can detect corruption at write time
while we still have the buffer we care about write sitting in memory.

So btrfs and DIX/DIF go hand in hand as far as I'm concerned.  They
solve different problems but both are squarely aimed at preventing
silent data corruption.

I do agree that we do have to be more prepared for collateral damage
scenarios.  As we discussed at LS we have 4KB drives coming out that can
invalidate previously acknowledged I/Os if it gets a subsequent write
failure on a sector.  And there's also the issue of fractured writes
when talking to disk arrays.  That's really what my I/O topology changes
were all about: Correctness.  The fact that they may increase
performance is nice but that was not the main motivator.

-- 
Martin K. Petersen	Oracle Linux Engineering
