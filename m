Return-Path: <linux-kernel-owner+w=401wt.eu-S932525AbZKBWaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525AbZKBWaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 17:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932408AbZKBWaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 17:30:24 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40857 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387AbZKBWaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 17:30:24 -0500
Date: Mon, 2 Nov 2009 14:30:28 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: nhorman@tuxdriver.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.32-rc5-git5] synchronize_sched() inside spin_lock()?
Message-ID: <20091102223028.GB6795@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200911022100.EAC21893.OMFFJVOSOQHLtF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911022100.EAC21893.OMFFJVOSOQHLtF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 09:00:06PM +0900, Tetsuo Handa wrote:
> Commit: 4ea7e38696c7e798c47ebbecadfd392f23f814f9
> 
> tracepoint_synchronize_unregister() calls synchronize_sched(), but it is
> between spin_lock() and spin_unlock(). Is it OK?

Calling synchronize_sched() while holding a spinlock would indeed be
very bad, but the code below seems to instead be invoking call_rcu(),
which is no problem.

Or am I missing something here?

							Thanx, Paul

> static int set_all_monitor_traces(int state)
> {
> 	int rc = 0;
> 	struct dm_hw_stat_delta *new_stat = NULL;
> 	struct dm_hw_stat_delta *temp;
> 
> 	spin_lock(&trace_state_lock);
> 
> 	switch (state) {
> 	case TRACE_ON:
> 		rc |= register_trace_kfree_skb(trace_kfree_skb_hit);
> 		rc |= register_trace_napi_poll(trace_napi_poll_hit);
> 		break;
> 	case TRACE_OFF:
> 		rc |= unregister_trace_kfree_skb(trace_kfree_skb_hit);
> 		rc |= unregister_trace_napi_poll(trace_napi_poll_hit);
> 
> 		tracepoint_synchronize_unregister();
> 
> 		/*
> 		 * Clean the device list
> 		 */
> 		list_for_each_entry_safe(new_stat, temp, &hw_stats_list, list) {
> 			if (new_stat->dev == NULL) {
> 				list_del_rcu(&new_stat->list);
> 				call_rcu(&new_stat->rcu, free_dm_hw_stat);
> 			}
> 		}
> 		break;
> 	default:
> 		rc = 1;
> 		break;
> 	}
> 
> 	if (!rc)
> 		trace_state = state;
> 
> 	spin_unlock(&trace_state_lock);
> 
> 	if (rc)
> 		return -EINPROGRESS;
> 	return rc;
> }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
