Return-Path: <linux-kernel-owner+w=401wt.eu-S1753714AbZHQV5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbZHQV5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 17:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbZHQV5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 17:57:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55032 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbZHQV5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 17:57:50 -0400
Message-ID: <4A89D29E.1010509@redhat.com>
Date: Mon, 17 Aug 2009 17:58:54 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [RFD] Kprobes/Kretprobes perf support
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com> <4A82EEC5.8000603@redhat.com> <4A82F5A0.2090603@redhat.com> <20090812191305.GB5974@nowhere> <4A857D49.3030705@redhat.com> <20090815143317.GB12298@elte.hu>
In-Reply-To: <20090815143317.GB12298@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> Frederic Weisbecker wrote:
>>> Ftrace events are supported by perfcounter currently but Kprobes
>>> dynamic ftrace events are of a different nature: we must create them
>>> before any toggling.
>>>
>>> So a large part is already done through the ftrace events and the fact
>>> that you create one dynamically for each kprobes (we'll just need
>>> a little callback for perf sample submission but that's a small
>>> point).
>>>
>>> The largest work that remains is to port the current powerful interface
>>> to create these k{ret}probes (with requested  arguments, etc...) through
>>> ftrace but using perf open syscall.
>>>
>>> And I imagine it won't be trivial.
>>>
>>> Ingo, Peter do you have an idea on how we could do that?
>>> We should be able to choose between a kprobe and kretprobe (these can
>>> be two separate counters). And also one must be able to request the dump
>>> of random desired parameters (or return values in case of kretprobe)
>>> or registers...
>>>
>>> May be we should use the perf attr by passing a __user address to a buffer
>>> that contains all these options?
>>> Once we get that to the kernel, that can be passed to ftrace-kprobe that
>>> can parse it, create the desired trace event and rely on perf to create
>>> a counter for it.
>>>
>>> I guess that won't imply so much adds to Masami's patchset. Most of
>>> the work is on the perf tools (parsing the user request).
>>>
>>> ./perf kprobes -e (func|addr):(c|r):(a1,a2,a3,... | rax,rbx,rcx,...)
>>>                                ^  ^
>>>                             c = call = kprobe
>>>                             r = return = kretprobe

It is better to support C/source syntax too.

./perf kprobes [-m kmod] [-k vmlinux] -e event-definition [-a arg-definition]
 or
./perf kprobes [-m kmod] [-k vmlinux] -f definition-file
 or
./perf kprobes [-m kmod] [-k vmlinux] -

event-definition:
 (p|r):[event-name]:probepoint

p = kprobe
r = kretprobe

probepoint (with debuginfo):
 function[+offs][@file]
 or
 @file:line

probepoint (without debuginfo):
 function[+offs]
 or
 address

arg-definition:
 a1,a2,a3,... | %ax,%bx,%cx,...| $var1,$var2,...

$var1,... are converted to register or memory address
by using debuginfo.

Thus, you can use perf like this.

./perf kprobes -e p::@mm/filemap.c:339 -a $inode,$pos


>>
>> If it is possible that libdwarf can be linked to the perf tool, I 
>> think it might be better to support 'C source line/local variable' 
>> style too, because basic dwarf decoding logic has already been 
>> done in c2kpe which I posted yesterday :-).
> 
> Sure - we can link it - and C/source syntax beats everything else, 
> hands down. We can also do the kind of automatic 'conditional 
> linking' we do for C++ symbol demangling - i.e. if libdwarf is not 
> installed we just emit a warning and dont build that functionality 
> but otherwise perf will still be built fine.
> 
> Thus there will be no dependency on libdwarf.

That's fine to me. If there is no libdwarf or CONFIG_DEBUG_INFO=n (or
just couldn't find vmlinux), 'perf kprobes' just doesn't accept
C/source syntax (and fail back to symbol/address syntax).

> 
> One thing that occured to me is that it would be nice to have sanity 
> checks of all sorts. For example we could expose the md5sum of the 
> kernel image and perf would double check against that when looking 
> around in the debuginfo - or something like that.

Systemtap has been done it with build-id.
http://sources.redhat.com/bugzilla/show_bug.cgi?id=4886

Perhaps, we can also use build-id to check the vmlinux version.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

