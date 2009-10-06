Return-Path: <linux-kernel-owner+w=401wt.eu-S932709AbZJFOJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709AbZJFOJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932626AbZJFOJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:09:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932677AbZJFOJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:09:14 -0400
Date: Tue, 6 Oct 2009 10:07:33 -0400
From: Jason Baron <jbaron@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       tglx@linutronix.de, rostedt@goodmis.org, ak@suse.de, rth@redhat.com,
       mhiramat@redhat.com
Subject: Re: [PATCH 0/4] jump label patches
Message-ID: <20091006140733.GA2631@redhat.com>
References: <cover.1253831945.git.jbaron@redhat.com> <20091006053915.D9D0928@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006053915.D9D0928@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05, 2009 at 10:39:15PM -0700, Roland McGrath wrote:
> I am, of course, fully in favor of this hack.  This version raises a new
> concern for me vs what we had discussed before.  I don't know what the
> conclusion about this should be, but I think it should be aired.
> 
> In the previous plan, we had approximately:
> 
> 	asm goto ("1:" P6_NOP5
> 		  ".pushsection __jump_table\n"
> 		  _ASM_PTR "1b, %l[do_trace]\n"
> 		  ".popsection" : : : do_trace);
> 	if (0) { do_trace: ... tracing_path(); ... }
> 	... hot_path(); ...
> 
> That is, the straight-line code path is a 5-byte nop.  To enable the
> "static if" at runtime, we replace that with a "jmp .Ldo_trace".
> So, disabled:
> 
> 	0x1:	nopl
> 	0x6:	hot path
> 	...
> 	0x100:	ret		# or jmp somewhere else, whatever
> 	...
> 	0x234:	tracing path	# never reached
> 	...
> 	0x250:	jmp 0x6
> 
> and enabled:
> 
> 	0x1:	jmp 0x234
> 	0x6:	hot path
> 	...
> 	0x100:	ret
> 	...
> 	0x234:	tracing path
> 	...
> 	0x250:	jmp 0x6
> 
> 
> In your new plan, instead we now have approximately:
> 
> 	asm goto ("1: jmp %l[dont_trace]\n"
> 		  ".pushsection __jump_table\n"
> 		  _ASM_PTR "1b, %l[dont_trace]\n"
> 		  ".popsection" : : : dont_trace);
> 	... tracing path ...
> 	dont_trace:
> 	... hot_path(); ...
> 
> That is, we've inverted the sense of the control flow: the straight-line
> code path is the tracing path, and in default "disabled" state we jump
> around the tracing path to get to the hot path.
> So, disabled:
> 
> 	0x1:	jmp 0x1f
> 	0x3:	tracing path	# never reached
> 	...
> 	0x1f:	hot path
> 	...
> 	0x119:	ret
> 
> and enabled:
> 
> 	0x1:	jmp 0x3
> 	0x3:	tracing path
> 	...
> 	0x1f:	hot path
> 	...
> 	0x119:	ret
> 
> 
> As I understand it, the point of the exercise is to optimize the "disabled"
> case to as close as possible to what we'd get with no tracing path compiled
> in at all.  In the first example (with "nopl"), it's easy to see how that
> is what we presume is pretty close to epsilon addition: the execution cost
> of the 5-byte nop, plus the indirect effects of those 5 bytes polluting the
> I-cache.  We only really know when we measure, but that just seems likely
> to be minimally obtrustive.
> 
> In the second example (with "jmp around"), I really wonder what the actual
> overhead is.  There's the cost of the jmp itself, plus maybe whatever extra
> jumps do to branch predictions or pipelines or whatnots of which I know not
> much, plus the entire tracing path being right there adjacent using up the
> I-cache space that would otherwise be keeping more of the hot path hot.
> I'm sure others on the list have more insight than I do into what the
> specific performance impacts we can expect from one code sequence or the
> other on various chips.
> 
> Of course, a first important point is what the actual compiled code
> sequences look like.  I'm hoping Richard (who implemented the compiler
> feature for us) can help us with making sure our expectations jibe with the
> code we'll really get.  There's no benefit in optimizing our asm not to
> introduce a jump into the hot path if the compiler actually generates the
> tracing path first and gives the hot path a "jmp" around it anyway.
> 
> The code example above assumes that "if (0)" is enough for the compiler to
> put that code fork (where the "do_trace:" label is) somewhere out of the
> straight-line path rather than jumping around it.  Going on the "belt and
> suspenders" theory as to being thoroughly explicit to the compiler what we
> intend, I'd go for:
> 
> 	if (__builtin_expect(0,0)) do_trace: __attribute__((cold)) { ... }
> 
> But we need Richard et al to tell us what actually makes a difference to
> the compiler's optimizer, and will reliably continue to do so in the future.
> 
> 
> Thanks,
> Roland

right, thanks for clearly explaining some of the
advantages/disadvantages of the 2 schemes. So the 2 reasons I moved from the
'nop' scheme to the 'jmp' scheme were:

1) The 'nop' scheme was still producing a 'jmp' around the hotpath. So
in the lingo from above, I was getting:

       0x1:    nopl
       0x6:    jmp 0x100    # jump to hot path
       0x8:    tracing path
       ...
       0x100:    hot path
       ...
       0x200:  ret             # or jmp somewhere else, whatever

So, since the compiler was still producing a jmp at instruction 0x6, I
was saving some icache by simply removing the nopl at instruction 0x1.
That said, I didn't try the 'builtin_expect' construct mentioned above
to move the tracing path out of line. However, the 'jmp' scheme could
use the same technique to move the tracing path out of line as well.
Finally, I do agree that if we had a chance to just place a single nop
or just place a jmp, the nop would certainly be better.


2) Concern over finding a 5-byte atomic nop that would work for all x86
processors. I think Steve Rostedt ran into this issue on with ftrace...
The problem is if the 5-byte nop is not atomic, then we risk being
interrupted and returning to a non-sensical opcode. The 'jmp' scheme, I
believed solved that problem, since I assume the entire 'jmp'
instruction is atomic.

thanks,

-Jason
