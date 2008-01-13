Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbYAMEkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbYAMEkQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 23:40:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbYAMEkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 23:40:04 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:51812 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbYAMEkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 23:40:01 -0500
From: Anton Salikhmetov <salikhmetov@gmail.com>
To: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com
Subject: [PATCH 0/2] yet another attempt to fix the ctime and mtime issue
Date: Sun, 13 Jan 2008 07:39:57 +0300
Message-Id: <12001991991217-git-send-email-salikhmetov@gmail.com>
X-Mailer: git-send-email 1.4.4.4
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The POSIX standard requires that the ctime and mtime fields
for memory-mapped files should be updated after a write
reference to the memory region where the file data is mapped.
At least FreeBSD 6.2 and HP-UX 11i implement this properly.
Linux does not, which leads to data loss problems in database
backup applications.

Kernel Bug Tracker contains more information about the problem:

http://bugzilla.kernel.org/show_bug.cgi?id=2645

There have been several attempts in the past to address this
issue. Following are a few links to LKML discussions related
to this bug:

http://lkml.org/lkml/2006/5/17/138
http://lkml.org/lkml/2007/2/21/242
http://lkml.org/lkml/2008/1/7/234

All earlier solutions were criticized. Some solutions did not
handle memory-mapped block devices properly. Some led to forcing
applications to explicitly call msync() to update file metadata.
Some contained errors in using kernel synchronization primitives.

In the two patches that follow, I would like to propose a new
solution.

This is the third version of my changes. This version takes
into account all feedback I received for the two previous versions.
The overall design remains basically the same as the one that
was acked by Rick van Riel:

http://lkml.org/lkml/2008/1/11/208

To the best of my knowledge, these patches are free of all the
drawbacks found during previous attempts by Peter Staubach,
Miklos Szeredi and myself.

New since the previous version:

1) no need to explicitly call msync() to update file times;
2) changing block device data is visible to all device files
   associated with the block device;
3) in the cleanup part, the error checks are separated out as
   suggested by Rik van Riel;
4) some small refinements accodring to the LKML comments.

This is how I tested the patches.

1. To test the features mentioned above, I wrote a unit test
   available from

   http://bugzilla.kernel.org/attachment.cgi?id=14430

   I verified that the unit test passed successfully for both
   regular files and block device files. For the unit test I
   used the following architectures: 32-bit x86, x86_64 and
   MIPS32 (cross-compiled from x86_64).

2. I did build tests with allmodconfig and allyesconfig on x86_64.

3. I ran the following test cases from the LTP test suite:

   msync01
   msync02
   msync03
   msync04
   msync05
   mmapstress01
   mmapstress09
   mmapstress10

   No regressions were found by these test cases.

I think that the bug #2645 is resolved by these patches.

Please apply.
