Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbYLLVvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbYLLVvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbYLLVvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:51:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55934 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873AbYLLVvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:51:35 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [RFC PATCH -v4 00/14] fsnotify, dnotify, and inotify
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, viro@ZenIV.linux.org.uk, hch@infradead.org,
       zbr@ioremap.net, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Date: Fri, 12 Dec 2008 16:51:14 -0500
Message-ID: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements a new generic in kernel filesystem
notification system, fsnotify.  On top of fsnotify I reimplement dnotify and
inotify.  I have not finished with the change from inotify although I think
inotify_user should be completed.  In kernel inotify users (aka audit) still
(until I get positive feedback) relay on the old inotify backend.  This can be
'easily' fixed.

All of this is in preperation for fanotify and using fanotify as an on access
file scanner.   So you better know it's coming.

Why is this useful?  Because I actually shrank the struct inode.  That's
right, my code is smaller and faster.  Eat that.

struct inode went from:
        unsigned long           i_dnotify_mask; /* Directory notify events */
        struct dnotify_struct   *i_dnotify; /* for directory notifications */
        struct list_head        inotify_watches; /* watches on this inode */
        struct mutex            inotify_mutex;  /* protects the watches list */

to:
        __u64                   i_fsnotify_mask; /* all events this inode cares about */
        struct list_head        i_fsnotify_mark_entries; /* fsnotify mark entries */

This is just an RFC as I haven't tested it heavily I might still be able to 
split patches.  I think there are some problem at the moment trying to build
fsnotify out.  I need to send patch 3 and 4 seperately.  Actually I think it's
perfectly reasonable to take patches 1-4 as is right now.

if you ever want to see more up2date patches check out:
http://people.redhat.com/~eparis/fsnotify

---

Eric Paris (14):
      shit on top for debugging
      inotify: reimplement inotify using fsnotify
      fsnotify: add correlations between events
      fsnotify: include pathnames with entries when possible
      fsnotify: generic notification queue and waitq
      dnotify: reimplement dnotify using fsnotify
      fsnotify: parent event notification
      fsnotify: add in inode fsnotify markings
      fsnotify: add group priorities
      fsnotify: unified filesystem notification backend
      fsnotify: use the new open-exec hook for inotify and dnotify
      fsnotify: sys_execve and sys_uselib do not call into fsnotify
      fsnotify: pass a file instead of an inode to open, read, and write
      filesystem notification: create fs/notify to contain all fs notification


 fs/Kconfig                           |   39 -
 fs/Makefile                          |    5 
 fs/compat.c                          |    5 
 fs/dnotify.c                         |  194 -------
 fs/exec.c                            |    5 
 fs/fcntl.c                           |    4 
 fs/inode.c                           |    7 
 fs/inotify.c                         |  913 ----------------------------------
 fs/inotify_user.c                    |  778 -----------------------------
 fs/nfsd/vfs.c                        |    4 
 fs/notify/Kconfig                    |   14 +
 fs/notify/Makefile                   |    4 
 fs/notify/dnotify/Kconfig            |   11 
 fs/notify/dnotify/Makefile           |    1 
 fs/notify/dnotify/dnotify.c          |  350 +++++++++++++
 fs/notify/fsnotify.c                 |   92 +++
 fs/notify/fsnotify.h                 |  115 ++++
 fs/notify/group.c                    |  222 ++++++++
 fs/notify/inode_mark.c               |  279 ++++++++++
 fs/notify/inotify/Kconfig            |   31 +
 fs/notify/inotify/Makefile           |    2 
 fs/notify/inotify/inotify.c          |  913 ++++++++++++++++++++++++++++++++++
 fs/notify/inotify/inotify.h          |  117 ++++
 fs/notify/inotify/inotify_fsnotify.c |  190 +++++++
 fs/notify/inotify/inotify_kernel.c   |  299 +++++++++++
 fs/notify/inotify/inotify_user.c     |  502 +++++++++++++++++++
 fs/notify/notification.c             |  279 ++++++++++
 fs/open.c                            |    2 
 fs/read_write.c                      |    8 
 include/linux/dcache.h               |    3 
 include/linux/dnotify.h              |   29 -
 include/linux/fs.h                   |    6 
 include/linux/fsnotify.h             |  271 ++++++++--
 include/linux/fsnotify_backend.h     |  152 ++++++
 include/linux/inotify.h              |    1 
 35 files changed, 3818 insertions(+), 2029 deletions(-)
 delete mode 100644 fs/dnotify.c
 delete mode 100644 fs/inotify.c
 delete mode 100644 fs/inotify_user.c
 create mode 100644 fs/notify/Kconfig
 create mode 100644 fs/notify/Makefile
 create mode 100644 fs/notify/dnotify/Kconfig
 create mode 100644 fs/notify/dnotify/Makefile
 create mode 100644 fs/notify/dnotify/dnotify.c
 create mode 100644 fs/notify/fsnotify.c
 create mode 100644 fs/notify/fsnotify.h
 create mode 100644 fs/notify/group.c
 create mode 100644 fs/notify/inode_mark.c
 create mode 100644 fs/notify/inotify/Kconfig
 create mode 100644 fs/notify/inotify/Makefile
 create mode 100644 fs/notify/inotify/inotify.c
 create mode 100644 fs/notify/inotify/inotify.h
 create mode 100644 fs/notify/inotify/inotify_fsnotify.c
 create mode 100644 fs/notify/inotify/inotify_kernel.c
 create mode 100644 fs/notify/inotify/inotify_user.c
 create mode 100644 fs/notify/notification.c
 create mode 100644 include/linux/fsnotify_backend.h
