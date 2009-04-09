Return-Path: <linux-kernel-owner+w=401wt.eu-S935607AbZDISPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935607AbZDISPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760129AbZDISPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:15:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:54194 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756788AbZDISPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:15:03 -0400
Date: Thu, 9 Apr 2009 18:12:33 GMT
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com, borntraeger@de.ibm.com,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, borntraeger@de.ibm.com,
       mingo@elte.hu
In-Reply-To: <20090409184834.7a0df7b2@osiris.boeblingen.de.ibm.com>
References: <20090409184834.7a0df7b2@osiris.boeblingen.de.ibm.com>
Subject: [tip:core/urgent] mutex: have non-spinning mutexes on s390 by default
Message-ID: <tip-36cd3c9f925b9307236505ae7ad1ad7ac4d4357c@git.kernel.org>
Git-Commit-ID: 36cd3c9f925b9307236505ae7ad1ad7ac4d4357c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 18:12:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  36cd3c9f925b9307236505ae7ad1ad7ac4d4357c
Gitweb:     http://git.kernel.org/tip/36cd3c9f925b9307236505ae7ad1ad7ac4d4357c
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Thu, 9 Apr 2009 18:48:34 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Apr 2009 19:28:24 +0200

mutex: have non-spinning mutexes on s390 by default

Impact: performance regression fix for s390

The adaptive spinning mutexes will not always do what one would expect on
virtualized architectures like s390. Especially the cpu_relax() loop in
mutex_spin_on_owner might hurt if the mutex holding cpu has been scheduled
away by the hypervisor.

We would end up in a cpu_relax() loop when there is no chance that the
state of the mutex changes until the target cpu has been scheduled again by
the hypervisor.

For that reason we should change the default behaviour to no-spin on s390.

We do have an instruction which allows to yield the current cpu in favour of
a different target cpu. Also we have an instruction which allows us to figure
out if the target cpu is physically backed.

However we need to do some performance tests until we can come up with
a solution that will do the right thing on s390.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
LKML-Reference: <20090409184834.7a0df7b2@osiris.boeblingen.de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/Kconfig      |    3 +++
 arch/s390/Kconfig |    1 +
 kernel/mutex.c    |    3 ++-
 3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index dc81b34..78a35e9 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -109,3 +109,6 @@ config HAVE_CLK
 
 config HAVE_DMA_API_DEBUG
 	bool
+
+config HAVE_DEFAULT_NO_SPIN_MUTEXES
+	bool
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index dcb667c..2eca5fe 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -82,6 +82,7 @@ config S390
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_FUNCTION_TRACER
+	select HAVE_DEFAULT_NO_SPIN_MUTEXES
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 5d79781..507cf2b 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -148,7 +148,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 	preempt_disable();
 	mutex_acquire(&lock->dep_map, subclass, 0, ip);
-#if defined(CONFIG_SMP) && !defined(CONFIG_DEBUG_MUTEXES)
+#if defined(CONFIG_SMP) && !defined(CONFIG_DEBUG_MUTEXES) && \
+    !defined(CONFIG_HAVE_DEFAULT_NO_SPIN_MUTEXES)
 	/*
 	 * Optimistic spinning.
 	 *
