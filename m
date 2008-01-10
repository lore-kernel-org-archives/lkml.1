Return-Path: <linux-kernel-owner+w=401wt.eu-S1760574AbYAJTIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760574AbYAJTIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYAJTH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:07:29 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57561 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758099AbYAJTHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:07:24 -0500
Subject: [RFC][PATCH 2/4] change mnt_writers underflow protection logic
To: linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, hch@infradead.org, serue@us.ibm.com,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 10 Jan 2008 11:07:00 -0800
References: <20080110190657.92A8B61F@kernel>
In-Reply-To: <20080110190657.92A8B61F@kernel>
Message-Id: <20080110190700.961C885D@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The comment tells most of the story.  I want to make the
spinlock in this case into a mutex, and the current
underflow protection mechanism uses preempt disabling from
put/get_cpu_Var(). I can't use that with a mutex.

Without the preempt disabling, there is no limit to the
number of cpus that might get to:

        use_cpu_writer_for_mount(cpu_writer, mnt);
        if (cpu_writer->count > 0) {
                cpu_writer->count--;
        } else {
                atomic_dec(&mnt->__mnt_writers);
        }
        spin_unlock(&cpu_writer->lock);
---->HERE
        if (must_check_underflow)
                handle_write_count_underflow(mnt);

because they get preempted once the spinlock is unlocked.

So, there's no limit on how many times __mnt_writers may
be decremented.  (I know the limit is still the number of
tasks on the system, but that's a heck of a lot higher
than the number of cpus.)  Doing the simple check in this
patch before the decrement and under a lock removes the
possibility that this can happen.

Since there are only NR_CPUS mnt_writer[]s, we can only
have NR_CPUS lock holders in the critical section at a
time, __mnt_writers can only underflow by
MNT_WRITER_UNDERFLOW_LIMIT+NR_CPUS.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/namespace.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff -puN fs/namespace.c~change-underflow-protection-logic fs/namespace.c
--- linux-2.6.git/fs/namespace.c~change-underflow-protection-logic	2008-01-10 10:36:37.000000000 -0800
+++ linux-2.6.git-dave/fs/namespace.c	2008-01-10 10:36:37.000000000 -0800
@@ -267,15 +267,30 @@ void mnt_drop_write(struct vfsmount *mnt
 	int must_check_underflow = 0;
 	struct mnt_writer *cpu_writer;
 
-	cpu_writer = &get_cpu_var(mnt_writers);
+retry:
+	cpu_writer = &__get_cpu_var(mnt_writers);
 	spin_lock(&cpu_writer->lock);
 
 	use_cpu_writer_for_mount(cpu_writer, mnt);
 	if (cpu_writer->count > 0) {
 		cpu_writer->count--;
 	} else {
-		must_check_underflow = 1;
+		/* Without this check, it is theoretically
+		 * possible to underflow __mnt_writers.
+		 * An unlimited number of processes could
+		 * all do this decrement, unlock, and then
+		 * stall before the underflow handling.
+		 * Doing this check limits the underflow
+		 * to the number of cpu_writer->lock
+		 * holders (NR_CPUS).
+		 */
+		if (atomic_read(&mnt->__mnt_writers) <
+		    MNT_WRITER_UNDERFLOW_LIMIT) {
+			spin_unlock(&cpu_writer->lock);
+			goto retry;
+		}
 		atomic_dec(&mnt->__mnt_writers);
+		must_check_underflow = 1;
 	}
 
 	spin_unlock(&cpu_writer->lock);
@@ -286,15 +301,6 @@ void mnt_drop_write(struct vfsmount *mnt
 	 */
 	if (must_check_underflow)
 		handle_write_count_underflow(mnt);
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
 
_
