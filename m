Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672Ab0AFGze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab0AFGze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 01:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293Ab0AFGzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 01:55:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:18725 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085Ab0AFGzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 01:55:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,227,1262592000"; 
   d="scan'208";a="584694002"
Date: Wed, 6 Jan 2010 14:55:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH] fs: O_* bit numbers uniqueness check
Message-ID: <20100106065526.GB11368@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The O_* bit numbers are defined in 20+ arch/*, and hence can silently
overlap. Add a boot time check to ensure the uniqueness as suggested
by David Miller.

CC: David Miller <davem@davemloft.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Christoph Hellwig <hch@infradead.org>
CC: Eric Paris <eparis@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fcntl.c                  |   14 ++++++++++++--
 include/asm-generic/fcntl.h |    2 ++
 2 files changed, 14 insertions(+), 2 deletions(-)

--- linux.orig/fs/fcntl.c	2010-01-06 14:41:26.000000000 +0800
+++ linux/fs/fcntl.c	2010-01-06 14:46:57.000000000 +0800
@@ -709,11 +709,21 @@ void kill_fasync(struct fasync_struct **
 }
 EXPORT_SYMBOL(kill_fasync);
 
-static int __init fasync_init(void)
+static int __init fcntl_init(void)
 {
+	/* please add new bits here to ensure allocation uniqueness */
+	BUG_ON(20 != hweight32(
+		O_RDONLY	| O_WRONLY	| O_RDWR	|
+		O_CREAT		| O_EXCL	| O_NOCTTY	|
+		O_TRUNC		| O_APPEND	| O_NONBLOCK	|
+		O_SYNC		| FASYNC	| O_DIRECT	|
+		O_LARGEFILE	| O_DIRECTORY	| O_NOFOLLOW	|
+		O_NOATIME	| O_CLOEXEC	| O_RANDOM	|
+		FMODE_EXEC	| FMODE_NONOTIFY));
+
 	fasync_cache = kmem_cache_create("fasync_cache",
 		sizeof(struct fasync_struct), 0, SLAB_PANIC, NULL);
 	return 0;
 }
 
-module_init(fasync_init)
+module_init(fcntl_init)
--- linux.orig/include/asm-generic/fcntl.h	2010-01-06 14:45:34.000000000 +0800
+++ linux/include/asm-generic/fcntl.h	2010-01-06 14:50:57.000000000 +0800
@@ -4,6 +4,8 @@
 #include <linux/types.h>
 
 /*
+ * When introducing new O_* bits, please check its uniqueness in fcntl_init().
+ *
  * FMODE_EXEC is 0x20
  * FMODE_NONOTIFY is 0x1000000
  * These cannot be used by userspace O_* until internal and external open
