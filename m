Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbYLDJZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbYLDJZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 04:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYLDJZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 04:25:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47335 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494AbYLDJZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 04:25:16 -0500
Date: Thu, 4 Dec 2008 10:24:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ken Chen <kenchen@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] export percpu cpuacct cgroup stats
Message-ID: <20081204092454.GK32594@elte.hu>
References: <b040c32a0812032048x4a11dc26k184a4b279b509050@mail.gmail.com> <49376BE3.1040909@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49376BE3.1040909@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> (I guess it's more appropriate to ask Ingo to pick up this patch)
> 
> Ken Chen wrote:
> > This patch export per-cpu CPU cycle usage for a given cpuacct cgroup.
> > There is a need for a user space monitor daemon to track group CPU
> > usage on per-cpu base.  It is also useful for monitor CFS load
> > balancer behavior by tracking per CPU group usage.
> > 
> > 
> > Signed-off-by: Ken Chen <kenchen@google.com>
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index b7480fb..cd78948 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -9345,12 +9345,34 @@ out:
> >  	return err;
> >  }
> > 
> > +static int cpuacct_percpu_seq_read(struct cgroup *cgroup, struct cftype *cft,
> > +				   struct seq_file *m)
> > +{
> > +	struct cpuacct *ca = cgroup_ca(cgroup);
> > +	u64 percpu;
> > +	int i;
> > +
> > +	for_each_possible_cpu(i) {
> > +		spin_lock_irq(&cpu_rq(i)->lock);
> > +		percpu = *percpu_ptr(ca->cpuusage, i);
> > +		spin_unlock_irq(&cpu_rq(i)->lock);
> > +		seq_printf(m, "%lld ", percpu);
> 
> Should be %llu. And if we don't cast percpu to unsigned long long, will 
> it trigger compile warning in some archs?

yes.

> > +	}
> > +	seq_printf(m, "\n");
> > +	return 0;
> > +}
> > +
> >  static struct cftype files[] = {
> >  	{
> >  		.name = "usage",
> >  		.read_u64 = cpuusage_read,
> >  		.write_u64 = cpuusage_write,
> >  	},
> > +	{
> > +		.name = "percpu",
> 
> IMO percpu_usage is a better name.

agreed. Looks good otherwise - will wait for v2 of the patch.

	Ingo
