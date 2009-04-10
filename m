Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbZDKOSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbZDKOSO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 10:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbZDKOR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 10:17:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:49361 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755792AbZDKOR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 10:17:58 -0400
From: Jan Blunck <jblunck@suse.de>
Date: Fri, 10 Apr 2009 18:13:57 +0200
Subject: [PATCH] atomic: Only take lock when the counter drops to zero on UP as well
To: Nick Piggin <npiggin@suse.de>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Message-Id: <20090411141754.45F7B16080@e179.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think it is wrong to unconditionally take the lock before calling
atomic_dec_and_test() in _atomic_dec_and_lock(). This will deadlock in
situation where it is known that the counter will not reach zero (e.g. holding
another reference to the same object) but the lock is already taken.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 lib/dec_and_lock.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/lib/dec_and_lock.c b/lib/dec_and_lock.c
index a65c314..e73822a 100644
--- a/lib/dec_and_lock.c
+++ b/lib/dec_and_lock.c
@@ -19,11 +19,10 @@
  */
 int _atomic_dec_and_lock(atomic_t *atomic, spinlock_t *lock)
 {
-#ifdef CONFIG_SMP
 	/* Subtract 1 from counter unless that drops it to 0 (ie. it was 1) */
 	if (atomic_add_unless(atomic, -1, 1))
 		return 0;
-#endif
+
 	/* Otherwise do it the slow way */
 	spin_lock(lock);
 	if (atomic_dec_and_test(atomic))
-- 
1.6.0.2

