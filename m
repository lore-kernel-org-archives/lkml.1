Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbXKNWhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbXKNWhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 17:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbXKNWg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 17:36:57 -0500
Received: from holomorphy.com ([66.93.40.71]:48364 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbXKNWg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 17:36:56 -0500
X-Greylist: delayed 2237 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Nov 2007 17:36:56 EST
Date: Wed, 14 Nov 2007 14:00:38 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: aglitke <agl@us.ibm.com>
Cc: ciju@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] hugetlbfs :shmget with SHM_HUGETLB only works as root
Message-ID: <20071114220038.GD1806@holomorphy.com>
References: <473B0317.6010603@linux.vnet.ibm.com> <1195054301.18047.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195054301.18047.20.camel@localhost.localdomain>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 09:31:41AM -0600, aglitke wrote:
> ... if the user's locked limit (ulimit -l) is set to unlimited, allowed
> (above) is set to 1.  In that case, the second part of that if() is
> bypassed, and the function grants permission.  Therefore, the easy
> solution is to make sure your user's lock_limit is RLIM_INFINITY.

This function deserves a minor cleanup and a bit more commenting.

Reading user->locked_shm within shmlock_user_lock would be nice, too.

Maybe something like this (untested, uncompiled) would do.


-- wli


diff --git a/mm/mlock.c b/mm/mlock.c
index 7b26560..5f51792 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -234,6 +234,12 @@ asmlinkage long sys_munlockall(void)
 /*
  * Objects with different lifetime than processes (SHM_LOCK and SHM_HUGETLB
  * shm segments) get accounted against the user_struct instead.
+ * First, user_shm_lock() checks that the user has permission to lock
+ * enough memory; then if so, the locked shm is accounted to the user's
+ * system-wide state. shmlock_user_lock protects the per-user field
+ * tracking how much locked_shm is in use within the struct user_struct.
+ * shmlock_user_lock is taken early to guard the read-only check that
+ * user->locked_shm is in-bounds against updates to user->locked_shm.
  */
 static DEFINE_SPINLOCK(shmlock_user_lock);
 
@@ -242,19 +248,22 @@ int user_shm_lock(size_t size, struct user_struct *user)
 	unsigned long lock_limit, locked;
 	int allowed = 0;
 
+	spin_lock(&shmlock_user_lock);
 	locked = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
 	if (lock_limit == RLIM_INFINITY)
 		allowed = 1;
-	lock_limit >>= PAGE_SHIFT;
-	spin_lock(&shmlock_user_lock);
-	if (!allowed &&
-	    locked + user->locked_shm > lock_limit && !capable(CAP_IPC_LOCK))
-		goto out;
-	get_uid(user);
-	user->locked_shm += locked;
-	allowed = 1;
-out:
+	else {
+		lock_limit >>= PAGE_SHIFT;
+		if (locked + user->locked_shm <= lock_limit)
+			allowed = 1;
+		else if (capable(CAP_IPC_LOCK))
+			allowed = 1;
+	}
+	if (allowed) {
+		get_uid(user);
+		user->locked_shm += locked;
+	}
 	spin_unlock(&shmlock_user_lock);
 	return allowed;
 }
