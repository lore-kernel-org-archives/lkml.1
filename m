Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbZHCMON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbZHCMON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 08:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbZHCMOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 08:14:12 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:34169 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754841AbZHCMOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 08:14:11 -0400
X-Trace: 240114059/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.63.67/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.63.67
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEAK1xdkpPRT9D/2dsb2JhbACBUs4qhBgFgUo
X-IronPort-AV: E=Sophos;i="4.43,314,1246834800"; 
   d="scan'208";a="240114059"
Date: Mon, 3 Aug 2009 13:14:03 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Izik Eidus <ieidus@redhat.com>
cc: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH 5/12] ksm: keep quiet while list empty
In-Reply-To: <Pine.LNX.4.64.0908031304430.16449@sister.anvils>
Message-ID: <Pine.LNX.4.64.0908031313030.16754@sister.anvils>
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ksm_scan_thread already sleeps in wait_event_interruptible until setting
ksm_run activates it; but if there's nothing on its list to look at, i.e.
nobody has yet said madvise MADV_MERGEABLE, it's a shame to be clocking
up system time and full_scans: ksmd_should_run added to check that too.

And move the mutex_lock out around it: the new counts showed that when
ksm_run is stopped, a little work often got done afterwards, because it
had been read before taking the mutex.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 mm/ksm.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

--- ksm4/mm/ksm.c	2009-08-02 13:49:59.000000000 +0100
+++ ksm5/mm/ksm.c	2009-08-02 13:50:07.000000000 +0100
@@ -1287,21 +1287,27 @@ static void ksm_do_scan(unsigned int sca
 	}
 }
 
+static int ksmd_should_run(void)
+{
+	return (ksm_run & KSM_RUN_MERGE) && !list_empty(&ksm_mm_head.mm_list);
+}
+
 static int ksm_scan_thread(void *nothing)
 {
 	set_user_nice(current, 5);
 
 	while (!kthread_should_stop()) {
-		if (ksm_run & KSM_RUN_MERGE) {
-			mutex_lock(&ksm_thread_mutex);
+		mutex_lock(&ksm_thread_mutex);
+		if (ksmd_should_run())
 			ksm_do_scan(ksm_thread_pages_to_scan);
-			mutex_unlock(&ksm_thread_mutex);
+		mutex_unlock(&ksm_thread_mutex);
+
+		if (ksmd_should_run()) {
 			schedule_timeout_interruptible(
 				msecs_to_jiffies(ksm_thread_sleep_millisecs));
 		} else {
 			wait_event_interruptible(ksm_thread_wait,
-					(ksm_run & KSM_RUN_MERGE) ||
-					kthread_should_stop());
+				ksmd_should_run() || kthread_should_stop());
 		}
 	}
 	return 0;
@@ -1346,10 +1352,16 @@ int ksm_madvise(struct vm_area_struct *v
 
 int __ksm_enter(struct mm_struct *mm)
 {
-	struct mm_slot *mm_slot = alloc_mm_slot();
+	struct mm_slot *mm_slot;
+	int needs_wakeup;
+
+	mm_slot = alloc_mm_slot();
 	if (!mm_slot)
 		return -ENOMEM;
 
+	/* Check ksm_run too?  Would need tighter locking */
+	needs_wakeup = list_empty(&ksm_mm_head.mm_list);
+
 	spin_lock(&ksm_mmlist_lock);
 	insert_to_mm_slots_hash(mm, mm_slot);
 	/*
@@ -1361,6 +1373,10 @@ int __ksm_enter(struct mm_struct *mm)
 	spin_unlock(&ksm_mmlist_lock);
 
 	set_bit(MMF_VM_MERGEABLE, &mm->flags);
+
+	if (needs_wakeup)
+		wake_up_interruptible(&ksm_thread_wait);
+
 	return 0;
 }
 
