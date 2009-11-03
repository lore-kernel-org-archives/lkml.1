Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbZKCAzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbZKCAzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 19:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757423AbZKCAzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 19:55:18 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40505 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757422AbZKCAzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 19:55:18 -0500
Date: Mon, 2 Nov 2009 16:55:22 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, nhorman@tuxdriver.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.32-rc5-git5] synchronize_sched() inside spin_lock()?
Message-ID: <20091103005522.GD6795@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200911022100.EAC21893.OMFFJVOSOQHLtF@I-love.SAKURA.ne.jp> <20091102223028.GB6795@linux.vnet.ibm.com> <200911021533.46413.dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911021533.46413.dmitry.torokhov@gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 03:33:46PM -0800, Dmitry Torokhov wrote:
> On Monday 02 November 2009 02:30:28 pm Paul E. McKenney wrote:
> > On Mon, Nov 02, 2009 at 09:00:06PM +0900, Tetsuo Handa wrote:
> > > Commit: 4ea7e38696c7e798c47ebbecadfd392f23f814f9
> > >
> > > tracepoint_synchronize_unregister() calls synchronize_sched(), but it is
> > > between spin_lock() and spin_unlock(). Is it OK?
> > 
> > Calling synchronize_sched() while holding a spinlock would indeed be
> > very bad, but the code below seems to instead be invoking call_rcu(),
> > which is no problem.
> > 
> > Or am I missing something here?
> > 
> > 							Thanx, Paul
> > 
> > > static int set_all_monitor_traces(int state)
> > > {
> > > 	int rc = 0;
> > > 	struct dm_hw_stat_delta *new_stat = NULL;
> > > 	struct dm_hw_stat_delta *temp;
> > >
> > > 	spin_lock(&trace_state_lock);
> > >
> > > 	switch (state) {
> > > 	case TRACE_ON:
> > > 		rc |= register_trace_kfree_skb(trace_kfree_skb_hit);
> > > 		rc |= register_trace_napi_poll(trace_napi_poll_hit);
> > > 		break;
> > > 	case TRACE_OFF:
> > > 		rc |= unregister_trace_kfree_skb(trace_kfree_skb_hit);
> > > 		rc |= unregister_trace_napi_poll(trace_napi_poll_hit);
> > >
> > > 		tracepoint_synchronize_unregister();
> 
> This has synchronize_sched() inside.

Ah!  That would indeed be bad.

							Thanx, Paul
