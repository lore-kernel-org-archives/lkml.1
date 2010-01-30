Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484Ab0A3Jxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab0A3Jxq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 04:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454Ab0A3Jxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 04:53:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:44571 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab0A3Jxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 04:53:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,373,1262592000"; 
   d="scan'208";a="591720105"
Message-Id: <20100130094957.835543016@intel.com>
User-Agent: quilt/0.48-1
Date: Sat, 30 Jan 2010 17:45:18 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       Roland Dreier <rdreier@cisco.com>, Jamie Lokier <jamie@shareable.org>,
       Andreas Schwab <schwab@linux-m68k.org>
cc: Al Viro <viro@zeniv.linux.org.uk>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 3/5] vfs: O_* bit numbers uniqueness check
References: <20100130094515.475881280@intel.com>
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

--- linux-mm.orig/fs/fcntl.c	2010-01-30 17:14:13.000000000 +0800
+++ linux-mm/fs/fcntl.c	2010-01-30 17:41:36.000000000 +0800
@@ -741,11 +741,21 @@ void kill_fasync(struct fasync_struct **
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
--- linux-mm.orig/include/asm-generic/fcntl.h	2010-01-30 17:40:48.000000000 +0800
+++ linux-mm/include/asm-generic/fcntl.h	2010-01-30 17:41:36.000000000 +0800
@@ -4,6 +4,8 @@
 #include <linux/types.h>
 
 /*
+ * When introducing new O_* bits, please check its uniqueness in fcntl_init().
+ *
  * FMODE_EXEC is 0x20
  * FMODE_NONOTIFY is 0x1000000
  * These cannot be used by userspace O_* until internal and external open


