Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbZJSSzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbZJSSzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 14:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757239AbZJSSzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 14:55:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757241AbZJSSzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 14:55:08 -0400
Message-ID: <4ADCB655.2020101@redhat.com>
Date: Mon, 19 Oct 2009 14:56:21 -0400
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
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com> <20091017080203.GA4155@elte.hu> <20091017103427.GA31238@elte.hu> <4ADAAF50.9040604@redhat.com> <20091019075103.GF17960@elte.hu>
In-Reply-To: <20091019075103.GF17960@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>> Here are a few syntax suggestions
>>>
>>> The simpest probe syntax should be to add a probe to a single 
>>> function name:
>>>
>>>   perf probe +schedule
>>>
>>> _nothing else_.
>>>
>>> To remove it, the user should just do something like:
>>>
>>>   perf probe -schedule
>>>
>>> (to be symmetric 'perf probe +schedule' should work as well)
>>
>> I think '-<symbol>' syntax doesn't work good with other command-line 
>> options and multiple definitions. (However, it will be good for 
>> input-from-file syntax. :-))
> 
> dash can be used too - perf has the options library from Git and there's 
> a wide spectrum of option parsing available, via 
> tools/perf/util/parse-options.h.
> 
> But yes, it complicates things a bit.

Yeah, what I'm concerning about is that user will confuse when deleting
probe points which starts with other option, like 'k'.
(-kmalloc can mean -k malloc too)

>> So, what would you think about using -D (def) and -U (undef) ?
> 
> The simpest case should be no extra character at all:
> 
>   perf probe schedule
> 
> There's a few well-known command line idioms to add/remove stuff, but -D 
> / -U is not one of them i'm afraid =B-)
> 
> The following ones might work too:
> 
>   perf probe +schedule
>   perf probe -schedule
> 
>   perf probe add schedule
>   perf probe del schedule
> 
>   perf probe --add schedule
>   perf probe --del schedule
> 
> [ Plain 'add/del' has a minor complication as we could have a similar 
>   symbol defined. ]
> 
> + / - is certainly the simplest.
> 
> --add/--del works like routes do, so that's intuitive as well. As long 
> as we have the simple default to add a new probe at a function, without 
> any extra options we can do this too initially.

How about the following syntax?
<adding>
perf probe schedule
perf probe --add schedule

<deleting>
perf probe --del schedule
perf probe --del all	/* delete all probepoints */

So, this doesn't symmetric, but provides simple way to add a probe.

>>> All the other extensions and possibilities - arguments, variables, 
>>> source code lines, etc. should be natural and intuitive extensions 
>>> of this basic, minimal syntax.
>>
>> Don't you like current space(' ') separated arguments? :-) I mean, 
>> what is 'natural' syntax in your opinion?
> 
> Yeah, space separated arguments are nice too. The question is how to 
> specify a more precise coordinate for the bit we want to probe - and how 
> to specify the information we want to extract. Something like:
> 
>   perf schedule+15
> 
> would be a rather intuitive shortcut for '15 lines into the schedule() 
> function' - and it might even be a largely cross-kernel-version 
> compatible way of specifying probe points.

I agreed with the cross-kernel-version issue. I'd rather like

 perf probe symbol:relative-line

and

 perf probe file:absolute-line

since it will be familiar for GDB users.

And I'd like to preserve

 perf probe symbol+offs-byte

for assembly users who might want to trace assembly code with
objdump.

> Or this:
> 
>   perf schedule:'switch_count = &prev->nivcsw'
> 
> would insert the probe to the source code that matches that statement 
> pattern. Rarely will people want to insert a probe to an absolutely line 
> number - that's a usage mode for higher level tools. (so we definitely 
> want to support it - but it should not use up valuable spots in our 
> options space.) Same goes for symbol offsets, etc. - humans will rarely 
> use them.

Hmm, maybe, it's possible. I should investigate dwarf more...


Thank you!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

