Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbZBTRsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbZBTRsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbZBTRsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:48:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44935 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334AbZBTRsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:48:21 -0500
Date: Fri, 20 Feb 2009 18:48:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>, Avi Kivity <avi@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
Message-ID: <20090220174811.GL24538@elte.hu>
References: <499edf47.1818d00a.060b.2b8d@mx.google.com> <499EE162.4050008@oracle.com> <20090220172241.GF24538@elte.hu> <20090220173107.GH5732@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220173107.GH5732@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > > >  config MARKERS
> > > >  	bool "Activate markers"
> > > > -	depends on TRACEPOINTS
> > > > +	select TRACEPOINTS
> > > >  	help
> > > >  	  Place an empty function call at each marker site. Can be
> > > >  	  dynamically changed for a probe function.
> > > 
> > > but using "select" instead of "depends on" just causes the 
> > > kind of problem that you described, whereas using "depends on" 
> > > does follow dependency chains.
> > 
> > Well, as long as the secondary selects are 'expanded' along the 
> > line of dependencies, it should still be fine. With an 
> > increasing number of dependencies it quickly becomes ugly 
> > though. This might be one of the cases where it works.
> > 
> > Eventually we should eliminate markers, their uses can either be 
> > converted to new-style tracepoints, or to ftrace_printk().
> > 
> > 	Ingo
> 
> ftrace_printk adds more overhead if not used since it 
> inconditionally send the trace, unless the related 
> TRACE_ITER_PRINTK flag on ftrace is unset.
> 
> I don't know how markers work, but the documentation describes 
> that a single branch check is done in case the probe is 
> disabled.
> 
> With ftrace_printk, even if TRACE_ITER_PRINTK is unset, this 
> is still one call and one branch check. So for hot callsite 
> it's unappropriate.
> 
> IMHO, tracepoints are more suited to replace markers if they 
> have to.

there's i think the KVM usecase where markers are used 
essentially a printk()-alike flexible tracing facility.

This is how KVMTRACE looks like at the moment:

./vmx.c:	KVMTRACE_3D(MSR_READ, vcpu, ecx, (u32)data, (u32)(data >> 32),
./vmx.c:	KVMTRACE_3D(MSR_WRITE, vcpu, ecx, (u32)data, (u32)(data >> 32),
./vmx.c:	KVMTRACE_0D(PEND_INTR, vcpu, handler);
./vmx.c:	KVMTRACE_3D(VMEXIT, vcpu, exit_reason, (u32)kvm_rip_read(vcpu),
./vmx.c:		KVMTRACE_0D(NMI, vcpu, handler);
./lapic.c:	KVMTRACE_1D(APIC_ACCESS, apic->vcpu, (u32)offset, handler);
./lapic.c:	KVMTRACE_1D(APIC_ACCESS, apic->vcpu, (u32)offset, handler);
./svm.c:	KVMTRACE_2D(DR_READ, vcpu, (u32)dr, (u32)val, handler);
./svm.c:		KVMTRACE_3D(PAGE_FAULT, &svm->vcpu, error_code,
./svm.c:		KVMTRACE_3D(TDP_FAULT, &svm->vcpu, error_code,
./svm.c:	KVMTRACE_0D(NMI, &svm->vcpu, handler);

I think this could easily be converted to a wrapper around 
ftrace_printk() plus a "kvmtrace" ftrace plugin which activates 
those wrapped ftrace_printk() sites via a single global 
__read_mostly flag.

This means KVM tracing is activated via:

 echo kvmtrace > /debug/tracing/current_tracer

that's all.

Basically the conversion would look like this:

before:

        KVMTRACE_3D(MSR_READ, &svm->vcpu, ecx, (u32)data,
                    (u32)(data >> 32), handler);

after:

	kvm_trace("MSR_READ: %p, %08lx, %016Lx\n", &svm->vcpu, ecx, data);

As a result all these traces would become a lot more readable 
(and a lot more flexible) both in the source code, and in the 
trace output stage.

And any ad-hoc tracepoint can be added, without worrying about 
the name of the macro or the number of type of arguments. Note 
that in this specific example we didnt need to split up the u64 
'data' into two 32-bit values, nor do we have to pass in the 
'handler' name, nor do we have to provide a MSR_READ 
enumeration.

The tracing-disabled case would still be as fast - a single 
branch check.

Avi, what do you think, any objections against an RFC patchset 
that shows this off?

	Ingo
