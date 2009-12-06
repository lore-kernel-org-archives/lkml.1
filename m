Return-Path: <linux-kernel-owner+w=401wt.eu-S932378AbZLFH7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbZLFH7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 02:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932303AbZLFH7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 02:59:42 -0500
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:47870 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbZLFH7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 02:59:39 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: stewb@linux-foundation.org, "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC 0/5] pathconf(3) with _PC_LINK_MAX
Date: Sun,  6 Dec 2009 16:58:58 +0900
Message-Id: <1260086343-8406-1-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pathconf(_PC_LINK_MAX) cannot get the correct value, since linux
kernel doesn't provide such interface. And the current implementation in
GLibc issues statfs(2) first and then returns the predefined value
(EXT2_LINK_MAX, etc) based upoin the filesystem type. But GLibc doesn't
support all filesystem types. ie. when the target filesystem is unknown
to pathconf(3), it will return LINUX_LINK_MAX (127).
For GLibc, there is no way except implementing this poor method.

This patch makes statfs(2) return the correct value via struct
statfs.f_spare[0].

RFC:
- Can we use f_spare for this purpose?
- Does pathconf(_PC_LINK_MAX) distinguish a dir and a non-dir?
  If a filesystem sets different limit for a dir as a link count from a
  non-dir, then should the filesystem checks the type of the specified
  dentry->d_inode->i_mode and return the different value?
  This patch series doesn't distinguish them and return a single value.
- Here I tried supporting only ext[23], nfs and tmpfs. Since I can test
  them by myself. I left other FSs as it is, which means if FS doesn't
  support _PC_LINK_MAX by modifying its s_op->statfs(), the default
  value will be returned. The default value is taken from GLibc trying
  to keep the compatibility. But it may not be important.
- Some FS such as ms-dos based one which doesn't support hardlink, will
  return LINK_MAX_UNSUPPORTED which is defined as 1.
- Other FS such as tmpfs which doesn't check the link count in link(2),
  will return LINK_MAX_UNLIMITED which is defined as -1. This value
  doesn't mean an error. The negative return value of pathconf(3) is
  valid.

Even if linux kernel return a correct value via statfs(2) (or anything
else), users will not get the value at once since the support in libc is
necessary too.


J. R. Okajima (5):
  vfs, support pathconf(3) with _PC_LINK_MAX
  ext2, support pathconf(3) with _PC_LINK_MAX
  ext3, support pathconf(3) with _PC_LINK_MAX
  nfs, support pathconf(3) with _PC_LINK_MAX
  tmpfs, support pathconf(3) with _PC_LINK_MAX

 fs/compat.c               |    5 +++--
 fs/ext2/super.c           |    1 +
 fs/ext3/super.c           |    1 +
 fs/libfs.c                |    1 +
 fs/nfs/client.c           |   10 +++++++---
 fs/nfs/super.c            |    1 +
 fs/open.c                 |    9 +++++++--
 include/linux/nfs_fs_sb.h |    1 +
 include/linux/statfs.h    |    6 ++++++
 mm/shmem.c                |    1 +
 10 files changed, 29 insertions(+), 7 deletions(-)

