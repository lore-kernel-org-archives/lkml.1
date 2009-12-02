Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbZLBTtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbZLBTtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 14:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbZLBTtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 14:49:12 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:41131 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbZLBTtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 14:49:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=B809DMrgxUWrRsNzDMWlvOvwjPP0QPi69HNzSI/mO8PPct7+sHN1UxUiAJznSmE4eR
         f2lbTRNINgdcH6vSfOysDedAUO1G0XkKaRffXlpgR3GTLfy3KkXFsTajARpfmE2GE2n7
         SRweRfcKoGZCkFTgo8X8Fv7XhKv/hyFFy6fIU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/2] mutex: Better control mutex adaptive spinning config
Date: Wed,  2 Dec 2009 20:49:16 +0100
Message-Id: <1259783357-8542-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce CONFIG_MUTEX_SPIN_ON_OWNER so that we can centralize in a
single place the conditions that determine its definition and use.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/Kconfig.locks |    3 +++
 kernel/mutex.c       |    4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index d1f86db..88c92fb 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -197,3 +197,6 @@ config INLINE_WRITE_UNLOCK_IRQ
 
 config INLINE_WRITE_UNLOCK_IRQRESTORE
 	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+
+config MUTEX_SPIN_ON_OWNER
+	def_bool SMP && !DEBUG_MUTEXES && !HAVE_DEFAULT_NO_SPIN_MUTEXES
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 947b3ad..632f04c 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -148,8 +148,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 	preempt_disable();
 	mutex_acquire(&lock->dep_map, subclass, 0, ip);
-#if defined(CONFIG_SMP) && !defined(CONFIG_DEBUG_MUTEXES) && \
-    !defined(CONFIG_HAVE_DEFAULT_NO_SPIN_MUTEXES)
+
+#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
 	/*
 	 * Optimistic spinning.
 	 *
-- 
1.6.2.3

