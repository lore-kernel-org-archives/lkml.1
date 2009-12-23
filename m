Return-Path: <linux-kernel-owner+w=401wt.eu-S1751942AbZLWFbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbZLWFbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 00:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbZLWFba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 00:31:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbZLWFb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 00:31:29 -0500
Subject: Re: [GIT PULL] notification - make audit use fsnotify and drop
 inotify.c
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1261104118.2868.25.camel@localhost>
References: <1261104118.2868.25.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Dec 2009 00:31:19 -0500
Message-ID: <1261546279.6283.38.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 21:42 -0500, Eric Paris wrote:
> I'm going to be the first one to admit I'm not 100% comfortable
> requesting this pull, but the window is going to (already did?) close
> and I want to put it out there.  I've been waiting for the VFS merge
> since I knew I had conflicts with Al which couldn't be resolved already
> since the VFS tree didn't exist.
> 
> These have been in linux-next for about 2 full cycles.  They do 3 main
> things.
> 
> 1) Fix a couple inotify problems including some of the idr memory leak
> stuff
> 2) convert audit to use fsnotify
> 3) drop the old in kernel inotify altogether thus shrinking struct
> inode!
> 
> I'll do more heavyweight testing, but these pass light testing that I
> could do since I rebased on top of the VFS tree.

I'm back with another/the same pull request.  Once again I had to rework
some things due to patches from Al which appeared in your tree.  The
series has (basically) been in linux-next for the last week and works in
my testing.  My "new and improved" inotify torture test does show
similar problems to those still occasionally reported because of a warn
on inotify memory leak/race issues in your tree and doesn't break with
these fixes.  These fixes also greatly limit (using WARN_ONCE instead of
WARN) the amount of dmesg spam people will get if I still don't have it
right.

The following changes since commit c9f937e4a3f4ebf9924ec21d80632e5eb61d949c:
  Linus Torvalds (1):
        Merge branch 'upstream-linus' of git://git.kernel.org/.../jgarzik/libata-dev

are available in the git repository at:

  git://git.infradead.org/users/eparis/notify.git for-linus

Eric Paris (18):
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
      inotify: do not spam console without limit

 Documentation/feature-removal-schedule.txt |    8 -
 fs/inode.c                                 |    6 -
 fs/notify/dnotify/dnotify.c                |    2 +-
 fs/notify/group.c                          |    2 +-
 fs/notify/inode_mark.c                     |   18 +-
 fs/notify/inotify/Kconfig                  |   15 -
 fs/notify/inotify/Makefile                 |    1 -
 fs/notify/inotify/inotify.c                |  933 ----------------------------
 fs/notify/inotify/inotify_fsnotify.c       |    2 +-
 fs/notify/inotify/inotify_user.c           |  210 +++++--
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
 kernel/audit_tree.c                        |  233 ++++---
 kernel/audit_watch.c                       |  293 +++++----
 kernel/auditfilter.c                       |   39 +-
 kernel/auditsc.c                           |   10 +-
 24 files changed, 523 insertions(+), 1556 deletions(-)
 delete mode 100644 fs/notify/inotify/inotify.c

