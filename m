Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbYIVEEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbYIVEEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 00:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbYIVEEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 00:04:10 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36636 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbYIVEEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 00:04:08 -0400
From: Krishna Kumar <krkumar2@in.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: krkumar2@in.ibm.com, Krishna Kumar <krkumar2@in.ibm.com>
Date: Mon, 22 Sep 2008 09:34:04 +0530
Message-Id: <20080922040404.10477.24678.sendpatchset@localhost.localdomain>
Subject: [PATCH 0/2] workqueue: Two API's to update delayed works quickly
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krishna Kumar <krkumar2@in.ibm.com>

Implement two API's for quickly updating delayed works:
	void schedule_update_delayed_work(struct delayed_work *dwork,
					  unsigned long delay);
	void queue_update_delayed_work(struct workqueue_struct *wq,
				       struct delayed_work *dwork,
				       unsigned long delay);

These API's are useful to update an existing work entry more efficiently (but
can be used to queue a new work entry too) when the operation is done very
frequently. The rationale is to save time of first cancelling work/timer and
adding work/timer when the same work is added many times in quick succession.
An additional optimization is to do nothing when events are queued within 1
jiffy past the expiry time. However this can result in the work being queue'd
upto 1 jiffy before the minimum time requested (but if another request comes 1
jiffy or more later, the work expires at the correct time). The assumption
behind this optimization is that the work scheduled doesn't require 100%
accuracy at the expense of performance. But if that is a faulty assumption, the
'time_in_range()' call can be changed to 'jiffies + delay == timer->expires'.

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
	   Time saved is all of above, plus avoid cancelling and re-adding. The
	   results below are testing this case (with HZ = 1000).

1. queue_delayed_work+cancel vs queue_update_delayed_work on 1 cpu. Queue the
   same entry on same cpu serially - do this many times.
	Laptop (Xeon 2 cpu): Saves 83.7%
		ORG: Time: 41654
		NEW: Time: 6804
	Server (x86-64, 4 cpu): Saves 93.8%
		ORG: Time: 211488
		NEW: Time: 13187
2. queue_delayed_work+cancel vs queue_update_delayed_work on 'N' cpus in
   parallel. Queue 'N' different entries on 'N' cpu's in paralle - do this
   many times.
	Laptop (Xeon 2 cpu): Saves 95.7%
		ORG: Time: 146064, 182160
		NEW: Time: 7014, 7045
	Server (x86-64, 4 cpu): Saves 93.7%
		ORG: Time: 165255, 225159, 227658, 237000
		NEW: Time: 13446, 13449, 13455, 13477
3. schedule_delayed_work+cancel vs schedule_update_delayed_work on 1 cpu.
   Queue the same entry on same cpu serially - do this many times.
	Laptop (Xeon 2 cpu): Saves 83.3%
		ORG: Time: 41878
		NEW: Time: 6987
	Server (x86-64, 4 cpu): Saves 92.3%
		ORG: Time: 184893
		NEW: Time: 14205
4. schedule_delayed_work+cancel vs schedule_update_delayed_work on 'N' cpus in
   parallel. Queue 'N' different entries on 'N' cpu's in parallel - do this
   many times.
	Laptop (Xeon 2 cpu): Saves 95.73%
		ORG: Time: 145147, 180987
		NEW: Time: 6955, 6958
	Server (x86-64, 4 cpu): Saves 94.5%
		ORG: Time: 165031, 263509, 277071, 321099
		NEW: Time: 14211, 14211, 14216, 14242

[PATCH 1/2]: Implement the kernel API's
[PATCH 2/2]: Modify some drivers to use the new APIs instead of the old ones

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
---
