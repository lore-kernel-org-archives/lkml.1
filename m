Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbYJXNnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbYJXNnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 09:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYJXNm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 09:42:57 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:33129 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbYJXNm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 09:42:57 -0400
Date: Fri, 24 Oct 2008 19:11:56 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       travis@sgi.com, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH 1/7] work_on_cpu: helper for doing task on a CPU.
Message-ID: <20081024134156.GA6045@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20081023005751.53973DDEFE@ozlabs.org> <20081023094036.GA7593@redhat.com> <20081023143605.GN5255@in.ibm.com> <200810241404.35932.rusty@rustcorp.com.au> <20081024072147.GA5000@in.ibm.com> <20081024102957.GC4583@redhat.com> <20081024114018.GA24080@in.ibm.com> <20081024132509.GB17708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024132509.GB17708@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 03:25:09PM +0200, Oleg Nesterov wrote:
> On 10/24, Gautham R Shenoy wrote:
> >
> > Having a rule that we shouldn't use work_on_cpu() in cpu-hotplug path
> > is a good thing. But maintaining it can be difficult.
> >
> > We've seen that in the past with the cpucontrol mutex.
> > We had clear rules that functions which get called in
> > cpu-hotplug callback paths, shouldn't take this mutex. But with
> > functions that were called in the cpu-hotplug notifier
> > path as well as normal paths, it created a whole locking mess,
> > and took quite some time to fix.
> >
> > Similarly, right now, we can have a BUG_ON() which notifies us whenever
> > someone ends up calling a function that invokes work_on_cpu() from the
> > CPU-Hotplug callpath. But we will fix it only when the BUG_ON() is hit.
> >
> > On the other hand, if we have a mechanism that's guaranteed to work
> > irrespective of the callpaths, why not use that ?
> 
> If we add another wq for work_on_cpu(), then we add another hard-to-maintain
> rule: get_online_cpus() must not be used by any work which can be queued
> on that wq. And, yet another per-cpu thread...

No, we don't have that rule!

Because using Rusty's function with a seperate workqueue,
we queue the work item as follows:

	 get_online_cpus();
	 queue_work_on(cpu, &on_each_cpu_wq, &wfc.work);
	 flush_work(&wfc.work);
	 put_online_cpus();

The very fact that we've successfully queued the work-item means that
no cpu-hotplug operation can occur till our work item finishes
execution.

Hence the work can use get_online_cpus()!

Yes, we end up using additional resources in the form of another per-cpu
threads. But is that so much of an issue?

> 
> Personally I don't even think we need a BUG_ON() in work_on_cpu(), because
> I don't think cpu-hotplug path is so special.
> 
> Not that I have a strong opinion though.
> 
> Oleg.

-- 
Thanks and Regards
gautham
