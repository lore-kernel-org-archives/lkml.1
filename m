Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbYI2HDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbYI2HDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 03:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYI2HDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 03:03:17 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:35508 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbYI2HDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 03:03:16 -0400
From: Krishna Kumar <krkumar2@in.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Krishna Kumar <krkumar2@in.ibm.com>
Date: Mon, 29 Sep 2008 12:33:02 +0530
Message-Id: <20080929070302.7386.72726.sendpatchset@localhost.localdomain>
Subject: [REV2: PATCH 0/2] workqueue: Two API's to update delayed works quickly
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krishna Kumar <krkumar2@in.ibm.com>

Implement two API's for quickly updating delayed works:
	int schedule_update_delayed_work(struct delayed_work *dwork,
					  unsigned long delay);
	int queue_update_delayed_work(struct workqueue_struct *wq,
				       struct delayed_work *dwork,
				       unsigned long delay);

I tested the following combinations, after Oleg suggested some improvements:
	A. - Original submission.
		1 CPU -> Org: 474213	New: 55365	Time saved: 88.3%
		4 CPU -> Org: 3650631	New: 225160	Time saved: 93.8%
	B1. - Oleg's suggestion to avoid costly __cancel_work_timer.
		1 CPU -> Org: 474213	New: 233714	Time saved: 50.7%
		4 CPU -> Org: 3650631	New: 959455	Time saved: 73.7%
	B2. - B1 + check for same expiry.
		1 CPU -> Org: 474213	New: 72276	Time saved: 84.8%
		4 CPU -> Org: 3650631	New: 301510	Time saved: 91.7%
	C. - Merge Oleg's idea with code A.
		1 CPU -> Org: 474213	New: 55160	Time saved: 88.4%
		4 CPU -> Org: 3650631	New: 215369	Time saved: 94.1%

Merged code seems to perform the best, though the difference with the original
submission is only marginal. Code snippets below with comments removed:

A: Original submission:
-----------------------
void queue_update_delayed_work(struct workqueue_struct *wq,
			       struct delayed_work *dwork, unsigned long delay)
{
	struct work_struct *work = &dwork->work;

	if (likely(test_and_set_bit(WORK_STRUCT_PENDING,
				    work_data_bits(work)))) {
		struct timer_list *timer = &dwork->timer;

		if (jiffies + delay == timer->expires)
			return;

		__cancel_work_timer_internal(work, timer);
	}

	__queue_delayed_work(-1, dwork, work, wq, delay);
}

B1: Oleg suggestion:
------------------------
(I optimized a bit as parallel updates are not important, only one needs to
succeed)

int queue_update_delayed_work(struct workqueue_struct *wq,
			      struct delayed_work *dwork, unsigned long delay)
{
	unsigned long when = jiffies + delay;

	if (queue_delayed_work(wq, dwork, delay))
		return 1;

	if (update_timer_expiry(&dwork->timer, when))
		return 0;

	cancel_work_sync(&dwork->work);
	queue_delayed_work(wq, dwork, delay);
	return 0;
}

B2: B1 + extra check:
---------------------
int queue_update_delayed_work(struct workqueue_struct *wq,
			      struct delayed_work *dwork, unsigned long delay)
{
	unsigned long when = jiffies + delay;

	if (queue_delayed_work(wq, dwork, delay))
		return 1;

	if (when == dwork->timer.expires ||
	    update_timer_expiry(&dwork->timer, when))
		return 0;

	cancel_work_sync(&dwork->work);
	queue_delayed_work(wq, dwork, delay);
	return 0;
}

C: Combined code:
-----------------
int queue_update_delayed_work(struct workqueue_struct *wq,
			      struct delayed_work *dwork, unsigned long delay)
{
	struct work_struct *work = &dwork->work;

	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
		__queue_delayed_work(-1, dwork, work, wq, delay);
		return 1;
	} else {
		struct timer_list *timer = &dwork->timer;
		unsigned long when = jiffies + delay;
		int ret;

		if (timer->expires == when)
			return 0;

		do {
			if (likely(update_timer_expiry(timer, when)))
				return 0;

			ret = try_to_grab_pending(work);
			if (ret < 0)
				wait_on_work(work);
		} while (ret < 0);

		__queue_delayed_work(-1, dwork, work, wq, delay);
		return 0;
	}
}

I am submitting the merged code. Please review and provide feedback.

Thanks

- KK

[PATCH 1/2]: Implement the kernel API's
[PATCH 2/2]: Modify some drivers to use the new APIs instead of the old ones

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
---

(Description of the patches from first submission:
These API's are useful to update an existing work entry more efficiently (but
can be used to queue a new work entry too) when the operation is done very
frequently. The rationale is to save time of first cancelling work/timer and
adding work/timer when the same work is added many times in quick succession.

queue_update_delayed_work_on() and schedule_update_delayed_work_on() are not
implemented as there are no users which can take advantage of these variations.

Example possible users (FS's, wireless drivers):
------------------------------------------------
	lbs_scan_networks, nfs4_renew_state, ocfs2_schedule_truncate_log_flush,
	nfs4_schedule_state_renewal, afs_flush_callback_breaks, afs_reap_server,
	afs_purge_servers, afs_vlocation_reaper, afs_vlocation_purge,
	o2hb_arm_write_timeout, lbs_scan_networks, isr_indicate_rf_kill,
	lbs_postpone_association_work, isr_scan_complete, ipw_radio_kill_sw,
	 __ipw_led_activity_on, ipw_radio_kill_sw, ds2760_battery_resume, etc.

Performance (numbers in jiffies):
---------------------------------
These API's are useful in following cases:
	a. add followed by cancel+add with long period between the add's. Time
	   saved is the time to clear and re-setting the WORK_STRUCT_PENDING
	   bit, plus the reduction of one API call.
	b. add followed by cancel+add with very short time between the add's.
	   Time saved is all of above, plus avoid cancelling and re-adding.
)
