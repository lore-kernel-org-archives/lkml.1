Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbZJEUQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbZJEUQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 16:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbZJEUQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 16:16:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958AbZJEUQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 16:16:03 -0400
Message-ID: <4ACA549F.9010300@redhat.com>
Date: Mon, 05 Oct 2009 16:18:39 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH tracing/kprobes v2 1/5] tracing/kprobes: Rename special
 variables syntax
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com> <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com> <20091003015444.GE4828@nowhere> <4AC830F0.2010003@redhat.com> <20091005191829.GA6071@nowhere>
In-Reply-To: <20091005191829.GA6071@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Sun, Oct 04, 2009 at 01:21:52AM -0400, Masami Hiramatsu wrote:
>> Hmm, # is widely used for comment, including some kernel pseudo
>> file interfaces, kprobe_events too. Comments are useful if a
>> probe list is restored from a file.
>>
>
>
> Right, let's think about something else.
>
>
>> For accessing local variables, kprobe-tracer needs to support *at least*
>> below variables:
>> - Registers
>> - Stack address (if a register points stack address, this isn't needed)
>
>
> Ok.
> Well, thinking more about the % sign, we shouldn't worry about
> format confusion, since it's a commonly used character for registers,
> we can take it for them: %rax, %rbx, etc. (is that what you did
> in this patch? I don't remember exactly...)

Yeah, that's what it does currently.

> And for addresses: @addr
>
>
>> Below special vars are complementary aliases.
>> - Function arguments
>
>
>
> For the function arguments, I guess we don't need to worry
> anymore about r0, r1, etc... but we can deal with the true var
> name, without any kind of prefixes.

This depends on ABI, function argument from ABI doesn't need
debuginfo, but it will be unstable on some arch, e.g. x86-32
with/without asmlinkage.

Thus, I think that we can just describe where function arguments
will be(e.g. arg0 is ax) as a note for each architecture
in Documents/trace/kprobetrace.txt.

>> - Return value
>
> What about %return ?
>
> As return values are usually stored in a register (at least in Arm
> and x86, I don't know about the others), the % prefix fits well for
> that.

Sure, that's what I

>> - Return address
>
>
> What about @return :-) ?

Hmm, it might conflict with global symbol... Maybe, we can remove this
because retprobe already shows return address in the head of entry.

(BTW, ideally, I think 'IP' should be the return address in kretprobe.
  But current implementation isn't.)

> That said we shouldn't worry about that in perf, since we can
> take snapshots of the backtraces, like in some other perf events.

Agreed.

>> and I'd like perf-probe to have a transparent syntax with kprobe-tracer.
>
>
> That's feasible. But think about the fact that perf probe benefits
> from a higher level of code view. Now that we have global and local
> variables resolution, we can't anymore expect using r1, r2, rax,
> a1, rv, ra without risking to collide with variable names.
>
> But this tracer hasn't been merged yet, so it's still time
> to update its interface.

Sure.

>> This means, if we can remove special vars except registers, or rename it
>> non-conflictable name with registers, we just need to separate name spaces
>> of
>> - Regsiters
>> - Local variables
>
>
> Yeah.
>
>
>> Here, local variables will support fields of data structs, and it will
>> use '->' expression. Since'>' means redirection in bash, local variables
>> need to be *escaped* in this case. Thus, I think we can use '$' prefix
>> for it. (I'm OK, because this is similar syntax to systemtap:-).
>>
>> So, if you don't like %regs, $svars and locals, we can use regs and $locals :-)
>
>
> '>' means redirection, but at least inside quotes it's not interpreted.

Ah, indeed.

> I'm fine with %regs actually. But I really don't like the "$" because
> I really worry about shell substitutions.
>
> Most people delimit their strings with double quotes.

Sure, especially C programmers :-)

> What if we take the following:
>
> [Ftrace and perf probe side]
>
> %reg = registers, we can also play with deref and offsets like (%esp), 8(%esp), etc.

Hmm, on x86-32, sp at intr context is not pointing the top of stack. actually &sp is
the real address of the stack :(
Perhaps, on x86-32, we can translate %sp to stack address in kprobe-tracer.

 > %return = return value

or %retval? :)

> @return = return addr

I'd like to remove it, because it's already shown.

> arg(n) = arg number, where n is the number

How about %N? or just adds a note in documents.


> [Perf probe only]
>
> var = variable name, global or local, we can deal with shadow issues later
>        through variable scope: func_name:var, filename:var, whatever for now
>        it's not a problem. Local also includes argument names.

That's fine to me. :-)

Thank you!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

