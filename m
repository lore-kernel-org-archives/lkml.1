Return-Path: <linux-kernel-owner+w=401wt.eu-S1759496AbXGBOeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759496AbXGBOeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbXGBOeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:34:13 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:35833 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbXGBOeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:34:11 -0400
Subject: Re: [RFC/PATCH] debug workqueue deadlocks with lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
       Thomas Sattler <tsattler@gmx.de>
In-Reply-To: <20070630114658.GA344@tv-sign.ru>
References: <1182969638.4769.56.camel@johannes.berg>
	 <1183048429.4089.1.camel@johannes.berg>
	 <1183052001.4089.2.camel@johannes.berg> <1183190728.7932.43.camel@earth4>
	 <20070630114658.GA344@tv-sign.ru>
Content-Type: text/plain
Date: Mon, 02 Jul 2007 15:03:12 +0200
Message-Id: <1183381393.4089.117.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-30 at 15:46 +0400, Oleg Nesterov wrote:

[reordered a bit]

> And,
> 
> >                 if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
> > @@ -376,6 +388,8 @@ void fastcall flush_workqueue(struct wor
> >         int cpu;
> >
> >         might_sleep();
> > +       lock_acquire(&wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
> > +       lock_release(&wq->lockdep_map, 0, _THIS_IP_);
> 
> one of the 2 callers was already modified. Perhaps it is better to add
> lock_acquire() into the second caller, cleanup_workqueue_thread(), but
> skip flush_cpu_workqueue() ?

I see what you mean now, that hunk wasn't supposed to be in my patch, I
wanted to move not copy the code.

> Johannes, could you change wait_on_work() as well? Most users of
> flush_workqueue() should be converted to use it.

I think this could lead to false positives, but then I think we
shouldn't care about those. Let me explain. The thing is that with this
it can happen that the code using the workqueue somehow obeys an
ordering in the work it queues, so as far as I can tell it'd be fine to
have two work items A and B where only B takes a lock L1, and then have
a wait_on_work(A) under L1, if and only if B was always queued right
after A (or something like that). However, since this invariant is
rather likely to be broken by subsequent changes to the code, I think
such code should probably use two workqueues instead, and I doubt it
ever happens anyway since then people could in most cases just put both
works into one function. Hence I included it in my patch below.

> But, perhaps we should not change flush_cpu_workqueue(). If we detect the
> deadlock, we will have num_online_cpus() reports, yes?

The idea here was that it would cover cleanup_workqueue_thread() as
well, but I can equally well just put it there, as below.

Arjan, thanks for your help, this patch seems to work as expected
without the false positive that was my previous dump I showed.

Here's my example rechecked with this new patch:

[  174.639892] =======================================================
[  174.639909] [ INFO: possible circular locking dependency detected ]
[  174.639916] 2.6.22-rc6 #168
[  174.639924] -------------------------------------------------------
[  174.639933] khubd/1927 is trying to acquire lock:
[  174.639940]  (zd1211rw_mac80211#2){--..}, at: [<c000000000060d04>] .flush_workqueue+0x48/0xf4
[  174.639971] 
[  174.639974] but task is already holding lock:
[  174.639982]  (rtnl_mutex){--..}, at: [<c0000000003a47fc>] .mutex_lock+0x3c/0x58
[  174.640016] 
[  174.640018] which lock already depends on the new lock.
[  174.640021] 
[  174.640030] 
[  174.640032] the existing dependency chain (in reverse order) is:
[  174.640040] 
[  174.640042] -> #1 (rtnl_mutex){--..}:
[  174.640065]        [<c0000000000724ac>] .__lock_acquire+0xb8c/0xd68
[  174.640121]        [<c000000000072728>] .lock_acquire+0xa0/0xe8
[  174.640169]        [<c0000000003a4528>] .__mutex_lock_slowpath+0x138/0x3d0
[  174.640216]        [<c0000000003a47fc>] .mutex_lock+0x3c/0x58
[  174.640262]        [<c000000000327284>] .rtnl_lock+0x24/0x40
[  174.640314]        [<d0000000004a91b8>] .ieee80211_sta_work+0xab4/0x1028 [mac80211]
[  174.640401]        [<c00000000005fe20>] .run_workqueue+0x114/0x22c
[  174.640452]        [<c000000000061370>] .worker_thread+0x11c/0x140
[  174.640500]        [<c0000000000662a8>] .kthread+0x84/0xd4
[  174.640549]        [<c0000000000235e8>] .kernel_thread+0x4c/0x68
[  174.640602] 
[  174.640604] -> #0 (zd1211rw_mac80211#2){--..}:
[  174.640634]        [<c00000000007239c>] .__lock_acquire+0xa7c/0xd68
[  174.640683]        [<c000000000072728>] .lock_acquire+0xa0/0xe8
[  174.640732]        [<c000000000060d34>] .flush_workqueue+0x78/0xf4
[  174.640769]        [<d00000000049a330>] .ieee80211_stop+0x1b4/0x35c [mac80211]
[  174.640839]        [<c00000000031b938>] .dev_close+0xb8/0xfc
[  174.640891]        [<c00000000031ba3c>] .unregister_netdevice+0xc0/0x254
[  174.640941]        [<d0000000004aa234>] .__ieee80211_if_del+0x34/0x50 [mac80211]
[  174.641018]        [<d000000000499658>] .ieee80211_unregister_hw+0xf8/0x2d8 [mac80211]
[  174.641089]        [<d00000000045efb0>] .disconnect+0x3c/0x98 [zd1211rw_mac80211]
[  174.641154]        [<d0000000000a9650>] .usb_unbind_interface+0x6c/0xcc [usbcore]
[  174.641248]        [<c00000000027bd54>] .__device_release_driver+0xcc/0x110
[  174.641299]        [<c00000000027c4a8>] .device_release_driver+0x70/0xbc
[  174.641351]        [<c00000000027b2e8>] .bus_remove_device+0xa0/0xcc
[  174.641400]        [<c000000000278368>] .device_del+0x2f4/0x3d4
[  174.641451]        [<d0000000000a5d68>] .usb_disable_device+0xa0/0x150 [usbcore]
[  174.641525]        [<d0000000000a0eac>] .usb_disconnect+0xfc/0x1a4 [usbcore]
[  174.641599]        [<d0000000000a17d4>] .hub_thread+0x3d8/0xc70 [usbcore]
[  174.641673]        [<c0000000000662a8>] .kthread+0x84/0xd4
[  174.641721]        [<c0000000000235e8>] .kernel_thread+0x4c/0x68
[  174.641767] 
[  174.641769] other info that might help us debug this:
[  174.641772] 
[  174.641782] 1 lock held by khubd/1927:
[  174.641791]  #0:  (rtnl_mutex){--..}, at: [<c0000000003a47fc>] .mutex_lock+0x3c/0x58
[  174.641827] 
[  174.641830] stack backtrace:
[  174.641838] Call Trace:
[  174.641848] [c00000007ebab130] [c00000000000f620] .show_stack+0x70/0x1bc (unreliable)
[  174.641879] [c00000007ebab1e0] [c00000000000f78c] .dump_stack+0x20/0x34
[  174.641903] [c00000007ebab260] [c000000000070388] .print_circular_bug_tail+0x84/0xa8
[  174.641930] [c00000007ebab330] [c00000000007239c] .__lock_acquire+0xa7c/0xd68
[  174.641955] [c00000007ebab420] [c000000000072728] .lock_acquire+0xa0/0xe8
[  174.641979] [c00000007ebab4e0] [c000000000060d34] .flush_workqueue+0x78/0xf4
[  174.642002] [c00000007ebab580] [d00000000049a330] .ieee80211_stop+0x1b4/0x35c [mac80211]
[  174.642047] [c00000007ebab640] [c00000000031b938] .dev_close+0xb8/0xfc
[  174.642071] [c00000007ebab6d0] [c00000000031ba3c] .unregister_netdevice+0xc0/0x254
[  174.642096] [c00000007ebab760] [d0000000004aa234] .__ieee80211_if_del+0x34/0x50 [mac80211]
[  174.642147] [c00000007ebab7f0] [d000000000499658] .ieee80211_unregister_hw+0xf8/0x2d8 [mac80211]
[  174.642193] [c00000007ebab8c0] [d00000000045efb0] .disconnect+0x3c/0x98 [zd1211rw_mac80211]
[  174.642227] [c00000007ebab960] [d0000000000a9650] .usb_unbind_interface+0x6c/0xcc [usbcore]
[  174.642277] [c00000007ebaba00] [c00000000027bd54] .__device_release_driver+0xcc/0x110
[  174.642302] [c00000007ebaba90] [c00000000027c4a8] .device_release_driver+0x70/0xbc
[  174.642327] [c00000007ebabb20] [c00000000027b2e8] .bus_remove_device+0xa0/0xcc
[  174.642351] [c00000007ebabbb0] [c000000000278368] .device_del+0x2f4/0x3d4
[  174.642375] [c00000007ebabc50] [d0000000000a5d68] .usb_disable_device+0xa0/0x150 [usbcore]
[  174.642422] [c00000007ebabcf0] [d0000000000a0eac] .usb_disconnect+0xfc/0x1a4 [usbcore]
[  174.642468] [c00000007ebabdb0] [d0000000000a17d4] .hub_thread+0x3d8/0xc70 [usbcore]
[  174.642517] [c00000007ebabf00] [c0000000000662a8] .kthread+0x84/0xd4
[  174.642541] [c00000007ebabf90] [c0000000000235e8] .kernel_thread+0x4c/0x68


I haven't had it report anything else, but I don't hook up many devices
to that particular machine.

---
 include/linux/workqueue.h |   41 ++++++++++++++++++++++++++++++++++++-----
 kernel/workqueue.c        |   17 ++++++++++++++++-
 2 files changed, 52 insertions(+), 6 deletions(-)

--- linux-2.6-git.orig/kernel/workqueue.c	2007-07-02 14:18:44.331427320 +0200
+++ linux-2.6-git/kernel/workqueue.c	2007-07-02 14:37:41.441427320 +0200
@@ -61,6 +61,9 @@ struct workqueue_struct {
 	const char *name;
 	int singlethread;
 	int freezeable;		/* Freeze threads during suspend */
+#ifdef CONFIG_LOCKDEP
+	struct lockdep_map lockdep_map;
+#endif
 };
 
 /* All the per-cpu workqueues on the system, for hotplug cpu to add/remove
@@ -257,7 +260,9 @@ static void run_workqueue(struct cpu_wor
 
 		BUG_ON(get_wq_data(work) != cwq);
 		work_clear_pending(work);
+		lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
 		f(work);
+		lock_release(&cwq->wq->lockdep_map, 0, _THIS_IP_);
 
 		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
 			printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
@@ -376,6 +381,8 @@ void fastcall flush_workqueue(struct wor
 	int cpu;
 
 	might_sleep();
+	lock_acquire(&wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	lock_release(&wq->lockdep_map, 0, _THIS_IP_);
 	for_each_cpu_mask(cpu, *cpu_map)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
@@ -453,6 +460,9 @@ static void wait_on_work(struct work_str
 	wq = cwq->wq;
 	cpu_map = wq_cpu_map(wq);
 
+	lock_acquire(&wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	lock_release(&wq->lockdep_map, 0, _THIS_IP_);
+
 	for_each_cpu_mask(cpu, *cpu_map)
 		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
 }
@@ -683,7 +693,8 @@ static void start_workqueue_thread(struc
 }
 
 struct workqueue_struct *__create_workqueue(const char *name,
-					    int singlethread, int freezeable)
+					    int singlethread, int freezeable,
+					    struct lock_class_key *key)
 {
 	struct workqueue_struct *wq;
 	struct cpu_workqueue_struct *cwq;
@@ -700,6 +711,7 @@ struct workqueue_struct *__create_workqu
 	}
 
 	wq->name = name;
+	lockdep_init_map(&wq->lockdep_map, name, key, 0);
 	wq->singlethread = singlethread;
 	wq->freezeable = freezeable;
 	INIT_LIST_HEAD(&wq->list);
@@ -739,6 +751,9 @@ static void cleanup_workqueue_thread(str
 	if (cwq->thread == NULL)
 		return;
 
+	lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	lock_release(&cwq->wq->lockdep_map, 0, _THIS_IP_);
+
 	/*
 	 * If the caller is CPU_DEAD the single flush_cpu_workqueue()
 	 * is not enough, a concurrent flush_workqueue() can insert a
--- linux-2.6-git.orig/include/linux/workqueue.h	2007-07-02 14:20:28.207427320 +0200
+++ linux-2.6-git/include/linux/workqueue.h	2007-07-02 14:25:35.158427320 +0200
@@ -119,11 +119,42 @@ struct execute_work {
 
 
 extern struct workqueue_struct *__create_workqueue(const char *name,
-						    int singlethread,
-						    int freezeable);
-#define create_workqueue(name) __create_workqueue((name), 0, 0)
-#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1)
-#define create_singlethread_workqueue(name) __create_workqueue((name), 1, 0)
+						   int singlethread,
+						   int freezeable,
+						   struct lock_class_key *key);
+#ifdef CONFIG_LOCKDEP
+#define create_workqueue(name) \
+({								\
+	static struct lock_class_key __key;			\
+	struct workqueue_struct *__wq;				\
+								\
+	__wq = __create_workqueue((name), 0, 0, &__key);	\
+	__wq;							\
+})
+#define create_freezeable_workqueue(name) \
+({								\
+	static struct lock_class_key __key;			\
+	struct workqueue_struct *__wq;				\
+								\
+	__wq = __create_workqueue((name), 1, 1, &__key);	\
+	__wq;							\
+})
+#define create_singlethread_workqueue(name) \
+({								\
+	static struct lock_class_key __key;			\
+	struct workqueue_struct *__wq;				\
+								\
+	__wq = __create_workqueue((name), 1, 0, &__key);	\
+	__wq;							\
+})
+#else
+#define create_workqueue(name) \
+	__create_workqueue((name), 0, 0, NULL)
+#define create_freezeable_workqueue(name) \
+	__create_workqueue((name), 1, 1, NULL)
+#define create_singlethread_workqueue(name) \
+	__create_workqueue((name), 1, 0, NULL)
+#endif
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 


