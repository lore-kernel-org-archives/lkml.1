Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab0BJJ3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 04:29:30 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:21132 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab0BJJ3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 04:29:18 -0500
From: Joel Becker <joel.becker@oracle.com>
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, mfasheh@suse.com
Subject: [0/11] ocfs2_dlmfs improvements v2
Date: Wed, 10 Feb 2010 01:27:43 -0800
Message-Id: <1265794074-19539-1-git-send-email-joel.becker@oracle.com>
X-Mailer: git-send-email 1.5.6.5
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B727C69.00A9:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v1:
- Ignore truncation of dlmfs files.  The LVB is a constant size.
- Check the LVB for validity before copying it to userspace.  LVBs can
  become invalid during lock recovery.
- This has now been tested to pass lvb_torture on two nodes with fsdlm

ocfs2 ships with its own cluster stack, o2cb.  The dlm portion, o2dlm,
is accessible to userspace via a custom filesystem, ocfs2_dlmfs.  Files
in this filesytem represent cluster lock resources.  Open the file, and
you take the lock.  The libo2dlm library wraps this filesystem,
providing a very simplified cluster locking API to userspace programs.

One of the things left out of the simplified interface is the ability to
learn that other nodes want a lock.  Notification that another node
wants the lock is called a "blocking asynchronous system trap", or
"bast".  Kernel users of o2dlm can register basts as they please, but
programs using libo2dlm and ocfs2_dlmfs cannot.  Thus, they must not
hold a lock forever; other nodes will never get the lock.  

The first improvement in this series adds poll(2) support to
ocfs2_dlmfs.  POLLIN on an open ocfs2_dlmfs flie signals a bast.  Now
user programs can hold a lock until they are notified to release it.

Another limitation of ocfs2_dlmfs is its reliance on o2dlm and thus the
entire o2cb cluster stack.  The ocfs2 filesystem has a glue layer,
called "stackglue", that allows it to switch between o2cb+o2dlm and the
userspace cluster stacks that work with fs/dlm.  This means userspace
programs for ocfs2 have to know about libo2dlm when o2dlm is employed
and libdlm when fs/dlm is employed.

The second improvement is to make ocfs2_dlmfs use stackglue.  Instead of
directly calling o2dlm APIs, it uses stackglue to remain agnostic of the
cluster stack.  Now a system using a userspace cluster stack and fs/dlm
can mount ocfs2_dlmfs and use libo2dlm.  This benefits everyone.

Joel

[Pull]
git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git dlmfs-stackglue
[View]
http://git.kernel.org/?p=linux/kernel/git/jlbec/ocfs2.git;a=shortlog;h=refs/heads/dlmfs-stackglue

 fs/ocfs2/Makefile                  |    1 +
 fs/ocfs2/dlm/Makefile              |    3 +-
 fs/ocfs2/dlmfs/Makefile            |    5 +
 fs/ocfs2/{dlm => dlmfs}/dlmfs.c    |  127 +++++++++++++-----
 fs/ocfs2/{dlm => dlmfs}/dlmfsver.c |    0
 fs/ocfs2/{dlm => dlmfs}/dlmfsver.h |    0
 fs/ocfs2/{dlm => dlmfs}/userdlm.c  |  266 ++++++++++++++++++------------------
 fs/ocfs2/{dlm => dlmfs}/userdlm.h  |   16 +-
 fs/ocfs2/dlmglue.c                 |  198 +++++++++++++--------------
 fs/ocfs2/ocfs2.h                   |    2 +-
 fs/ocfs2/ocfs2_lockingver.h        |    2 +
 fs/ocfs2/stack_o2cb.c              |   37 +++---
 fs/ocfs2/stack_user.c              |   49 +++----
 fs/ocfs2/stackglue.c               |   98 +++++++++-----
 fs/ocfs2/stackglue.h               |   95 ++++++++------
 15 files changed, 502 insertions(+), 397 deletions(-)



