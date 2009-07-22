Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbZGVVW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbZGVVW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 17:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbZGVVW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 17:22:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:37623 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbZGVVWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 17:22:24 -0400
Date: Wed, 22 Jul 2009 21:21:55 GMT
From: tip-bot for Bruno Premont <bonbons@linux-vserver.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bonbons@linux-vserver.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, bonbons@linux-vserver.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20090722222232.2eb3e1c4@neptune.home>
References: <20090722222232.2eb3e1c4@neptune.home>
Subject: [tip:irq/urgent] genirq: Fix UP compile failure caused by irq_thread_check_affinity
Message-ID: <tip-61f3826133dc07142935fb5712fc738e19eb5575@git.kernel.org>
Git-Commit-ID: 61f3826133dc07142935fb5712fc738e19eb5575
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 22 Jul 2009 21:21:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61f3826133dc07142935fb5712fc738e19eb5575
Gitweb:     http://git.kernel.org/tip/61f3826133dc07142935fb5712fc738e19eb5575
Author:     Bruno Premont <bonbons@linux-vserver.org>
AuthorDate: Wed, 22 Jul 2009 22:22:32 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 22 Jul 2009 23:18:46 +0200

genirq: Fix UP compile failure caused by irq_thread_check_affinity

Since genirq: Delegate irq affinity setting to the irq thread
(591d2fb02ea80472d846c0b8507007806bdd69cc) compilation with
CONFIG_SMP=n fails with following error:

/usr/src/linux-2.6/kernel/irq/manage.c:
   In function 'irq_thread_check_affinity':
/usr/src/linux-2.6/kernel/irq/manage.c:475:
   error: 'struct irq_desc' has no member named 'affinity'
make[4]: *** [kernel/irq/manage.o] Error 1

That commit adds a new function irq_thread_check_affinity() which
uses struct irq_desc.affinity which is only available for CONFIG_SMP=y.
Move that function under #ifdef CONFIG_SMP.

[ tglx@brownpaperbag: compile and boot tested on UP and SMP ]

Signed-off-by: Bruno Premont <bonbons@linux-vserver.org>
LKML-Reference: <20090722222232.2eb3e1c4@neptune.home>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 kernel/irq/manage.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index f0de36f..61c679d 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -451,6 +451,7 @@ static int irq_wait_for_interrupt(struct irqaction *action)
 	return -1;
 }
 
+#ifdef CONFIG_SMP
 /*
  * Check whether we need to change the affinity of the interrupt thread.
  */
@@ -478,6 +479,10 @@ irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
 	set_cpus_allowed_ptr(current, mask);
 	free_cpumask_var(mask);
 }
+#else
+static inline void
+irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action) { }
+#endif
 
 /*
  * Interrupt handler thread
