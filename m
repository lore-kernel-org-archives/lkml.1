Return-Path: <linux-kernel-owner+w=401wt.eu-S1751350AbZHaENn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbZHaENn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 00:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbZHaENm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 00:13:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbZHaENl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 00:13:41 -0400
Message-ID: <4A9B4E2A.1070201@redhat.com>
Date: Mon, 31 Aug 2009 00:14:34 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?UTF-8?B?UHJ6ZW15c8WCYXdQYXdlxYJjenlr?= <przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [TOOL] c2kpe: C expression to kprobe event format converter
References: <20090813203403.31965.20973.stgit@localhost.localdomain> <4A847EA7.20307@redhat.com> <20090830195041.GA6189@nowhere>
In-Reply-To: <20090830195041.GA6189@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Aug 13, 2009 at 04:59:19PM -0400, Masami Hiramatsu wrote:
>> This program converts probe point in C expression to kprobe event
>> format for kprobe-based event tracer. This helps to define kprobes
>> events by C source line number or function name, and local variable
>> name. Currently, this supports only x86(32/64) kernels.
>>
>>
>> Compile
>> --------
>> Before compilation, please install libelf and libdwarf development
>> packages.
>> (e.g. elfutils-libelf-devel and libdwarf-devel on Fedora)
> 
> 
> This may probably need a specific libdwarf version?
> 
> c2kpe.c: In function ‘die_get_entrypc’:
> c2kpe.c:422: erreur: ‘Dwarf_Ranges’ undeclared (first use in this function)
> c2kpe.c:422: erreur: (Each undeclared identifier is reported only once
> c2kpe.c:422: erreur: for each function it appears in.)
> c2kpe.c:422: erreur: ‘ranges’ undeclared (first use in this function)
> c2kpe.c:447: attention : implicit declaration of function ‘dwarf_get_ranges’
> c2kpe.c:451: attention : implicit declaration of function ‘dwarf_ranges_dealloc’

Aah, sure, it should be compiled with libdwarf newer than 20090324.
You can find it in http://reality.sgiweb.org/davea/dwarf.html

BTW, libdwarf and libdw (which is the yet another implementation of
dwarf library) are still under development, e.g. libdwarf doesn't
support gcc-4.4.1(very new) and only the latest libdw(0.142) can
support it. So, perhaps I might better port it on libdw, even that is
less documented...:(

>> TODO
>> ----
>>  - Fix bugs.
>>  - Support multiple probepoints from stdin.
>>  - Better kmodule support.
>>  - Use elfutils-libdw?
>>  - Merge into trace-cmd or perf-tools?
> 
> 
> Yeah definetly, that would be a veeery interesting thing to have.
> I've played with kprobe ftrace to debug something this evening.
> 
> It's very cool to be able to put dynamic tracepoints in desired places.
> 
> But...
> I firstly needed to put random trace_printk() in some places to
> observe some variables values. And then I thought about the kprobes
> tracer and realized I could do that without the need of rebuilding
> my kernel. Then I've played with it and indeed it works well and
> it's useful, but at the cost of reading objdump based assembly
> code to find the places where I could find my variables values.
> And after two or three probes in such conditions, I've become
> tired of that, then I wanted to try this tool.
> 
> 
> While I cannot yet because of this build error, I can imagine
> the power of such facility from perf.
> 
> We could have a perf probe that creates a kprobe event in debugfs
> (default enable = 0) and which then rely on perf record for the actual
> recording.
> 
> Then we could analyse it through perf trace.
> Let's imagine a simple example:
> 
> int foo(int arg1, int arg2)
> {
> 	int var1;
> 
> 	var1 = arg1;
> 	var1 *= arg2;
> 	var1 -= arg1;
> 
> ------> insert a probe here (file bar.c : line 60)
> 
> 	var1 ^= ...
> 
> 	return var1;
> }
> 
> ./perf kprobe --file bar.c:60 --action "arg1=%d","arg2=%d","var1=%d" -- ls -R /

I recommend it should be separated from record, like below:

# set new event
./perf kprobe --add kprobe:event1 --file bar.c:60 --action "arg1=%d","arg2=%d","var1=%d"
# record new event
./perf record -e kprobe:event1 -a -R -- ls -R /

This will allow us to focus on one thing -- convert C to kprobe-tracer.
And also, it can be listed as like as tracepoint events.

> ./perf trace
> 	arg1=1 arg2=1 var1=0
> 	arg1=2 arg2=2 var1=2
> 	etc..
> 
> You may want to sort by field:
> 
> ./perf trace -s arg1 --order desc
>         arg1=1
>           |
>           ------- arg2=1 var=1
>           |
>           ------- arg2=2 var=1
> 
>         arg1=2
>           |
>           ------- arg2=1 var=0
>           |
>           ------- [...]
> 
> ./perf trace -s arg1,arg2 --order asc
>         arg1=1
>           |
>           ------- arg2=1
>                     |
>                     --------- var1=0
>                     |
>                     --------- var1=....
>                   arg2=...
>                     |
> 
> Ok the latter is a bad example because var1 will always have only one
> value for a given arg1 and arg2. But I guess you see the point.
> 
> You won't have to care about the perf trace part, it's already
> implemented and I'll soon handle the sorting part.
> 
> All we need is the perf kprobes that translate a C level
> probing expression to a /debug/tracing/kprobe_events compliant
> thing. And then just call perf record with the new created
> event as an argument.

Indeed, that's what I imagine.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

