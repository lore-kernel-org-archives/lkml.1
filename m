Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbZBKJax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbZBKJax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 04:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbZBKJao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 04:30:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36752 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbZBKJan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 04:30:43 -0500
Date: Wed, 11 Feb 2009 10:30:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jason Baron <jbaron@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, lenb@kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: PATCH] ftrace: Add a C/P state tracer to help power
	optimization
Message-ID: <20090211093029.GC14265@elte.hu>
References: <20081006102640.481acd23@infradead.org> <20081027155920.GS5704@elte.hu> <20081027110522.6cb7b142@infradead.org> <y0m3aihx1kd.fsf@ton.toronto.redhat.com> <20081027140630.521f933d@infradead.org> <20090210205747.GA3114@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210205747.GA3114@redhat.com>
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


* Jason Baron <jbaron@redhat.com> wrote:

> On Mon, Oct 27, 2008 at 02:06:30PM -0700, Arjan van de Ven wrote:
> > > Arjan van de Ven <arjan@infradead.org> writes:
> > > 
> > > > [...]
> > > > --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > > > +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > > > [...]
> > > > @@ -427,6 +429,8 @@ static int acpi_cpufreq_target(struct
> > > > cpufreq_policy *policy, }
> > > >  	}
> > > >  
> > > > +	trace_power_mark(&it, POWER_PSTATE, next_perf_state);
> > > > +
> > > >  	switch (data->cpu_feature) {
> > > >  	case SYSTEM_INTEL_MSR_CAPABLE:
> > > >  		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
> > > > [...]
> > > 
> > > Is there some reason that this doesn't use tracepoints instead
> > > of such a single-backend hook?
> > 
> > because it's a ton simpler this way? do simple things simpe and all
> > that....
> > 
> 
> hi,
> 
> I wrote a patch to make c/p state tracer dependent on tracepoints and
> then realized that the discussion had already been had. However, the
> patch to use tracepoints is fairly simple, allows for other consumers,
> and avoids a function call in the off case. please consider.
> 
> thanks,
> 
> -Jason
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> ---
> 
>  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    3 +++
>  arch/x86/kernel/process.c                  |    4 ++++
>  include/linux/ftrace.h                     |   15 ---------------
>  include/trace/power.h                      |   18 ++++++++++++++++++
>  kernel/trace/trace_power.c                 |   28 ++++++++++++++++++++--------
>  5 files changed, 45 insertions(+), 23 deletions(-)
>  create mode 100644 include/trace/power.h

Looks good, but could you please base this on latest -tip? There's a number of 
pending changes in the tracing tree that conflict:

patching file arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
Hunk #1 FAILED at 34.
1 out of 2 hunks FAILED -- rejects in file 
arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
patching file arch/x86/kernel/process.c
Hunk #1 FAILED at 9.
1 out of 2 hunks FAILED -- rejects in file arch/x86/kernel/process.c
patching file include/linux/ftrace.h
Hunk #1 FAILED at 342.
1 out of 1 hunk FAILED -- rejects in file include/linux/ftrace.h
The next patch would create the file include/trace/power.h,
which already exists!  Applying it anyway.
patching file include/trace/power.h
Patch attempted to create file include/trace/power.h, which already exists.
Hunk #1 FAILED at 1.
1 out of 1 hunk FAILED -- rejects in file include/trace/power.h
patching file kernel/trace/trace_power.c
Hunk #1 FAILED at 14.
Hunk #2 succeeded at 111 (offset 1 line).
Hunk #4 succeeded at 148 (offset -5 lines).
Hunk #5 succeeded at 183 (offset -6 lines).
1 out of 5 hunks FAILED -- rejects in file kernel/trace/trace_power.c

See:

  http://people.redhat.com/mingo/tip.git/README

	Ingo
