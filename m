Return-Path: <linux-kernel-owner+w=401wt.eu-S1760389AbYDBTGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389AbYDBTGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758927AbYDBTGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:06:32 -0400
Received: from relay2.sgi.com ([192.48.171.30]:43049 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759298AbYDBTGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:06:31 -0400
Date: Wed, 2 Apr 2008 12:03:50 -0700 (PDT)
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
Subject: EMM: Fixup return value handling of emm_notify()
In-Reply-To: <Pine.LNX.4.64.0804021048460.27214@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0804021202450.28436@schroedinger.engr.sgi.com>
References: <20080401205531.986291575@sgi.com> <20080401205635.793766935@sgi.com>
 <20080402064952.GF19189@duo.random> <Pine.LNX.4.64.0804021048460.27214@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Christoph Lameter wrote:

> Here f.e. We can add a special emm_age() function that iterates 
> differently and does the | for you.

Well maybe not really necessary. How about this fix? Its likely a problem 
to stop callbacks if one callback returned an error.


Subject: EMM: Fixup return value handling of emm_notify()

Right now we stop calling additional subsystems if one callback returned
an error. That has the potential for causing additional trouble with the
subsystems that do not receive the callbacks they expect if one has failed.

So change the handling of error code to continue callbacks to other
subsystems but return the first error code encountered.

If a callback returns a positive return value then add up all the value
from all the calls. That can be used to establish how many references
exist (xpmem may want this feature at some point) or ensure that the
aging works the way Andrea wants it to (KVM, XPmem so far do not
care too much).

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/rmap.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c	2008-04-02 11:46:20.738342852 -0700
+++ linux-2.6/mm/rmap.c	2008-04-02 12:03:57.672494320 -0700
@@ -299,27 +299,45 @@ void emm_notifier_register(struct emm_no
 }
 EXPORT_SYMBOL_GPL(emm_notifier_register);
 
-/* Perform a callback */
+/*
+ * Perform a callback
+ *
+ * The return of this function is either a negative error of the first
+ * callback that failed or a consolidated count of all the positive
+ * values that were returned by the callbacks.
+ */
 int __emm_notify(struct mm_struct *mm, enum emm_operation op,
 		unsigned long start, unsigned long end)
 {
 	struct emm_notifier *e = rcu_dereference(mm->emm_notifier);
 	int x;
+	int result = 0;
 
 	while (e) {
-
 		if (e->callback) {
 			x = e->callback(e, mm, op, start, end);
-			if (x)
-				return x;
+
+			/*
+			 * Callback may return a positive value to indicate a count
+			 * or a negative error code. We keep the first error code
+			 * but continue to perform callbacks to other subscribed
+			 * subsystems.
+			 */
+			if (x && result >= 0) {
+				if (x >= 0)
+					result += x;
+				else
+					result = x;
+			}
 		}
+
 		/*
 		 * emm_notifier contents (e) must be fetched after
 		 * the retrival of the pointer to the notifier.
 		 */
 		e = rcu_dereference(e->next);
 	}
-	return 0;
+	return result;
 }
 EXPORT_SYMBOL_GPL(__emm_notify);
 #endif
