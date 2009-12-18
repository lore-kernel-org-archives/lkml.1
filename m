Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbZLRCmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbZLRCmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 21:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZLRCmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 21:42:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbZLRCmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 21:42:07 -0500
Subject: [GIT PULL] notification - make audit use fsnotify and drop
 inotify.c
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 21:41:58 -0500
Message-Id: <1261104118.2868.25.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm going to be the first one to admit I'm not 100% comfortable
requesting this pull, but the window is going to (already did?) close
and I want to put it out there.  I've been waiting for the VFS merge
since I knew I had conflicts with Al which couldn't be resolved already
since the VFS tree didn't exist.

These have been in linux-next for about 2 full cycles.  They do 3 main
things.

1) Fix a couple inotify problems including some of the idr memory leak
stuff
2) convert audit to use fsnotify
3) drop the old in kernel inotify altogether thus shrinking struct
inode!

I'll do more heavyweight testing, but these pass light testing that I
could do since I rebased on top of the VFS tree.

---

The following changes since commit b8a7f3cd7e8212e5c572178ff3b5a514861036a5:
  Linus Torvalds (1):
        Merge branch 'master' of git://git.kernel.org/.../viro/vfs-2.6

are available in the git repository at:

  git://git.infradead.org/users/eparis/notify.git for-linus

Eric Paris (17):
      inotify: simplify the inotify idr handling
      Audit: clean up the audit_watch split
      audit: convert audit watches to use fsnotify instead of inotify
      audit: redo audit watch locking and refcnt in light of fsnotify
      audit: do not get and put just to free a watch
      fsnotify: duplicate fsnotify_mark_entry data between 2 marks
      fsnotify: allow addition of duplicate fsnotify marks
      audit: reimplement audit_trees using fsnotify rather than inotify
      Audit: audit watches depend on fsnotify
      Audit: split audit watch Kconfig
      Audit: audit watch init should not be before fsnotify init
      fsnotify: use fsnotify_create_event to allocate the q_overflow event
      inotify: use container_of instead of casting
      fsnotify: kzalloc fsnotify groups
      fsnotify: use kmem_cache_zalloc to simplify event initialization
      inotify: do not reuse watch descriptors
      inotify: remove inotify in kernel interface

 Documentation/feature-removal-schedule.txt |    8 -
 fs/inode.c                                 |    6 -
 fs/notify/dnotify/dnotify.c                |    2 +-
 fs/notify/group.c                          |    2 +-
 fs/notify/inode_mark.c                     |   18 +-
 fs/notify/inotify/Kconfig                  |   15 -
 fs/notify/inotify/Makefile                 |    1 -
 fs/notify/inotify/inotify.c                |  933 ----------------------------
 fs/notify/inotify/inotify_user.c           |  211 +++++--
 fs/notify/notification.c                   |   24 +-
 fs/open.c                                  |    1 +
 include/linux/fs.h                         |    5 -
 include/linux/fsnotify.h                   |   51 +--
 include/linux/fsnotify_backend.h           |   10 +-
 include/linux/inotify.h                    |  174 ------
 init/Kconfig                               |   10 +-
 kernel/Makefile                            |    5 +-
 kernel/audit.c                             |    1 -
 kernel/audit.h                             |   26 +-
 kernel/audit_tree.c                        |  223 ++++---
 kernel/audit_watch.c                       |  293 +++++----
 kernel/auditfilter.c                       |   39 +-
 kernel/auditsc.c                           |   10 +-
 23 files changed, 519 insertions(+), 1549 deletions(-)
 delete mode 100644 fs/notify/inotify/inotify.c

