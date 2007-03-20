Return-Path: <linux-kernel-owner+w=401wt.eu-S933458AbXCTJd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458AbXCTJd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 05:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933461AbXCTJd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 05:33:27 -0400
Received: from mx2.go2.pl ([193.17.41.42]:38361 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933458AbXCTJd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 05:33:26 -0400
Date: Tue, 20 Mar 2007 10:37:53 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       "J\. Bruce Fields" <bfields@fieldses.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Re: [2.6.20] BUG: workqueue leaked lock
Message-ID: <20070320093753.GA1751@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17918.11420.155569.991473@notabene.brown>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19-03-2007 07:24, Neil Brown wrote:
> On Friday March 16, akpm@linux-foundation.org wrote:
>> OK.  That's not necessarily a bug: one could envisage a (weird) piece of
>> code which takes a lock then releases it on a later workqueue invokation. 
>> But I'm not sure that nfs4_laundromat() is actually supposed to be doing
>> anything like that.
>>
>> Then again, maybe it is: it seems to be waddling through a directory under
>> the control of a little state machine, with timeouts.
>>
>> Neil: help?
> 
> I'm quite certain that laundromat_main does *not* leave client_mutex
> locked as the last thing it does is call nfs4_unlock_state which is
> 	mutex_unlock(&client_mutex);
> To me, that raises some doubt about whether the lock leak check is
> working properly...
> It is somewhat harder to track locking of i_mutex, but it seems to me
> that every time it is taken, it is released again shortly afterwards.
> 
> So I think this must be a problem with leak detection, not with NFSd.
> 
> NeilBrown
> 
> 
>> On Fri, 16 Mar 2007 09:41:20 +0100 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>>
>>> On Thu, 2007-03-15 at 11:06 -0800, Andrew Morton wrote:
>>>>> On Tue, 13 Mar 2007 17:50:14 +0100 Folkert van Heusden <folkert@vanheusden.com> wrote:
>>>>> ...
>>>>> [ 1756.728209] BUG: workqueue leaked lock or atomic: nfsd4/0x00000000/3577
>>>>> [ 1756.728271]     last function: laundromat_main+0x0/0x69 [nfsd]
>>>>> [ 1756.728392] 2 locks held by nfsd4/3577:
>>>>> [ 1756.728435]  #0:  (client_mutex){--..}, at: [<c1205b88>] mutex_lock+0x8/0xa
>>>>> [ 1756.728679]  #1:  (&inode->i_mutex){--..}, at: [<c1205b88>] mutex_lock+0x8/0xa
>>>>> [ 1756.728923]  [<c1003d57>] show_trace_log_lvl+0x1a/0x30
>>>>> [ 1756.729015]  [<c1003d7f>] show_trace+0x12/0x14
>>>>> [ 1756.729103]  [<c1003e79>] dump_stack+0x16/0x18
>>>>> [ 1756.729187]  [<c102c2e8>] run_workqueue+0x167/0x170
>>>>> [ 1756.729276]  [<c102c437>] worker_thread+0x146/0x165
>>>>> [ 1756.729368]  [<c102f797>] kthread+0x97/0xc4
>>>>> [ 1756.729456]  [<c1003bdb>] kernel_thread_helper+0x7/0x10
>>>>> [ 1756.729547]  =======================
...
>>> I think I'm responsible for this message (commit
>>> d5abe669172f20a4129a711de0f250a4e07db298); what is says is that the
>>> function executed by the workqueue (here laundromat_main) leaked an
>>> atomic context or is still holding locks (2 locks in this case).

This check is valid with keventd, but it looks like nfsd runs
kthread by itself. I'm not sure it's illegal to hold locks then,
so, if I'm not wrong with this, here is my patch proposal (for
testing) to take this into consideration.

Reported-by: Folkert van Heusden <folkert@vanheusden.com>
Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>

---

diff -Nurp 2.6.21-rc4-git4-/kernel/workqueue.c 2.6.21-rc4-git4/kernel/workqueue.c
--- 2.6.21-rc4-git4-/kernel/workqueue.c	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.21-rc4-git4/kernel/workqueue.c	2007-03-20 09:30:46.000000000 +0100
@@ -316,6 +316,7 @@ static void run_workqueue(struct cpu_wor
 		struct work_struct *work = list_entry(cwq->worklist.next,
 						struct work_struct, entry);
 		work_func_t f = work->func;
+		int ld;
 
 		list_del_init(cwq->worklist.next);
 		spin_unlock_irqrestore(&cwq->lock, flags);
@@ -323,13 +324,15 @@ static void run_workqueue(struct cpu_wor
 		BUG_ON(get_wq_data(work) != cwq);
 		if (!test_bit(WORK_STRUCT_NOAUTOREL, work_data_bits(work)))
 			work_release(work);
+		ld = lockdep_depth(current);
+
 		f(work);
 
-		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
+		if (unlikely(in_atomic() || (ld -= lockdep_depth(current)))) {
 			printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
-					"%s/0x%08x/%d\n",
+					"%s/0x%08x/%d/%d\n",
 					current->comm, preempt_count(),
-				       	current->pid);
+				       	current->pid, ld);
 			printk(KERN_ERR "    last function: ");
 			print_symbol("%s\n", (unsigned long)f);
 			debug_show_held_locks(current);
