Return-Path: <linux-kernel-owner+w=401wt.eu-S1765603AbZFQLTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765603AbZFQLTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 07:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbZFQLTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 07:19:09 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:60908 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbZFQLTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 07:19:08 -0400
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] TOMOYO: Add garbage collector support. (v3)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200906172019.EAE00032.OLOJFQVMtFOFSH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 17 Jun 2009 20:19:07 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This patchset adds garbage collector for TOMOYO.
This time, I'm using some sort of RCU-like approach instead of cookie-list
approach.

TOMOYO 1/3: Move sleeping operations to outside the semaphore.
6 files changed, 231 insertions(+), 345 deletions(-)

TOMOYO 2/3: Replace tomoyo_save_name() with tomoyo_get_name()/tomoyo_put_name().
5 files changed, 70 insertions(+), 23 deletions(-)

TOMOYO 3/3: Add RCU-like garbage collector.
7 files changed, 733 insertions(+), 358 deletions(-)

Paul E. McKenney wrote ( http://lkml.org/lkml/2009/5/27/2 ) :
> I would also recommend the three-part LWN series as a starting point:
> 
> #       http://lwn.net/Articles/262464/ (What is RCU, Fundamentally?)
> #       http://lwn.net/Articles/263130/ (What is RCU's Usage?)
> #       http://lwn.net/Articles/264090/ (What is RCU's API?)
I've read these articles. They are very good.

I came up with an idea that we may be able to implement GC while readers are
permitted to sleep but no read locks are required.

The idea is to have two counters which hold the number of readers currently
reading the list, one is active and the other is inactive. Reader increments
the currently active counter before starts reading and decrements that counter
after finished reading. GC swaps active counter and inactive counter and waits
for previously active counter's count to become 0 before releasing elements
removed from the list.
Code is shown below.

atomic_t users_counter[2];
atomic_t users_counter_idx;
DEFINE_MUTEX(updator_mutex);
DEFINE_MUTEX(gc_mutex);

--- reader ---
{
	/* Get counter index. */
	int idx = atomic_read(&users_counter_idx);
	/* Lock counter. */
	atomic_inc(&users_counter[idx]);
	list_for_each_entry_rcu() {
		... /* Allowed to sleep. */
	}
	/* Unlock counter. */
	atomic_dec(&users_counter[idx]);
}

--- writer ---
{
	bool found = false;
	/* Get lock for writing. */
	mutex_lock(&updater_mutex);
	list_for_each_entry_rcu() {
		if (...)
			continue;
		found = true;
		break;
	}
	if (!found)
		list_add_rcu(element);
	/* Release lock for writing. */
	mutex_unlock(&updater_mutex);
}

--- garbage collector ---
{
	bool element_deleted = false;
	/* Protect the counters from concurrent GC threads. */
	mutex_lock(&gc_mutex);
	/* Get lock for writing. */
	mutex_lock(&updater_mutex);
	list_for_each_entry_rcu() {
		if (...)
			continue;
		list_del_rcu(element);
		element_deleted = true;
		break;
	}
	/* Release lock for writing. */
	mutex_unlock(&updater_mutex);
	if (element_deleted) {
		/* Swap active counter. */
		const int idx = atomic_read(&users_counter_idx);
		atomic_set(&users_counter_idx, idx ^ 1);
		/*
		 * Wait for readers who are using previously active counter.
		 * This is similar to synchronize_rcu() while this code allows
		 * readers to do operations which may sleep.
		 */
		while (atomic_read(&users_counter[idx]))
			msleep(1000);
		/*
		 * Nobody is using previously active counter.
		 * Ready to release memory of elements removed before
		 * previously active counter became inactive.
		 */
		kfree(element);
	}
	mutex_unlock(&gc_mutex);
}

In this idea, GC's kfree() call may be deferred for unknown duration, but
defer duration will not matter if we use a dedicated kernel thread for GC.

I noticed that there is QRCU in the "RCU has a Family of Wait-to-Finish APIs"
section. My idea seems to resemble QRCU except grace periods.
But "Availability" field is empty. Oh, what happened to QRCU?

Regards.
