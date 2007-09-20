Return-Path: <linux-kernel-owner+w=401wt.eu-S1751950AbXITTxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbXITTxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750727AbXITTww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:52:52 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45439 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbXITTwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:52:51 -0400
Subject: [PATCH 00/25] Read-only bind mounts
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 20 Sep 2007 12:52:49 -0700
Message-Id: <20070920195249.852667D5@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is against 2.6.23-rc6.  Compared to 2.6.23-rc6-mm1, there
are a few (trivial) merge conflicts with the audit git tree,
and one slightly more complicated one with ext2-reservations.patch.

Changes from last post:
- added several kerneldoc comments for exported functions
- broke out the 'mnt' variable patch 
- removed WARN_ON() in ioctl patch

The first four patches here are very simple cleanups, and can go
in ahead of the rest of the patches.

If you are reviewing this, the things that need the most review
are the last two patches that actually add the logic for
tracking mount write counts.

---

Why do we need r/o bind mounts?

This feature allows a read-only view into a read-write filesystem.
In the process of doing that, it also provides infrastructure for
keeping track of the number of writers to any given mount.

This has a number of uses.  It allows chroots to have parts of
filesystems writable.  It will be useful for containers in the future
because users may have root inside a container, but should not
be allowed to write to somefilesystems.  This also replaces 
patches that vserver has had out of the tree for several years.

It allows security enhancement by making sure that parts of
your filesystem read-only (such as when you don't trust your
FTP server), when you don't want to have entire new filesystems
mounted, or when you want atime selectively updated.
I've been using the following script to test that the feature is
working as desired.  It takes a directory and makes a regular
bind and a r/o bind mount of it.  It then performs some normal
filesystem operations on the three directories, including ones
that are expected to fail, like creating a file on the r/o
mount.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
