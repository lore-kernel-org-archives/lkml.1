Return-Path: <linux-kernel-owner+w=401wt.eu-S1762812AbYEUGAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762812AbYEUGAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 02:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbYEUGAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 02:00:32 -0400
Received: from ozlabs.org ([203.10.76.45]:58017 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479AbYEUGAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 02:00:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Introduce down_nowait()
Date: Wed, 21 May 2008 16:00:15 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805211600.16415.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I planned on removing the much-disliked down_trylock() (with its
backwards return codes) in 2.6.27, but it's creating something of a
logjam with other patches in -mm and linux-next.

Andrew suggested introducing "down_nowait" as a wrapper now, to make
the transition easier.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>

diff -r 92664ae4130b include/linux/semaphore.h
--- a/include/linux/semaphore.h	Wed May 21 14:54:40 2008 +1000
+++ b/include/linux/semaphore.h	Wed May 21 15:07:31 2008 +1000
@@ -48,4 +48,18 @@ extern int __must_check down_timeout(str
 extern int __must_check down_timeout(struct semaphore *sem, long jiffies);
 extern void up(struct semaphore *sem);
 
+/**
+ * down_nowait - try to down a semaphore, but don't block
+ * @sem: the semaphore
+ *
+ * This is equivalent to down_trylock(), but has the same return codes as
+ * spin_trylock and mutex_trylock: 1 if semaphore acquired, 0 if not.
+ *
+ * down_trylock() with its confusing return codes will be deprecated
+ * soon.  It will not be missed.
+ */
+static inline int __must_check down_nowait(struct semaphore *sem)
+{
+        return !down_trylock(sem);
+}
 #endif /* __LINUX_SEMAPHORE_H */
