Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbYKYRYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbYKYRYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 12:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYKYRWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 12:22:01 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53954 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773AbYKYRWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 12:22:00 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v3 0/8] file notification: fsnotify a unified file
	notification backend
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, hch@infradead.org,
       a.p.zijlstra@chello.nl
Date: Tue, 25 Nov 2008 12:20:51 -0500
Message-ID: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements fsnotify a filesystem notification backend which
should be the basis for dnotify, inotify, and eventually fanotify.

This series only reimplements dnotify using the new fsnotify backend.  If
accepted I will do the work to port inotify as well.  Currently struct inode
goes from:

#ifdef CONFIG_DNOTIFY
       unsigned long           i_dnotify_mask; /* Directory notify events */
       struct dnotify_struct   *i_dnotify; /* for directory notifications */
#endif

to:
#ifdef CONFIG_FSNOTIFY
       unsigned long           i_fsnotify_mask; /* all events this inode cares about */
       struct list_head        i_fsnotify_mark_entries; /* fsnotify mark entries */
       spinlock_t              i_fsnotify_lock; /* protect the entries list */
#endif

so the inode still grows, but the inotify fields will be dropped as well
resulting in a smaller struct inode.  These are all the fields fanotify will
want as well.

rwlocks have been completely dropped in favor of even smaller critical section
spinlocks.  i_lock is no longer used to protect dnotify information and
instead the more specific i_fsnotify_lock is used.
---

Eric Paris (8):
      dnotify: reimplement dnotify using fsnotify
      fsnotify: add in inode fsnotify markings
      fsnotify: add group priorities
      fsnotify: unified filesystem notification backend
      fsnotify: use the new open-exec hook for inotify and dnotify
      fsnotify: sys_execve and sys_uselib do not call into fsnotify
      fsnotify: pass a file instead of an inode to open, read, and write
      filesystem notification: create fs/notify to contain all fs notification


 fs/Kconfig                       |   39 --
 fs/Makefile                      |    5 
 fs/compat.c                      |    5 
 fs/dnotify.c                     |  194 --------
 fs/exec.c                        |    5 
 fs/inode.c                       |    7 
 fs/inotify.c                     |  911 --------------------------------------
 fs/inotify_user.c                |  778 --------------------------------
 fs/nfsd/vfs.c                    |    4 
 fs/notify/Kconfig                |   14 +
 fs/notify/Makefile               |    4 
 fs/notify/dnotify/Kconfig        |   11 
 fs/notify/dnotify/Makefile       |    1 
 fs/notify/dnotify/dnotify.c      |  400 +++++++++++++++++
 fs/notify/fsnotify.c             |  104 ++++
 fs/notify/fsnotify.h             |   99 ++++
 fs/notify/group.c                |  150 ++++++
 fs/notify/inode_mark.c           |  226 +++++++++
 fs/notify/inotify/Kconfig        |   27 +
 fs/notify/inotify/Makefile       |    2 
 fs/notify/inotify/inotify.c      |  911 ++++++++++++++++++++++++++++++++++++++
 fs/notify/inotify/inotify_user.c |  778 ++++++++++++++++++++++++++++++++
 fs/notify/notification.c         |  188 ++++++++
 fs/open.c                        |    2 
 fs/read_write.c                  |    8 
 include/linux/dnotify.h          |   21 -
 include/linux/fs.h               |    7 
 include/linux/fsnotify.h         |   73 ++-
 include/linux/fsnotify_backend.h |  103 ++++
 29 files changed, 3100 insertions(+), 1977 deletions(-)
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
 create mode 100644 fs/notify/inotify/inotify_user.c
 create mode 100644 fs/notify/notification.c
 create mode 100644 include/linux/fsnotify_backend.h
