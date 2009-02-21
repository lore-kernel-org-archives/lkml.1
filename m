Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbZBUWF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbZBUWF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 17:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbZBUWFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 17:05:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60717 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089AbZBUWFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 17:05:13 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Avi Kivity <avi@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
References: <499edf47.1818d00a.060b.2b8d@mx.google.com>
	<499EE162.4050008@oracle.com> <20090220172241.GF24538@elte.hu>
	<20090220173107.GH5732@nowhere> <20090220174811.GL24538@elte.hu>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Sat, 21 Feb 2009 17:04:46 -0500
In-Reply-To: <20090220174811.GL24538@elte.hu> (Ingo Molnar's message of "Fri, 20 Feb 2009 18:48:11 +0100")
Message-ID: <y0mtz6nqwe9.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> [...]
> there's i think the KVM usecase where markers are used 
> essentially a printk()-alike flexible tracing facility.
>
> [...]
> ./vmx.c:	KVMTRACE_3D(MSR_READ, vcpu, ecx, (u32)data, (u32)(data >> 32),
> ./vmx.c:	KVMTRACE_3D(MSR_WRITE, vcpu, ecx, (u32)data, (u32)(data >> 32),
> ./vmx.c:	KVMTRACE_0D(PEND_INTR, vcpu, handler);
>
> I think this could easily be converted to a wrapper around 
> ftrace_printk() plus a "kvmtrace" ftrace plugin [...]

It would be even easier converted to the markers API directly,
without the KVMTRACE* macro intermediary:

before:
        KVMTRACE_3D(MSR_READ, &svm->vcpu, ecx, (u32)data,
                    (u32)(data >> 32), handler);
after:
	trace_mark(kvmtrace, "MSR_READ: %p, %08lx, %016Lx\n",
                             &svm->vcpu, ecx, data);

All this already "just works".

The only part that's missing, from ftrace's point of view, is an
interface from markers to the ftrace printing.  And Lai Jiangshan
kindly posted exactly such generic code back in December:

http://lkml.org/lkml/2008/12/30/297

Please let's get this merged.

> This means KVM tracing is activated via:
>  echo kvmtrace > /debug/tracing/current_tracer
> that's all.

Lai's interface is almost identical, and automatically works for
any/all markers.


> And any ad-hoc tracepoint can be added, without worrying about 
> the name of the macro or the number of type of arguments. [...]

(This KVMTRACE stuff was always unnecessary with respect to markers,
and must have been explained by some historical baggage.)


- FChE
