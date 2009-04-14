Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbZDNB6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbZDNB6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 21:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbZDNB4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 21:56:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:56160 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbZDNB4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 21:56:43 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu
Subject: [PATCHSET] CUSE: implement CUSE, take #3
Date: Tue, 14 Apr 2009 10:54:48 +0900
Message-Id: <1239674094-30894-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 01:55:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Miklos.

This is the third take of implement-CUSE patchset.  Sorry about the
huge delay.  :-)

Changes from the last take[L] are...

* Rather large FUSE update to make inode, superblock and mnt optional.

* CUSE no longer creates its superblock or mount.  It simply sets cdev
  file->private_data to fuse_file and operates on it.

* cdev lifetime handling fixed.  CUSE cdev now atomically looks up
  matching device (connection) like other cdevs do.

* CUSE init protocal updated.  An additional request CUSE_INIT_DONE is
  sent after successful creation of devices.  This is to allow
  userland server to synchronize init completion.

This patchset contains the following six patches.

  0001-FUSE-misc-cleanups.patch
  0002-FUSE-use-fuse-objects-as-the-main-objects-in-file-h.patch
  0003-FUSE-make-ff-fi-optional.patch
  0004-FUSE-update-fuse_conn_init-and-separate-out-fuse_.patch
  0005-FUSE-export-symbols-to-be-used-by-CUSE.patch
  0006-CUSE-implement-CUSE-Character-device-in-Userspace.patch

0001 is misc preparation.  0002 updates fuse file handling operations
such that it primarily operations on fuse_file instead of vfs objects.
This patch is rather huge but I couldn't think of a good meaningful
way to chop it down further.  As scary as it looks, it should have
zero functional difference and most changes are mechanical.

0003 makes fuse_file->fi (added by 0002) optional so that fuse_file
can be used separately.

0004-0005 prepares for CUSE implementation and 0006 does it.

I didn't replace the kthread init helper with req->end() callback for
two reasons.  Firstly, init involves issuing two commands - FUSE_INIT
and CUSE_INIT.  Chaning init sequence via req->end() would require
another split in the init sequence.  Secondly, the second command
would have to be issued from ->end(), which is just hairy.  I think
doing the latter part of initialization in kthread is better here.

This patchset is on top of the current linus#master[1] and available in the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git cuse

diffstat follows.

 fs/Kconfig            |   10 
 fs/fuse/Makefile      |    1 
 fs/fuse/cuse.c        |  675 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev.c         |    9 
 fs/fuse/dir.c         |   97 ++++---
 fs/fuse/file.c        |  613 +++++++++++++++++++++++----------------------
 fs/fuse/fuse_i.h      |  100 ++++++-
 fs/fuse/inode.c       |   54 ++--
 include/linux/cuse.h  |   49 +++
 include/linux/fuse.h  |    2 
 include/linux/magic.h |    5 
 11 files changed, 1237 insertions(+), 378 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/759831
[1] 80a04d3f2f94fb68b5df05e3ac6697130bc3467a
