Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbZBXGGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbZBXGGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 01:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbZBXGGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 01:06:37 -0500
Received: from smtp-out.google.com ([216.239.33.17]:49839 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbZBXGGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 01:06:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:user-agent:from:x-system-of-record;
	b=kJjY9lkU9Ww9avuL1x0ylGsp72XOkucDIRkwnSW8GiOwxpnIEKItZCroRoe2uVQH9
	5mNZe09Vrurc5XXxQlc0w==
Date: Mon, 23 Feb 2009 22:05:58 -0800
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Dave Hansen <haveblue@us.ibm.com>, nickpiggin@yahoo.com.au,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Another Performance Regression in write() syscall
Message-ID: <20090224060558.GA14812@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: sqazi@google.com (Salman Qazi)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Analysis of profile data has led us to believe that the commit
3d733633a633065729c9e4e254b2e5442c00ef7e has caused a performance
regression.  This commit provides for tracking of writers so that read only
bind mounts function correctly.

We can verify this regression by applying the following patch to partially
disable the above-mentioned commit and then running the fstime component
of Unixbench.  The settings used were 256 byte writes with MAX_BLOCK of 2000.

The following numbers were produced (5 samples, each specified in Kb/sec)

    2.6.29-rc6:
    283750, 295200, 294500, 293000, 293300

    2.6.29-rc6 + patch:
    337200, 329000, 331050, 337300, 328450

    2.6.18
    395700, 342000, 399100, 366050, 359850

See w_test() in src/fstime in Unixbench version 4.1.0.  A simplified
version of the test (leaving out the accounting code) is:

        alarm(10);
        while (!sigalarm) {
            for (f_blocks = 0; f_blocks < 2000; ++f_blocks) {
                write(f, buf, 256);
            }
            lseek(f, 0L, 0);
        }

The following patch is not intended to be a fix, but a way to demonstrate
the problem.

diff --git a/fs/namespace.c b/fs/namespace.c
index 06f8e63..ec0bfd9 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -251,21 +251,10 @@ static inline void use_cpu_writer_for_mount(struct mnt_writer *cpu_writer,
  */
 int mnt_want_write(struct vfsmount *mnt)
 {
-	int ret = 0;
-	struct mnt_writer *cpu_writer;
+	if (__mnt_is_readonly(mnt))
+		return -EROFS;
+	return 0;
 
-	cpu_writer = &get_cpu_var(mnt_writers);
-	spin_lock(&cpu_writer->lock);
-	if (__mnt_is_readonly(mnt)) {
-		ret = -EROFS;
-		goto out;
-	}
-	use_cpu_writer_for_mount(cpu_writer, mnt);
-	cpu_writer->count++;
-out:
-	spin_unlock(&cpu_writer->lock);
-	put_cpu_var(mnt_writers);
-	return ret;
 }
 EXPORT_SYMBOL_GPL(mnt_want_write);
 
@@ -282,45 +271,6 @@ static void lock_mnt_writers(void)
 	}
 }
 
-/*
- * These per-cpu write counts are not guaranteed to have
- * matched increments and decrements on any given cpu.
- * A file open()ed for write on one cpu and close()d on
- * another cpu will imbalance this count.  Make sure it
- * does not get too far out of whack.
- */
-static void handle_write_count_underflow(struct vfsmount *mnt)
-{
-	if (atomic_read(&mnt->__mnt_writers) >=
-	    MNT_WRITER_UNDERFLOW_LIMIT)
-		return;
-	/*
-	 * It isn't necessary to hold all of the locks
-	 * at the same time, but doing it this way makes
-	 * us share a lot more code.
-	 */
-	lock_mnt_writers();
-	/*
-	 * vfsmount_lock is for mnt_flags.
-	 */
-	spin_lock(&vfsmount_lock);
-	/*
-	 * If coalescing the per-cpu writer counts did not
-	 * get us back to a positive writer count, we have
-	 * a bug.
-	 */
-	if ((atomic_read(&mnt->__mnt_writers) < 0) &&
-	    !(mnt->mnt_flags & MNT_IMBALANCED_WRITE_COUNT)) {
-		WARN(1, KERN_DEBUG "leak detected on mount(%p) writers "
-				"count: %d\n",
-			mnt, atomic_read(&mnt->__mnt_writers));
-		/* use the flag to keep the dmesg spam down */
-		mnt->mnt_flags |= MNT_IMBALANCED_WRITE_COUNT;
-	}
-	spin_unlock(&vfsmount_lock);
-	unlock_mnt_writers();
-}
-
 /**
  * mnt_drop_write - give up write access to a mount
  * @mnt: the mount on which to give up write access
@@ -331,37 +281,6 @@ static void handle_write_count_underflow(struct vfsmount *mnt)
  */
 void mnt_drop_write(struct vfsmount *mnt)
 {
-	int must_check_underflow = 0;
-	struct mnt_writer *cpu_writer;
-
-	cpu_writer = &get_cpu_var(mnt_writers);
-	spin_lock(&cpu_writer->lock);
-
-	use_cpu_writer_for_mount(cpu_writer, mnt);
-	if (cpu_writer->count > 0) {
-		cpu_writer->count--;
-	} else {
-		must_check_underflow = 1;
-		atomic_dec(&mnt->__mnt_writers);
-	}
-
-	spin_unlock(&cpu_writer->lock);
-	/*
-	 * Logically, we could call this each time,
-	 * but the __mnt_writers cacheline tends to
-	 * be cold, and makes this expensive.
-	 */
-	if (must_check_underflow)
-		handle_write_count_underflow(mnt);
-	/*
-	 * This could be done right after the spinlock
-	 * is taken because the spinlock keeps us on
-	 * the cpu, and disables preemption.  However,
-	 * putting it here bounds the amount that
-	 * __mnt_writers can underflow.  Without it,
-	 * we could theoretically wrap __mnt_writers.
-	 */
-	put_cpu_var(mnt_writers);
 }
 EXPORT_SYMBOL_GPL(mnt_drop_write);
 
