Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbZHOOdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbZHOOdj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 10:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbZHOOdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 10:33:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38650 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088AbZHOOdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 10:33:38 -0400
Date: Sat, 15 Aug 2009 16:33:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [RFD] Kprobes/Kretprobes perf support
Message-ID: <20090815143317.GB12298@elte.hu>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com> <4A82EEC5.8000603@redhat.com> <4A82F5A0.2090603@redhat.com> <20090812191305.GB5974@nowhere> <4A857D49.3030705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A857D49.3030705@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Frederic Weisbecker wrote:
>> Ftrace events are supported by perfcounter currently but Kprobes
>> dynamic ftrace events are of a different nature: we must create them
>> before any toggling.
>>
>> So a large part is already done through the ftrace events and the fact
>> that you create one dynamically for each kprobes (we'll just need
>> a little callback for perf sample submission but that's a small
>> point).
>>
>> The largest work that remains is to port the current powerful interface
>> to create these k{ret}probes (with requested  arguments, etc...) through
>> ftrace but using perf open syscall.
>>
>> And I imagine it won't be trivial.
>>
>> Ingo, Peter do you have an idea on how we could do that?
>> We should be able to choose between a kprobe and kretprobe (these can
>> be two separate counters). And also one must be able to request the dump
>> of random desired parameters (or return values in case of kretprobe)
>> or registers...
>>
>> May be we should use the perf attr by passing a __user address to a buffer
>> that contains all these options?
>> Once we get that to the kernel, that can be passed to ftrace-kprobe that
>> can parse it, create the desired trace event and rely on perf to create
>> a counter for it.
>>
>> I guess that won't imply so much adds to Masami's patchset. Most of
>> the work is on the perf tools (parsing the user request).
>>
>> ./perf kprobes -e (func|addr):(c|r):(a1,a2,a3,... | rax,rbx,rcx,...)
>>                                ^  ^
>>                             c = call = kprobe
>>                             r = return = kretprobe
>
> If it is possible that libdwarf can be linked to the perf tool, I 
> think it might be better to support 'C source line/local variable' 
> style too, because basic dwarf decoding logic has already been 
> done in c2kpe which I posted yesterday :-).

Sure - we can link it - and C/source syntax beats everything else, 
hands down. We can also do the kind of automatic 'conditional 
linking' we do for C++ symbol demangling - i.e. if libdwarf is not 
installed we just emit a warning and dont build that functionality 
but otherwise perf will still be built fine.

Thus there will be no dependency on libdwarf.

One thing that occured to me is that it would be nice to have sanity 
checks of all sorts. For example we could expose the md5sum of the 
kernel image and perf would double check against that when looking 
around in the debuginfo - or something like that.

	Ingo
