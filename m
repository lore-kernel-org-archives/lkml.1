Return-Path: <linux-kernel-owner+w=401wt.eu-S1759374AbYKTPD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374AbYKTPD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757992AbYKTOxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:53:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:58692 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757984AbYKTOxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:53:19 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, npiggin@suse.de
Subject: [PATCHSET] FUSE: implement direct mmap
Date: Thu, 20 Nov 2008 23:52:14 +0900
Message-Id: <1227192740-10532-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 20 Nov 2008 14:52:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

This is the first take of fuse-implement-direct-mmap patchset.  This
patchset implements direct mmap support for FUSE (and CUSE).  Each
direct mmap area is backed by anonymous mapping (shmem_file) and the
FUSE server can decide how they are shared.

mmap request is handled in two steps.  MMAP first queries the server
whether it wants to share the mapping with an existing one or create a
new one, and if so, with which flags.  MMAP_COMMIT notifies the server
the result of mmap and if successful the fd the server can use to
access the mmap region.

This patchset contains the following six patches.

 0001-mmap-don-t-assume-f_op-mmap-doesn-t-change-vma.patch
 0002-fdtable-export-alloc_fd.patch
 0003-FUSE-don-t-let-fuse_req-end-put-the-base-referen.patch
 0004-FUSE-make-request_wait_answer-wait-for-end-co.patch
 0005-FUSE-implement-fuse_req-prep.patch
 0006-FUSE-implement-direct-mmap.patch

0001-0002 update mm and fdtable for following FUSE changes.  0003-0005
update fuse_req->end() handling and add ->prep().  0006 implements
direct mmap.

Direct mmap implementation jumps through a few hoops to override
vma->vm_file with shmem_file.  It would be great if there's a cleaner
way to achieve this.  For details, please take a look at 0006.

Nick, can you please verify that 0001 doesn't break anything and
replacing vma->vm_file in ->mmap() is okay?

Andrew, would 0002 be okay?

Thanks.

This patchset is on top of

  master (ee2f6cc7f9ea2542ad46070ed62ba7aa04d08871)
+ [1] poll-allow-f_op_poll-to-sleep-take-2
+ [2] add-cdev_release-and-convert-cdev_alloc-to-use-it
+ [3] extend-FUSE patchset, take #2
+ [4] implement-CUSE patchset, take #2

This patchset is also available in the following git tree.

 http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=fuse-mmap
 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git fuse-mmap

and contains the following changes.

 fs/file.c            |    1 
 fs/fuse/cuse.c       |    6 
 fs/fuse/dev.c        |   75 ++++++---
 fs/fuse/file.c       |  412 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/fuse/fuse_i.h     |   19 ++
 fs/fuse/inode.c      |    1 
 include/linux/fuse.h |   47 +++++
 mm/mmap.c            |    1 
 8 files changed, 533 insertions(+), 29 deletions(-)

--
tejun

[1] http://lkml.org/lkml/2008/11/20/161
[2] http://article.gmane.org/gmane.linux.kernel/727133
[3] http://lkml.org/lkml/2008/11/20/171
[4] http://lkml.org/lkml/2008/11/20/179
