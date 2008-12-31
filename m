Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbYLaTKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbYLaTKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 14:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbYLaTKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 14:10:16 -0500
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:48747 "EHLO
	QMTA01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756527AbYLaTKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 14:10:15 -0500
From: Peter W Morreale <pmorreale@novell.com>
Subject: [PATCH 1/2] Fix pdflush thread creation upper bound.
To: pmorreale@novell.com, akpm@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, spamtrap@knobisoft.de
Date: Wed, 31 Dec 2008 12:10:11 -0700
Message-ID: <20081231191011.30792.17202.stgit@hermosa.site>
In-Reply-To: <20081231190755.30792.24205.stgit@hermosa.site>
References: <20081231190755.30792.24205.stgit@hermosa.site>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a race on creating pdflush threads.  Without the patch,
it is possible to create more than MAX_PDFLUSH_THREADS threads, and this
has been observed in practice on IO loaded SMP machines.

The fix involves moving the lock around to protect the check against the
thread count and correctly dealing with thread creation failure.

This fix also _mostly_ repairs a race condition on how quickly the
threads are created.  The original intent was to create a pdflush thread
(up to the max allowed) every second.  Without this patch is is possible
to create NCPUS pdflush threads concurrently.  The 'mostly' caveat is
because an assumption is made that thread creation will be successful.
If we fail to create the thread, the miss is not considered fatal. (we
will try again in 1 second)
---

Signed-off-by: Peter W Morreale <pmorreale@novell.com>

 mm/pdflush.c |   32 +++++++++++++++++++++++++-------
 1 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/mm/pdflush.c b/mm/pdflush.c
index 0cbe0c6..80745c7 100644
--- a/mm/pdflush.c
+++ b/mm/pdflush.c
@@ -98,7 +98,6 @@ static int __pdflush(struct pdflush_work *my_work)
 	INIT_LIST_HEAD(&my_work->list);
 
 	spin_lock_irq(&pdflush_lock);
-	nr_pdflush_threads++;
 	for ( ; ; ) {
 		struct pdflush_work *pdf;
 
@@ -126,20 +125,26 @@ static int __pdflush(struct pdflush_work *my_work)
 
 		(*my_work->fn)(my_work->arg0);
 
+		spin_lock_irq(&pdflush_lock);
+
 		/*
 		 * Thread creation: For how long have there been zero
-		 * available threads?
+		 * available threads?  
+		 *
+		 * To throttle creation, we reset last_empty_jifs.
 		 */
 		if (time_after(jiffies, last_empty_jifs + 1 * HZ)) {
-			/* unlocked list_empty() test is OK here */
 			if (list_empty(&pdflush_list)) {
-				/* unlocked test is OK here */
-				if (nr_pdflush_threads < MAX_PDFLUSH_THREADS)
+				if (nr_pdflush_threads < MAX_PDFLUSH_THREADS) {
+					last_empty_jifs = jiffies;
+					nr_pdflush_threads++;
+					spin_unlock_irq(&pdflush_lock);
 					start_one_pdflush_thread();
+					spin_lock_irq(&pdflush_lock);
+				}
 			}
 		}
 
-		spin_lock_irq(&pdflush_lock);
 		my_work->fn = NULL;
 
 		/*
@@ -226,13 +231,26 @@ int pdflush_operation(void (*fn)(unsigned long), unsigned long arg0)
 
 static void start_one_pdflush_thread(void)
 {
-	kthread_run(pdflush, NULL, "pdflush");
+	struct task_struct *k;
+
+	k = kthread_run(pdflush, NULL, "pdflush");
+	if (unlikely(IS_ERR(k))) {
+		spin_lock_irq(&pdflush_lock);
+		nr_pdflush_threads--;
+		spin_unlock_irq(&pdflush_lock);
+	}
 }
 
 static int __init pdflush_init(void)
 {
 	int i;
 
+	/*
+	 * Pre-set nr_pdflush_threads...  If we fail to create, 
+	 * the count will be decremented.
+	 */
+	nr_pdflush_threads = MIN_PDFLUSH_THREADS;
+
 	for (i = 0; i < MIN_PDFLUSH_THREADS; i++)
 		start_one_pdflush_thread();
 	return 0;

