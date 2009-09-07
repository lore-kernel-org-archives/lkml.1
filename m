Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbZIGRGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbZIGRGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 13:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbZIGRGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 13:06:24 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:46600 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbZIGRGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 13:06:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvIEAIbYpEpMROOX/2dsb2JhbACBU9cZhBgFgVQ
Date: Mon, 7 Sep 2009 13:06:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, roland@redhat.com, rth@redhat.com,
       mingo@elte.hu, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/4] RFC: jump label - (tracepoint optimizations)
Message-ID: <20090907170619.GB6968@Krystal>
References: <cover.1252007851.git.jbaron@redhat.com> <20090907154824.GA1085@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090907154824.GA1085@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:53:47 up 20 days,  3:43,  2 users,  load average: 0.72, 0.33,
	0.31
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> * Jason Baron (jbaron@redhat.com) wrote:
[...]
> > Solution:
> > 
> > In discussing this problem with Roland McGrath and Richard Henderson, we came 
> > up with a new 'asm goto' statement that allows branching to a label. Thus, this
> > patch set introdues a 'STATIC_JUMP_IF()' macro as follows:
> > 
> > #ifdef HAVE_STATIC_JUMP
> > 
> > #define STATIC_JUMP_IF(tag, label, cond)                               \
> >        asm goto ("1:"   /* 5-byte insn */                              \
> >           P6_NOP5                                                      \
> 
> Hrm, be careful there. P6_NOP5 is not always a single instruction. If
> you are preempted in the middle of it, bad things could happen, even
> with stop_machine, if you iret in the middle the of the new jump
> instruction. It could cause an illegal instruction fault. You should use
> an atomic nop5. I think the function tracer already does, since I
> told Steven about this exact issue.
> 

Just to clarify this statement:

P6_NOP5 happens to be an atomic nop, but nothing states this requirement
in arch/x86/include/asm/nops.h. Other 5-bytes nops are defined as
multiple instructions (e.g. 2 bytes + 3 bytes nops). So I recommend to
create a family of ATOMIC_P6_NOP5 (and other ATOMIC_*_NOP5 defines) to
document this atomicity requirement.

Ftrace could probably handle this more gracefully than it does at the
moment. It basically assumes that P6_NOP5 is atomic, and falls back on a
5-bytes jmp if it detects that P6_NOP5 faults.

That's coherent with the
"TODO: check the cpuid to determine the best nop."

present in x86 ftrace.c.

So, at the very least, if we rely on nops.h having a single-instruction
P6_NOP5 5 bytes nop, a comment to that effect should be added to nops.h.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
