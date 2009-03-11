Return-Path: <linux-kernel-owner+w=401wt.eu-S1751884AbZCKQZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbZCKQZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbZCKQZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:25:41 -0400
Received: from phunq.net ([64.81.85.152]:48636 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750870AbZCKQZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:25:40 -0400
From: Daniel Phillips <phillips@phunq.net>
To: linux-kernel@vger.kernel.org
Subject: Tux3 report: Tux3 Git tree available
Date: Wed, 11 Mar 2009 09:25:37 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, tux3@tux3.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903110925.37614.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Git tree for Tux3 kernel code is now available at:

   git://git.kernel.org/pub/scm/linux/kernel/git/daniel/linux-tux3.git

To build a recent of Linus's kernel with Tux3:

   git clone git://git.kernel.org/pub/scm/linux/kernel/git/daniel/linux-tux3.git
   cd linux-tux3
   make defconfig
   make CONFIG_TUX3=y

Tux3 userspace code is available from our Mercurial repository.  To
build Tux3 userspace code and create a Tux3 filesystem:

   hg clone http://hg.tux3.org/tux3
   cd tux3
   make
   ./tux3 mkfs /dev/<testpartition>

The Git Tux3 code is identical to the code in the user/kernel directory
of the Mercurial repository.  More than 80% of the kernel code also
executes in userspace under Fuse, or as a component of the "tux3"
utility command, or as part of the "make tests" unit tests.  We plan to
continue our dual userspace/kernel development model, as it has proven
effective at producing decent code with a low bug count.  For this
reason, please expect to see some wrappers in the kernel code, especially
around buffer operations.  Not only do we need to be compatible with
a slightly different buffer API in userspace, but we plan to use these
wrappers to help move away from buffers completely in due course.

There are various other oddities to be seen where writing code for both
userspace and kernel was not completely straightforward.  For example,
kernel has multiple kinds of inodes with conversions between generic
and specific inodes, while userspace has only one kind.  We will attempt
to reduce these differences over time, and reduce the frequency of #ifdef
__KERNEL__ where bits of userspace appear in the kernel files.

Tux3 is strictly for developers at the moment.  >>Crash recovery is not
implemented yet.<<  If Tux3 oopses or the machine loses power before
unmounting a Tux3 filesystem, then you should reboot and recreate the
Tux3 filesystem with "tux3 mkfs".

A quick status report: Tux3 now runs fine as root fs, as was announced
last month.  Of course nobody should use this for real work because if
it crashes, chances are it will not mount again.  Crash recovery code is
now partly implemented both in userspace and kernel, so we can see how
it looks now, but it is not yet functional.  There are a few known bugs
and deficiencies.  We thought that it would be wrong of us to hog the
bugs for ourselves, thus depriving the wider community of the fun and
glory of fixing these together, so we are going to offer Tux3 for
review, and hopefully merging in the not too distant future, complete
with bugs, warts and deficiencies.

The good news is: Tux3 does appear to work pretty well.  With 6,525
lines of kernel code, it is close to implementing an Ext3-level feature
set.  Ext3 is 32,926 lines including JBD.  Sure, we are short a few
comments, and some rather important code, like allocation policy. 
However, at this point we can see that Tux3 is as light and tight as
originally hoped for, and we expect it to remain so throughout its life. 
As a wild guess, when fleshed out with recovery, an effective allocation
policy, btree directories, versioning, and loads of comments, Tux3 will
still come in under 10,000 lines.

Development work is proceding on a number of fronts.  Hirofumi has taken
over the logging and recovery work from me, I am working on out of space
handling, and a team of students at Pune Institute in India are busy
implementing block deduplication, more on that later.

Tux3 performance at this point is decent, much more so than I expected
since we have not yet begun serious optimization work.  At least for
intial untar-like loads, Tux3 performs a little better than Ext3 and a
little worse than Ext2.  When logging is fully functional, Tux3 will be
writing a few additional log blocks, but there should also be less
seeking, according to my calculations.  In other words, when Tux3
recovery code is fully functional, it should be a speedup rather than a
slowdown.  And there is at least one big, easy optimization that will
yield a substantial reduction in total blocks transfered.  This ongoing
work promises to be a lot of fun.  Since it would be selfish of us to
keep all that fun for ourselves, we think it is about time to offer up
Tux3 for review.

How do we want to go about this?  Six and a half thousand lines of code
is a bit much to post to lkml.  On the other hand, that hasn't stopped a
number of other artists from posting even bigger patches.

This is what we have today:

git diff 16b71fdf97599f1b1b7f38418ee9922d9f117396 | diffstat
 Makefile       |    1
 tux3/Kconfig   |    7
 tux3/Makefile  |   13
 tux3/balloc.c  |  314 ++++++++++++++++++
 tux3/btree.c   |  774 ++++++++++++++++++++++++++++++++++++++++++++++
 tux3/commit.c  |  241 ++++++++++++++
 tux3/dir.c     |  347 ++++++++++++++++++++
 tux3/dleaf.c   |  838 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tux3/filemap.c |  645 ++++++++++++++++++++++++++++++++++++++
 tux3/iattr.c   |  201 ++++++++++++
 tux3/ileaf.c   |  312 ++++++++++++++++++
 tux3/inode.c   |  564 ++++++++++++++++++++++++++++++++++
 tux3/log.c     |  180 ++++++++++
 tux3/namei.c   |  282 +++++++++++++++++
 tux3/super.c   |  253 +++++++++++++++
 tux3/trace.h   |   34 ++
 tux3/tux3.h    |  944 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tux3/utility.c |   68 ++++
 tux3/xattr.c   |  508 ++++++++++++++++++++++++++++++
 19 files changed, 6526 insertions(+)

The full patch is 191KB.  We could try patchbombing lkml with that, one
patch per file, say.

Or should we do it with a url:

   http://tux3.org/patches/tux3-2.6.29-rc7

Or just post one big patch?  It's not that big.

Regards,

Daniel
