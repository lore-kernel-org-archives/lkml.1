Return-Path: <linux-kernel-owner+w=401wt.eu-S1423366AbXBPGse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423366AbXBPGse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 01:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423367AbXBPGse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 01:48:34 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41437 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423366AbXBPGsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 01:48:33 -0500
Date: Fri, 16 Feb 2007 12:18:25 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@osdl.org, paulmck@us.ibm.com,
       mingo@elte.hu, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 1/4] freezer-cpu-hotplug core
Message-ID: <20070216064825.GA2829@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214194742.GA301@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214194742.GA301@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 10:47:42PM +0300, Oleg Nesterov wrote:
> >  	for (;;) {
> > -		if (cwq->wq->freezeable)
> > +		if (cwq->wq->freezeable) {
> 
> Else? This is wrong. The change like this should start from making all
> cwq->threads freezeable, otherwise it just doesn't work.

I agree we need to have all threads frozen for hotplug. Only exception I
have found is kthread workqueue, which needs to be active after
freeze_processes(). stop_machine and CPU_UP_PREPARE/kthread_create()
depend on it to work.

A worker thread (like kthread workqueue), which has exempted itself from 
hotplug-freeze, should essentially be prepared to get preempted any time and 
made to run on any cpu. If that is the case, do you see any problems in having 
the if () statement above?

> > +wait_to_die:
> > +	/* Wait for kthread_stop */
> > +	set_current_state(TASK_INTERRUPTIBLE);
> > +	while (!kthread_should_stop()) {
> > +		schedule();
> > +		set_current_state(TASK_INTERRUPTIBLE);
> > +	}
> > +	__set_current_state(TASK_RUNNING);
> > +	return 0;
> >  }
> 
> I believe this is not needed, see the comments for the next patch.

Without this, thread cleanup (cwq->should_stop)/create(CPU_UP_PREPARE) becomes 
racy 

-- 
Regards,
vatsa
