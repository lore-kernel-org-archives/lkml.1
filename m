Return-Path: <linux-kernel-owner+w=401wt.eu-S1751399AbZJRGAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbZJRGAx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 02:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbZJRGAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 02:00:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbZJRGAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 02:00:52 -0400
Message-ID: <4ADAAF50.9040604@redhat.com>
Date: Sun, 18 Oct 2009 02:01:52 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
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
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com> <20091017080203.GA4155@elte.hu> <20091017103427.GA31238@elte.hu>
In-Reply-To: <20091017103427.GA31238@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> I took a good look at the current bits, and there are a few more things 
> that need to be fixed before we can consider 'perf probe' for upstream.
> 
> Firstly, this decoder bug is still not fixed:
> 
>   CHK     include/linux/compile.h
>   TEST    posttest
> Error: ffffffff81068fe0:        66 0f 73 fd 04          pslldq $0x4,%xmm5
> Error: objdump says 5 bytes, but insn_get_length() says 4 (attr:8000)
> make[1]: *** [posttest] Error 2
> 
> 64-bit allyesconfig will trigger this for example, but the attached 
> smaller config too. This needs to be fixed before we can apply any
> new commits.

Absolutely, yes. Thank you for reporting. I'm checking it again.

> Secondly, the probe syntax is quite non-obvious currently. All the 'p' 
> and -P gymnastics is just a barrier to the first-time user getting his 
> first probe inserted successfully.

Hmm...

> The user need not worry about whether it's a 'kprobe' or a 'kretprobe'. 
> The user should _specify_ what it wants to probe, and _that_ will lead 
> to 'perf probe' picking the most suitable facility to achieve that kind 
> of probing.
> 
> It might be a kprobe, a kretprobe, or an mcount driven function probe, 
> an existing tracepoint if it happens to be present in that place already 
> - or some other future mechanism. The driving force must be a robust 
> specification of 'what', not the mechanics of 'how'.

Agreed.

> Considering that, the current 'perf probe' syntax does not achieve that 
> goal yet.
> 
> Here are a few syntax suggestions
> 
> The simpest probe syntax should be to add a probe to a single function 
> name:
> 
>   perf probe +schedule
> 
> _nothing else_.
> 
> To remove it, the user should just do something like:
> 
>   perf probe -schedule
> 
> (to be symmetric 'perf probe +schedule' should work as well)

I think '-<symbol>' syntax doesn't work good with other command-line
options and multiple definitions.
(However, it will be good for input-from-file syntax. :-))

So, what would you think about using -D (def) and -U (undef) ?

> perf probe will make up a synthetic probe name for that - probe-1 for 
> example. It will also pick the suitable probe mechanism (kprobes).

How about [perfprobe:symbol_offs] ?

> All the other extensions and possibilities - arguments, variables, 
> source code lines, etc. should be natural and intuitive extensions of 
> this basic, minimal syntax.

Don't you like current space(' ') separated arguments? :-)
I mean, what is 'natural' syntax in your opinion?

> 
> To insert a simple probe no -P should be needed, 'p', no ':' - no probe 
> name even.

Yeah, return-probe and event-name should be optional.

> Furthermore, there should be a way to list existing probes (and only 
> probes), probably via 'perf list --probes' or 'perf probe --list'.

OK. I think perf probe --list will list up all probes including
user-defined ftrace-event via debugfs (not perf-probe), since
perf can use and delete it.

> Plus, 'perf probe --help' should list a few simple examples, beyond the 
> syntax.
> 
> Ok?

Sure.

Thank you!


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

