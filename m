Return-Path: <linux-kernel-owner+w=401wt.eu-S932262Ab0AFPm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab0AFPm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 10:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496Ab0AFPm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 10:42:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33243 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab0AFPm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 10:42:26 -0500
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org, "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.1001050802401.3630@localhost.localdomain>
References: <20100104182429.833180340@chello.nl>
	 <20100104182813.753545361@chello.nl>
	 <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com>
	 <alpine.LFD.2.00.1001041904250.3630@localhost.localdomain>
	 <1262681834.2400.31.camel@laptop>
	 <alpine.LFD.2.00.1001050727400.3630@localhost.localdomain>
	 <20100105154047.GA18217@ZenIV.linux.org.uk>
	 <alpine.LFD.2.00.1001050802401.3630@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 16:41:26 +0100
Message-ID: <1262792486.4049.31.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-05 at 08:10 -0800, Linus Torvalds wrote:

> You _can_ handle it (make the RCU callback just schedule the work instead 
> of doing it directly), but it does sound really nasty. I suspect we should 
> explore just about any other approach over this one. 

Agreed, scheduling work also has the bonus that sync rcu doesn't quite
do what you expect it to etc..

Anyway, the best I could come up with is something like the below, I
tried to come up with something that would iterate mm->cpu_vm_mask, but
since faults can schedule that doesn't work out.

Iterating the full thread group seems like a mighty expensive thing to
do in light of these massive thread freaks like Java and Google.

Will ponder things more...

---
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1277,6 +1277,7 @@ struct task_struct {
 	struct plist_node pushable_tasks;
 
 	struct mm_struct *mm, *active_mm;
+	struct vm_area_struct *fault_vma;
 
 /* task state */
 	int exit_state;
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c
+++ linux-2.6/mm/memory.c
@@ -3157,6 +3157,7 @@ int handle_speculative_fault(struct mm_s
 		goto out_unmap;
 
 	entry = *pte;
+	rcu_assign_pointer(current->fault_vma, vma);
 
 	if (read_seqcount_retry(&vma->vm_sequence, seq))
 		goto out_unmap;
@@ -3167,6 +3168,7 @@ int handle_speculative_fault(struct mm_s
 	ret = handle_pte_fault(mm, vma, address, entry, pmd, flags, seq);
 
 out_unlock:
+	rcu_assign_pointer(current->fault_vma, NULL);
 	rcu_read_unlock();
 	return ret;
 
Index: linux-2.6/mm/mmap.c
===================================================================
--- linux-2.6.orig/mm/mmap.c
+++ linux-2.6/mm/mmap.c
@@ -235,6 +235,27 @@ static void free_vma(struct vm_area_stru
 	call_rcu(&vma->vm_rcu_head, free_vma_rcu);
 }
 
+static void sync_vma(struct vm_area_struct *vma)
+{
+	struct task_struct *t;
+	int block = 0;
+
+	if (!vma->vm_file)
+		return;
+
+	rcu_read_lock();
+	for (t = current; (t = next_thread(t)) != current; ) {
+		if (rcu_dereference(t->fault_vma) == vma) {
+			block = 1;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	if (block)
+		synchronize_rcu();
+}
+
 /*
  * Close a vm structure and free it, returning the next.
  */
@@ -243,6 +264,7 @@ static struct vm_area_struct *remove_vma
 	struct vm_area_struct *next = vma->vm_next;
 
 	might_sleep();
+	sync_vma(vma);
 	if (vma->vm_ops && vma->vm_ops->close)
 		vma->vm_ops->close(vma);
 	if (vma->vm_file) {


