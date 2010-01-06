Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518Ab0AFHS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab0AFHS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 02:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672Ab0AFHSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 02:18:24 -0500
Received: from mga03.intel.com ([143.182.124.21]:10179 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684Ab0AFHSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 02:18:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="229695811"
Date: Wed, 6 Jan 2010 15:18:17 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v2] fs: O_* bit numbers uniqueness check
Message-ID: <20100106071817.GA24428@localhost>
References: <20100106065526.GB11368@localhost> <adahbqzvhgn.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adahbqzvhgn.fsf@roland-alpha.cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 03:08:08PM +0800, Roland Dreier wrote:
> 
>  > +	/* please add new bits here to ensure allocation uniqueness */
>  > +	BUG_ON(20 != hweight32(
>  > +		O_RDONLY	| O_WRONLY	| O_RDWR	|
> 
> I wonder if there's a way to make this BUILD_BUG_ON(), so the problem is
> caught at compile time (a change like adding an O_ flag is often compile
> tested only for obscure archs).  One could create a compile-time
> macro-ized version of hweight32() and use that, I guess, although I'm
> not sure it's worth the ugliness.

Yeah, I chose the boot time check because of hweight32()..

> Failing that maybe this should be WARN_ON()?  I'd be annoyed if my arch
> wouldn't boot because some strange new O_ flag happened to collide.

Good suggestion! Here is the updated patch.

Andrew, this patch relies on the newly introduced O_RANDOM and Eric's
FMODE_NONOTIFY. 

Thanks,
Fengguang
---
fs: O_* bit numbers uniqueness check

The O_* bit numbers are defined in 20+ arch/*, and hence can silently
overlap. Add a boot time check to ensure the uniqueness as suggested
by David Miller.

v2: change to WARN_ON() as suggested by Roland

CC: David Miller <davem@davemloft.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Christoph Hellwig <hch@infradead.org>
CC: Eric Paris <eparis@redhat.com>
CC: Roland Dreier <rdreier@cisco.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fcntl.c                  |   14 ++++++++++++--
 include/asm-generic/fcntl.h |    2 ++
 2 files changed, 14 insertions(+), 2 deletions(-)

--- linux.orig/fs/fcntl.c	2010-01-06 14:41:26.000000000 +0800
+++ linux/fs/fcntl.c	2010-01-06 15:15:11.000000000 +0800
@@ -709,11 +709,21 @@ void kill_fasync(struct fasync_struct **
 }
 EXPORT_SYMBOL(kill_fasync);
 
-static int __init fasync_init(void)
+static int __init fcntl_init(void)
 {
+	/* please add new bits here to ensure allocation uniqueness */
+	WARN_ON(20 != hweight32(
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
