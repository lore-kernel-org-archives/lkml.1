Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbZH3Tut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbZH3Tut (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 15:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbZH3Tus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 15:50:48 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:50769 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbZH3Tur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 15:50:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=kFVLicyVI+/K0mpEc6cu2Sd1dIU3xDXbOAKHNh3gsoWTXBbM/0mK8Y/+9crjEfUqRv
         btELulSncO8HT9E7dmE28Oz8rSPJJ43VBxc86YJAQ/8H19VLXF3Sv0GCXaMN8HYTsGyu
         ClTTxNdjj2HfsBbvsvYoQ6RcIkDaBllmvNaaA=
Date: Sun, 30 Aug 2009 21:50:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?utf-8?B?UHJ6ZW15c8WCYXdQYXdlxYJjenlr?= <przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [TOOL] c2kpe: C expression to kprobe event format converter
Message-ID: <20090830195041.GA6189@nowhere>
References: <20090813203403.31965.20973.stgit@localhost.localdomain> <4A847EA7.20307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A847EA7.20307@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 04:59:19PM -0400, Masami Hiramatsu wrote:
> This program converts probe point in C expression to kprobe event
> format for kprobe-based event tracer. This helps to define kprobes
> events by C source line number or function name, and local variable
> name. Currently, this supports only x86(32/64) kernels.
>
>
> Compile
> --------
> Before compilation, please install libelf and libdwarf development
> packages.
> (e.g. elfutils-libelf-devel and libdwarf-devel on Fedora)


This may probably need a specific libdwarf version?

c2kpe.c: In function ‘die_get_entrypc’:
c2kpe.c:422: erreur: ‘Dwarf_Ranges’ undeclared (first use in this function)
c2kpe.c:422: erreur: (Each undeclared identifier is reported only once
c2kpe.c:422: erreur: for each function it appears in.)
c2kpe.c:422: erreur: ‘ranges’ undeclared (first use in this function)
c2kpe.c:447: attention : implicit declaration of function ‘dwarf_get_ranges’
c2kpe.c:451: attention : implicit declaration of function ‘dwarf_ranges_dealloc’


> TODO
> ----
>  - Fix bugs.
>  - Support multiple probepoints from stdin.
>  - Better kmodule support.
>  - Use elfutils-libdw?
>  - Merge into trace-cmd or perf-tools?


Yeah definetly, that would be a veeery interesting thing to have.
I've played with kprobe ftrace to debug something this evening.

It's very cool to be able to put dynamic tracepoints in desired places.

But...
I firstly needed to put random trace_printk() in some places to
observe some variables values. And then I thought about the kprobes
tracer and realized I could do that without the need of rebuilding
my kernel. Then I've played with it and indeed it works well and
it's useful, but at the cost of reading objdump based assembly
code to find the places where I could find my variables values.
And after two or three probes in such conditions, I've become
tired of that, then I wanted to try this tool.


While I cannot yet because of this build error, I can imagine
the power of such facility from perf.

We could have a perf probe that creates a kprobe event in debugfs
(default enable = 0) and which then rely on perf record for the actual
recording.

Then we could analyse it through perf trace.
Let's imagine a simple example:

int foo(int arg1, int arg2)
{
	int var1;

	var1 = arg1;
	var1 *= arg2;
	var1 -= arg1;

------> insert a probe here (file bar.c : line 60)

	var1 ^= ...

	return var1;
}

./perf kprobe --file bar.c:60 --action "arg1=%d","arg2=%d","var1=%d" -- ls -R /
./perf trace
	arg1=1 arg2=1 var1=0
	arg1=2 arg2=2 var1=2
	etc..

You may want to sort by field:

./perf trace -s arg1 --order desc
        arg1=1
          |
          ------- arg2=1 var=1
          |
          ------- arg2=2 var=1

        arg1=2
          |
          ------- arg2=1 var=0
          |
          ------- [...]

./perf trace -s arg1,arg2 --order asc
        arg1=1
          |
          ------- arg2=1
                    |
                    --------- var1=0
                    |
                    --------- var1=....
                  arg2=...
                    |

Ok the latter is a bad example because var1 will always have only one
value for a given arg1 and arg2. But I guess you see the point.

You won't have to care about the perf trace part, it's already
implemented and I'll soon handle the sorting part.

All we need is the perf kprobes that translate a C level
probing expression to a /debug/tracing/kprobe_events compliant
thing. And then just call perf record with the new created
event as an argument.

Frederic.

