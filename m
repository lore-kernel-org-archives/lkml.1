Return-Path: <linux-kernel-owner+w=401wt.eu-S964912AbXGLARt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964912AbXGLARt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933665AbXGLARQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:17:16 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:33535 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934558AbXGLARN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:17:13 -0400
Subject: [PATCH 00/23] Mount writer count API (read-only bind mounts prep)
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Wed, 11 Jul 2007 17:17:10 -0700
Message-Id: <20070712001710.654CD9ED@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The most contentious part of the r/o bind mount patches is
actually implementing the count tracking.  It has NUMA and
SMP implications, and is going to need to have a whole
discussion on that one patch.

These patches, on the other hand, simply introduce a new
API: mnt_want_write() and mnt_drop_write().  They do not
functionally change the kernel, just alter the way in
which we check filesystems for our ability to write to
them.

These functions should be used in place of IS_RDONLY(inode)
as they explicitly spell out when a mount is expected to
_stay_ r/w instead of simply checking at a single point
in time.

It should take a very small number (like 3) of small
patches to actually implement read-only bind mounts on
top of this new API.

These apply to current -git (as of July 11th, 2007).

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
