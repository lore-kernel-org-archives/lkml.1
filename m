Return-Path: <linux-kernel-owner+w=401wt.eu-S933369AbYBUQAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933369AbYBUQAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756707AbYBUPy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 10:54:56 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:41385
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932522AbYBUPyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:54:54 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH [RT] 11/14] optimize the !printk fastpath through the lock
	acquisition
To: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, gregkh@suse.de,
       sdietrich@novell.com, pmorreale@novell.com, mkohari@novell.com,
       ghaskins@novell.com
Date: Thu, 21 Feb 2008 10:27:22 -0500
Message-ID: <20080221152722.4804.77478.stgit@novell1.haskins.net>
In-Reply-To: <20080221152504.4804.8724.stgit@novell1.haskins.net>
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Decorate the printk path with an "unlikely()"

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/rtmutex.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 122f143..ebdaa17 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -660,12 +660,12 @@ rt_spin_lock_fastlock(struct rt_mutex *lock,
 		void fastcall (*slowfn)(struct rt_mutex *lock))
 {
 	/* Temporary HACK! */
-	if (!current->in_printk)
-		might_sleep();
-	else if (in_atomic() || irqs_disabled())
+	if (unlikely(current->in_printk) && (in_atomic() || irqs_disabled()))
 		/* don't grab locks for printk in atomic */
 		return;
 
+	might_sleep();
+
 	if (likely(rt_mutex_cmpxchg(lock, NULL, current)))
 		rt_mutex_deadlock_account_lock(lock, current);
 	else
@@ -677,7 +677,7 @@ rt_spin_lock_fastunlock(struct rt_mutex *lock,
 			void fastcall (*slowfn)(struct rt_mutex *lock))
 {
 	/* Temporary HACK! */
-	if (current->in_printk && (in_atomic() || irqs_disabled()))
+	if (unlikely(current->in_printk) && (in_atomic() || irqs_disabled()))
 		/* don't grab locks for printk in atomic */
 		return;
 

