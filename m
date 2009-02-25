Return-Path: <linux-kernel-owner+w=401wt.eu-S1760313AbZBYHZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760313AbZBYHZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 02:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbZBYHZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 02:25:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54203 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbZBYHZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 02:25:30 -0500
Date: Wed, 25 Feb 2009 08:25:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Salman Qazi <sqazi@google.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Subject: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Message-ID: <20090225072503.GD21903@elte.hu>
References: <20090224020304.GA4496@google.com> <200902242002.37555.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0902240744500.3111@localhost.localdomain> <200902251423.58861.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902251423.58861.nickpiggin@yahoo.com.au>
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Wednesday 25 February 2009 02:52:34 Linus Torvalds wrote:
> > On Tue, 24 Feb 2009, Nick Piggin wrote:
> > > > it does make some kind of sense to try to avoid the noncached versions
> > > > for small writes - because small writes tend to be for temp-files.
> > >
> > > I don't see the significance of a temp file. If the pagecache is
> > > truncated, then the cachelines remain dirty and so you can't avoid an
> > > eventual store back to RAM?
> >
> > No, because many small files end up being used as scratch-pads (think
> > shell script sequences etc), and get read back immediately again. Doing
> > non-temporal stores might just be bad simply because trying to play games
> > with caching may simply do the wrong thing.
> 
> OK, for that angle it could make sense. Although as has been 
> noted earlier, at this point of the copy, we don't have much 
> idea about the length of the write passed into the vfs (and 
> obviously will never know the higher level intention of 
> userspace).
> 
> I don't know if we can say a 1 page write is nontemporal, but 
> anything smaller is temporal. And having these kinds of 
> behavioural cutoffs I would worry will create strange 
> performance boundary conditions in code.

I agree in principle.

The main artifact would be the unaligned edges around a bigger 
write. In particular the tail portion of a big write will be 
cached.

For example if we write a 100,000 bytes file, we'll copy the 
first 24 pages (98304 bytes) uncached, while the final 1696 
bytes cached. But there is nothing that necessiates this 
assymetry.

For that reason it would be nice to pass down the total size of 
the write to the assembly code. These are single-usage-site APIs 
anyway so it should be easy.

I.e. something like the patch below (untested). I've extended 
the copy APIs to also pass down a 'total' size as well, and 
check for that instead of the chunk 'len'. Note that it's 
checked in the inlined portion so all the "total == len" special 
cases will optimize out the new parameter completely.

This should express the 'large vs. small' question adequately, 
with no artifacts. Agreed?

	Ingo

Index: tip/arch/x86/include/asm/uaccess_32.h
===================================================================
--- tip.orig/arch/x86/include/asm/uaccess_32.h
+++ tip/arch/x86/include/asm/uaccess_32.h
@@ -157,7 +157,7 @@ __copy_from_user(void *to, const void __
 }
 
 static __always_inline unsigned long __copy_from_user_nocache(void *to,
-				const void __user *from, unsigned long n)
+		const void __user *from, unsigned long n, unsigned long total)
 {
 	might_fault();
 	if (__builtin_constant_p(n)) {
@@ -180,7 +180,7 @@ static __always_inline unsigned long __c
 
 static __always_inline unsigned long
 __copy_from_user_inatomic_nocache(void *to, const void __user *from,
-				  unsigned long n)
+				  unsigned long n, unsigned long total)
 {
        return __copy_from_user_ll_nocache_nozero(to, from, n);
 }
Index: tip/arch/x86/include/asm/uaccess_64.h
===================================================================
--- tip.orig/arch/x86/include/asm/uaccess_64.h
+++ tip/arch/x86/include/asm/uaccess_64.h
@@ -189,7 +189,7 @@ extern long __copy_user_nocache(void *ds
 				unsigned size, int zerorest);
 
 static inline int __copy_from_user_nocache(void *dst, const void __user *src,
-					   unsigned size)
+				   unsigned size, unsigned long total)
 {
 	might_sleep();
 	/*
@@ -198,17 +198,16 @@ static inline int __copy_from_user_nocac
 	 * non-temporal stores here. Smaller writes get handled
 	 * via regular __copy_from_user():
 	 */
-	if (likely(size >= PAGE_SIZE))
+	if (likely(total >= PAGE_SIZE))
 		return __copy_user_nocache(dst, src, size, 1);
 	else
 		return __copy_from_user(dst, src, size);
 }
 
 static inline int __copy_from_user_inatomic_nocache(void *dst,
-						    const void __user *src,
-						    unsigned size)
+	    const void __user *src, unsigned size, unsigned total)
 {
-	if (likely(size >= PAGE_SIZE))
+	if (likely(total >= PAGE_SIZE))
 		return __copy_user_nocache(dst, src, size, 0);
 	else
 		return __copy_from_user_inatomic(dst, src, size);
Index: tip/drivers/gpu/drm/i915/i915_gem.c
===================================================================
--- tip.orig/drivers/gpu/drm/i915/i915_gem.c
+++ tip/drivers/gpu/drm/i915/i915_gem.c
@@ -211,7 +211,7 @@ fast_user_write(struct io_mapping *mappi
 
 	vaddr_atomic = io_mapping_map_atomic_wc(mapping, page_base);
 	unwritten = __copy_from_user_inatomic_nocache(vaddr_atomic + page_offset,
-						      user_data, length);
+						      user_data, length, length);
 	io_mapping_unmap_atomic(vaddr_atomic);
 	if (unwritten)
 		return -EFAULT;
Index: tip/include/linux/uaccess.h
===================================================================
--- tip.orig/include/linux/uaccess.h
+++ tip/include/linux/uaccess.h
@@ -41,13 +41,13 @@ static inline void pagefault_enable(void
 #ifndef ARCH_HAS_NOCACHE_UACCESS
 
 static inline unsigned long __copy_from_user_inatomic_nocache(void *to,
-				const void __user *from, unsigned long n)
+		const void __user *from, unsigned long n, unsigned long total)
 {
 	return __copy_from_user_inatomic(to, from, n);
 }
 
 static inline unsigned long __copy_from_user_nocache(void *to,
-				const void __user *from, unsigned long n)
+		const void __user *from, unsigned long n, unsigned long total)
 {
 	return __copy_from_user(to, from, n);
 }
Index: tip/mm/filemap.c
===================================================================
--- tip.orig/mm/filemap.c
+++ tip/mm/filemap.c
@@ -1816,14 +1816,14 @@ EXPORT_SYMBOL(file_remove_suid);
 static size_t __iovec_copy_from_user_inatomic(char *vaddr,
 			const struct iovec *iov, size_t base, size_t bytes)
 {
-	size_t copied = 0, left = 0;
+	size_t copied = 0, left = 0, total = bytes;
 
 	while (bytes) {
 		char __user *buf = iov->iov_base + base;
 		int copy = min(bytes, iov->iov_len - base);
 
 		base = 0;
-		left = __copy_from_user_inatomic_nocache(vaddr, buf, copy);
+		left = __copy_from_user_inatomic_nocache(vaddr, buf, copy, total);
 		copied += copy;
 		bytes -= copy;
 		vaddr += copy;
@@ -1851,8 +1851,9 @@ size_t iov_iter_copy_from_user_atomic(st
 	if (likely(i->nr_segs == 1)) {
 		int left;
 		char __user *buf = i->iov->iov_base + i->iov_offset;
+
 		left = __copy_from_user_inatomic_nocache(kaddr + offset,
-							buf, bytes);
+							buf, bytes, bytes);
 		copied = bytes - left;
 	} else {
 		copied = __iovec_copy_from_user_inatomic(kaddr + offset,
@@ -1880,7 +1881,8 @@ size_t iov_iter_copy_from_user(struct pa
 	if (likely(i->nr_segs == 1)) {
 		int left;
 		char __user *buf = i->iov->iov_base + i->iov_offset;
-		left = __copy_from_user_nocache(kaddr + offset, buf, bytes);
+
+		left = __copy_from_user_nocache(kaddr + offset, buf, bytes, bytes);
 		copied = bytes - left;
 	} else {
 		copied = __iovec_copy_from_user_inatomic(kaddr + offset,
