Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbZHZW3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbZHZW3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 18:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbZHZW3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 18:29:50 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:40042 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753904AbZHZW3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 18:29:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4EADpRlUpMROOX/2dsb2JhbACBU9Y9hBoF
Date: Wed, 26 Aug 2009 18:29:49 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
Message-ID: <20090826222949.GB16363@Krystal>
References: <1251270092.7538.1226.camel@twins> <4A94DFF4.5030301@cn.fujitsu.com> <alpine.DEB.2.00.0908261012020.23885@gandalf.stny.rr.com> <20090826164624.GA21456@Krystal> <alpine.DEB.2.00.0908261343010.11291@gandalf.stny.rr.com> <20090826180114.GA29130@Krystal> <20090826181758.GA30248@Krystal> <alpine.DEB.2.00.0908261544590.11291@gandalf.stny.rr.com> <20090826195345.GB5298@Krystal> <alpine.DEB.2.00.0908261627390.11291@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908261627390.11291@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 18:03:50 up 8 days,  8:53,  2 users,  load average: 0.16, 0.25,
	0.21
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Wed, 26 Aug 2009, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> > > Anyway, this prevents your tracepoints from doing the odd things of 
> > > loading a probe before it exists. Well you can, but then you prevent the 
> > > unload of the module that registered it. Fine, I chucked out that patch.
> > > 
> > 
> > you should try adding the required tracepoint_synchronize_unregister()
> > call to ftrace_profile_disable_##call in ftrace.h. I expect this will
> > fix your problem.
> 
> Just did, and it did not solve the bug.
> 
> > 
> > Note that this is a bit slow to call it at each unregistration. Ideally,
> > a module containing tracepoint probes should call this synchronization
> > primitive only once at module unload.
> 
> The bug looks like it is registering a probe, but not unregistering it 
> before leaving the module. But when the module is loaded again, it now has 
> a bad function to call when the tracepoint is hit.
> 
> -- Steve

Hrm, looking at #define _TRACE_PROFILE(call, proto, args) from ftrace.h
is interesting. The profile reg/unreg are actually visible as:

#define _TRACE_PROFILE_INIT(call)                                       \
        .profile_count = ATOMIC_INIT(-1),                               \
        .profile_enable = ftrace_profile_enable_##call,                 \
        .profile_disable = ftrace_profile_disable_##call,

So each time profiling is activated, we iterate on all tracepoints to
call their profile_enable. But they stay active even when the module is
unloaded. That's odd.

If _anything_ external to the module containing the probe takes
responsibility for registering the probe to a tracepoint, it should
unregister it before the module exits.

One simple quick-and-dirty to do this is to increment the refcount of
the module containing the probe before enabling it and decrementing the
refcount after disabling its probe. This is one of the solutions you
proposed so far, and it looks sane. I use something similar in LTTng
btw. Probe modules are refcounted when probes are connected to a
tracepoints by the "probe manager".

However, because you put the DEFINE_TRACE within the same module as your
actual code, you cannot unload the module unless you stop profiling. One
way to fix this is, as Peter proposed, use a different module for the
probe than the module you are probing. I agree with him. The module used
as probe for tracing is expected to be somehow tied to tracing sessions,
and I think it is OK to expect the probe module no to be unloadable as
long as a tracing session which uses it is active.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
