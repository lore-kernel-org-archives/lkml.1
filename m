Return-Path: <linux-kernel-owner+w=401wt.eu-S1759079AbZCBKkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759079AbZCBKkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 05:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756908AbZCBKkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 05:40:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36120 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388AbZCBKkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 05:40:07 -0500
Date: Mon, 2 Mar 2009 11:39:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Salman Qazi <sqazi@google.com>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] x86, mm: dont use non-temporal stores in pagecache accesses
Message-ID: <20090302103938.GM20897@elte.hu>
References: <20090224020304.GA4496@google.com> <200902272305.01867.nickpiggin@yahoo.com.au> <20090228082922.GB11425@elte.hu> <200902282249.57479.nickpiggin@yahoo.com.au> <20090228125816.GA14917@elte.hu> <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain> <20090228092450.3ded2db5@infradead.org> <alpine.LFD.2.00.0902280935010.3111@localhost.localdomain> <20090228182759.GA28865@elte.hu> <20090228103958.41fce55b@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228103958.41fce55b@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Sat, 28 Feb 2009 19:27:59 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > OTOH, given how draconian non-temporal stores are, i'm leaning 
> > towards removing them from the x86 code altogether. If it matter 
> > to performance somewhere it can be reintroduced, based on really 
> > well backed up numbers.
> 
> I think that is mostly the right approach; O_DIRECT could be 
> the exception to that (because there we don't only wipe it 
> from the cpu cache due to DMA, it even gets wiped from the 
> pagecache!). But I can see that being too special of a case to 
> care about in the grand scheme of things (although the 
> database people will now get upset with me ;-)

ok, i've removed most of the non-temporal stores hacks from the 
pagecache code on x86 - see the commit below, queued up in 
tip:x86/mm. (Other architectures did not make use of the 
_nocache() primitives at all.)

The _nocache() primitives are still there and are also still 
used by the Intel 3D driver code - passing buffers from the CPU 
to the GPU is an arguably correct special-case use of MOVNT.

O_SYNC (or any other thing iozone benchmarks might hit) will 
need to try a cleaner approach that does not affect the cached 
path. But, i'd not be surprised if it was all fine as-is as well 
- O_DIRECT IO wont normally get copied anyway.

	Ingo

----------------->
>From f180053694b43d5714bf56cb95499a3c32ff155c Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 2 Mar 2009 11:00:57 +0100
Subject: [PATCH] x86, mm: dont use non-temporal stores in pagecache accesses

Impact: standardize IO on cached ops

On modern CPUs it is almost always a bad idea to use non-temporal stores,
as the regression in this commit has shown it:

  30d697f: x86: fix performance regression in write() syscall

The kernel simply has no good information about whether using non-temporal
stores is a good idea or not - and trying to add heuristics only increases
complexity and inserts fragility.

The regression on cached write()s took very long to be found - over two
years. So dont take any chances and let the hardware decide how it makes
use of its caches.

The only exception is drivers/gpu/drm/i915/i915_gem.c: there were we are
absolutely sure that another entity (the GPU) will pick up the dirty
data immediately and that the CPU will not touch that data before the
GPU will.

Also, keep the _nocache() primitives to make it easier for people to
experiment with these details. There may be more clear-cut cases where
non-cached copies can be used, outside of filemap.c.

Cc: Salman Qazi <sqazi@google.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uaccess_32.h |    4 ++--
 arch/x86/include/asm/uaccess_64.h |   25 +++++++------------------
 drivers/gpu/drm/i915/i915_gem.c   |    2 +-
 include/linux/uaccess.h           |    4 ++--
 mm/filemap.c                      |   11 ++++-------
 mm/filemap_xip.c                  |    2 +-
 6 files changed, 17 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index a0ba613..5e06259 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -157,7 +157,7 @@ __copy_from_user(void *to, const void __user *from, unsigned long n)
 }
 
 static __always_inline unsigned long __copy_from_user_nocache(void *to,
-		const void __user *from, unsigned long n, unsigned long total)
+				const void __user *from, unsigned long n)
 {
 	might_fault();
 	if (__builtin_constant_p(n)) {
@@ -180,7 +180,7 @@ static __always_inline unsigned long __copy_from_user_nocache(void *to,
 
 static __always_inline unsigned long
 __copy_from_user_inatomic_nocache(void *to, const void __user *from,
-				  unsigned long n, unsigned long total)
+				  unsigned long n)
 {
        return __copy_from_user_ll_nocache_nozero(to, from, n);
 }
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index dcaa040..8cc6873 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -188,29 +188,18 @@ __copy_to_user_inatomic(void __user *dst, const void *src, unsigned size)
 extern long __copy_user_nocache(void *dst, const void __user *src,
 				unsigned size, int zerorest);
 
-static inline int __copy_from_user_nocache(void *dst, const void __user *src,
-				   unsigned size, unsigned long total)
+static inline int
+__copy_from_user_nocache(void *dst, const void __user *src, unsigned size)
 {
 	might_sleep();
-	/*
-	 * In practice this limit means that large file write()s
-	 * which get chunked to 4K copies get handled via
-	 * non-temporal stores here. Smaller writes get handled
-	 * via regular __copy_from_user():
-	 */
-	if (likely(total >= PAGE_SIZE))
-		return __copy_user_nocache(dst, src, size, 1);
-	else
-		return __copy_from_user(dst, src, size);
+	return __copy_user_nocache(dst, src, size, 1);
 }
 
-static inline int __copy_from_user_inatomic_nocache(void *dst,
-	    const void __user *src, unsigned size, unsigned total)
+static inline int
+__copy_from_user_inatomic_nocache(void *dst, const void __user *src,
+				  unsigned size)
 {
-	if (likely(total >= PAGE_SIZE))
-		return __copy_user_nocache(dst, src, size, 0);
-	else
-		return __copy_from_user_inatomic(dst, src, size);
+	return __copy_user_nocache(dst, src, size, 0);
 }
 
 unsigned long
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 6b209db..8185766 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -215,7 +215,7 @@ fast_user_write(struct io_mapping *mapping,
 
 	vaddr_atomic = io_mapping_map_atomic_wc(mapping, page_base);
 	unwritten = __copy_from_user_inatomic_nocache(vaddr_atomic + page_offset,
-						      user_data, length, length);
+						      user_data, length);
 	io_mapping_unmap_atomic(vaddr_atomic);
 	if (unwritten)
 		return -EFAULT;
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 6f3c603..6b58367 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -41,13 +41,13 @@ static inline void pagefault_enable(void)
 #ifndef ARCH_HAS_NOCACHE_UACCESS
 
 static inline unsigned long __copy_from_user_inatomic_nocache(void *to,
-		const void __user *from, unsigned long n, unsigned long total)
+				const void __user *from, unsigned long n)
 {
 	return __copy_from_user_inatomic(to, from, n);
 }
 
 static inline unsigned long __copy_from_user_nocache(void *to,
-		const void __user *from, unsigned long n, unsigned long total)
+				const void __user *from, unsigned long n)
 {
 	return __copy_from_user(to, from, n);
 }
diff --git a/mm/filemap.c b/mm/filemap.c
index 60fd567..126d397 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1816,14 +1816,14 @@ EXPORT_SYMBOL(file_remove_suid);
 static size_t __iovec_copy_from_user_inatomic(char *vaddr,
 			const struct iovec *iov, size_t base, size_t bytes)
 {
-	size_t copied = 0, left = 0, total = bytes;
+	size_t copied = 0, left = 0;
 
 	while (bytes) {
 		char __user *buf = iov->iov_base + base;
 		int copy = min(bytes, iov->iov_len - base);
 
 		base = 0;
-		left = __copy_from_user_inatomic_nocache(vaddr, buf, copy, total);
+		left = __copy_from_user_inatomic(vaddr, buf, copy);
 		copied += copy;
 		bytes -= copy;
 		vaddr += copy;
@@ -1851,9 +1851,7 @@ size_t iov_iter_copy_from_user_atomic(struct page *page,
 	if (likely(i->nr_segs == 1)) {
 		int left;
 		char __user *buf = i->iov->iov_base + i->iov_offset;
-
-		left = __copy_from_user_inatomic_nocache(kaddr + offset,
-							buf, bytes, bytes);
+		left = __copy_from_user_inatomic(kaddr + offset, buf, bytes);
 		copied = bytes - left;
 	} else {
 		copied = __iovec_copy_from_user_inatomic(kaddr + offset,
@@ -1881,8 +1879,7 @@ size_t iov_iter_copy_from_user(struct page *page,
 	if (likely(i->nr_segs == 1)) {
 		int left;
 		char __user *buf = i->iov->iov_base + i->iov_offset;
-
-		left = __copy_from_user_nocache(kaddr + offset, buf, bytes, bytes);
+		left = __copy_from_user(kaddr + offset, buf, bytes);
 		copied = bytes - left;
 	} else {
 		copied = __iovec_copy_from_user_inatomic(kaddr + offset,
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index bf54f8a..0c04615 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -354,7 +354,7 @@ __xip_file_write(struct file *filp, const char __user *buf,
 			break;
 
 		copied = bytes -
-			__copy_from_user_nocache(xip_mem + offset, buf, bytes, bytes);
+			__copy_from_user_nocache(xip_mem + offset, buf, bytes);
 
 		if (likely(copied > 0)) {
 			status = copied;
