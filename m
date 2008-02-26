Return-Path: <linux-kernel-owner+w=401wt.eu-S1764609AbYBZS5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764609AbYBZS5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 13:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763473AbYBZS5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 13:57:22 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:2849 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763033AbYBZS5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 13:57:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=SzUipVJ2M41hz1Ollqv1br8sCiC5RIKOYYBdSl6j0cvHMUmsNTdGq0xCycrxzozVtsOQIS4bUUM3v36a1PR1YIY4fSwsy1wR6x6GG3QE50WV3I0c+3HeVGCBCd4Z/xMDRnxdnvYfrnRQYttZ2dQNzqKkbJNNLCCn3s4lsxHVH0Q=
Message-ID: <9f5edc120802261057p318c55c4xb4269d48fa7b37b6@mail.gmail.com>
Date: Tue, 26 Feb 2008 13:57:19 -0500
From: "Joe Landman" <joe.landman@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Odd performance observation for RAID0
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks:

  I posted this in linux-raid, though I thought it might interest the
kernel folks due to the subsystems in question.  No responses there.

  Executive summary version:  building a RAID0 across 2 large hardware
RAIDed disks results in buffered I/O performance that is similar to a
single one of these controllers.  Additional tests, breaking the raid
apart into 2 separate drives, yields the expected I/O performance when
using buffered IO, and 2 simultaneous IO operations, one to each disk.
 Direct IO doesn't show this performance anomaly and is fast in either
case.  Observed with kernel 2.6.23.14.

  A curious thing happens with 2.6.24.2, in that now direct IO
performance is as bad as buffered IO performance.

  The problem as stated, leads me to think that I might be running
into a point of serialization of the buffer cache.

  Details:

  I built a RAID0 stripe across two large hardware RAID cards
(identical cards/driver).  What I am finding is that direct IO is
about the performance I expect (2x the single RAID card) while
buffered IO is about the same as the performance of a single RAID
card.  This is true across chunk sizes of 64 through 4096k, with an
xfs file system.

 This is a 2.6.23.14 kernel.  I tried 2.6.24.2, and there the direct
IO on two RAID cards was the same speed as the direct and buffered IO
on one RAID card, even though the RAID0 striped across 2 RAID cards.

  There appears to be some issue with this combination of RAID0,
buffer cache, and the driver. Breaking the raid in 2, and performing
the same tests on each RAID card results in the expected performance
during buffered io and direct IO.

  Tests were simple reads and writes:

   dd if=/dev/zero of=/big/local.file bs=8388608 count=10000

and

   dd if=/big/local.file of=/dev/null bs=8388608

added oflag=direct and iflag=direct for the direct io versions.  I
tried changing the default IO scheduler (cfq to deadline) though this
particular workload shouldn't make much of a difference (all reads or
all writes).  I tried altering queue depth, and a number of other
parameters. All told, they had limited impact.

  The end user of this system indicated that they will be using
fadvise mechanisms to handle cache hinting, and they will be doing
large block sequential streaming, so direct IO like performance should
be fine.  That said, I am concerned that the buffered IO case appears
serialized.  Of course we are not re-using the buffer for these tests,
so this could have an impact.  Along those lines, I tried adjusting
the "dirty" parameters to see what I could do

/proc/sys/vm/dirty_expire_centisecs
/proc/sys/vm/dirty_writeback_centisecs
/proc/sys/vm/dirty_ratio
/proc/sys/vm/dirty_background_ratio

I tried various changes that I thought might work (increasing the
dirty_ratio while decreasing the dirty_expire_centisecs).  I did get
some impact, though it was mostly in the direction of lower
performance.

The questions I have are, could the raid0 device be effectively
serializing access to the buffer cache?  The hardware RAID devices I
am using are quite fast, so this might represent a different area of
testing than raid0 normally gets.

Other possibilities I have thought of include oddities in xfs (I tried
ext3 as well, though I ran into an 8TB limit) and how it interacts
with the buffer cache.  Driver oddities (seen on several versions of
this driver).  To try to eliminate these other effects, I broke the
unit up into 2 separate devices (1 per RAID card), and built two file
systems.  Simultaneous IO to each file system gave expected
performance.  My take on that is that the driver (handling both RAIDs)
has no trouble interacting with the OS and the buffer cache under
heavy IO situations.  I used xfs on each file system, so it further
suggests that xfs is not likely the problem.

With all this said, does anyone have any suggestions on this?  Or even
where to look in the raid0.c code (or elsewhere) to see what is going
on?

Thanks!

Joe
