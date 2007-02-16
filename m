Return-Path: <linux-kernel-owner+w=401wt.eu-S1945950AbXBPPrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945950AbXBPPrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945949AbXBPPrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:47:55 -0500
Received: from mail.screens.ru ([213.234.233.54]:37212 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945945AbXBPPry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:47:54 -0500
Date: Fri, 16 Feb 2007 18:47:09 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@osdl.org, paulmck@us.ibm.com,
       mingo@elte.hu, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 1/4] freezer-cpu-hotplug core
Message-ID: <20070216154709.GC83@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214194742.GA301@tv-sign.ru> <20070216064825.GA2829@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216064825.GA2829@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Srivatsa Vaddagiri wrote:
>
> On Wed, Feb 14, 2007 at 10:47:42PM +0300, Oleg Nesterov wrote:
> > >  	for (;;) {
> > > -		if (cwq->wq->freezeable)
> > > +		if (cwq->wq->freezeable) {
> > 
> > Else? This is wrong. The change like this should start from making all
> > cwq->threads freezeable, otherwise it just doesn't work.
> 
> I agree we need to have all threads frozen for hotplug.

Well, only multithreaded, strictly speaking.

>                                                          Only exception I
> have found is kthread workqueue, which needs to be active after
> freeze_processes(). stop_machine and CPU_UP_PREPARE/kthread_create()
> depend on it to work.

Yes. That is why I worried about freeze_processes() before CPU_UP_PREPARE.

> A worker thread (like kthread workqueue), which has exempted itself from 
> hotplug-freeze, should essentially be prepared to get preempted any time and 
> made to run on any cpu. If that is the case, do you see any problems in having 
> the if () statement above?

helper_wq ("kthread") is singlethread (see above), but this is not nice to
rely on that. (I am not sure I undestand you though).

> > > +wait_to_die:
> > > +	/* Wait for kthread_stop */
> > > +	set_current_state(TASK_INTERRUPTIBLE);
> > > +	while (!kthread_should_stop()) {
> > > +		schedule();
> > > +		set_current_state(TASK_INTERRUPTIBLE);
> > > +	}
> > > +	__set_current_state(TASK_RUNNING);
> > > +	return 0;
> > >  }
> > 
> > I believe this is not needed, see the comments for the next patch.
> 
> Without this, thread cleanup (cwq->should_stop)/create(CPU_UP_PREPARE) becomes 
> racy

Could you explain? (Again, perhaps you are talking about the old code).

Oleg.

