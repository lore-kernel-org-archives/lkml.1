Return-Path: <linux-kernel-owner+w=401wt.eu-S933645AbXDIOy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645AbXDIOy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933662AbXDIOy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:54:28 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:43963 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933641AbXDIOy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:54:27 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [GIT PULL -mm] Unionfs branch management code
Date: Mon,  9 Apr 2007 10:53:51 -0400
Message-Id: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.268.g3dda
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches introduce new branch-management code into Unionfs as
well as fix a number of stability issues and resource leaks.  For detailed
announcement, see end of this email.

As before, there is a git repo at:

git://git.kernel.org/pub/scm/linux/kernel/git/jsipek/unionfs.git

(master.kernel.org:/pub/scm/linux/kernel/git/jsipek/unionfs.git)

There are 21 new commits:

	Unionfs: Don't inline do_remount_{add,del,mode}_option
	Unionfs: Added several BUG_ONs to assert dentry validity
	Unionfs: Properly handle stale inodes passed to unionfs_permission
	Unionfs: Pass lowernd to lower ->revalidate function
	Unionfs: vfsmount reference counting fixes
	Unionfs: unionfs_create needs to revalidate the dentry
	Unionfs: Decrement totalopens counter on error in unionfs_open
	Unionfs: Document unionfs_d_release locking
	Unionfs: Remove the older incgen ioctl
	Unionfs: Grab the unionfs sb private data lock around branch info users
	Unionfs: Rewrite unionfs_d_revalidate
	Unionfs: Introduce unionfs_mnt{get,put}
	Unionfs: Bulk of branch-management remount code
	Unionfs: Introduce branch-id code
	Unionfs: Actually verify if dentry's info node is locked
	Unionfs: Provide more helpful info on branch leaks during unmount
	Unionfs: Rename unionfs_data sbcount field to more appropriate open_files
	Unionfs: Proper comment on rwsem field
	Unionfs: Documentation updates for branch-management
	fs: Export drop_pagecache_sb symbol
	fs: Introduce path{get,put}

Thanks,

Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>

---

Announcement:

We're pleased to announce that we merged new branch-management code into
Unionfs 2.0.  Using this code, you can add, remove, and/or change the mode
of branches.  We allow multiple branch-management operations at the same
time and they are applied atomically.

The new branch-management interface uses the remount functionality.  It is
NOT compatible with the older Unionfs 1.x branch-management interface, which
used ioctl()s.  The older interface was not atomic for multiple operations,
and had a fundamental consistency problem with open files being revalidated.
The new remount-based branch-management interface fixes all of that, and
also saves users from having to use another utility (unionctl) to control
their branches: you can now use plain /sbin/mount for all your
branch-management commands.  Additionally, we now allow the entire union to
be remounted read-only or read-write.  Here are a few examples of how to use
the new interface:

To delete a branch /foo, regardless where it is in the current union:

# mount -t unionfs -o remount,del=/foo none MOUNTPOINT

To insert (add) a branch /foo before /bar:

# mount -t unionfs -o remount,add=/bar:/foo none MOUNTPOINT

To insert (add) a branch /foo (in "rw" mode) at the very beginning (i.e., a
new highest-priority branch), you can use the above syntax, or use a short
hand version as follows:

# mount -t unionfs -o remount,add=/foo none MOUNTPOINT

To change the mode of one existing branch, say /foo, from read-only to
read-write, and change /bar from read-write to read-only:

# mount -t unionfs -o remount,mode=/foo=rw,mode=/bar=ro none MOUNTPOINT


The above are just a few examples.  You can mix and match the branch
management commands.  For more documentation and examples, see the following
file in the latest patch:

	Documentation/filesystems/unionfs/usage.txt

Finally, the patch below includes bug fixes to a number of bugs we've
discovered during our thorough testing of the branch-management code.  One
of the challenges in branch management is that it can change the composition
of a live, running file system *while* it has open files and cached objects.
We tested the code as much as possible to ensure that even under intense
multi-threaded workloads, generation number and stale cache entries are
handled properly.

