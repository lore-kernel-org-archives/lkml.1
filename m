Return-Path: <linux-kernel-owner+w=401wt.eu-S1762273AbXF1Ji4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762273AbXF1Ji4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 05:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbXF1Jir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 05:38:47 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:57715 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbXF1Jip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 05:38:45 -0400
Subject: [RFC/PATCH] debug workqueue deadlocks with lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 27 Jun 2007 20:40:38 +0200
Message-Id: <1182969638.4769.56.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a fake lock to each workqueue in order to debug things
where you have something like

  my_function() -> lock(); ...; flush_workqueue(); ...
vs
  run_workqueue() -> my_work() -> ...; lock(); ...

which can obviously deadlock if my_work is scheduled when my_function()
is invoked (but hasn't locked yet.)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I'm not sure if this is correct on SMP because then might it complain
that the fake lock is locked at the same time from multiple CPUs? I
haven't (on my quad G5), however, had it print out anything but the
trace below which is legitimate.

This is sort of a regression test for an actual deadlock in mac80211 I
found by experiencing it, apparently it's really hard to trigger. Then I
wanted to see if I could add lockdep support to debug cases like it.
Here's the output with my patch:

[  171.522236] =======================================================
[  171.522248] [ INFO: possible circular locking dependency detected ]
[  171.522257] 2.6.22-rc6 #163
[  171.522266] -------------------------------------------------------
[  171.522275] khubd/1922 is trying to acquire lock:
[  171.522283]  (khelper){--..}, at: [<c000000000060c8c>] .flush_workqueue+0x48/0xf4
[  171.522318] 
[  171.522320] but task is already holding lock:
[  171.522330]  (rtnl_mutex){--..}, at: [<c0000000003a4784>] .mutex_lock+0x3c/0x58
[  171.522366] 
[  171.522368] which lock already depends on the new lock.
[  171.522371] 
[  171.522383] 
[  171.522386] the existing dependency chain (in reverse order) is:
[  171.522396] 
[  171.522398] -> #1 (rtnl_mutex){--..}:
[  171.522424]        [<c000000000072434>] .__lock_acquire+0xb8c/0xd68
[  171.522476]        [<c0000000000726b0>] .lock_acquire+0xa0/0xe8
[  171.522527]        [<c0000000003a44b0>] .__mutex_lock_slowpath+0x138/0x3d0
[  171.522579]        [<c0000000003a4784>] .mutex_lock+0x3c/0x58
[  171.522629]        [<c000000000327208>] .rtnl_lock+0x24/0x40
[  171.522677]        [<c000000000328fb4>] .linkwatch_event+0x20/0x70
[  171.522725]        [<c00000000005fe38>] .run_workqueue+0x114/0x22c
[  171.522774]        [<c0000000000612f8>] .worker_thread+0x11c/0x140
[  171.522822]        [<c000000000066230>] .kthread+0x84/0xd4
[  171.522872]        [<c0000000000235ec>] .kernel_thread+0x4c/0x68
[  171.522922] 
[  171.522924] -> #0 (khelper){--..}:
[  171.522947]        [<c000000000072324>] .__lock_acquire+0xa7c/0xd68
[  171.523000]        [<c0000000000726b0>] .lock_acquire+0xa0/0xe8
[  171.523051]        [<c000000000060cbc>] .flush_workqueue+0x78/0xf4
[  171.523102]        [<d000000000498374>] .ieee80211_stop+0x1fc/0x3a4 [mac80211]
[  171.523176]        [<c00000000031b8bc>] .dev_close+0xb8/0xfc
[  171.523222]        [<c00000000031b9c0>] .unregister_netdevice+0xc0/0x254
[  171.523275]        [<d0000000004a828c>] .__ieee80211_if_del+0x34/0x50 [mac80211]
[  171.523352]        [<d000000000497654>] .ieee80211_unregister_hw+0xf8/0x2d8 [mac80211]
[  171.523421]        [<d00000000045cfa8>] .disconnect+0x3c/0x98 [zd1211rw_mac80211]
[  171.523483]        [<d0000000000ff650>] .usb_unbind_interface+0x6c/0xcc [usbcore]
[  171.523555]        [<c00000000027bcdc>] .__device_release_driver+0xcc/0x110
[  171.523605]        [<c00000000027c430>] .device_release_driver+0x70/0xbc
[  171.523655]        [<c00000000027b270>] .bus_remove_device+0xa0/0xcc
[  171.523708]        [<c0000000002782f0>] .device_del+0x2f4/0x3d4
[  171.523758]        [<d0000000000fbd68>] .usb_disable_device+0xa0/0x150 [usbcore]
[  171.523833]        [<d0000000000f6eac>] .usb_disconnect+0xfc/0x1a4 [usbcore]
[  171.523907]        [<d0000000000f77d4>] .hub_thread+0x3d8/0xc70 [usbcore]
[  171.523984]        [<c000000000066230>] .kthread+0x84/0xd4
[  171.524039]        [<c0000000000235ec>] .kernel_thread+0x4c/0x68
[  171.524093] 
[  171.524096] other info that might help us debug this:
[  171.524099] 
[  171.524109] 1 lock held by khubd/1922:
[  171.524117]  #0:  (rtnl_mutex){--..}, at: [<c0000000003a4784>] .mutex_lock+0x3c/0x58
[  171.524155] 
[  171.524157] stack backtrace:
[  171.524165] Call Trace:
[  171.524174] [c0000000086af130] [c00000000000f624] .show_stack+0x70/0x1bc (unreliable)
[  171.524203] [c0000000086af1e0] [c00000000000f790] .dump_stack+0x20/0x34
[  171.524228] [c0000000086af260] [c000000000070310] .print_circular_bug_tail+0x84/0xa8
[  171.524256] [c0000000086af330] [c000000000072324] .__lock_acquire+0xa7c/0xd68
[  171.524281] [c0000000086af420] [c0000000000726b0] .lock_acquire+0xa0/0xe8
[  171.524307] [c0000000086af4e0] [c000000000060cbc] .flush_workqueue+0x78/0xf4
[  171.524332] [c0000000086af580] [d000000000498374] .ieee80211_stop+0x1fc/0x3a4 [mac80211]
[  171.524376] [c0000000086af640] [c00000000031b8bc] .dev_close+0xb8/0xfc
[  171.524401] [c0000000086af6d0] [c00000000031b9c0] .unregister_netdevice+0xc0/0x254
[  171.524425] [c0000000086af760] [d0000000004a828c] .__ieee80211_if_del+0x34/0x50 [mac80211]
[  171.524475] [c0000000086af7f0] [d000000000497654] .ieee80211_unregister_hw+0xf8/0x2d8 [mac80211]
[  171.524522] [c0000000086af8c0] [d00000000045cfa8] .disconnect+0x3c/0x98 [zd1211rw_mac80211]
[  171.524558] [c0000000086af960] [d0000000000ff650] .usb_unbind_interface+0x6c/0xcc [usbcore]
[  171.524611] [c0000000086afa00] [c00000000027bcdc] .__device_release_driver+0xcc/0x110
[  171.524635] [c0000000086afa90] [c00000000027c430] .device_release_driver+0x70/0xbc
[  171.524662] [c0000000086afb20] [c00000000027b270] .bus_remove_device+0xa0/0xcc
[  171.524687] [c0000000086afbb0] [c0000000002782f0] .device_del+0x2f4/0x3d4
[  171.524713] [c0000000086afc50] [d0000000000fbd68] .usb_disable_device+0xa0/0x150 [usbcore]
[  171.524763] [c0000000086afcf0] [d0000000000f6eac] .usb_disconnect+0xfc/0x1a4 [usbcore]
[  171.524811] [c0000000086afdb0] [d0000000000f77d4] .hub_thread+0x3d8/0xc70 [usbcore]
[  171.524860] [c0000000086aff00] [c000000000066230] .kthread+0x84/0xd4
[  171.524887] [c0000000086aff90] [c0000000000235ec] .kernel_thread+0x4c/0x68

[actually from a previous version of the patch]

In the actual case I experienced #1 wasn't from linkwatch_event() but
from something else in mac80211 but they both do rtnl_lock().

And finally, the patch:

---
 kernel/workqueue.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- linux-2.6-git.orig/kernel/workqueue.c	2007-06-27 19:10:35.183199046 +0200
+++ linux-2.6-git/kernel/workqueue.c	2007-06-27 20:30:00.896667168 +0200
@@ -61,8 +61,15 @@ struct workqueue_struct {
 	const char *name;
 	int singlethread;
 	int freezeable;		/* Freeze threads during suspend */
+#ifdef CONFIG_LOCKDEP
+	struct lockdep_map lockdep_map;
+#endif
 };
 
+#ifdef CONFIG_LOCKDEP
+static struct lock_class_key wq_lockdep_key;
+#endif
+
 /* All the per-cpu workqueues on the system, for hotplug cpu to add/remove
    threads to each one as cpus come/go. */
 static DEFINE_MUTEX(workqueue_mutex);
@@ -257,7 +264,9 @@ static void run_workqueue(struct cpu_wor
 
 		BUG_ON(get_wq_data(work) != cwq);
 		work_clear_pending(work);
+		lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
 		f(work);
+		lock_release(&cwq->wq->lockdep_map, 0, _THIS_IP_);
 
 		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
 			printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
@@ -342,6 +351,9 @@ static int flush_cpu_workqueue(struct cp
 	} else {
 		struct wq_barrier barr;
 
+		lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+		lock_release(&cwq->wq->lockdep_map, 0, _THIS_IP_);
+
 		active = 0;
 		spin_lock_irq(&cwq->lock);
 		if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
@@ -376,6 +388,8 @@ void fastcall flush_workqueue(struct wor
 	int cpu;
 
 	might_sleep();
+	lock_acquire(&wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	lock_release(&wq->lockdep_map, 0, _THIS_IP_);
 	for_each_cpu_mask(cpu, *cpu_map)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
@@ -700,6 +714,9 @@ struct workqueue_struct *__create_workqu
 	}
 
 	wq->name = name;
+#ifdef CONFIG_LOCKDEP
+	lockdep_init_map(&wq->lockdep_map, name, &wq_lockdep_key, 0);
+#endif
 	wq->singlethread = singlethread;
 	wq->freezeable = freezeable;
 	INIT_LIST_HEAD(&wq->list);


