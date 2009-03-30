Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbZC3Mc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbZC3Mc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbZC3McP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:32:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35672 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbZC3McO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:32:14 -0400
Date: Mon, 30 Mar 2009 13:31:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Q: check_unsafe_exec() races (Was: [PATCH 2/4] fix setuid
	sometimes doesn't)
Message-ID: <20090330123101.GQ28946@ZenIV.linux.org.uk>
References: <20090329055513.GH28946@ZenIV.linux.org.uk> <20090329060118.GI28946@ZenIV.linux.org.uk> <20090329213635.GA21820@redhat.com> <20090329222022.GJ28946@ZenIV.linux.org.uk> <20090329235639.GA32199@redhat.com> <20090330000338.GB32199@redhat.com> <20090330010843.GM28946@ZenIV.linux.org.uk> <20090330011303.GN28946@ZenIV.linux.org.uk> <20090330013612.GA4080@redhat.com> <20090330014040.GA4807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330014040.GA4807@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 03:40:40AM +0200, Oleg Nesterov wrote:

> > We can't proceed. If that another exec() fails, it will clear "under exec" at
> > the end of do_execve(), before we kill other threads.
> 
> Or we need a counter to mark/unmark.

Nah, easier to have check_unsafe_exec() return -EAGAIN in cases we care
about.

Anyway, completely untested patchset is in
git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ execve-mess
(the last 9 changesets of it).

WARNING: that's *NOT* for merge at the moment; this is not a pull request.

Review (and testing) would be welcome.

Shortlog of execve-related part:
Al Viro (6):
      Take fs_struct handling to new file (fs/fs_struct.c), sanitize chroot_fs_refs()
      New helper - current_umask()
      Get rid of indirect include of fs_struct.h
      Kill unsharing fs_struct in __set_personality()
      New locking/refcounting for fs_struct
      check_unsafe_exec() doesn't care about signal handlers sharing

Hugh Dickins (3):
      Don't bump fs_struct refcount for procfs accesses
      compat_do_execve should unshare_files
      fix setuid sometimes doesn't - files_struct

Diffstat (again, of execve-related stuff)
 arch/cris/kernel/process.c                |    1 -
 arch/powerpc/platforms/cell/spufs/inode.c |    2 +-
 fs/Makefile                               |    2 +-
 fs/btrfs/acl.c                            |    2 +-
 fs/btrfs/ioctl.c                          |    2 +-
 fs/cifs/dir.c                             |    4 +-
 fs/cifs/inode.c                           |    4 +-
 fs/compat.c                               |   28 ++++-
 fs/dcache.c                               |    1 +
 fs/exec.c                                 |   39 +++++--
 fs/ext2/acl.c                             |    2 +-
 fs/ext3/acl.c                             |    2 +-
 fs/ext4/acl.c                             |    2 +-
 fs/fat/inode.c                            |    2 +-
 fs/fs_struct.c                            |  173 +++++++++++++++++++++++++++++
 fs/generic_acl.c                          |    2 +-
 fs/gfs2/acl.c                             |    2 +-
 fs/hfsplus/options.c                      |    2 +-
 fs/hpfs/super.c                           |    2 +-
 fs/internal.h                             |    8 +-
 fs/jffs2/acl.c                            |    2 +-
 fs/jfs/acl.c                              |    2 +-
 fs/namei.c                                |   14 +--
 fs/namespace.c                            |   61 +----------
 fs/nfs/nfs3proc.c                         |    6 +-
 fs/nfs/nfs4proc.c                         |    2 +-
 fs/nfsd/nfssvc.c                          |    7 +-
 fs/ocfs2/acl.c                            |    2 +-
 fs/omfs/inode.c                           |    2 +-
 fs/open.c                                 |    1 +
 fs/proc/base.c                            |   53 +++------
 fs/proc/task_nommu.c                      |    3 +-
 fs/reiserfs/xattr_acl.c                   |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c               |    4 +-
 include/linux/fs.h                        |    2 +
 include/linux/fs_struct.h                 |    7 +-
 include/linux/mnt_namespace.h             |    2 +
 include/linux/nsproxy.h                   |    1 +
 include/linux/sched.h                     |    3 +-
 init/do_mounts.c                          |    1 +
 ipc/mqueue.c                              |    2 +-
 kernel/auditsc.c                          |    1 +
 kernel/exec_domain.c                      |   22 ----
 kernel/exit.c                             |   32 +-----
 kernel/fork.c                             |   63 +++++------
 kernel/sys.c                              |    1 +
 net/unix/af_unix.c                        |    2 +-
 security/tomoyo/realpath.c                |    1 +
 48 files changed, 337 insertions(+), 246 deletions(-)
 create mode 100644 fs/fs_struct.c

