Return-Path: <linux-kernel-owner+w=401wt.eu-S1762592AbXKAXR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762592AbXKAXR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760093AbXKAXJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:09:13 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58562 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759064AbXKAXJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:09:05 -0400
Subject: [PATCH 25/27] r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 01 Nov 2007 16:09:00 -0700
References: <20071101230826.9A4F6E00@kernel>
In-Reply-To: <20071101230826.9A4F6E00@kernel>
Message-Id: <20071101230900.13469A0F@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



With the r/o bind mount patches, we can have as many
spinlocks nested as there are CPUs on the system.
Lockdep freaks out after 8.

So, create a new lockdep class of locks for the
mnt_writer spinlocks, and initialize each of the
cpu locks to be in a different class.

It should shut up warnings like this, while still
allowing some of the lockdep goodness to remain:

=============================================
[ INFO: possible recursive locking detected ]
2.6.23-rc6 #6

---

 linux-2.6.git-dave/fs/namespace.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/namespace.c~r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts fs/namespace.c
--- linux-2.6.git/fs/namespace.c~r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts	2007-11-01 14:46:21.000000000 -0700
+++ linux-2.6.git-dave/fs/namespace.c	2007-11-01 14:46:21.000000000 -0700
@@ -112,6 +112,7 @@ struct mnt_writer {
 	 * must be ordered by cpu number.
 	 */
 	spinlock_t lock;
+	struct lock_class_key lock_class; /* compiles out with !lockdep */
 	unsigned long count;
 	struct vfsmount *mnt;
 } ____cacheline_aligned_in_smp;
@@ -123,6 +124,7 @@ static int __init init_mnt_writers(void)
 	for_each_possible_cpu(cpu) {
 		struct mnt_writer *writer = &per_cpu(mnt_writers, cpu);
 		spin_lock_init(&writer->lock);
+		lockdep_set_class(&writer->lock, &writer->lock_class);
 		writer->count = 0;
 	}
 	return 0;
_
