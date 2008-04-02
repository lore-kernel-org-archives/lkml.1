Return-Path: <linux-kernel-owner+w=401wt.eu-S1760209AbYDBVIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760209AbYDBVIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbYDBVIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:08:07 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53084 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753162AbYDBVIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:08:06 -0400
Date: Wed, 2 Apr 2008 14:05:28 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Hugh Dickins <hugh@veritas.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Nick Piggin <npiggin@suse.de>
Subject: EMM: Require single threadedness for registration.
In-Reply-To: <Pine.LNX.4.64.0804021048460.27214@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0804021402190.30337@schroedinger.engr.sgi.com>
References: <20080401205531.986291575@sgi.com> <20080401205635.793766935@sgi.com>
 <20080402064952.GF19189@duo.random> <Pine.LNX.4.64.0804021048460.27214@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a patch to require single threaded execution during emm_register. 
This also allows an easy implementation of an unregister function and gets
rid of the races that Andrea worried about.

The approach here is similar to what was used in selinux for security
context changes (see selinux_setprocattr).

Is it okay for the users of emm to require single threadedness for 
registration?



Subject: EMM: Require single threaded execution for register and unregister

We can avoid the concurrency issues arising at registration if we
only allow registration of notifiers when the process has only a single
thread. That even allows to avoid the use of rcu.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/rmap.c |   46 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 9 deletions(-)

Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c	2008-04-02 13:53:46.002473685 -0700
+++ linux-2.6/mm/rmap.c	2008-04-02 14:03:05.872199896 -0700
@@ -286,20 +286,48 @@ void emm_notifier_release(struct mm_stru
 	}
 }
 
-/* Register a notifier */
+/*
+ * Register a notifier
+ *
+ * mmap_sem is held writably.
+ *
+ * Process must be single threaded.
+ */
 void emm_notifier_register(struct emm_notifier *e, struct mm_struct *mm)
 {
+	BUG_ON(atomic_read(&mm->mm_users) != 1);
+
 	e->next = mm->emm_notifier;
-	/*
-	 * The update to emm_notifier (e->next) must be visible
-	 * before the pointer becomes visible.
-	 * rcu_assign_pointer() does exactly what we need.
-	 */
-	rcu_assign_pointer(mm->emm_notifier, e);
+	mm->emm_notifier = e;
 }
 EXPORT_SYMBOL_GPL(emm_notifier_register);
 
 /*
+ * Unregister a notifier
+ *
+ * mmap_sem is held writably
+ *
+ * Process must be single threaded
+ */
+void emm_notifier_unregister(struct emm_notifier *e, struct mm_struct *mm)
+{
+	struct emm_notifier *p = mm->emm_notifier;
+
+	BUG_ON(atomic_read(&mm->mm_users) != 1);
+
+	if (e == p)
+		mm->emm_notifier = e->next;
+	else {
+		while (p->next != e)
+			p = p->next;
+
+		p->next = e->next;
+	}
+	e->callback(e, mm, emm_release, 0, TASK_SIZE);
+}
+EXPORT_SYMBOL_GPL(emm_notifier_unregister);
+
+/*
  * Perform a callback
  *
  * The return of this function is either a negative error of the first
@@ -309,7 +337,7 @@ EXPORT_SYMBOL_GPL(emm_notifier_register)
 int __emm_notify(struct mm_struct *mm, enum emm_operation op,
 		unsigned long start, unsigned long end)
 {
-	struct emm_notifier *e = rcu_dereference(mm->emm_notifier);
+	struct emm_notifier *e = mm->emm_notifier;
 	int x;
 	int result = 0;
 
@@ -335,7 +363,7 @@ int __emm_notify(struct mm_struct *mm, e
 		 * emm_notifier contents (e) must be fetched after
 		 * the retrival of the pointer to the notifier.
 		 */
-		e = rcu_dereference(e->next);
+		e = e->next;
 	}
 	return result;
 }
