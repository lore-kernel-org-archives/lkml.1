Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616AbZIKBdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbZIKBdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 21:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbZIKBdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 21:33:35 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:45321 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbZIKBdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 21:33:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sYwd5kPf9FeGd7b+Gt+3sfab7WN18Rve7tvD7IEX63q1j2BUwQ7iuN8yB9dH04Gj6G
         VdtmTQKclKBRtsyJwdE4Hm6nG75IB+QLh7GJJB1R/NkzxTcp60M+GPcoyw/nou29sR9j
         68pT0uBb/M/VCR1Fukfq3FS4oBXcQyeoms2Ms=
Date: Fri, 11 Sep 2009 03:33:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH tracing/kprobes 0/7] tracing/kprobes: kprobe-based
	event tracer update and perf support
Message-ID: <20090911013332.GB16396@nowhere>
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 07:52:58PM -0400, Masami Hiramatsu wrote:
> Hi Frederic,
> 
> This series fixes bugs and upgrades kprobe-based event tracer
> as a dynamic event tracer on ftrace/perf tools. This also enhances
> tracer output format to show each argument name and event name on
> each entry.
> 
> With this series, users can add trace events dynamically on ftrace
> and use those events with perf tools as below.
> 
> (Step.1) Define new events under new group
> 
> $ echo p:mygroup/myprobe do_sys_open dfd=a0 filename=a1 flags=a2 mode=a3 \
>  > /debug/tracing/kprobes_events
> $ echo r:mygroup/myretprobe do_sys_open rv >> /debug/tracing/kprobes_events
> $ cat /debug/tracing/kprobes_events
> p:myprobe do_sys_open+0 dfd=a0 filename=a1 flags=a2 mode=a3
> r:myretprobe do_sys_open+0 rv=rv
> 
> (You can see that each argument has its name.)
> 
> 
> (Step.2) Perf shows new events
> 
> $ perf list
> ...
>    mygroup:myretprobe                         [Tracepoint event]
>    mygroup:myprobe                            [Tracepoint event]
> ...
> 
> 
> (Step.3) Record events with perf
> 
> $ perf record -f -e mygroup:myprobe:record -F 1 -a ls
> ...
> [ perf record: Captured and wrote 0.081 MB perf.data (~3544 samples) ]
> 
> 
> (Step.4) Perf trace shows the result
> 
> $ perf trace
> version = 0.5
>             perf-1405  [000]     0.000000: myprobe: (c04b0a5c) dfd=ffffff9c filename=810d3f7 flags=98800 mode=1
>             perf-1405  [000]     0.000000: myprobe: (c04b0a5c) dfd=ffffff9c filename=bff7650c flags=8000 mode=1b6
>             perf-1405  [000]     0.000000: myprobe: (c04b0a5c) dfd=ffffff9c filename=bff7650c flags=98800 mode=bff7450c
>             perf-1405  [000]     0.000000: myprobe: (c04b0a5c) dfd=ffffff9c filename=bff7650c flags=8000 mode=1b6


Nice!

May be another step in the todo-list that would be nice: define the format
for a type. Like it's done from ftrace events.


> 
> 
> (Step.5) You can also use return probes.
> 
> $ perf record -f -e mygroup:myretprobe:record -F 1 -a ls
> ...
> [ perf record: Captured and wrote 0.081 MB perf.data (~3544 samples) ]
> $ perf trace
> version = 0.5
>             perf-1408  [000]     0.000000: myretprobe: (c04b0a5c <- c04b0b7d) rv=b
>             perf-1408  [000]     0.000000: myretprobe: (c04b0a5c <- c04b0b7d) rv=c
>             perf-1408  [000]     0.000000: myretprobe: (c04b0a5c <- c04b0b7d) rv=d
>             perf-1408  [000]     0.000000: myretprobe: (c04b0a5c <- c04b0b7d) rv=c
> 
> 
> TODO:
> - Implement perf kprobe command to help defining new probes.



Yeah!

I wonder what could be the best workflow to use it.

Imagine the following steps:

- perf kprobe = define kprobes using C expression
- perf record -e our_kprobes
- perf trace

That's way too much.
Especially it's sad to be forced to define a kprobe, then
get back its name, use it with record, and eventually
unsheathe perf trace.

I guess we should choose between the low level, very granular
but uninviting method "kprobe + record + trace" and also an all
in one quick approach.

And that could be chosen from perf kprobe:

Low level:

perf kprobe --define-only [-p|-r] [probe_name] -a1 [arg1] -a2 [arg2] \
	    --format="%s %...."

perf record -e kprobes:probe_name
perf trace

Quick:

perf kprobe -p probe_name -a1 ..... cmdline| -a

And after the profiled task is finished, it could launch perf trace
by itself (or wait for a Ctrl + C if -a/wide profiling)

Well, it's just a brainstorming, having the low level method first
would be already a very nice thing.

I'm really looking forward seeing this C expression-like kprobe creation
tool.

It seems powerful enough to replace printk + kernel rebuild.

No need anymore to write some printk to debug, worrying,
sweating, feeling guilty because we know we'll need yet another
printk() after the reboot, and we even already know where while
it is compiling.

We would build less kernels, then drink less coffee, becoming
less nervous, more friendly. Everyone will offer flowers in
the street, the icebergs will grow back and white bears will...

And eventually we'll be inspired enough to write perf love,
the more than expected tool to post process ftrace "love" events.

Thanks,
Frederic.

