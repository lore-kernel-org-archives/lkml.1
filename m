Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbXL1VKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbXL1VKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 16:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbXL1VKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 16:10:36 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40582 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbXL1VKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 16:10:35 -0500
Date: Fri, 28 Dec 2007 16:09:50 -0500
Message-Id: <200712282109.lBSL9oV4027434@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] unionfs: work better with tmpfs 
In-reply-to: Your message of "Tue, 18 Dec 2007 22:10:34 GMT."
             <Pine.LNX.4.64.0712182207400.28390@blonde.wat.veritas.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <Pine.LNX.4.64.0712182207400.28390@blonde.wat.veritas.com>, Hugh Dickins writes:
> Here's a few patches to unionfs, which together with the tmpfs
> patches I just posted, get that combination working better.
> 
>  fs/stack.c         |    6 +++
>  fs/unionfs/inode.c |   83 +++++++++++++++++++++----------------------
>  fs/unionfs/mmap.c  |    3 -
>  3 files changed, 47 insertions(+), 45 deletions(-)

The series of patches I just posted includes your fixes, and more.  Thanks!

> But on the way I've noticed a number of issues with unionfs not dealt
> with in these patches.
> 
> 1. Please try unionfs with lockdep configured on (perhaps while running LTP
> to get coverage of a variety of cases): I soon gave up, not knowing which
> way round the locks should really be taken e.g. unionfs_read_lock versus
> unionfs_lock_dentry.
>
> 2. I'm worried about the locking generally (no doubt it's difficult!).
> My 2/4 patch half-fixes one issue, but raises others: if some function
> in a filesystem is usually called with i_mutex held, are you safe to be
> calling it (not knowing that lower filesystem) without its i_mutex held?

The series of patches I just posted addresses locking.  Lockdep helped me
find and fix a number of locking problems (deadlocks and races).  I tried
the fixes w/ my unionfs-specific regression suite (on top of many different
filesystems), with ltp on top of ext3 or tmpfs, and with a large "make -j"
kernel compile on top of ext3 or tmpfs.  I also tried it with machines with
more/less memory, SMP/UMP, and/or while forcing drop_caches.

I also found and reported a lockdep problem in nfs4 and ext3.  I also
re-discovered a long-standing lockdep problem in jffs2 (which I reported a
while back, but it still exists).

> 3. LTP's rename14 tends to fill the filesystem with inodes, which prevent
> further tests from running (but not on all machines: a timing issue
> perhaps).  I have to run LTP with rename14 moved aside.
>
> 4. Though you made improvements, some blocks still remain mysteriously
> allocated even after the unionfs should be empty e.g. after an LTP run.

The series of patches I just posted fixes these.  Basically, we weren't
releasing the lower inodes early enough, in several scenarios.  So they hung
around until the f/s unmounted.  To test the fixes, I've run each of the 707
LTP "syscalls" tests, and each of the 54 "fs" tests, and compared the number
of inodes and blocks used in the upper and lower file systems before and
after each test.  And I've tested it with LTP running in a union on top of
ext3 or tmpfs.  I'm happy to report we don't leak a single inode now.

> Hugh

I've tried all of these on linus's latest tree.  Since Andrew reported that
x86 is broken in -mm, I wasn't yet able to try it with mm or with your tmpfs
patches.

Cheers,
Erez.
