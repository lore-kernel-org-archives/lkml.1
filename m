Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbZCJPbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbZCJPbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 11:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbZCJPbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 11:31:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54059 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756567AbZCJPbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 11:31:19 -0400
Date: Tue, 10 Mar 2009 16:31:15 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [patch 1/2] fs: mnt_want_write speedup
Message-ID: <20090310153115.GD8579@wotan.suse.de>
References: <20090310143718.GB15977@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310143718.GB15977@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 03:37:18PM +0100, Nick Piggin wrote:
> It does this by removing the complex per-cpu locking and counter-cache and
> replaces it with a percpu counter in struct vfsmount. This makes the code
> much simpler, and avoids spinlocks (although the msync is still pretty
> costly, unfortunately).

Hmm, it's stupid to say msync when I mean smp_mb() (which turns out to
be msync on x86). Not least because we have an msync syscall.

Anyway, the following is just an RFC at this stage (and I think exploration
in this area should not hold up the proposed patch 1/2). Having seqcounts
does reduce some barriers, but as we can see it actually potentially
opens a hole and is not exactly a trivial exercise when your read-side is
performing stores as well. So I don't have a magic bullet to avoid
thinking about barriers yet, I'm afraid.

--
OK, this is a way we could use seqcounts in order to reduce the open-coded
barriers. However one problem with using seqcounts like this is that the
write seqcount only has smp_wmb, however it subsequently loads each of the
percpu counters, and those loads could pass the store to the seqcount,
which would enable both mnt_make_readonly and a mnt_want_write()r to succeed.

One could argue that seqlocks should have acquire/release semantics
(especially on the write-side), although that would add weight to these
primitives. I prefer explicit barriers... although smp_mb() is actually
heavier than the barriers present in seqlock readside, so possibly open
coding a seqlock with the required barriers would be even better again?

But for now I think the previous patch is still an improvement on the old
scheme.

---
 fs/namespace.c        |   48 ++++++++++++++----------------------------------
 include/linux/mount.h |    4 +++-
 2 files changed, 17 insertions(+), 35 deletions(-)

Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c
+++ linux-2.6/fs/namespace.c
@@ -235,28 +235,19 @@ static unsigned int count_mnt_writers(st
 int mnt_want_write(struct vfsmount *mnt)
 {
 	int ret = 0;
+	unsigned seq;
 
 	preempt_disable();
+again:
+	seq = read_seqcount_begin(&mnt->mnt_seqcount);
 	inc_mnt_writers(mnt);
-	/*
-	 * The store to inc_mnt_writers must be visible before we pass
-	 * MNT_WRITE_HOLD loop below, so that the slowpath can see our
-	 * incremented count after it has set MNT_WRITE_HOLD.
-	 */
-	smp_mb();
-	while (mnt->mnt_flags & MNT_WRITE_HOLD)
-		cpu_relax();
-	/*
-	 * After the slowpath clears MNT_WRITE_HOLD, mnt_is_readonly will
-	 * be set to match its requirements. So we must not load that until
-	 * MNT_WRITE_HOLD is cleared.
-	 */
-	smp_rmb();
 	if (__mnt_is_readonly(mnt)) {
 		dec_mnt_writers(mnt);
 		ret = -EROFS;
 		goto out;
 	}
+	if (read_seqcount_retry(&mnt->mnt_seqcount, seq))
+		goto again;
 out:
 	preempt_enable();
 	return ret;
@@ -284,28 +275,22 @@ static int mnt_make_readonly(struct vfsm
 	int ret = 0;
 
 	spin_lock(&vfsmount_lock);
-	mnt->mnt_flags |= MNT_WRITE_HOLD;
-	/*
-	 * After storing MNT_WRITE_HOLD, we'll read the counters. This store
-	 * should be visible before we do.
-	 */
-	smp_mb();
+	/* vfsmount_lock protects mnt_seqcount */
+	write_seqcount_begin(&mnt->mnt_seqcount);
 
 	/*
-	 * With writers on hold, if this value is zero, then there are
-	 * definitely no active writers (although held writers may subsequently
-	 * increment the count, they'll have to wait, and decrement it after
-	 * seeing MNT_READONLY).
+	 * Writers will be held in mnt_want_write (although they will be
+	 * wildly incrementing and decrementing their write counters). But if
+	 * this value is zero, then there are _definitely_ no active writers,
+	 * so we can proceed.
 	 *
 	 * It is OK to have counter incremented on one CPU and decremented on
 	 * another: the sum will add up correctly. The danger would be when we
 	 * sum up each counter, if we read a counter before it is incremented,
 	 * but then read another CPU's count which it has been subsequently
 	 * decremented from -- we would see more decrements than we should.
-	 * MNT_WRITE_HOLD protects against this scenario, because
-	 * mnt_want_write first increments count, then smp_mb, then spins on
-	 * MNT_WRITE_HOLD, so it can't be decremented by another CPU while
-	 * we're counting up here.
+	 * However the seqlock in mnt_want_write ensures that increments will
+	 * not be decremented by another CPU until we drop the seqcount.
 	 */
 	if (count_mnt_writers(mnt) > 0) {
 		ret = -EBUSY;
@@ -314,12 +299,7 @@ static int mnt_make_readonly(struct vfsm
 	if (!ret)
 		mnt->mnt_flags |= MNT_READONLY;
 out:
-	/*
-	 * MNT_READONLY must become visible before ~MNT_WRITE_HOLD, so writers
-	 * that become unheld will see MNT_READONLY.
-	 */
-	smp_wmb();
-	mnt->mnt_flags &= ~MNT_WRITE_HOLD;
+	write_seqcount_end(&mnt->mnt_seqcount);
 	spin_unlock(&vfsmount_lock);
 	return ret;
 }
Index: linux-2.6/include/linux/mount.h
===================================================================
--- linux-2.6.orig/include/linux/mount.h
+++ linux-2.6/include/linux/mount.h
@@ -13,6 +13,7 @@
 #include <linux/list.h>
 #include <linux/nodemask.h>
 #include <linux/spinlock.h>
+#include <linux/seqlock.h>
 #include <asm/atomic.h>
 
 struct super_block;
@@ -29,7 +30,6 @@ struct mnt_namespace;
 #define MNT_READONLY	0x40	/* does the user want this to be r/o? */
 
 #define MNT_SHRINKABLE	0x100
-#define MNT_WRITE_HOLD	0x200
 
 #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
@@ -64,6 +64,8 @@ struct vfsmount {
 	int mnt_expiry_mark;		/* true if marked for expiry */
 	int mnt_pinned;
 	int mnt_ghosts;
+
+	seqcount_t mnt_seqcount;	/* protects mnt_writers */
 #ifdef CONFIG_SMP
 	int *mnt_writers;
 #else
