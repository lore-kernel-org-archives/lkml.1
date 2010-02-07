Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab0BGDnx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 22:43:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:16528 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab0BGDnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 22:43:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,420,1262592000"; 
   d="scan'208";a="770770384"
Message-Id: <20100207034223.615803205@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 07 Feb 2010 11:28:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Al Viro <viro@ZenIV.linux.org.uk>, David Miller <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       Roland Dreier <rdreier@cisco.com>, Jamie Lokier <jamie@shareable.org>,
       Andreas Schwab <schwab@linux-m68k.org>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@amd64.org>
CC: Peter Zijlstra <peterz@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] vfs: O_* bit numbers uniqueness check
References: <20100207032805.769788305@intel.com>
Content-Disposition: inline; filename=fcntl-bit-check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The O_* bit numbers are defined in 20+ arch/*, and can silently overlap.
Add a compile time check to ensure the uniqueness as suggested by David
Miller.

v5: use Peter's HWEIGHT32()
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

--- linux.orig/fs/fcntl.c	2010-01-30 18:09:33.000000000 +0800
+++ linux/fs/fcntl.c	2010-02-07 11:17:36.000000000 +0800
@@ -741,11 +741,21 @@ void kill_fasync(struct fasync_struct **
 }
 EXPORT_SYMBOL(kill_fasync);
 
-static int __init fasync_init(void)
+static int __init fcntl_init(void)
 {
+	/* please add new bits here to ensure allocation uniqueness */
+	BUILD_BUG_ON(17 != HWEIGHT32(
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
--- linux.orig/include/asm-generic/fcntl.h	2010-02-07 11:17:04.000000000 +0800
+++ linux/include/asm-generic/fcntl.h	2010-02-07 11:17:06.000000000 +0800
@@ -4,6 +4,8 @@
 #include <linux/types.h>
 
 /*
+ * When introducing new O_* bits, please check its uniqueness in fcntl_init().
+ *
  * FMODE_EXEC is 0x20
  * FMODE_NONOTIFY is 0x1000000
  * These cannot be used by userspace O_* until internal and external open


