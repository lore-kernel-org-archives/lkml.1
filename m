Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbZKBXd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbZKBXd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 18:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757288AbZKBXdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 18:33:55 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:38047 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261AbZKBXdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 18:33:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=fF9CfpydML58ySDMCTy8Z0bGzvsdqFa65TUEdNA3pGntCdlJQ93qF5qFvLZGXzHH1F
         CO6TLdbDKAQ1ujQNiZ/a9u4H9s7xhyIa7GSj+Ey4vvQb8DlEMErSsuz2lpwPc0O9mzLg
         50bUwHzVQq7r0MeeJ0DObR4AK++ZB8JK7cwhg=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [2.6.32-rc5-git5] synchronize_sched() inside spin_lock()?
Date: Mon, 2 Nov 2009 15:33:46 -0800
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc5; KDE/4.3.2; x86_64; ; )
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, nhorman@tuxdriver.com,
       linux-kernel@vger.kernel.org
References: <200911022100.EAC21893.OMFFJVOSOQHLtF@I-love.SAKURA.ne.jp> <20091102223028.GB6795@linux.vnet.ibm.com>
In-Reply-To: <20091102223028.GB6795@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911021533.46413.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 November 2009 02:30:28 pm Paul E. McKenney wrote:
> On Mon, Nov 02, 2009 at 09:00:06PM +0900, Tetsuo Handa wrote:
> > Commit: 4ea7e38696c7e798c47ebbecadfd392f23f814f9
> >
> > tracepoint_synchronize_unregister() calls synchronize_sched(), but it is
> > between spin_lock() and spin_unlock(). Is it OK?
> 
> Calling synchronize_sched() while holding a spinlock would indeed be
> very bad, but the code below seems to instead be invoking call_rcu(),
> which is no problem.
> 
> Or am I missing something here?
> 
> 							Thanx, Paul
> 
> > static int set_all_monitor_traces(int state)
> > {
> > 	int rc = 0;
> > 	struct dm_hw_stat_delta *new_stat = NULL;
> > 	struct dm_hw_stat_delta *temp;
> >
> > 	spin_lock(&trace_state_lock);
> >
> > 	switch (state) {
> > 	case TRACE_ON:
> > 		rc |= register_trace_kfree_skb(trace_kfree_skb_hit);
> > 		rc |= register_trace_napi_poll(trace_napi_poll_hit);
> > 		break;
> > 	case TRACE_OFF:
> > 		rc |= unregister_trace_kfree_skb(trace_kfree_skb_hit);
> > 		rc |= unregister_trace_napi_poll(trace_napi_poll_hit);
> >
> > 		tracepoint_synchronize_unregister();

This has synchronize_sched() inside.


-- 
Dmitry
