Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbZKBMAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbZKBMAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 07:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZKBMAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 07:00:06 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:62634 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbZKBMAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 07:00:05 -0500
To: nhorman@tuxdriver.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6.32-rc5-git5] synchronize_sched() inside spin_lock()?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200911022100.EAC21893.OMFFJVOSOQHLtF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 2 Nov 2009 21:00:06 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: 4ea7e38696c7e798c47ebbecadfd392f23f814f9

tracepoint_synchronize_unregister() calls synchronize_sched(), but it is
between spin_lock() and spin_unlock(). Is it OK?

static int set_all_monitor_traces(int state)
{
	int rc = 0;
	struct dm_hw_stat_delta *new_stat = NULL;
	struct dm_hw_stat_delta *temp;

	spin_lock(&trace_state_lock);

	switch (state) {
	case TRACE_ON:
		rc |= register_trace_kfree_skb(trace_kfree_skb_hit);
		rc |= register_trace_napi_poll(trace_napi_poll_hit);
		break;
	case TRACE_OFF:
		rc |= unregister_trace_kfree_skb(trace_kfree_skb_hit);
		rc |= unregister_trace_napi_poll(trace_napi_poll_hit);

		tracepoint_synchronize_unregister();

		/*
		 * Clean the device list
		 */
		list_for_each_entry_safe(new_stat, temp, &hw_stats_list, list) {
			if (new_stat->dev == NULL) {
				list_del_rcu(&new_stat->list);
				call_rcu(&new_stat->rcu, free_dm_hw_stat);
			}
		}
		break;
	default:
		rc = 1;
		break;
	}

	if (!rc)
		trace_state = state;

	spin_unlock(&trace_state_lock);

	if (rc)
		return -EINPROGRESS;
	return rc;
}
