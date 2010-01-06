Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857Ab0AFHmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab0AFHmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 02:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656Ab0AFHmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 02:42:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:31828 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab0AFHmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 02:42:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,225,1262592000"; 
   d="scan'208";a="528861909"
Date: Wed, 6 Jan 2010 15:42:06 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] fs: O_* bit numbers uniqueness check
Message-ID: <20100106074206.GA25668@localhost>
References: <20100106065526.GB11368@localhost> <adahbqzvhgn.fsf@roland-alpha.cisco.com> <20100106071817.GA24428@localhost> <adad41nvgfc.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adad41nvgfc.fsf@roland-alpha.cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 03:30:31PM +0800, Roland Dreier wrote:
> 
>  > Yeah, I chose the boot time check because of hweight32()..
> 
> One could do something like
> 
> #define HWEIGHT32(x) (!!((x) & (1u <<  0)) +
> 		      !!((x) & (1u <<  1)) +
> //...
> 		      !!((x) & (1u << 31)));
> 
> that would probably work with BUILD_BUG_ON().
> 
> But as I said maybe it's too ugly.

Yes, it'll feel like this. Then you'll have to fix the possible error
in order to compile ;)

---
fs: O_* bit numbers uniqueness check

The O_* bit numbers are defined in 20+ arch/*, and hence can silently
overlap. Add a boot time check to ensure the uniqueness as suggested
by David Miller.

v3: change to BUILD_BUG_ON() as suggested by Roland

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
 include/linux/bitops.h      |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+), 2 deletions(-)

--- linux.orig/fs/fcntl.c	2010-01-06 14:41:26.000000000 +0800
+++ linux/fs/fcntl.c	2010-01-06 15:37:14.000000000 +0800
@@ -709,11 +709,21 @@ void kill_fasync(struct fasync_struct **
 }
 EXPORT_SYMBOL(kill_fasync);
 
-static int __init fasync_init(void)
+static int __init fcntl_init(void)
 {
+	/* please add new bits here to ensure allocation uniqueness */
+	BUILD_BUG_ON(20 != HWEIGHT32(
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
--- linux.orig/include/linux/bitops.h	2010-01-06 15:33:39.000000000 +0800
+++ linux/include/linux/bitops.h	2010-01-06 15:38:57.000000000 +0800
@@ -8,6 +8,39 @@
 #define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
 #define BITS_PER_BYTE		8
 #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
+
+#define HWEIGHT32(x) (!!((x) & (1u <<  0)) +	\
+                      !!((x) & (1u <<  1)) +	\
+                      !!((x) & (1u <<  2)) +	\
+                      !!((x) & (1u <<  3)) +	\
+                      !!((x) & (1u <<  4)) +	\
+                      !!((x) & (1u <<  5)) +	\
+                      !!((x) & (1u <<  6)) +	\
+                      !!((x) & (1u <<  7)) +	\
+                      !!((x) & (1u <<  8)) +	\
+                      !!((x) & (1u <<  9)) +	\
+                      !!((x) & (1u << 10)) +	\
+                      !!((x) & (1u << 11)) +	\
+                      !!((x) & (1u << 12)) +	\
+                      !!((x) & (1u << 13)) +	\
+                      !!((x) & (1u << 14)) +	\
+                      !!((x) & (1u << 15)) +	\
+                      !!((x) & (1u << 16)) +	\
+                      !!((x) & (1u << 17)) +	\
+                      !!((x) & (1u << 18)) +	\
+                      !!((x) & (1u << 19)) +	\
+                      !!((x) & (1u << 20)) +	\
+                      !!((x) & (1u << 21)) +	\
+                      !!((x) & (1u << 22)) +	\
+                      !!((x) & (1u << 23)) +	\
+                      !!((x) & (1u << 24)) +	\
+                      !!((x) & (1u << 25)) +	\
+                      !!((x) & (1u << 26)) +	\
+                      !!((x) & (1u << 27)) +	\
+                      !!((x) & (1u << 28)) +	\
+                      !!((x) & (1u << 29)) +	\
+                      !!((x) & (1u << 30)) +	\
+                      !!((x) & (1u << 31)))
 #endif
 
 /*
