Return-Path: <linux-kernel-owner+w=401wt.eu-S1761193AbXKAXKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761193AbXKAXKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbXKAXIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:08:42 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58019 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401AbXKAXIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:08:41 -0400
Subject: [PATCH 00/27] Read-only bind mounts (-mm resend)
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 01 Nov 2007 16:08:26 -0700
Message-Id: <20071101230826.9A4F6E00@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is against 2.6.24-rc1 + recent git.

I've integrated all of the fixes from mm, and included cleanups
in a different order.  This also includes some extra fput-time
checking to ensure that we have balanced mount writer counts.

These replace the patches in -mm mostly because the new fixes
require some cleanups that are functionally independent from
the r/o bind mount code itself.  These fixes precent the rest
of the set and require some by hand merging.

If you're going to review one and only one patch, 17/27 (the
one for "opend" files) is the most critical.

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
your filesystem are read-only (such as when you don't trust your
FTP server), when you don't want to have entire new filesystems
mounted, or when you want atime selectively updated.
I've been using this script:

	http://sr71.net/~dave/linux/robind-test.sh

to test that the feature is working as desired.  It takes a
directory and makes a regular bind and a r/o bind mount of it.
It then performs some normal filesystem operations on the
three directories, including ones that are expected to fail,
like creating a file on the r/o mount.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
