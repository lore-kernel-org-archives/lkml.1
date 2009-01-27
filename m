Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbZA0HPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbZA0HPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 02:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZA0HPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 02:15:23 -0500
Received: from ozlabs.org ([203.10.76.45]:41472 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbZA0HPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 02:15:22 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Date: Tue, 27 Jan 2009 17:45:18 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       a.p.zijlstra@chello.nl, travis@sgi.com, mingo@redhat.com,
       davej@redhat.com, cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090124001537.7cfde78e.akpm@linux-foundation.org> <20090126215049.GA3493@redhat.com> <20090126221729.GA10215@elte.hu>
In-Reply-To: <20090126221729.GA10215@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901271745.19574.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 January 2009 08:47:29 Ingo Molnar wrote:
> 
> * Oleg Nesterov <oleg@redhat.com> wrote:
> 
> > But "[PATCH 1/3] work_on_cpu: dont try to get_online_cpus() in 
> > work_on_cpu." removes get_online_cpus/put_online_cpus, this means the 
> > work can run on the wrong CPU anyway. Or work_on_cpu() can hang forever 
> > if CPU has already gone away before queue_work_on().
> > 
> > Confused.
> 
> The idea was to require work_on_cpu() users to be CPU hotplug-safe. But 
> ... Rusty pointed it out in the past that this might be fragile, and we 
> could put back the get_online_cpus()/put_online_cpus() calls.

Old code used to do:

	tmp = current->cpus_allowed;
	set_cpus_allowed(current, cpumask_of_cpu(cpu));
	function(arg);
	set_cpus_allowed(current, tmp);

We replaced it with:

	work_on_cpu(cpu, function, arg);

I thought I'd be clever and reliably check that the cpu they asked for
was online inside work_on_cpu.  Leading to locking problems.  But if they
didn't previously ensure cpu hotplug didn't happen, they were buggy already,
so I took out the check and hence the hotplug lock.

So we're no *worse* than we were before, but yes, an audit would probably
lead to fixes.

Hope that clarifies?
Rusty.
