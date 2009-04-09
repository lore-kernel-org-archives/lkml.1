Return-Path: <linux-kernel-owner+w=401wt.eu-S936062AbZDIQtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936062AbZDIQtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 12:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZDIQsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 12:48:40 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:36677 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935359AbZDIQsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 12:48:38 -0400
Date: Thu, 9 Apr 2009 18:48:34 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mutex: have non-spinning mutexes on s390 by default
Message-ID: <20090409184834.7a0df7b2@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20090409181404.71ac2988@osiris.boeblingen.de.ibm.com>
References: <20090409174758.74abec87@osiris.boeblingen.de.ibm.com>
	<1239292496.7647.607.camel@twins>
	<20090409181404.71ac2988@osiris.boeblingen.de.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated Patch below:

Subject: [PATCH] mutex: have non-spinning mutexes on s390 by default

From: Heiko Carstens <heiko.carstens@de.ibm.com>

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

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/Kconfig      |    3 +++
 arch/s390/Kconfig |    1 +
 kernel/mutex.c    |    3 ++-
 3 files changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/Kconfig
===================================================================
--- linux-2.6.orig/arch/Kconfig
+++ linux-2.6/arch/Kconfig
@@ -109,3 +109,6 @@ config HAVE_CLK
 
 config HAVE_DMA_API_DEBUG
 	bool
+
+config HAVE_DEFAULT_NO_SPIN_MUTEXES
+	bool
Index: linux-2.6/arch/s390/Kconfig
===================================================================
--- linux-2.6.orig/arch/s390/Kconfig
+++ linux-2.6/arch/s390/Kconfig
@@ -82,6 +82,7 @@ config S390
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_FUNCTION_TRACER
+	select HAVE_DEFAULT_NO_SPIN_MUTEXES
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
Index: linux-2.6/kernel/mutex.c
===================================================================
--- linux-2.6.orig/kernel/mutex.c
+++ linux-2.6/kernel/mutex.c
@@ -148,7 +148,8 @@ __mutex_lock_common(struct mutex *lock, 
 
 	preempt_disable();
 	mutex_acquire(&lock->dep_map, subclass, 0, ip);
-#if defined(CONFIG_SMP) && !defined(CONFIG_DEBUG_MUTEXES)
+#if defined(CONFIG_SMP) && !defined(CONFIG_DEBUG_MUTEXES) && \
+    !defined(CONFIG_HAVE_DEFAULT_NO_SPIN_MUTEXES)
 	/*
 	 * Optimistic spinning.
 	 *
