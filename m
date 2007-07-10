Return-Path: <linux-kernel-owner+w=401wt.eu-S1761341AbXGJA0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761341AbXGJA0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 20:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760164AbXGJA0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 20:26:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:51310 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbXGJA0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 20:26:44 -0400
Message-ID: <4692D230.3050403@oracle.com>
Date: Mon, 09 Jul 2007 17:26:24 -0700
From: Herbert van den Bergh <Herbert.van.den.Bergh@oracle.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070418)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
CC: akpm@linux-foundation.org, Dave McCracken <dave.mccracken@oracle.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: [PATCH] do not limit locked memory when RLIMIT_MEMLOCK is RLIM_INFINITY
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes a bug in mm/mlock.c on 32-bit architectures that prevents
a user from locking more than 4GB of shared memory, or allocating more
than 4GB of shared memory in hugepages, when rlim[RLIMIT_MEMLOCK] is
set to RLIM_INFINITY.

Signed-off-by: Herbert van den Bergh <herbert.van.den.bergh@oracle.com>
Acked-by: Chris Mason <chris.mason@oracle.com>

--- linux-2.6.22/mm/mlock.c.orig    2007-07-09 10:19:31.000000000 -0700
+++ linux-2.6.22/mm/mlock.c    2007-07-09 10:19:19.000000000 -0700
@@ -244,9 +244,12 @@ int user_shm_lock(size_t size, struct us
 
     locked = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
     lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
+    if (lock_limit == RLIM_INFINITY)
+        allowed = 1;
     lock_limit >>= PAGE_SHIFT;
     spin_lock(&shmlock_user_lock);
-    if (locked + user->locked_shm > lock_limit && !capable(CAP_IPC_LOCK))
+    if (!allowed &&
+        locked + user->locked_shm > lock_limit && !capable(CAP_IPC_LOCK))
         goto out;
     get_uid(user);
     user->locked_shm += locked;

