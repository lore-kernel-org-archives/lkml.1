Return-Path: <linux-kernel-owner+w=401wt.eu-S965748AbXHGVSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965748AbXHGVSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932492AbXHGUz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:55:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59750 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934999AbXHGUz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:55:26 -0400
Date: Tue, 7 Aug 2007 13:48:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Herbert.van.den.Bergh@oracle.com,
       chris.mason@oracle.com
Subject: [2.6.22.2 review 61/84] do not limit locked memory when
	RLIMIT_MEMLOCK is RLIM_INFINITY
Message-ID: <20070807204809.GK23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="do-not-limit-locked-memory-when-rlimit_memlock-is-rlim_infinity.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Herbert van den Bergh <Herbert.van.den.Bergh@oracle.com>

Fix a bug in mm/mlock.c on 32-bit architectures that prevents a user from
locking more than 4GB of shared memory, or allocating more than 4GB of
shared memory in hugepages, when rlim[RLIMIT_MEMLOCK] is set to
RLIM_INFINITY.

Signed-off-by: Herbert van den Bergh <herbert.van.den.bergh@oracle.com>
Acked-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/mlock.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -244,9 +244,12 @@ int user_shm_lock(size_t size, struct us
 
 	locked = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
+	if (lock_limit == RLIM_INFINITY)
+		allowed = 1;
 	lock_limit >>= PAGE_SHIFT;
 	spin_lock(&shmlock_user_lock);
-	if (locked + user->locked_shm > lock_limit && !capable(CAP_IPC_LOCK))
+	if (!allowed &&
+	    locked + user->locked_shm > lock_limit && !capable(CAP_IPC_LOCK))
 		goto out;
 	get_uid(user);
 	user->locked_shm += locked;

-- 
