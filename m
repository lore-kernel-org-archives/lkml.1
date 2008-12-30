Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYL3XM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYL3XM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 18:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbYL3XMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 18:12:34 -0500
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:48916 "EHLO
	QMTA01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752685AbYL3XMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 18:12:33 -0500
From: Peter W Morreale <pmorreale@novell.com>
Subject: [PATCH 1/2] Fix pdflush thread creation upper bound.
To: linux-kernel@vger.kernel.org
Date: Tue, 30 Dec 2008 16:12:31 -0700
Message-ID: <20081230231231.10427.48410.stgit@hermosa.site>
In-Reply-To: <20081230231152.10427.50620.stgit@hermosa.site>
References: <20081230231152.10427.50620.stgit@hermosa.site>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: \"Peter W. Morreale\" <pmorreale@novell.com>

This patch fixes a race on creating pdflush threads.  Without the patch,
it is possible to create more than MAX_PDFLUSH_THREADS threads, and this
has been observed in practice on IO loaded SMP machines.

The fix involves moving the lock around to protect the check against the
thread count and correctly dealing with thread creation failure.
---

Signed-off-by: Peter W Morreale <pmorreale@novell.com>

 mm/pdflush.c |   27 +++++++++++++++++++++------
 1 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/mm/pdflush.c b/mm/pdflush.c
index 0cbe0c6..481680f 100644
--- a/mm/pdflush.c
+++ b/mm/pdflush.c
@@ -98,7 +98,6 @@ static int __pdflush(struct pdflush_work *my_work)
 	INIT_LIST_HEAD(&my_work->list);
 
 	spin_lock_irq(&pdflush_lock);
-	nr_pdflush_threads++;
 	for ( ; ; ) {
 		struct pdflush_work *pdf;
 
@@ -126,20 +125,23 @@ static int __pdflush(struct pdflush_work *my_work)
 
 		(*my_work->fn)(my_work->arg0);
 
+		spin_lock_irq(&pdflush_lock);
+
 		/*
 		 * Thread creation: For how long have there been zero
 		 * available threads?
 		 */
 		if (time_after(jiffies, last_empty_jifs + 1 * HZ)) {
-			/* unlocked list_empty() test is OK here */
 			if (list_empty(&pdflush_list)) {
-				/* unlocked test is OK here */
-				if (nr_pdflush_threads < MAX_PDFLUSH_THREADS)
+				if (nr_pdflush_threads < MAX_PDFLUSH_THREADS) {
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
@@ -226,13 +228,26 @@ int pdflush_operation(void (*fn)(unsigned long), unsigned long arg0)
 
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

