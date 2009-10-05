Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbZJETTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbZJETTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 15:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZJETTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 15:19:12 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:42470 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbZJETTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 15:19:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r1AhTMJniat/khi81AUBpzWQviAhlklxHHkD/WJcHqij4omhW3nJmSdqMAPvHJIGot
         uVLul7qz7UfM8Vuotw/BcMj7CIYmMDoC5VZRUf+HOnWGyWeXqGZ3fJzsHq27i2WcXg4f
         VN6k6NSuVyTyhP6HpogCdFkL9ld/JMod+N030=
Date: Mon, 5 Oct 2009 21:18:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20091005191829.GA6071@nowhere>
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com> <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com> <20091003015444.GE4828@nowhere> <4AC830F0.2010003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC830F0.2010003@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 04, 2009 at 01:21:52AM -0400, Masami Hiramatsu wrote:
> Hmm, # is widely used for comment, including some kernel pseudo
> file interfaces, kprobe_events too. Comments are useful if a
> probe list is restored from a file.
>


Right, let's think about something else.


> For accessing local variables, kprobe-tracer needs to support *at least*
> below variables:
> - Registers
> - Stack address (if a register points stack address, this isn't needed)


Ok.
Well, thinking more about the % sign, we shouldn't worry about
format confusion, since it's a commonly used character for registers,
we can take it for them: %rax, %rbx, etc. (is that what you did
in this patch? I don't remember exactly...)

And for addresses: @addr


> Below special vars are complementary aliases.
> - Function arguments



For the function arguments, I guess we don't need to worry
anymore about r0, r1, etc... but we can deal with the true var
name, without any kind of prefixes.


> - Return value



What about %return ?

As return values are usually stored in a register (at least in Arm
and x86, I don't know about the others), the % prefix fits well for
that.


> - Return address


What about @return :-) ?

That said we shouldn't worry about that in perf, since we can
take snapshots of the backtraces, like in some other perf events.


> and I'd like perf-probe to have a transparent syntax with kprobe-tracer.


That's feasible. But think about the fact that perf probe benefits
from a higher level of code view. Now that we have global and local
variables resolution, we can't anymore expect using r1, r2, rax, 
a1, rv, ra without risking to collide with variable names.

But this tracer hasn't been merged yet, so it's still time
to update its interface.

 
> This means, if we can remove special vars except registers, or rename it
> non-conflictable name with registers, we just need to separate name spaces
> of
> - Regsiters
> - Local variables


Yeah.


> Here, local variables will support fields of data structs, and it will
> use '->' expression. Since '>' means redirection in bash, local variables
> need to be *escaped* in this case. Thus, I think we can use '$' prefix
> for it. (I'm OK, because this is similar syntax to systemtap:-).
> 
> So, if you don't like %regs, $svars and locals, we can use regs and $locals :-)


'>' means redirection, but at least inside quotes it's not interpreted.

I'm fine with %regs actually. But I really don't like the "$" because
I really worry about shell substitutions.

Most people delimit their strings with double quotes.

What if we take the following:

[Ftrace and perf probe side]

%reg = registers, we can also play with deref and offsets like (%esp), 8(%esp), etc.
%return = return value
@return = return addr
arg(n) = arg number, where n is the number


[Perf probe only]

var = variable name, global or local, we can deal with shadow issues later
      through variable scope: func_name:var, filename:var, whatever for now
      it's not a problem. Local also includes argument names.

Hmm?

