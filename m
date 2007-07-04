Return-Path: <linux-kernel-owner+w=401wt.eu-S1758991AbXGEIfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991AbXGEIfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 04:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757793AbXGEIfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 04:35:39 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:41912 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757680AbXGEIfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 04:35:38 -0400
Subject: [PATCH] debug work struct cancel deadlocks with lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Sattler <tsattler@gmx.de>
Content-Type: text/plain
Date: Wed, 04 Jul 2007 23:12:09 +0200
Message-Id: <1183583529.9662.34.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a lockdep_map for each work struct in order to debug
deadlocks like
  my_function -> lock(); ...; cancel_work_sync(my_work)
vs.
  run_workqueue() -> my_work.f() -> ...; lock(); ...

which will deadlock if my_work.f() is invoked already but my_function()
has acquired the lock already.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
I don't like the static initialiser for the lockdep_map but don't see a
better way to do it. It works because it does the same things
lockdep_init_map() does when subclass == 0.

I used my mac80211 example and changed flush_workqueue() to
cancel_work_sync(), getting this:

[  411.105999] =======================================================
[  411.132092] [ INFO: possible circular locking dependency detected ]
[  411.144695] 2.6.22-rc7 #175
[  411.157203] -------------------------------------------------------
[  411.169945] khubd/1922 is trying to acquire lock:
[  411.182652]  (&ifsta->work){--..}, at: [<c00000000006d050>] .wait_on_work+0x0/0x180
[  411.195650] 
[  411.195652] but task is already holding lock:
[  411.221293]  (rtnl_mutex){--..}, at: [<c00000000041a3ec>] .mutex_lock+0x3c/0x60
[  411.221599] 
[  411.221601] which lock already depends on the new lock.
[  411.221604] 
[  411.221607] 
[  411.221609] the existing dependency chain (in reverse order) is:
[  411.221613] 
[  411.221614] -> #1 (rtnl_mutex){--..}:
[  411.221620]        [<c000000000081668>] .__lock_acquire+0xc18/0x1110
[  411.221634]        [<c000000000081c00>] .lock_acquire+0xa0/0xf0
[  411.221646]        [<c00000000041a04c>] .__mutex_lock_slowpath+0xdc/0x440
[  411.221657]        [<c00000000041a3ec>] .mutex_lock+0x3c/0x60
[  411.221668]        [<c00000000038dfb4>] .rtnl_lock+0x24/0x40
[  411.221682]        [<d0000000004aff88>] .ieee80211_sta_work+0x848/0x10d0 [mac80211]
[  411.221730]        [<c00000000006c110>] .run_workqueue+0x1f0/0x300
[  411.221742]        [<c00000000006d9cc>] .worker_thread+0xdc/0x1a0
[  411.221754]        [<c00000000007319c>] .kthread+0xcc/0xe0
[  411.221766]        [<c000000000026fd4>] .kernel_thread+0x4c/0x68
[  411.221779] 
[  411.221780] -> #0 (&ifsta->work){--..}:
[  411.221786]        [<c0000000000814e4>] .__lock_acquire+0xa94/0x1110
[  411.221798]        [<c000000000081c00>] .lock_acquire+0xa0/0xf0
[  411.221810]        [<c00000000006d0bc>] .wait_on_work+0x6c/0x180
[  411.221821]        [<c00000000006d6e0>] .cancel_work_sync+0x40/0x80
[  411.221833]        [<d00000000049ff24>] .ieee80211_stop+0x144/0x370 [mac80211]
[  411.221865]        [<c000000000380730>] .dev_close+0xf0/0x140
[  411.221878]        [<c0000000003809a4>] .unregister_netdevice+0x224/0x270
[  411.221891]        [<d0000000004b13c4>] .__ieee80211_if_del+0x34/0x50 [mac80211]
[  411.221924]        [<d00000000049f148>] .ieee80211_unregister_hw+0xf8/0x340 [mac80211]
[  411.221955]        [<d00000000046fbec>] .disconnect+0x3c/0xa0 [zd1211rw_mac80211]
[  411.221981]        [<d0000000000add3c>] .usb_unbind_interface+0x6c/0xe0 [usbcore]
[  411.222032]        [<c0000000002ccc1c>] .__device_release_driver+0xbc/0x110
[  411.222045]        [<c0000000002cd4c4>] .device_release_driver+0x64/0xd0
[  411.222057]        [<c0000000002cc0c0>] .bus_remove_device+0x90/0xe0
[  411.222068]        [<c0000000002c8b9c>] .device_del+0x20c/0x3e0
[  411.222082]        [<d0000000000a9c04>] .usb_disable_device+0xd4/0x1b0 [usbcore]
[  411.222116]        [<d0000000000a4518>] .usb_disconnect+0xf8/0x1b0 [usbcore]
[  411.222151]        [<d0000000000a5048>] .hub_thread+0x4d8/0xe00 [usbcore]
[  411.222184]        [<c00000000007319c>] .kthread+0xcc/0xe0
[  411.222197]        [<c000000000026fd4>] .kernel_thread+0x4c/0x68
[  411.222209] 
[  411.222211] other info that might help us debug this:
[  411.222213] 
[  411.222217] 1 lock held by khubd/1922:
[  411.222220]  #0:  (rtnl_mutex){--..}, at: [<c00000000041a3ec>] .mutex_lock+0x3c/0x60
[  411.222231] 
[  411.222232] stack backtrace:
[  411.222236] Call Trace:
[  411.222240] [c00000000f872f90] [c00000000001054c] .show_stack+0x6c/0x1e0 (unreliable)
[  411.222253] [c00000000f873040] [c0000000000106e0] .dump_stack+0x20/0x40
[  411.222263] [c00000000f8730c0] [c00000000007ef94] .print_circular_bug_tail+0xb4/0xe0
[  411.222274] [c00000000f873190] [c0000000000814e4] .__lock_acquire+0xa94/0x1110
[  411.222284] [c00000000f873290] [c000000000081c00] .lock_acquire+0xa0/0xf0
[  411.222294] [c00000000f873350] [c00000000006d0bc] .wait_on_work+0x6c/0x180
[  411.222304] [c00000000f873490] [c00000000006d6e0] .cancel_work_sync+0x40/0x80
[  411.222314] [c00000000f873520] [d00000000049ff24] .ieee80211_stop+0x144/0x370 [mac80211]
[  411.222344] [c00000000f8735e0] [c000000000380730] .dev_close+0xf0/0x140
[  411.222355] [c00000000f873670] [c0000000003809a4] .unregister_netdevice+0x224/0x270
[  411.222365] [c00000000f873710] [d0000000004b13c4] .__ieee80211_if_del+0x34/0x50 [mac80211]
[  411.222397] [c00000000f8737a0] [d00000000049f148] .ieee80211_unregister_hw+0xf8/0x340 [mac80211]
[  411.222427] [c00000000f873860] [d00000000046fbec] .disconnect+0x3c/0xa0 [zd1211rw_mac80211]
[  411.222447] [c00000000f873900] [d0000000000add3c] .usb_unbind_interface+0x6c/0xe0 [usbcore]
[  411.222481] [c00000000f8739a0] [c0000000002ccc1c] .__device_release_driver+0xbc/0x110
[  411.222491] [c00000000f873a30] [c0000000002cd4c4] .device_release_driver+0x64/0xd0
[  411.222500] [c00000000f873ac0] [c0000000002cc0c0] .bus_remove_device+0x90/0xe0
[  411.222509] [c00000000f873b50] [c0000000002c8b9c] .device_del+0x20c/0x3e0
[  411.222520] [c00000000f873c00] [d0000000000a9c04] .usb_disable_device+0xd4/0x1b0 [usbcore]
[  411.222553] [c00000000f873ca0] [d0000000000a4518] .usb_disconnect+0xf8/0x1b0 [usbcore]
[  411.222585] [c00000000f873d50] [d0000000000a5048] .hub_thread+0x4d8/0xe00 [usbcore]
[  411.222618] [c00000000f873ef0] [c00000000007319c] .kthread+0xcc/0xe0
[  411.222628] [c00000000f873f90] [c000000000026fd4] .kernel_thread+0x4c/0x68


---
 include/linux/workqueue.h |   33 +++++++++++++++++++++++++++++++++
 kernel/workqueue.c        |   17 ++++++++++++++++-
 2 files changed, 49 insertions(+), 1 deletion(-)

--- linux-2.6-git.orig/include/linux/workqueue.h	2007-07-04 21:29:59.357544144 +0200
+++ linux-2.6-git/include/linux/workqueue.h	2007-07-04 22:15:40.455811173 +0200
@@ -28,6 +28,9 @@ struct work_struct {
 #define WORK_STRUCT_WQ_DATA_MASK (~WORK_STRUCT_FLAG_MASK)
 	struct list_head entry;
 	work_func_t func;
+#ifdef CONFIG_LOCKDEP
+	struct lockdep_map lockdep_map;
+#endif
 };
 
 #define WORK_DATA_INIT()	ATOMIC_LONG_INIT(0)
@@ -41,10 +44,29 @@ struct execute_work {
 	struct work_struct work;
 };
 
+#ifdef CONFIG_LOCKDEP
+/*
+ * HACK! This really should call lockdep_init_map() but can't
+ * because there's no requirement to initialise work structs
+ * at runtime. This works because subclass == 0.
+ *
+ * NB: because we have to copy the lockdep_map, setting .key
+ * here is required!
+ */
+#define __WORK_INIT_LOCKDEP_MAP(n, k)				\
+	.lockdep_map = {					\
+		.name = n,					\
+		.key = (void*) k,				\
+	},
+#else
+#define __WORK_INIT_LOCKDEP_MAP(n, k)
+#endif
+
 #define __WORK_INITIALIZER(n, f) {				\
 	.data = WORK_DATA_INIT(),				\
 	.entry	= { &(n).entry, &(n).entry },			\
 	.func = (f),						\
+	__WORK_INIT_LOCKDEP_MAP(#n, &(n))			\
 	}
 
 #define __DELAYED_WORK_INITIALIZER(n, f) {			\
@@ -76,12 +98,23 @@ struct execute_work {
  * assignment of the work data initializer allows the compiler
  * to generate better code.
  */
+#ifdef CONFIG_LOCKDEP
 #define INIT_WORK(_work, _func)						\
 	do {								\
+		static struct lock_class_key __key;			\
 		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
+		lockdep_init_map(&(_work)->lockdep_map, #_work, &__key, 0);\
 		INIT_LIST_HEAD(&(_work)->entry);			\
 		PREPARE_WORK((_work), (_func));				\
 	} while (0)
+#else
+#define INIT_WORK(_work, _func)						\
+	do {								\
+		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
+		INIT_LIST_HEAD(&(_work)->entry);			\
+		PREPARE_WORK((_work), (_func));				\
+	} while (0)
+#endif
 
 #define INIT_DELAYED_WORK(_work, _func)				\
 	do {							\
--- linux-2.6-git.orig/kernel/workqueue.c	2007-07-04 21:29:59.412544144 +0200
+++ linux-2.6-git/kernel/workqueue.c	2007-07-04 22:16:49.001811173 +0200
@@ -253,7 +253,17 @@ static void run_workqueue(struct cpu_wor
 		struct work_struct *work = list_entry(cwq->worklist.next,
 						struct work_struct, entry);
 		work_func_t f = work->func;
-
+#ifdef CONFIG_LOCKDEP
+		/*
+		 * It is permissible to free the struct work_struct
+		 * from inside the function that is called from it,
+		 * this we need to take into account for lockdep too.
+		 * To avoid bogus "held lock freed" warnings as well
+		 * as problems when looking into work->lockdep_map,
+		 * make a copy and use that here.
+		 */
+		struct lockdep_map lockdep_map = work->lockdep_map;
+#endif
 		cwq->current_work = work;
 		list_del_init(cwq->worklist.next);
 		spin_unlock_irq(&cwq->lock);
@@ -261,7 +271,9 @@ static void run_workqueue(struct cpu_wor
 		BUG_ON(get_wq_data(work) != cwq);
 		work_clear_pending(work);
 		lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+		lock_acquire(&lockdep_map, 0, 0, 0, 2, _THIS_IP_);
 		f(work);
+		lock_release(&lockdep_map, 1, _THIS_IP_);
 		lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
 
 		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
@@ -453,6 +465,9 @@ static void wait_on_work(struct work_str
 
 	might_sleep();
 
+	lock_acquire(&work->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	lock_release(&work->lockdep_map, 1, _THIS_IP_);
+
 	cwq = get_wq_data(work);
 	if (!cwq)
 		return;


