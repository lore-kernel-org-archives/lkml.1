Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbYJ2BuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbYJ2BuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 21:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYJ2Bt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 21:49:59 -0400
Received: from anchor-post-31.mail.demon.net ([194.217.242.89]:1311 "EHLO
	anchor-post-31.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751981AbYJ2Bt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 21:49:57 -0400
To: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: [PATCH V2 00/16] Squashfs: compressed read-only filesystem
Message-Id: <E1Kv0C3-0006GU-ES@dylan>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Wed, 29 Oct 2008 01:49:55 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This a respin of the Squashfs patches incorporating the review comments
received.  Thanks to everyone who have sent comments.

Summary of changes in patch respin:

1. Functions changed to return 0 on success and -ESOMETHING on error
2. Header files moved from include/linux to fs/squashfs
3. Variables changed to use sb and inode
4. Number of squashfs_read_metadata() parameters reduced
5. Xattr placeholder code tweaked
6. TRACE and ERROR macros fixed to use pr_debug and pr_warning
7. Some obsolete macros in squashfs_fs.h removed
8. A number of gotos to return statements replaced with direct returns
9. Sparse with endian checking (make C=2 CHECKFLAGS="-D__CHECK_ENDIAN__")
   errors fixed
10. get_dir_index_using_name() misaligned access fixed
11. Fix a couple of printk warnings on PPC64
12. Shorten a number of variable names

There is now a public git repository on kernel.org. Pull/clone from
git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-2.6.git

These 16 patches are against 2.6.28-rc2.

Following is the original re-submission oveview, detailing the major
changes since the original 2005 submission, and a case for its inclusion.

Thanks

Phillip

This is a second attempt at mainlining Squashfs.  The first attempt was way
way back in early 2005 :-)  Since then the filesystem layout has undergone
two major revisions, and the kernel code has almost been completely
rewritten.  Both of these were to address the criticisms made at the original
attempt.

Summary of changes:
	1. Filesystem layout is now 64-bit, in theory filesystems and
	   files can be 2^64 in size.

	2. Filesystem is now fixed little-endian.

	3. "." and ".." are now returned by readdir.

	4. Sparse files are now supported.

	5. Filesystem is now exportable (NFS etc.).

	6. Datablocks up to 1 Mbyte are now supported.

Codewise all of the packed bit-fields and the swap macros have been removed in
favour of aligned structures and in-line swapping using leXX_to_cpu().  The
code has also been extensively restructured, reformatted to kernel coding
standards and commented.

Previously there was resistance to the inclusion of another compressed
filesystem when Linux already had cramfs.  There was pressure for a strong
case to be made for the inclusion of Squashfs.  Hopefully the case for
the inclusion of other compressed filesystems has now already been answered
over the last couple of years, however, it is worth listing the
features of Squashfs over cramfs, which is still the only read-only
compressed filesystem in mainline.

Max filesystem size: cramfs 16 Mbytes, Squashfs 64-bit filesystem
Max filesize: cramfs 16 Mbytes, Squashfs 64-bit filesystem
Block size: cramfs 4K, Squashfs default 128K, max 1Mbyte
Tail-end packing: cramfs no, Squashfs yes
Directory indexes: cramfs no, Squashfs yes
Compressed metadata: cramfs no, Squashfs yes
Hard link support: cramfs no, Squashfs yes
Support for "." and ".." in readdir: cramfs no, Squashfs yes
Real inode numbers: cramfs no, Squashfs yes.  Cramfs gives device inodes,
	fifo and empty directories the same inode of 1!
Exportable filesystem (NFS, etc.): cramfs no, Squashfs yes
Active maintenance: cramfs no (it is listed as orphaned, probably no active
	work for years), Squashfs yes

Sorry for the list formatting, but many email readers are very unforgiving
displaying tabbed lists and so I avoided them.

For those that want hard performance statistics
http://tree.celinuxforum.org/CelfPubWiki/SquashFsComparisons gives
a full comparison of the performance of Squashfs against cramfs, zisofs,
cloop and ext3.  I made these tests a number of years ago using Squashfs 2.1,
but they are still valid.  In fact the performance should now be better.

Cramfs is a limited filesystem, it's good for some embedded users but not now
much else, its layout and features hasn't changed in the eight years+ since
its release.  Squashfs, despite never being in mainline, has been actively
developed for over six years, and in that time has gone through four
layout revisions, each revision improving compression and performance where
limitations were found.  For an often dismissed filesystem, Squashfs has
advanced features such as metadata compression and tail-end packing for greater
compression, and directory indexes for faster dentry operations.

Despite not being in mainline, it is widely used.  It is packaged
by all major distributions (Ubuntu, Fedora, Debian, SUSE, Gentoo), it is used
on most LiveCDs, it is extensively used in embedded systems (STBs, routers,
mobile phones), and notably is used in such things as Splashtop and the
Amazon Kindle.

Anyway that's my case for inclusion.  If any readers want Squashfs
mainlined it's probably now a good time to offer support!

There are 16 patches in the patch set, and the patches are against the
latest linux-next tree (linux 2.6.27-next-20081016).

Finally, I would like to acknowledge the financial support of the Consumer
Embedded Linux Forum (CELF).  They've made it possible for me to spend the
last four months working full time on this mainlining attempt.

Phillip

