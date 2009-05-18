Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbZERQLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbZERQLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756202AbZERQJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:09:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:41495 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbZERQJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:29 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 01/32] atomic: Only take lock when the counter drops to zero on UP as well
Date: Mon, 18 May 2009 18:08:57 +0200
Message-Id: <1242662968-11684-2-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think it is wrong to unconditionally take the lock before calling
atomic_dec_and_test() in _atomic_dec_and_lock(). This will deadlock in
situation where it is known that the counter will now reach zero (e.g. holding
another reference to the same object) and the lock is already taken.

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
1.6.1.3

