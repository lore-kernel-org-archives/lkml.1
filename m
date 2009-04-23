Return-Path: <linux-kernel-owner+w=401wt.eu-S1758409AbZDWNvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409AbZDWNvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 09:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbZDWNvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 09:51:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbZDWNvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 09:51:07 -0400
Date: Thu, 23 Apr 2009 15:51:05 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org
Cc: npiggin@suse.de, paulmck@us.ibm.com, akpm@linux-foundation.org
Subject: [PATCH] atomic: Only take lock when the counter drops to zero on UP as well (v2)
Message-ID: <20090423135105.GU11220@bolzano.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_atomic_dec_and_lock() should not unconditionally take the lock before
calling atomic_dec_and_test() in the UP case. For consistency reasons it
should behave exactly like in the SMP case.
    
Besides that this works around the problem that with CONFIG_DEBUG_SPINLOCK
this spins in __spin_lock_debug() if the lock is already taken even if the
counter doesn't drop to 0.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
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
