Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbZJFFkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbZJFFkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 01:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbZJFFkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 01:40:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbZJFFkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 01:40:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jason Baron <jbaron@redhat.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       tglx@linutronix.de, rostedt@goodmis.org, ak@suse.de, rth@redhat.com,
       mhiramat@redhat.com
Subject: Re: [PATCH 0/4] jump label patches
In-Reply-To: Jason Baron's message of  Thursday, 24 September 2009 19:17:45 -0400 <cover.1253831945.git.jbaron@redhat.com>
References: <cover.1253831945.git.jbaron@redhat.com>
Emacs: anything free is worth what you paid for it.
Message-Id: <20091006053915.D9D0928@magilla.sf.frob.com>
Date: Mon,  5 Oct 2009 22:39:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am, of course, fully in favor of this hack.  This version raises a new
concern for me vs what we had discussed before.  I don't know what the
conclusion about this should be, but I think it should be aired.

In the previous plan, we had approximately:

	asm goto ("1:" P6_NOP5
		  ".pushsection __jump_table\n"
		  _ASM_PTR "1b, %l[do_trace]\n"
		  ".popsection" : : : do_trace);
	if (0) { do_trace: ... tracing_path(); ... }
	... hot_path(); ...

That is, the straight-line code path is a 5-byte nop.  To enable the
"static if" at runtime, we replace that with a "jmp .Ldo_trace".
So, disabled:

	0x1:	nopl
	0x6:	hot path
	...
	0x100:	ret		# or jmp somewhere else, whatever
	...
	0x234:	tracing path	# never reached
	...
	0x250:	jmp 0x6

and enabled:

	0x1:	jmp 0x234
	0x6:	hot path
	...
	0x100:	ret
	...
	0x234:	tracing path
	...
	0x250:	jmp 0x6


In your new plan, instead we now have approximately:

	asm goto ("1: jmp %l[dont_trace]\n"
		  ".pushsection __jump_table\n"
		  _ASM_PTR "1b, %l[dont_trace]\n"
		  ".popsection" : : : dont_trace);
	... tracing path ...
	dont_trace:
	... hot_path(); ...

That is, we've inverted the sense of the control flow: the straight-line
code path is the tracing path, and in default "disabled" state we jump
around the tracing path to get to the hot path.
So, disabled:

	0x1:	jmp 0x1f
	0x3:	tracing path	# never reached
	...
	0x1f:	hot path
	...
	0x119:	ret

and enabled:

	0x1:	jmp 0x3
	0x3:	tracing path
	...
	0x1f:	hot path
	...
	0x119:	ret


As I understand it, the point of the exercise is to optimize the "disabled"
case to as close as possible to what we'd get with no tracing path compiled
in at all.  In the first example (with "nopl"), it's easy to see how that
is what we presume is pretty close to epsilon addition: the execution cost
of the 5-byte nop, plus the indirect effects of those 5 bytes polluting the
I-cache.  We only really know when we measure, but that just seems likely
to be minimally obtrustive.

In the second example (with "jmp around"), I really wonder what the actual
overhead is.  There's the cost of the jmp itself, plus maybe whatever extra
jumps do to branch predictions or pipelines or whatnots of which I know not
much, plus the entire tracing path being right there adjacent using up the
I-cache space that would otherwise be keeping more of the hot path hot.
I'm sure others on the list have more insight than I do into what the
specific performance impacts we can expect from one code sequence or the
other on various chips.

Of course, a first important point is what the actual compiled code
sequences look like.  I'm hoping Richard (who implemented the compiler
feature for us) can help us with making sure our expectations jibe with the
code we'll really get.  There's no benefit in optimizing our asm not to
introduce a jump into the hot path if the compiler actually generates the
tracing path first and gives the hot path a "jmp" around it anyway.

The code example above assumes that "if (0)" is enough for the compiler to
put that code fork (where the "do_trace:" label is) somewhere out of the
straight-line path rather than jumping around it.  Going on the "belt and
suspenders" theory as to being thoroughly explicit to the compiler what we
intend, I'd go for:

	if (__builtin_expect(0,0)) do_trace: __attribute__((cold)) { ... }

But we need Richard et al to tell us what actually makes a difference to
the compiler's optimizer, and will reliably continue to do so in the future.


Thanks,
Roland
