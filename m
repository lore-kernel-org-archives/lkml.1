Return-Path: <linux-kernel-owner+w=401wt.eu-S933345AbZFOSME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbZFOSME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbZFOSLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:11:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474AbZFOSLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:11:54 -0400
Date: Mon, 15 Jun 2009 14:11:13 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Jan Blunck <jblunck@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul McKenney <paulmck@us.ibm.com>
Subject: [PATCH] atomic: Fix _atomic_dec_and_lock() deadlock on UP
Message-ID: <20090615181113.GD352@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

_atomic_dec_and_lock() can deadlock on UP with spinlock debugging
enabled.  Currently, on UP we unconditionally spin_lock() first, which
calls __spin_lock_debug(), which takes the lock unconditionally even
on UP.  This will deadlock in situations in which we call
atomic_dec_and_lock() knowing that the counter won't go to zero
(because we hold another reference) and that we already hold the lock.
Instead, we should use the SMP code path which only takes the lock if
necessary.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
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
1.6.0.6

