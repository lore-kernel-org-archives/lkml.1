Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbZIGPsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbZIGPsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 11:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbZIGPsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 11:48:37 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:41923 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbZIGPsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 11:48:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvIEANPHpEpMROOX/2dsb2JhbACBU8kXCI4OgkAIgVAFgVQ
Date: Mon, 7 Sep 2009 11:48:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, roland@redhat.com, rth@redhat.com,
       mingo@elte.hu
Subject: Re: [PATCH 0/4] RFC: jump label - (tracepoint optimizations)
Message-ID: <20090907154824.GA1085@Krystal>
References: <cover.1252007851.git.jbaron@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <cover.1252007851.git.jbaron@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:30:17 up 20 days,  2:19,  2 users,  load average: 0.69, 0.53,
	0.38
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> hi,
> 
> Problem:
> 
> Currenly, tracepoints are implemented using a conditional. The conditional
> check requires checking a global variable for each tracepoint. Although,
> the overhead of this check is small, it increases under memory pressure. As we
> increase the number of tracepoints in the kernel this may become more of an
> issue. In addition, tracepoints are often dormant (disabled), and provide no
> direct kernel functionality. Thus, it is highly desirable to reduce their
> impact as much as possible. Mathieu Desnoyers has already suggested a number of
> requirements for a solution to this issue.
> 

Hi Jason,

Thanks for working on this. It's a useful idea that's just been sitting
there for too long now. Please see comments below,

> Solution:
> 
> In discussing this problem with Roland McGrath and Richard Henderson, we came 
> up with a new 'asm goto' statement that allows branching to a label. Thus, this
> patch set introdues a 'STATIC_JUMP_IF()' macro as follows:
> 
> #ifdef HAVE_STATIC_JUMP
> 
> #define STATIC_JUMP_IF(tag, label, cond)                               \
>        asm goto ("1:"   /* 5-byte insn */                              \
>           P6_NOP5                                                      \

Hrm, be careful there. P6_NOP5 is not always a single instruction. If
you are preempted in the middle of it, bad things could happen, even
with stop_machine, if you iret in the middle the of the new jump
instruction. It could cause an illegal instruction fault. You should use
an atomic nop5. I think the function tracer already does, since I
told Steven about this exact issue.

>                ".pushsection __jump_table,  \"a\" \n\t"                \
>                _ASM_PTR "1b, %l[" #label "], %c0 \n\t"                 \
>                ".popsection \n\t"                                      \
>                : :  "i" (__sjstrtab_##tag) :  : label)
> 

Supporting multiple labels to create a real jump table would be a
nice-to-have as future enhancement too. This could be called
STATIC_JUMP_TABLE(). Actually, the STATIC_JUMP_IF could probably be
implemented in terms of STATIC_JUMP_TABLE.

> #else
> 
> #define STATIC_JUMP_IF(tag, label, cond)        \
>         if (unlikely(cond))                     \
>                 goto label;
> 

Hrm, however, it's not clear to me how the STATIC_JUMP_TABLE() fallback
would look like. In the case of STATIC_JUMP_IF, it's a simple if (),
which makes support of compilers lacking static jump support easy. We
could probably use a switch statement to replace the STATIC_JUMP_TABLE
though.

> #endif /* !HAVE_STATIC_JUMP */
> 
> 
> which can be used as:
> 
>         STATIC_JUMP_IF(trace, trace_label, jump_enabled);
>         printk("not doing tracing\n");
> if (0) {
> trace_label:
>         printk("doing tracing: %d\n", file);
> }
> 

Hrm. Is there any way to make this a bit prettier ? Given modifications
are made to gcc anyway...

Maybe:

static_jump_if (trace, jump_enabled) {
 ...

} else {
 ...
}

And for the jump table:

static_jump_table (trace, jump_select) {
  case 0: ...
          break;
  case 1: ...
          break;
  default:
          ...
}


> ---------------------------------------
> 
> Thus, if 'HAVE_STATIC_JUMP' is defined (which will depend ultimately on the
> existence of 'asm goto' in the compiler version), we simply have a no-op
> followed by a jump around the dormant (disabled) tracing code.

Hrm, why don't we collapse that into a single 5-bytes jump instruction
instead ?

> The
> 'STATIC_JUMP_IF()' macro, produces a 'jump_table' which has the following
> format:
> 
> [instruction address] [jump target] [tracepoint name]
> 
> Thus, to enable a tracepoint, we simply patch the 'instruction address' with
> a jump to the 'jump target'. The current implementation is using ftrace
> infrastructure to accomplish the patching, which uses 'stop_machine'. In
> subsequent versions, we will update the mechanism to use more efficient
> code patching techniques.
> 
> I've tested the performance of this using 'get_cycles()' calls around the
> tracepoint call sites. For an Intel Core 2 Quad cpu (in cycles, averages):
> 		
> 		idle		after tbench run
> 		----		----------------
> old code	 32		  88
> new code	  2		   4
> 
> 
> The performance improvement can be reproduced very reliably (using patch 4
> in this series) on both Intel and AMD hardware.
> 
> In terms of code analysis the current code for the disabled case is a 'cmpl'
> followed by a 'je' around the tracepoint code. so:
> 
> cmpl - 83 3d 0e 77 87 00 00 - 7 bytes
> je   - 74 3e                - 2 bytes
> 
> total of 9 instruction bytes.
> 
> The new code is a 'nopl' followed by a 'jmp'. Thus:
> 
> nopl - 0f 1f 44 00 00 - 5 bytes
> jmp  - eb 3e          - 2 bytes
> 
> total of 7 instruction bytes.
> 
> So, the new code also accounts for 2 less bytes in the instruction cache per tracepoint.
> 

With a single 5-bytes jump, this would account for a 5 bytes total,
which is 4 bytes less.

Thanks,

Mathieu

> here's a link to the gcc thread introducing this feature:
> 
> http://gcc.gnu.org/ml/gcc-patches/2009-07/msg01556.html
> 
> Todo:
> 
> -convert the patching to a more optimal implementation (not using stop machine)
> -expand infrastructure for modules
> -other use cases?
> -mark the trace_label section with 'cold' attributes
> -add module support
> -add support for other arches (besides x86)
> 
> thanks,
> 
> -Jason
> 
>  arch/x86/kernel/ftrace.c          |   36 +++++
>  arch/x86/kernel/test_nx.c         |    3 +
>  include/asm-generic/vmlinux.lds.h |   11 ++
>  include/linux/ftrace.h            |    3 +
>  include/linux/jump_label.h        |   45 ++++++
>  include/linux/tracepoint.h        |   50 +++++---
>  kernel/Makefile                   |    2 +-
>  kernel/jump_label.c               |  271 +++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace_workqueue.c    |    2 +
>  kernel/tracepoint.c               |  134 ++++++++++++++++++
>  10 files changed, 540 insertions(+), 17 deletions(-)
>  create mode 100644 include/linux/jump_label.h
>  create mode 100644 kernel/jump_label.c
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
