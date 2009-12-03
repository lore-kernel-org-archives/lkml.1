Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbZLCNYC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbZLCNYC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 08:24:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755732AbZLCNX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 08:23:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:32919 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298AbZLCNX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 08:23:58 -0500
Date: Thu, 3 Dec 2009 13:23:12 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1259783357-8542-1-git-send-regression-fweisbec@gmail.com>
References: <1259783357-8542-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] mutex: Better control mutex adaptive spinning config
Message-ID: <tip-c02260277e472095ffb3ad893be5eeab9dcefde3@git.kernel.org>
Git-Commit-ID: c02260277e472095ffb3ad893be5eeab9dcefde3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c02260277e472095ffb3ad893be5eeab9dcefde3
Gitweb:     http://git.kernel.org/tip/c02260277e472095ffb3ad893be5eeab9dcefde3
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 2 Dec 2009 20:49:16 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Dec 2009 11:50:11 +0100

mutex: Better control mutex adaptive spinning config

Introduce CONFIG_MUTEX_SPIN_ON_OWNER so that we can centralize
in a single place the conditions that determine its definition
and use.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1259783357-8542-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
