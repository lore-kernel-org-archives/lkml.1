Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab0CBWLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 17:11:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab0CBWLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 17:11:37 -0500
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Valerie Aurora <vaurora@redhat.com>
Subject: [RFC PATCH 0/6] Union mount core rewrite v1
Date: Tue,  2 Mar 2010 14:11:23 -0800
Message-Id: <1267567889-4637-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a major rewrite of parts of union mounts, in particular the
pathname lookup code.  For more info about union mounts, see:

http://valerieaurora.org/union/

The previous code had two important problems fixed in this series:

- On file open, is_unionized() grabs vfsmount lock and walks up the
  mount tree even for non-union mounts.

- Pathname lookup required three cut-n-pasted versions of two complex
  functions, one for each of cached/real/"hashed" lookups.

This rewrite reduces the additional cost of a non-union lookup in a
CONFIG_UNION_MOUNT kernel to either 1 or 2 mount flag tests (but adds
the requirement that file systems be unioned only at their root
directories).  This rewrite implements lookup with one lookup_union()
function for all types of lookups.

This posted patch series includes only the union lookup, mount, and
readdir patches and not the relatively uncontroversial whiteout and
fallthru code.  Rewrite of the in-kernel file copyup is next on my
todo list.

The entire patch set is against Viro's for-next branch, and available
at:

git://git.kernel.org/pub/scm/linux/kernel/git/val/linux-2.6.git

Branch no_copyup.  Please review!  Thanks,

-VAL

Jan Blunck (3):
  union-mount: Introduce union_mount structure and basic operations
  union-mount: Drive the union cache via dcache
  union-mount: Call do_whiteout() on unlink and rmdir in unions

Valerie Aurora (3):
  union-mount: Implement union lookup
  union-mount: Support for mounting union mount file systems
  union-mount: Copy up directory entries on first readdir()

 fs/Kconfig             |   13 +
 fs/Makefile            |    1 +
 fs/dcache.c            |   17 ++
 fs/namei.c             |  199 +++++++++++++++-
 fs/namespace.c         |  123 ++++++++++-
 fs/readdir.c           |    9 +
 fs/union.c             |  629 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dcache.h |   28 +++
 include/linux/mount.h  |    3 +
 include/linux/union.h  |   74 ++++++
 10 files changed, 1094 insertions(+), 2 deletions(-)
 create mode 100644 fs/union.c
 create mode 100644 include/linux/union.h

