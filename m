Return-Path: <linux-kernel-owner+w=401wt.eu-S1422642AbXCBA1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422642AbXCBA1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 19:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422650AbXCBA1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 19:27:54 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59382 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422642AbXCBA1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 19:27:53 -0500
Date: Thu, 1 Mar 2007 16:27:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>, Roman Zippel <zippel@linux-m68k.org>,
       Mike Galbraith <efault@gmx.de>, Ken Chen <kenneth.w.chen@intel.com>,
       balducci@units.it, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Fix posix-cpu-timer breakage caused by stale
 p->last_ran value
Message-Id: <20070301162716.81a53b64.akpm@linux-foundation.org>
In-Reply-To: <45E7658A.9060309@redhat.com>
References: <20070221104747.3cb0da32.akpm@linux-foundation.org>
	<1172104409.25076.165.camel@localhost.localdomain>
	<45E7658A.9060309@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Mar 2007 18:45:14 -0500
Chuck Ebbert <cebbert@redhat.com> wrote:

> Thomas Gleixner wrote:
> > Problem description at:
> > http://bugzilla.kernel.org/show_bug.cgi?id=8048
> > 
> > Commit b18ec80396834497933d77b81ec0918519f4e2a7 
> >     [PATCH] sched: improve migration accuracy
> > optimized the scheduler time calculations, but broke posix-cpu-timers.
> > 
> > The problem is that the p->last_ran value is not updated after a context
> > switch. So a subsequent call to current_sched_time() calculates with a
> > stale p->last_ran value, i.e. accounts the full time, which the task was
> > scheduled away.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > 
> > Index: linux-2.6/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched.c
> > +++ linux-2.6/kernel/sched.c
> > @@ -3566,7 +3566,7 @@ switch_tasks:
> >  
> >  	sched_info_switch(prev, next);
> >  	if (likely(prev != next)) {
> > -		next->timestamp = now;
> > +		next->timestamp = next->last_ran = now;
> >  		rq->nr_switches++;
> >  		rq->curr = next;
> >  		++*switch_count;
> > 
> 
> Is this going to be merged or not??

It just hit mainline.
