Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbZBTS5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbZBTS5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 13:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbZBTS5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 13:57:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33375 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbZBTS5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 13:57:31 -0500
Date: Fri, 20 Feb 2009 13:56:25 -0500
From: Jason Baron <jbaron@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Avi Kivity <avi@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
Message-ID: <20090220185625.GA3104@redhat.com>
References: <499edf47.1818d00a.060b.2b8d@mx.google.com> <499EE162.4050008@oracle.com> <20090220172241.GF24538@elte.hu> <20090220173107.GH5732@nowhere> <20090220174811.GL24538@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220174811.GL24538@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 06:48:11PM +0100, Ingo Molnar wrote:
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > > > >  config MARKERS
> > > > >  	bool "Activate markers"
> > > > > -	depends on TRACEPOINTS
> > > > > +	select TRACEPOINTS
> > > > >  	help
> > > > >  	  Place an empty function call at each marker site. Can be
> > > > >  	  dynamically changed for a probe function.
> > > > 
> > > > but using "select" instead of "depends on" just causes the 
> > > > kind of problem that you described, whereas using "depends on" 
> > > > does follow dependency chains.
> > > 
> > > Well, as long as the secondary selects are 'expanded' along the 
> > > line of dependencies, it should still be fine. With an 
> > > increasing number of dependencies it quickly becomes ugly 
> > > though. This might be one of the cases where it works.
> > > 
> > > Eventually we should eliminate markers, their uses can either be 
> > > converted to new-style tracepoints, or to ftrace_printk().
> > > 
> > > 	Ingo
> > 
> > ftrace_printk adds more overhead if not used since it 
> > inconditionally send the trace, unless the related 
> > TRACE_ITER_PRINTK flag on ftrace is unset.
> > 
> > I don't know how markers work, but the documentation describes 
> > that a single branch check is done in case the probe is 
> > disabled.
> > 
> > With ftrace_printk, even if TRACE_ITER_PRINTK is unset, this 
> > is still one call and one branch check. So for hot callsite 
> > it's unappropriate.
> > 
> > IMHO, tracepoints are more suited to replace markers if they 
> > have to.
> 
> there's i think the KVM usecase where markers are used 
> essentially a printk()-alike flexible tracing facility.
> 
> This is how KVMTRACE looks like at the moment:
> 
> ./vmx.c:	KVMTRACE_3D(MSR_READ, vcpu, ecx, (u32)data, (u32)(data >> 32),
> ./vmx.c:	KVMTRACE_3D(MSR_WRITE, vcpu, ecx, (u32)data, (u32)(data >> 32),
> ./vmx.c:	KVMTRACE_0D(PEND_INTR, vcpu, handler);
> ./vmx.c:	KVMTRACE_3D(VMEXIT, vcpu, exit_reason, (u32)kvm_rip_read(vcpu),
> ./vmx.c:		KVMTRACE_0D(NMI, vcpu, handler);
> ./lapic.c:	KVMTRACE_1D(APIC_ACCESS, apic->vcpu, (u32)offset, handler);
> ./lapic.c:	KVMTRACE_1D(APIC_ACCESS, apic->vcpu, (u32)offset, handler);
> ./svm.c:	KVMTRACE_2D(DR_READ, vcpu, (u32)dr, (u32)val, handler);
> ./svm.c:		KVMTRACE_3D(PAGE_FAULT, &svm->vcpu, error_code,
> ./svm.c:		KVMTRACE_3D(TDP_FAULT, &svm->vcpu, error_code,
> ./svm.c:	KVMTRACE_0D(NMI, &svm->vcpu, handler);
> 
> I think this could easily be converted to a wrapper around 
> ftrace_printk() plus a "kvmtrace" ftrace plugin which activates 
> those wrapped ftrace_printk() sites via a single global 
> __read_mostly flag.
> 
> This means KVM tracing is activated via:
> 
>  echo kvmtrace > /debug/tracing/current_tracer
> 
> that's all.
> 
> Basically the conversion would look like this:
> 
> before:
> 
>         KVMTRACE_3D(MSR_READ, &svm->vcpu, ecx, (u32)data,
>                     (u32)(data >> 32), handler);
> 
> after:
> 
> 	kvm_trace("MSR_READ: %p, %08lx, %016Lx\n", &svm->vcpu, ecx, data);
> 
> As a result all these traces would become a lot more readable 
> (and a lot more flexible) both in the source code, and in the 
> trace output stage.
> 
> And any ad-hoc tracepoint can be added, without worrying about 
> the name of the macro or the number of type of arguments. Note 
> that in this specific example we didnt need to split up the u64 
> 'data' into two 32-bit values, nor do we have to pass in the 
> 'handler' name, nor do we have to provide a MSR_READ 
> enumeration.
> 
> The tracing-disabled case would still be as fast - a single 
> branch check.
> 
> Avi, what do you think, any objections against an RFC patchset 
> that shows this off?
> 

hi,

this is the kind of case that i've designed 'dynamic debug' for. It
implicitly allows fined grained control via - source file and line
number, function name, module name, and/or fomat string. If we are going
to have a bunch of these type of interfaces sprinkled throughout the
kernel, I think this fine grained control becomes important. this is all
controlled and visible via: <debugfs>/dynamic_debug/control file. In the
above case i believe matching 'kvm' module would turn all these
statements on/off. We can always add 'tags' to tie specific debug
statements together as well.

In terms of usage, currently, if you set 'CONFIG_DYNAMIC_DEBUG' all
'pr_debug' and 'dev_dbg' statements are picked up. Thus, simply
converting the above statements to use 'pr_debug()' will make them
run-time tunable if CONFIG_DYNAMIC_DEBUG is set. That's all that needs
to be done...we don't need to write an ftracer debug statements.

We could also make subsystem specific macros as you mentioned
conditional on subsystem specific CONFIG parameters. For example, if 
'CONFIG_KVM_DEBUG' is set we tie it into this infrastructure otherwise its a
no-op.

In terms of the 'backend', currently we're using 'printk'. However, i've
posted patches in to tie into ftrace_printk(). This could easily be made
toggle switch.

That said, markers do allow for callbacks, so that different parts of
the kernel can register and get called when the marker is hit. This
behavior might be more appropriate if its not simple 'printk' style
debugging.

thanks,

-Jason


