Return-Path: <linux-kernel-owner+w=401wt.eu-S932294AbZICVBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294AbZICVBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 17:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932258AbZICVBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 17:01:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47598 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932252AbZICVBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 17:01:49 -0400
Date: Thu, 3 Sep 2009 23:01:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       roland@redhat.com, rth@redhat.com
Subject: Re: [PATCH 0/4] RFC: jump label - (tracepoint optimizations)
Message-ID: <20090903210139.GA25581@elte.hu>
References: <cover.1252007851.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1252007851.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Baron <jbaron@redhat.com> wrote:

> hi,
> 
> Problem:
> 
> Currenly, tracepoints are implemented using a conditional. The 
> conditional check requires checking a global variable for each 
> tracepoint. Although, the overhead of this check is small, it 
> increases under memory pressure. As we increase the number of 
> tracepoints in the kernel this may become more of an issue. In 
> addition, tracepoints are often dormant (disabled), and provide no 
> direct kernel functionality. Thus, it is highly desirable to 
> reduce their impact as much as possible. Mathieu Desnoyers has 
> already suggested a number of requirements for a solution to this 
> issue.
> 
> Solution:
> 
> In discussing this problem with Roland McGrath and Richard 
> Henderson, we came up with a new 'asm goto' statement that allows 
> branching to a label. Thus, this patch set introdues a 
> 'STATIC_JUMP_IF()' macro as follows:
> 
> #ifdef HAVE_STATIC_JUMP
> 
> #define STATIC_JUMP_IF(tag, label, cond)                               \
>        asm goto ("1:"   /* 5-byte insn */                              \
>           P6_NOP5                                                      \
>                ".pushsection __jump_table,  \"a\" \n\t"                \
>                _ASM_PTR "1b, %l[" #label "], %c0 \n\t"                 \
>                ".popsection \n\t"                                      \
>                : :  "i" (__sjstrtab_##tag) :  : label)
> 
> #else
> 
> #define STATIC_JUMP_IF(tag, label, cond)        \
>         if (unlikely(cond))                     \
>                 goto label;
> 
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
> ---------------------------------------
> 
> Thus, if 'HAVE_STATIC_JUMP' is defined (which will depend 
> ultimately on the existence of 'asm goto' in the compiler 
> version), we simply have a no-op followed by a jump around the 
> dormant (disabled) tracing code. The 'STATIC_JUMP_IF()' macro, 
> produces a 'jump_table' which has the following format:
> 
> [instruction address] [jump target] [tracepoint name]
> 
> Thus, to enable a tracepoint, we simply patch the 'instruction 
> address' with a jump to the 'jump target'. The current 
> implementation is using ftrace infrastructure to accomplish the 
> patching, which uses 'stop_machine'. In subsequent versions, we 
> will update the mechanism to use more efficient code patching 
> techniques.
> 
> I've tested the performance of this using 'get_cycles()' calls 
> around the tracepoint call sites. For an Intel Core 2 Quad cpu (in 
> cycles, averages):
> 		
> 		idle		after tbench run
> 		----		----------------
> old code	 32		  88
> new code	  2		   4
> 
> 
> The performance improvement can be reproduced very reliably (using 
> patch 4 in this series) on both Intel and AMD hardware.
> 
> In terms of code analysis the current code for the disabled case 
> is a 'cmpl' followed by a 'je' around the tracepoint code. so:
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
> So, the new code also accounts for 2 less bytes in the instruction 
> cache per tracepoint.
> 
> here's a link to the gcc thread introducing this feature:
> 
> http://gcc.gnu.org/ml/gcc-patches/2009-07/msg01556.html

This looks really interesting and desired. Once GCC adds this (or an 
equivalent) feature, i'd love to have your optimization in the 
kernel.

> Todo:
> 
> - convert the patching to a more optimal implementation (not using stop machine)
> - expand infrastructure for modules
> - other use cases?
[...]

Other usecases might be kernel features that are turned on/off via 
some slowpath. For example SLAB statistics could be patched in/out 
using this method. Or scheduler statistics.

Basically everything that is optional and touches some very hot 
codepath would be eligible - not just tracepoints.

	Ingo
