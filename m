Return-Path: <linux-kernel-owner+w=401wt.eu-S1751120AbZJSHwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120AbZJSHwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 03:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbZJSHwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 03:52:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57738 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbZJSHwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 03:52:37 -0400
Date: Mon, 19 Oct 2009 09:51:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip tracing/kprobes 0/9] tracing/kprobes, perf: perf
	probe and kprobe-tracer bugfixes
Message-ID: <20091019075103.GF17960@elte.hu>
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com> <20091017080203.GA4155@elte.hu> <20091017103427.GA31238@elte.hu> <4ADAAF50.9040604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADAAF50.9040604@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Ingo Molnar wrote:
> > 
> > I took a good look at the current bits, and there are a few more things 
> > that need to be fixed before we can consider 'perf probe' for upstream.
> > 
> > Firstly, this decoder bug is still not fixed:
> > 
> >   CHK     include/linux/compile.h
> >   TEST    posttest
> > Error: ffffffff81068fe0:        66 0f 73 fd 04          pslldq $0x4,%xmm5
> > Error: objdump says 5 bytes, but insn_get_length() says 4 (attr:8000)
> > make[1]: *** [posttest] Error 2
> > 
> > 64-bit allyesconfig will trigger this for example, but the attached 
> > smaller config too. This needs to be fixed before we can apply any
> > new commits.
> 
> Absolutely, yes. Thank you for reporting. I'm checking it again.

Thanks!

> > Secondly, the probe syntax is quite non-obvious currently. All the 
> > 'p' and -P gymnastics is just a barrier to the first-time user 
> > getting his first probe inserted successfully.
> 
> Hmm...
> 
> > The user need not worry about whether it's a 'kprobe' or a 
> > 'kretprobe'. The user should _specify_ what it wants to probe, and 
> > _that_ will lead to 'perf probe' picking the most suitable facility 
> > to achieve that kind of probing.
> > 
> > It might be a kprobe, a kretprobe, or an mcount driven function 
> > probe, an existing tracepoint if it happens to be present in that 
> > place already - or some other future mechanism. The driving force 
> > must be a robust specification of 'what', not the mechanics of 
> > 'how'.
> 
> Agreed.
> 
> > Considering that, the current 'perf probe' syntax does not achieve 
> > that goal yet.
> > 
> > Here are a few syntax suggestions
> > 
> > The simpest probe syntax should be to add a probe to a single 
> > function name:
> > 
> >   perf probe +schedule
> > 
> > _nothing else_.
> > 
> > To remove it, the user should just do something like:
> > 
> >   perf probe -schedule
> > 
> > (to be symmetric 'perf probe +schedule' should work as well)
> 
> I think '-<symbol>' syntax doesn't work good with other command-line 
> options and multiple definitions. (However, it will be good for 
> input-from-file syntax. :-))

dash can be used too - perf has the options library from Git and there's 
a wide spectrum of option parsing available, via 
tools/perf/util/parse-options.h.

But yes, it complicates things a bit.

> So, what would you think about using -D (def) and -U (undef) ?

The simpest case should be no extra character at all:

  perf probe schedule

There's a few well-known command line idioms to add/remove stuff, but -D 
/ -U is not one of them i'm afraid =B-)

The following ones might work too:

  perf probe +schedule
  perf probe -schedule

  perf probe add schedule
  perf probe del schedule

  perf probe --add schedule
  perf probe --del schedule

[ Plain 'add/del' has a minor complication as we could have a similar 
  symbol defined. ]

+ / - is certainly the simplest.

--add/--del works like routes do, so that's intuitive as well. As long 
as we have the simple default to add a new probe at a function, without 
any extra options we can do this too initially.

> > perf probe will make up a synthetic probe name for that - probe-1 
> > for example. It will also pick the suitable probe mechanism 
> > (kprobes).
> 
> How about [perfprobe:symbol_offs] ?

Yeah, that's a nice idea - naming it after the symbol keeps the probe 
namespace still very readable.

> > All the other extensions and possibilities - arguments, variables, 
> > source code lines, etc. should be natural and intuitive extensions 
> > of this basic, minimal syntax.
> 
> Don't you like current space(' ') separated arguments? :-) I mean, 
> what is 'natural' syntax in your opinion?

Yeah, space separated arguments are nice too. The question is how to 
specify a more precise coordinate for the bit we want to probe - and how 
to specify the information we want to extract. Something like:

  perf schedule+15

would be a rather intuitive shortcut for '15 lines into the schedule() 
function' - and it might even be a largely cross-kernel-version 
compatible way of specifying probe points.

Or this:

  perf schedule:'switch_count = &prev->nivcsw'

would insert the probe to the source code that matches that statement 
pattern. Rarely will people want to insert a probe to an absolutely line 
number - that's a usage mode for higher level tools. (so we definitely 
want to support it - but it should not use up valuable spots in our 
options space.) Same goes for symbol offsets, etc. - humans will rarely 
use them.

We also want to have functionality that helps people find probe spots 
within a function:

  perf probe --list-lines schedule

Would list the line numbers and source code of the schedule() function. 
(similar to how GDB 'list' works) That way someone can have an ad-hoc 
session of deciding what place to probe, and the line numbers make for 
an easy ID of the statement to probe.

Anyway, these details make or break the actual utility of this tool, so 
lets iterate this some more and we'll see the limitations and the needs 
in practice. As usual, tool design rarely survives first contact with an 
actual user - so we have to show some adaptibility ;-)

	Ingo
