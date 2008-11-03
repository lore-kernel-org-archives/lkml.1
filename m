Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbYKCT0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbYKCT0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 14:26:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbYKCT0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 14:26:37 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:42531 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751121AbYKCT0g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 14:26:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgEAKDeDklMQWxa/2dsb2JhbACBdsoNg1I
Date: Mon, 3 Nov 2008 14:26:33 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>,
       Robert Richter <robert.richter@amd.com>, srostedt@redhat.com,
       a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Identify which executable object the userspace address
	belongs to. Store thread group leader id, and use it to lookup the
	address in the process's map. We could have looked up the address
	on thread's map, but the thread might not exist by the time we are
	called. The process might not exist either, but if you are reading
	trace_pipe, that is unlikely.
Message-ID: <20081103192633.GB23269@Krystal>
References: <1225660694-19765-1-git-send-email-edwintorok@gmail.com> <1225660694-19765-2-git-send-email-edwintorok@gmail.com> <1225660694-19765-3-git-send-email-edwintorok@gmail.com> <20081103074754.GB13727@elte.hu> <490EB361.9090007@gmail.com> <20081103082932.GF28771@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20081103082932.GF28771@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:16:10 up 151 days, 23:56,  8 users,  load average: 0.49, 1.24,
	0.87
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Török Edwin <edwintorok@gmail.com> wrote:
> 
> > > Your patches are a nice feature we want to have nevertheless - to 
> > > be able to see where a user-space app is running has been one of 
> > > the historically weak points of kernel instrumentation.
> > 
> > Thanks.
> > It currently works for x86 only, but architecture porters can add
> > support for theirs quite easily, it just needs to modeled after how
> > oprofile does it for example.
> > BTW would it make sense to change oprofile and the sysprof tracer to use
> > save_stack_trace_user? It would eliminate some code duplication.
> 
> that definitely sounds like the right direction. I've Cc:-ed Robert 
> Richter, the Oprofile maintainer - please Cc: him to code that touches 
> oprofile.
> 
> note that NMI interaction of user-space stackframe walkers can be a 
> bit tricky: the basic problem is that if you fetch a user-space 
> stackframe that can create a fault, and the IRET at the end of the 
> fault handler will re-enable NMIs (violating the NMI code's 
> assumptions).
> 
> there are patches on lkml written by Mathieu Desnoyers that solve this 
> by changing all the fault path to use RET instead of IRET. It might 
> make sense to dust them off - we carried them for a long time in -tip 
> and they were robust. (they just never had any really strong 
> justification and were rather complex - that changes now)
> 
> Mathieu, what do you think?
> 

Yep, using the NMI-safe traps seems like a good idea for this. I look
forward to add those userspace stack dumps in my LTTng traces. I've had
this feature in the past in LTTng and it was _really_ useful, e.g. to
know the whole userspace stack that caused a system call.

The patchset version I have in my -lttng tree is pretty much the same
you currently have in -tip. I have not ported my tree to 2.6.28-rcX yet
though.

For trap instrumentation, I think the sane way to deal with the
recursive trap problem is to keep a nesting count associated with
instrumentation within the trap handler, which would dynamically disable
this specific instrumentation (per-cpu given preemption is disabled
within the instrumentation) once it reaches a given nesting level. That
would permit to overcome the recursive trap problem without losing
nested events happening when, for example, a NMI nests over a standard
interrupt, which is, in this case, nested but not caused by recursion.

Also, we have to think carefully about how we want to access userspace.
a copy_from_user_inatomic(), which may fail if the data we try to access
is not in cache, seems like a sane approach to deal with such
instrumentation called in atomic context. But if we detect that the
instrumentation is called from preemptable context, then a
copy_from_user() could be ok.

Mathieu

> > Would it make sense to add a script that post-processes the output 
> > to scripts/tracing?
> >
> > It would parse a trace log (from trace or latency_trace) and use 
> > addr2line to resolve the address to source:line, and if successful 
> > replace the relative address with that; and also group identical 
> > stack traces together.
> 
> sure, please add it to scripts/tracing/.
> 
> The best approach would be if the kernel could output the best info by 
> default - but that seems rather hard for addr2line functionality which 
> involves debuginfo processing, etc.
> 
> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
