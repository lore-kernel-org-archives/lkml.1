Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbYJ2CaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbYJ2CaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 22:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbYJ2C3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 22:29:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303AbYJ2C3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 22:29:50 -0400
Date: Tue, 28 Oct 2008 19:29:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, tim.bird@am.sony.com,
       linux-next@vger.kernel.org
Subject: Re: [PATCH V2 00/16] Squashfs: compressed read-only filesystem
Message-Id: <20081028192919.94def38b.akpm@linux-foundation.org>
In-Reply-To: <E1Kv0C3-0006GU-ES@dylan>
References: <E1Kv0C3-0006GU-ES@dylan>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008 01:49:55 +0000 Phillip Lougher <phillip@lougher.demon.co.uk> wrote:

> Hi,
> 
> This a respin of the Squashfs patches incorporating the review comments
> received.  Thanks to everyone who have sent comments.
> 
> Summary of changes in patch respin:
> 
> 1. Functions changed to return 0 on success and -ESOMETHING on error
> 2. Header files moved from include/linux to fs/squashfs
> 3. Variables changed to use sb and inode
> 4. Number of squashfs_read_metadata() parameters reduced
> 5. Xattr placeholder code tweaked
> 6. TRACE and ERROR macros fixed to use pr_debug and pr_warning
> 7. Some obsolete macros in squashfs_fs.h removed
> 8. A number of gotos to return statements replaced with direct returns
> 9. Sparse with endian checking (make C=2 CHECKFLAGS="-D__CHECK_ENDIAN__")
>    errors fixed
> 10. get_dir_index_using_name() misaligned access fixed
> 11. Fix a couple of printk warnings on PPC64
> 12. Shorten a number of variable names

- what are the limitations of squashfs (please add this to the
  changelog of patch #1 or something).  Does it support nfsd? (yes, it
  does!)  xatrs and acls?  File size limits, entries-per-directory,
  etc, etc?

  What is on the todo list?

- Please check that all non-static identifiers really did need global
  scope.  I saw some which surprised me a bit.

- Please check that all global identifiers have suitable names.  For
  example "get_fragment_location" is a poor choice for a kernel-wide
  identifier.  It could clash with other subsystems, mainly.  Plus it
  is hardly self-identifying.  I see quite a few such cases.

- The fs uses vmalloc() rather a lot.  I'd suggest that this be
  explained and justified in the design/implementation overview,
  wherever that is.  This should include a means by which we can
  estimate (or at least understand) the amount of memory which will be
  allocated in this way.

  Because vmalloc() is unreliable.  It is a fixed-size resource on
  each machine.  Some machines will run out much much earlier than
  others.  It will set an upper limit on the number of filesystems
  which can be concurrently mounted, and presumably upon the size of
  those filesystems.  One a per-machine basis, which is worse.

  It also exposes users to vmalloc arena fragmentation.  eg: mount
  ten 1G filesystems, then unmount every second one, then try to mount
  a 2G filesystem and you find you have no contiguous vmalloc space
  (simplified example).

  See, this vmalloc thing is a fairly big deal.  What's up with all
  of this??

- The fs uses brelse() in quite a few places where the bh is known to
  be non-zero.  Suggest that these be converted to the more efficient
  and modern put_bh().

- this:

+/*
+ * Blocks in Squashfs are compressed.  To avoid repeatedly decompressing
+ * recently accessed data Squashfs uses two small metadata and fragment caches.
+ *
+ * This file implements a generic cache implementation used for both caches,
+ * plus functions layered ontop of the generic cache implementation to
+ * access the metadata and fragment caches.
+ */

  confuses me.  Why not just decompress these blocks into pagecache
  and let the VFS handle the caching??

  The real bug here is that this rather obvious question wasn't
  answered anywhere in the patch submission (afaict).  How to fix that?

  Methinks we need a squashfs.txt which covers these things.

- I suspect that squashfs_cache_put() has races around the handling
  of cache->waiting.  Does it assume that another CPU wrote that flag
  prior to adding itself to the waitqueue?  How can the other task do
  that atomically?  What about memory ordering issues?

  Suggest that cache->lock coverage be extended to clear all this up.

- Quite a few places do kzalloc(a * b, ...).  Please convert to
  kcalloc() which has checks for multiplicative overflows.

> There is now a public git repository on kernel.org. Pull/clone from
> git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-2.6.git

Generally looks OK to me.  Please prepare a tree for linx-next
inclusion and unless serious problems are pointed out I'd suggest
shooting for a 2.6.29 merge.


