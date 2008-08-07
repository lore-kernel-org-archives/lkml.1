Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbYHGQrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbYHGQrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 12:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbYHGQq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 12:46:58 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:47639 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbYHGQq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 12:46:57 -0400
To: linasvepstas@gmail.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "John Stoffel" <john@stoffel.org>,
       "Alistair John Strachan" <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: amd64 sata_nv (massive) memory corruption
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
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
	<3ae3aa420808062132x52860092p9dee56705ba99a3@mail.gmail.com>
Date: Thu, 07 Aug 2008 12:42:20 -0400
In-Reply-To: <3ae3aa420808062132x52860092p9dee56705ba99a3@mail.gmail.com> (Linas Vepstas's message of "Wed\, 6 Aug 2008 23\:32\:06 -0500")
Message-ID: <yq17iasg4k3.fsf@sermon.lab.mkp.net>
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

Linas> My problem is that the corruption I see is "silent": so
Linas> redundancy is useless, as I cannot distinguish good blocks from
Linas> bad.  I'm running RAID, one of the two disks returns bad data.
Linas> Without checksums, I can't tell which version of a block is the
Linas> good one.

But btrfs can.


Linas> There is also in interesting possibility that offers a middle
Linas> ground between raw performance and safety: instead of verifying
Linas> checksums on *every* read access, it could be enough to verify
Linas> only every so often -- say, only one out of every 10 reads, or
Linas> maybe triggered by a cron job in the middle of the night: turn
Linas> on verification, touch a bunch of files for an hour or two,
Linas> turn off verification before 6AM. 

All evidence suggests that scrubbing is a good way to keep your data
healthy.

A common corruption scenario a few years ago was bleed to adjacent
tracks due to a frequently written hot spot on disk.  Scrubbing in
RAID arrays helped fix that.  Modern drives actually maintain an
internal list of hot spots and will automatically schedule refreshes
of adjacent blocks to prevent bleed.

But there are obviously other corruption scenarios that scrubbing can
help alleviate -- including genuine bit rot on the platter.


Linas> Yes, well, my HBA is soldered onto my MB, and I'm buying $80
Linas> hard drives one at a time at Frye's electronics, so it could be
Linas> 5-10 years before DIX/DIF trickles down to consumer-grade
Linas> electronics.  And I don't want to wait 5-10 years ...

I doubt it's going to take *that* long.

Corruption of in-flight data has been a problem for years.  And it is
a problem that RAID and FS checksums can't fix.

Oracle has been providing customers with in-flight integrity
protection on high-end arrays for many years using a proprietary
technology called HARD.  Array vendors license it from us and HARD is
mandatory in a lot of business and government deployments.

DIF/DIX is our attempt to make integrity protection available on mid-
to low-range equipment.  We decided to embrace and extend an existing,
open standard and are working with standards bodies to nudge them in
the right direction in terms of new features.  It has taken about two
years from conception to product in a highly conservative, slow-moving
industry.

As as I mentioned earlier, T13 is working on EPP which is essentially
DIF for SATA.  The protection format is the same which means we can
prepare one type of integrity information regardless of whether the
target drive is SCSI or SATA.

Once External Path Protection is ratified I'm expecting drives to
appear fairly quickly.  The turnaround time should be short as SATA
drive generations don't last nearly as long as SCSI.


Linas> Thus, a "tactical" solution seems to be pure-software
Linas> check-summing in a kernel device-mapper module, performance be
Linas> damned.

What I don't understand is why you are so focused on fixing this at
the RAID level.  I think your time would be better spent contributing
to btrfs which gives you checksums and redundancy on consumer grade
hardware today.  It's is only a few months away from GA.  So why not
implement scrubbing in btrfs instead of spending time on a kludgy
device mapper module with crappy performance?

-- 
Martin K. Petersen	Oracle Linux Engineering
