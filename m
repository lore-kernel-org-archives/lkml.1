Return-Path: <linux-kernel-owner+w=401wt.eu-S1751925AbZIOJRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbZIOJRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbZIOJRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:17:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:23131 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbZIOJRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:17:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,388,1249282800"; 
   d="scan'208";a="187734615"
Date: Tue, 15 Sep 2009 17:17:00 +0800
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] hrtimers: Remove the "timer_stats_active" check when
 setting the start info
Message-ID: <20090915171700.5669bb59@feng-desktop>
In-Reply-To: <alpine.LFD.2.00.0909151056160.8957@localhost.localdomain>
References: <20090903163253.1d846628@feng-desktop>
	<alpine.LFD.2.00.0909151056160.8957@localhost.localdomain>
Organization: intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009 17:00:09 +0800
Thomas Gleixner <tglx@linutronix.de> wrote:

> > 
> > Recent hrtimer code will set the start info to a hrtimer only when
> > that flag is set, then the start info of all hrtimers will always
> > be uninitialised before a "echo 1 > /proc/timer_stats", thus
> > the /proc/timer_lists will have something like:
> > 
> > active timers:
> >  #0: <c27d46b0>, tick_sched_timer, S:01, <(null)>, /-1
> >  # expires at 91062000000-91062000000 nsecs [in 156071 to 156071
> > nsecs] #1: <efb81b6c>, hrtimer_wakeup, S:01, <(null)>, /-1
> >  # expires at 91062300331-91062350331 nsecs [in 456402 to 506402
> > nsecs] #2: <efac9b6c>, hrtimer_wakeup, S:01, <(null)>, /-1
> >  # expires at 91068699811-91068749811 nsecs [in 6855882 to 6905882
> > nsecs] #3: <efacdb6c>, hrtimer_wakeup, S:01, <(null)>, /-1
> >  # expires at 91068755511-91068805511 nsecs [in 6911582 to 6961582
> > nsecs] #4: <efa95b6c>, hrtimer_wakeup, S:01, <(null)>, /-1
> >  # expires at 91068806066-91068856066 nsecs [in 6962137 to 7012137
> > nsecs] .....
> > 
> > This patch will fix it.
> 
> Well, at the same time it forces the memcpy when !timer_stats_active.
> We generally want to avoid such overhead when debug facilities are
> disabled.

I understand the performance point, that's why I add a check line trying
to avoid unnecessary copy (yes, the check itself will bring some overload):
 
 void __timer_stats_hrtimer_set_start_info(struct hrtimer *timer, void *addr)
 {
-       if (timer->start_site)
+       if (timer->start_site == addr && timer->start_pid == current->pid)
                return;

Also there is one corner case, that a hrtimer get initialized and queued in
before setting timer_stats_active to 1, but get run after that. Then its
start_site will be NULL which will prevent it from being accounted. 

Thanks,
Feng


