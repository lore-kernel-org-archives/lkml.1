Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbZAETRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbZAETRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbZAETRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:17:16 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:56877 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbZAETRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:17:15 -0500
X-Greylist: delayed 56552 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jan 2009 14:17:14 EST
To: Pavel Machek <pavel@suse.cz>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20090103123813.GA1512@ucw.cz>
	<200901041349.49906.rob@landley.net>
	<20090104225545.GF1913@elf.ucw.cz>
	<yq1r63i30bv.fsf@sermon.lab.mkp.net>
	<20090105094504.GB27199@atrey.karlin.mff.cuni.cz>
Date: Mon, 05 Jan 2009 14:15:44 -0500
In-Reply-To: <20090105094504.GB27199@atrey.karlin.mff.cuni.cz> (Pavel Machek's message of "Mon\, 5 Jan 2009 10\:45\:04 +0100")
Message-ID: <yq1sknx1s4f.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A01020A.49625C67.01F1:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Pavel" == Pavel Machek <pavel@suse.cz> writes:

>> It is mostly true on SCSI class devices because various UNIX, RAID
>> array and database vendors have spent many years leaning very hard on
>> the drive manufacturers to make it so.
>> 
>> But it's not a hard guarantee, you can't get it in writing, and it's
>> not in any of the standards.  Hybrid drives with flash had potential
>> to close that particular loophole but those appear to be dead in the
>> water.

Pavel> So "in practice it works but vendors will not guarantee that"?

It works some of the time.  But in reality if you yank power halfway
during a write operation the end result is undefined.

The saving grace for normal users is that the potential corruption is
limited to a couple of sectors.

The current suck of flash SSDs is that the erase block size amplifies
this problem by at least one order of magnitude, often two.  I have a
couple of SSDs here that will leave my filesystem in shambles every time
the machine crashes.  I quickly got tired of reinstalling Fedora several
times per week so now my main machine is back to spinning media.

The people that truly and deeply care about this type of write atomicity
(i.e. enterprises) deploy disk arrays that will do the right thing in
face of an error.  This involves NVRAM, mirrored caches, uninterruptible
power supplies, etc.  Brute force if you will.

High-end arrays even give you atomicity at a bigger granularity such as
filesystem or database blocks.  On some storage you can say "this LUN is
used for an Oracle database that always writes in multiples of 8KB" and
the array will guarantee that each 8KB block of the I/O is written in
its entirety or not at all.  Some arrays even allow you to verify Oracle
logical block checksums to ensure that the I/O is intact and internally
consistent.

I have been bugging storage vendors about a per-I/O write atomicity
setting for a while.  But it really messes up their pipelining so they
aren't keen on the idea.  We may be able to get some of it fixed as a
side-effect of the DIF bits vs. the impending switch to 4KB sectors,
though.

-- 
Martin K. Petersen	Oracle Linux Engineering
