Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab0AOBvJ (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260Ab0AOBvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:51:06 -0500
Received: from mga14.intel.com ([143.182.124.37]:59358 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab0AOBte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:49:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="232971463"
Message-Id: <20100115014422.545809181@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Jan 2010 09:39:57 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, David Miller <davem@davemloft.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
        Roland Dreier <rdreier@cisco.com>, Jamie Lokier <jamie@shareable.org>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
CC: Nick Piggin <npiggin@suse.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: David Howells <dhowells@redhat.com>
CC: Jonathan Corbet <corbet@lwn.net>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 3/6] vfs: O_* bit numbers uniqueness check
References: <20100115013954.311049665@intel.com>
Content-Disposition: inline; filename=fcntl-bit-check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The O_* bit numbers are defined in 20+ arch/*, and can silently overlap.
Add a compile time check to ensure the uniqueness as suggested by David
Miller.

v4: use the nice hweight_long() (suggested by Jamie)
    split O_SYNC to (__O_SYNC | O_DSYNC) (suggested by Andreas)
    take away the FMODE_* and O_RANDOM bits
v3: change to BUILD_BUG_ON() (suggested by Roland)

CC: David Miller <davem@davemloft.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Christoph Hellwig <hch@infradead.org>
CC: Eric Paris <eparis@redhat.com>
CC: Roland Dreier <rdreier@cisco.com>
CC: Jamie Lokier <jamie@shareable.org>
CC: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fcntl.c                  |   14 ++++++++++++--
 include/asm-generic/fcntl.h |    2 ++
 2 files changed, 14 insertions(+), 2 deletions(-)

--- linux.orig/fs/fcntl.c	2010-01-09 11:02:57.000000000 +0800
+++ linux/fs/fcntl.c	2010-01-09 21:36:16.000000000 +0800
@@ -709,11 +709,21 @@ void kill_fasync(struct fasync_struct **
 }
 EXPORT_SYMBOL(kill_fasync);
 
-static int __init fasync_init(void)
+static int __init fcntl_init(void)
 {
+	/* please add new bits here to ensure allocation uniqueness */
+	BUILD_BUG_ON(17 != hweight_long(
+		O_RDONLY	| O_WRONLY	| O_RDWR	|
+		O_CREAT		| O_EXCL	| O_NOCTTY	|
+		O_TRUNC		| O_APPEND	| O_NONBLOCK	|
+		__O_SYNC	| O_DSYNC	| FASYNC	|
+		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	|
+		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC
+		));
+
 	fasync_cache = kmem_cache_create("fasync_cache",
 		sizeof(struct fasync_struct), 0, SLAB_PANIC, NULL);
 	return 0;
 }
 
-module_init(fasync_init)
+module_init(fcntl_init)
--- linux.orig/include/asm-generic/fcntl.h	2010-01-09 11:02:57.000000000 +0800
+++ linux/include/asm-generic/fcntl.h	2010-01-09 12:23:17.000000000 +0800
@@ -4,6 +4,8 @@
 #include <linux/types.h>
 
 /*
+ * When introducing new O_* bits, please check its uniqueness in fcntl_init().
+ *
  * FMODE_EXEC is 0x20
  * FMODE_NONOTIFY is 0x1000000
  * These cannot be used by userspace O_* until internal and external open


