Return-Path: <linux-kernel-owner+w=401wt.eu-S1751986AbYKLQKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbYKLQKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbYKLQKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:10:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47045 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbYKLQKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:10:45 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH =-v3 00/21] fanotify: novel file access notification and
	permission system
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Date: Wed, 12 Nov 2008 11:10:26 -0500
Message-ID: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the following is a file notification and access system intended to allow
a variety of userspace programs to get information about filesystem
events no matter where or how they happen on a system and use that in
conjunction with the actual on disk data related to that event to
provide additional services such as file change indexing or content
based antivirus scanning.  Minor changes are almost certainly possible
to make this notification and access interface usable for HSMs.  fscking
all notify is generally refered to as fanotify, or for the weak of heart
you can call it file access notify system.  The ideas behind this
code are based on talpa the GPL antivirus interface originally written
by Sophos and on the feedback from lkml and malware-list.  This is
however a complete rewrite from scratch.

The last patch set addressed every complaint/critisism from lists.  This
set adds a couple new features, some documentation, and a couple fixes to
the networking headers to support bi-arch machines.

**fanotify-executive-summary**

fanotify has a number of event types and only sends events for S_ISREG()
files.  These events incluse open, read, write, and permissions checking
for open and read.  The permissions checking events require that the
listener return some sort of allow/deny/more_time response as the
original process blocks until it gets an event (or times out)
listeners may register a group which will get notifications about
any combination of these events, it will be up to the listener to
determine what events they are interested in hearing or mediating access
decisions for.

groups are a construct in which userspace indicates what priority (only
really used for permission type events) and what type of events its
listeners want to hear.  A single group may have unlimited listeners but
each event will only go to ONE listener.  Two groups may register for
the same type of events and one listener in EACH group will get a copy
of the event.

The user interface for fanotify is all through sockopt calls.  Userspace
pulls events from the kernel using getsockopt and sends responses to the
kernel using setsockopt.  These are the only socket operations defined
for PF_FANOTIFY sockets.

---

Eric Paris (21):
      fanotify: add Documentation
      fanotify: allow fastpath entries to survive inode modification
      fanotify: evict misbehaving clients
      fanotify: all userspace to set timeouts
      fanotify: add option to clear all fastpaths
      fanotify: send file f_flags along with notifications
      fanotify: send tgid with notification messages
      fanotify: send pid with fanotify notification events
      fanotify: ability for userspace to delay responses
      fanotify: user interface for access decisions
      fanotify: give a special access permission check
      fanotify: blocking and access granting
      fanotify: add group priorities
      fanotify: add a userspace interface for fastpaths
      fanotify: fastpath to ignore certain in core inodes
      fanotify: add a userspace interface for fanotify notifications
      fanotify: make use of the new fsnotify_open_exec calls
      fsnotify: sys_execve and sys_uselib do not call into fsnotify
      fanotify: fscking all notify, system wide file access notification
      fsnotify: pass a file instead of an inode to open, read, and write
      filesystem notification: create fs/notify to contain all fs notification


 Documentation/filesystems/fanotify/fanotify.txt    |  214 ++++++
 .../filesystems/fanotify/fanotify_tester.c         |  255 +++++++
 fs/Kconfig                                         |   39 -
 fs/Makefile                                        |    5 
 fs/aio.c                                           |    7 
 fs/compat.c                                        |    5 
 fs/dnotify.c                                       |  194 -----
 fs/exec.c                                          |   15 
 fs/inode.c                                         |    6 
 fs/inotify.c                                       |  773 --------------------
 fs/inotify_user.c                                  |  778 --------------------
 fs/nfsd/vfs.c                                      |    4 
 fs/notify/Kconfig                                  |   52 +
 fs/notify/Makefile                                 |    6 
 fs/notify/access.c                                 |  222 ++++++
 fs/notify/dnotify.c                                |  194 +++++
 fs/notify/fanotify.c                               |  152 ++++
 fs/notify/fanotify.h                               |  112 +++
 fs/notify/fastpath.c                               |  264 +++++++
 fs/notify/group.c                                  |  163 ++++
 fs/notify/inotify.c                                |  773 ++++++++++++++++++++
 fs/notify/inotify_user.c                           |  778 ++++++++++++++++++++
 fs/notify/notification.c                           |  277 +++++++
 fs/open.c                                          |    7 
 fs/read_write.c                                    |   14 
 include/linux/Kbuild                               |    1 
 include/linux/fanotify.h                           |  197 +++++
 include/linux/fs.h                                 |    5 
 include/linux/fsnotify.h                           |   39 +
 include/linux/sched.h                              |    1 
 include/linux/socket.h                             |    5 
 mm/mmap.c                                          |    7 
 mm/mprotect.c                                      |    6 
 mm/nommu.c                                         |    7 
 net/Makefile                                       |    1 
 net/core/sock.c                                    |    6 
 net/fanotify/Makefile                              |    5 
 net/fanotify/af_fanotify.c                         |  295 ++++++++
 net/fanotify/af_fanotify.h                         |   20 +
 39 files changed, 4096 insertions(+), 1808 deletions(-)
 create mode 100644 Documentation/filesystems/fanotify/fanotify.txt
 create mode 100644 Documentation/filesystems/fanotify/fanotify_tester.c
 delete mode 100644 fs/dnotify.c
 delete mode 100644 fs/inotify.c
 delete mode 100644 fs/inotify_user.c
 create mode 100644 fs/notify/Kconfig
 create mode 100644 fs/notify/Makefile
 create mode 100644 fs/notify/access.c
 create mode 100644 fs/notify/dnotify.c
 create mode 100644 fs/notify/fanotify.c
 create mode 100644 fs/notify/fanotify.h
 create mode 100644 fs/notify/fastpath.c
 create mode 100644 fs/notify/group.c
 create mode 100644 fs/notify/inotify.c
 create mode 100644 fs/notify/inotify_user.c
 create mode 100644 fs/notify/notification.c
 create mode 100644 include/linux/fanotify.h
 create mode 100644 net/fanotify/Makefile
 create mode 100644 net/fanotify/af_fanotify.c
 create mode 100644 net/fanotify/af_fanotify.h

-- 
Signature
