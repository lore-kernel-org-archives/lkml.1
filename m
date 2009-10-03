Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbZJCBZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbZJCBZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 21:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756683AbZJCBZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 21:25:32 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:57811 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656AbZJCBZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 21:25:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SeQpucRP2XXSUXr0OPxZSptshTrGrP2bDNFQFBoFhI86xwC1cJMZ4F+8bMEenZ8Ged
         FuZagqwSgpGniNYckhy2xjW0qjFcsIM2VlpPIhJ/XGSQNDJ1ugil6qOzPCjVQM/WCD8y
         wndSkNRQp/9YlJzPP8hQ+aQyf2B5GxnpcfgMY=
Date: Sat, 3 Oct 2009 03:25:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH tracing/kprobes v2 0/5] tracing/kprobes, perf: perf
	probe support take 2
Message-ID: <20091003012528.GC4828@nowhere>
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 05:48:34PM -0400, Masami Hiramatsu wrote:
> Hi,
> 
> These patches introduce 'perf probe' command and update kprobe-tracer.
> perf probe command allows you to add new probe points by C line number
> and local variable names.
> 
> This version fixes some bugs, changes subcommand name from kprobe to
> probe and use spaces for separator instead of ',' for visibility (this
> also make it easy to support probe list from stdin).
> 
> Usage
> -----
>  perf probe [<options>] -P 'PROBEDEF' [-P 'PROBEDEF' ...]
> 
>     -k, --vmlinux <file>  vmlinux/module pathname
>     -r, --release <rel>   kernel release
>     -P, --probe <p|r:[GRP/]NAME FUNC[+OFFS][@SRC]|@SRC:LINE [ARG ...]>
>                           probe point definition, where
> 		p:	kprobe probe
> 		r:	kretprobe probe
> 		GRP:	Group name (optional)
> 		NAME:	Event name
> 		FUNC:	Function name
> 		OFFS:	Offset from function entry (in byte)
> 		SRC:	Source code path
> 		LINE:	Line number
> 		ARG:	Probe argument (local variable name or
> 			kprobe-tracer argument format is supported.)
> 
> Examples
> --------
> 1) Add a new kprobe probe on a line of C source code.
> ./perf probe -P 'p:myprobe @fs/read_write.c:285 file buf count'
> Adding new event: p:myprobe vfs_read+57 file=%bx buf=%si count=%ax


Nice! Great thing.

One neat, at a first glance, file=%bx buf=%si look like a format
definition.

How about using file=bx ? Or does that introduce any ambiguities
with kprobes definitions syntax?



> 
> 2) Add a new kretprobe probe on a function return.
> ./perf probe -P 'r:myretprobe vfs_read $rv'
> Adding new event: r:myretprobe vfs_read+0 $rv


The '$' character may perhaps also confuse bash scripts that create
perf probe.



> 3) Check it in the perf list.
> ./perf list
> ...
>   rNNN                                       [raw hardware event descriptor]
> 
>   kprobes:myprobe                            [Tracepoint event]
>   kprobes:myretprobe                         [Tracepoint event]
>   skb:kfree_skb                              [Tracepoint event]
> ...
> 
> 4) Record the event by perf
> ./perf record -f -e kprobes:myprobe:record  -F 1 -a ls
> ...
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.081 MB perf.data (~3540 samples) ]
> 
> 5) Trace the event
> ./perf trace
>             perf-11445 [000] 95862.048894383: myprobe: (c04bbed5) file=dae15e80 buf=b78b2000 count=400
>             perf-11445 [000] 95862.049066533: myprobe: (c04bbed5) file=dae15d80 buf=b78b2000 count=400
>             perf-11445 [000] 95862.049134394: myprobe: (c04bbed5) file=dae15d80 buf=b78b2000 count=400
>             perf-11445 [000] 95862.049171495: myprobe: (c04bbed5) file=dae15a80 buf=b78b2000 count=400
> 
> NOTE
> ----
>  perf still fails to parse format if arguments have special charactors
> (e.g. $rv, +10($sp) etc.) So, tracing myretprobe will fail with this
> version. This will be solved by naming arguments automatically if it
> doesn't have C-language name.
> 
> TODO
> ----
>  - Support sys_perf_counter_open (non-root)


Hmm, we really want it to be only usable by the root
(except if the policy is tuned to allow that, but that's
managed by perf already).


>  - Input from stdin/output to stdout
>  - Non-auto static variable
>  - Fields of data structures (var->field)
>  - Type support
>    - Bit fields
>  - Array (var[N])
>  - Dynamic array indexing (var[var2])
>  - String/dynamic arrays (var:string, var[N..M])
>  - Force Type casting ((type)var)
>  - Non-inline search
>  - libdw, libdwfl
>  - etc.
> 
> Thank you,
> 


Cool, I'm reviewing/testing it and if no rough problem
arise I'll apply it.

Thanks a lot!

