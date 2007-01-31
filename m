Return-Path: <linux-kernel-owner+w=401wt.eu-S933241AbXAaNTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241AbXAaNTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 08:19:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933248AbXAaNTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 08:19:07 -0500
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:20736 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933241AbXAaNTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 08:19:05 -0500
X-IronPort-AV: i="4.13,262,1167627600"; 
   d="scan'208"; a="400928023:sNHT28029020"
From: "Matthew Kirk" <mkirk01@rcn.com>
To: "'Andrew Morton'" <akpm@osdl.org>
Cc: <linux-kernel@vger.kernel.org>
References: <001a01c74136$0028ecf0$6600a8c0@charm><20070126031654.a41fe374.akpm@osdl.org><000c01c74180$dfe71070$6600a8c0@charm> <20070126114805.628f1351.akpm@osdl.org>
Subject: RE: fsync occasionally very slow
Date: Wed, 31 Jan 2007 08:18:41 -0500
Message-ID: <000c01c7453a$53b94920$6600a8c0@charm>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <20070126114805.628f1351.akpm@osdl.org>
Thread-Index: AcdBgvEb5ONQhTnCRnK0kbJyzKwlKQDtpCxQ
X-Junkmail-Status: score=10/50, host=mr08.lnh.mail.rcn.net
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A090202.45C09743.0121,ss=1,fgs=0,
	ip=207.172.4.11,
	so=2006-05-09 23:27:51,
	dmn=5.2.125/2006-10-10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Regarding the long fsyncs, here's a trace...
>>> 
>>> I upgraded to a more recent kernel - 2.6.18.6 - and ran it on a
>>workstation.
>>> This particular box has In this case the elevator is CFQ.
>>> 
>>> This sample came from a stall that lasted about 2.5 minutes(!) - the
longest
>>> one I've seen yet.  The box is a bit more memory constrained than the
>>> original system but exhibits similar behavior.  It doesn't page.  Also,
>>> there is no raid card - simply striped PATA drives.

>>Using your little test app, the longest fsync() stall I can >>demonstrate
on 2.6.20-rc4-mm1 on plain-old-sata-disk is 1.2 seconds.
>> What's the max stall you're able to see with the test app?

I have had that spike last up to about 4 seconds.  The pattern is that once
fsync starts taking time (e.g. there’s data to flush) the times will all be
in the milliseconds, except for one spike in the middle.  .  The times that
are in the milliseconds are all in a gradually increasing slope.

The stall I get from the real app is usually from a couple seconds to 25 or
so seconds.  

I’m not entirely sure that my test app demonstrates the same issue.


>>Perhaps the file is just super-fragmented.  If your production app >>does
something like: 

>>	for (a lot) {
>>		fd = open(name);
>>		write(fd, a little bit);
>>		close(fd);
>>	}
>>in multiple threads, or against a lot of different files then you >>might
be fragmenting the files a lot.  This is because ext3 discards >>its in-core
anti-fragmentation data structures on close().  So

>> - Please check your app, see whether or not it is frequently opening >>
and closing the output files.

The app opens each file for write exactly once, except for log files, which
get written infrequently.  A file may be opened for read, but that’s
infrequent.  Files are either 1K long or more than 10M long, in roughly
equal numbers.  Each file is created/opened, written sequentially in one or
more chunks of from 100K to 10M (as data is received over a network),
fsync-ed, closed, and then renamed into its final name (same directory). The
entire sequence for an individual file takes place in one thread. The
directory containing the file is then fsynced.  (probably irrelevant – when
we open files for read we always read the entire file sequentially, then
close it, and we always call posix_fadvise(willneed)).

There are usually about 10-15 large files open for write at a time.


>> - Using `bmap' from
  http://www.zip.com.au/~akpm/linux/patches/stuff/ext3-tools.tar.gz,
  determine whether the offending files are highly fragmented.

I’ll get back to you on this today.

>> - Tell us how much dirty data is being written out by these fsyncs?

Each of these fsyncs is used to flush an entire new file that’s either 1K
long or larger than 10MB (but usually about 10MB).

>> - Try mounting the filesystem with `-o data=writeback'.  Probably won't
help much if it's also demonstrable on ext2.

I’ll try that…

>> - Can you reproduce the stalls on a plain-old-disk?  Get RAID out of >>
the picture?

Using my test app I reproduced the behaviour on my home PC, which is a
pathetic little thing with an IDE drive.  I’ve also reproduced it in the
regular software using both hardware RAID and software RAID and will try
just a plain PATA drive later today.

>> - You've seen the stalls with both CFQ and AS.  I guess you could try
deadline and no-op, but it sounds like that won't help.

Deadline does it too.  I'll try noop later today..

Thanks

-- 
No virus found in this outgoing message.
Checked by AVG Free Edition.
Version: 7.5.432 / Virus Database: 268.17.16/660 - Release Date: 1/30/2007
5:04 PM
 
