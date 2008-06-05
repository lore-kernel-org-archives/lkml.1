Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbYFEP2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbYFEP2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 11:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbYFEP1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 11:27:51 -0400
Received: from smtp2.sssup.it ([193.205.80.100]:54467 "EHLO smtp2.sssup.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757645AbYFEP1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:27:49 -0400
X-Greylist: delayed 2438 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2008 11:27:48 EDT
Date: Thu, 5 Jun 2008 16:57:03 +0200
From: Michael Trimarchi <trimarchimichael@yahoo.it>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: fabio@gandalf.sssup.it, Max Krasnyansky <maxk@qualcomm.com>,
       Mark Hounschell <dmarkh@cfl.rr.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Oeser <ioe-lkml@rameria.de>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, "Derek L. Fults" <dfults@sgi.com>,
       devik <devik@cdi.cz>, Dimitri Sivanich <sivanich@sgi.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>, "Randy.Dunlap" <rddunlap@osdl.org>,
       suresh.b.siddha@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Dario <faggioli@gandalf.sssup.it>
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may have realtime uses)
Message-ID: <20080605145703.GD56022@gandalf.sssup.it>
References: <933603.75777.qm@web26206.mail.ukl.yahoo.com> <1212667660.23439.42.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212667660.23439.42.camel@twins>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Thu, Jun 05, 2008 02:07:40PM +0200
>
> On Thu, 2008-06-05 at 11:16 +0000, Michael Trimarchi wrote:
...
> > By now I'm facing some problems.  I still have not clear what
> > parameters a task forked from a sched_edf task should get, as it would
> > involve some form of admission control, 
> 
> I'd start with something like:
> 
> u64 sched_param::edf_period  [ns]
> u64 sched_param::edf_runtime [ns]
> 
> so that deadline = time_of_schedule + edf_period, and his allowance
> within that period is edf_runtime.
> 

This is what I'm doing right now (apart from using timespec structs
instead of u64 values to align the sched_param struct specified by
POSIX on systems with SCHED_SPORADIC support).

I'll clean up the code and post it here in the next few days.


> fork would inherit the parent's settings, and we'd need to do admission
> control on all tasks entering SCHED_EDF, either through setscheduler()
> or fork(). We could fail with -ENOTIME or somesuch error.
> 
> > and how to deal with tasks that run longer than their nominal
> > execution time (i.e., should we use some server mechanism to limit the
> > amount of cpu they're using, or handle that in some other way?)
> 
> Yeah - we already account the amount of runtime, we can send them
> SIGXCPU and stop running them. Look at the rt_bandwidth code upstream -
> it basically stops rt task groups from running once their quota is
> depleted - waking them up once it gets refreshed due to the period
> expiring.
> 
> For single tasks its easier, just account their time and dequeue them
> once it exceeds the quota, and enqueue them on a refresh timer thingy to
> start them again once the period rolls over.
> 

Ok, using the same mechanism even for SCHED_EDF tasks seems the
right way to go.


> The only tricky bit here is PI :-) it would need to keep running despite
> being over quota.
> 

There is some work in this area, and there are some protocols
handling that, but that simple solution will be a good starting
point.
