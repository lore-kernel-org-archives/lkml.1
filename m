Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615Ab0AINwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab0AINwd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 08:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553Ab0AINwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 08:52:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:44506 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab0AINwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 08:52:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,246,1262592000"; 
   d="scan'208";a="529871664"
Date: Sat, 9 Jan 2010 21:52:19 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] fs: O_* bit numbers uniqueness check
Message-ID: <20100109135219.GD20015@localhost>
References: <20100106065526.GB11368@localhost> <20100106154814.GA5172@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106154814.GA5172@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 11:48:14PM +0800, Christoph Hellwig wrote:
> On Wed, Jan 06, 2010 at 02:55:26PM +0800, Wu Fengguang wrote:
> > The O_* bit numbers are defined in 20+ arch/*, and hence can silently
> > overlap. Add a boot time check to ensure the uniqueness as suggested
> > by David Miller.
> 
> The right fix is to stop overlyaing the FMODE_ flags into the O_
> namespace.  Al has been working towards this.

I thinks they are orthogonal problems -- this patch watches for the
possible conflicting O_* in so many archs.

Anyway here is the new version without the FMODE_ and O_RANDOM.

Thanks,
Fengguang
---
fs: O_* bit numbers uniqueness check

The O_* bit numbers are defined in 20+ arch/*, and hence can silently
overlap. Add a boot time check to ensure the uniqueness as suggested
by David Miller.

v4: use the nice hweight_long() as suggested by Jamie
    split O_SYNC to (__O_SYNC | O_DSYNC) as suggested by Andreas
    take away FMODE_* and O_RANDOM
v3: change to BUILD_BUG_ON() as suggested by Roland

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
