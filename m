Return-Path: <linux-kernel-owner+w=401wt.eu-S1761729AbYDBSpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761729AbYDBSpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756217AbYDBSpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:45:36 -0400
Received: from relay2.sgi.com ([192.48.171.30]:47267 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755577AbYDBSpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:45:36 -0400
Date: Wed, 2 Apr 2008 11:43:02 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Hugh Dickins <hugh@veritas.com>,
       Andrea Arcangeli <andrea@qumranet.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: EMM: Fix rcu handling and spelling
In-Reply-To: <20080401213811.GD8558@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0804021142350.28436@schroedinger.engr.sgi.com>
References: <20080401205531.986291575@sgi.com> <20080401205635.793766935@sgi.com>
 <1207084480.29991.2.camel@lappy> <20080401213811.GD8558@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: EMM: Fix rcu handling and spelling

Fix the way rcu_dereference is done.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/rmap.h |    2 +-
 mm/rmap.c            |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/include/linux/rmap.h
===================================================================
--- linux-2.6.orig/include/linux/rmap.h	2008-04-02 11:41:58.737866596 -0700
+++ linux-2.6/include/linux/rmap.h	2008-04-02 11:42:08.282029661 -0700
@@ -91,7 +91,7 @@ static inline void page_dup_rmap(struct 
  * when the VM removes references to pages.
  */
 enum emm_operation {
-	emm_release,		/* Process existing, */
+	emm_release,		/* Process exiting, */
 	emm_invalidate_start,	/* Before the VM unmaps pages */
 	emm_invalidate_end,	/* After the VM unmapped pages */
  	emm_referenced		/* Check if a range was referenced */
Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c	2008-04-02 11:41:58.737866596 -0700
+++ linux-2.6/mm/rmap.c	2008-04-02 11:42:08.282029661 -0700
@@ -303,7 +303,7 @@ EXPORT_SYMBOL_GPL(emm_notifier_register)
 int __emm_notify(struct mm_struct *mm, enum emm_operation op,
 		unsigned long start, unsigned long end)
 {
-	struct emm_notifier *e = rcu_dereference(mm)->emm_notifier;
+	struct emm_notifier *e = rcu_dereference(mm->emm_notifier);
 	int x;
 
 	while (e) {
@@ -317,7 +317,7 @@ int __emm_notify(struct mm_struct *mm, e
 		 * emm_notifier contents (e) must be fetched after
 		 * the retrival of the pointer to the notifier.
 		 */
-		e = rcu_dereference(e)->next;
+		e = rcu_dereference(e->next);
 	}
 	return 0;
 }

