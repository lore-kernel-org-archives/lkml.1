Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbZBUDPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbZBUDPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 22:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbZBUDPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 22:15:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:14511 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbZBUDPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 22:15:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=szeq0NKMrzcSBd8ifPgHvWYJqebL2Tld/OT9BmgowMmooKlfsPhjyFb/zQqZzC/7L9
         yKDyKi6o9sUG8zWfedPg6t1EFSZ99adcNBJ9lE/yVvBivWu2/TvR4k1VIC9UoLEMlU8I
         TSXT06A8nrm0ey3KUqTc+5qDjKZSW5mjjoDHI=
Date: Sat, 21 Feb 2009 04:15:25 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
Message-ID: <20090221031523.GA5771@nowhere>
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
> 
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


Note that I haven't looked at kvm tracing in detail, so I could be wrong.
But when I look of the kind of events above which are traced through KVM,
I guess the frequency rate of traces can be high.

The use of ftrace_printk seems to me an overhead here for ring buffer space consuming
and tracing overhead itself.

ftrace_printk inserts the events on the ring buffer as already formatted, so
it consumes more space that traditional binary insertion. But I skip that since we have
16384 entries by default (large enough), though the notion of entry size is dynamic
with the ring buffer.

But doing the vsnprintf on tracing context seems to me inappropriate since
tracing should be as much transparent as possible from the traced site point
of view. I think it should be better on output time, unless the traces rate is not
as high as I imagine.

 
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


Right.
Anyway, it needs to be integrated into the common tracing part
of the kernel. virt/kvm_trace.c is a whole tracer.


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
> 	Ingo

