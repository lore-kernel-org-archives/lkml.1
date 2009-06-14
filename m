Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbZFNBwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbZFNBwo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 21:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbZFNBwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 21:52:36 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:39530 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbZFNBwg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 21:52:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=kCo84p27t8PVJRYoQMEYl9zTwS83KDMWNK8gcLQgdRFIsB8nuEpYGmzpw6I0qItXQJ
         70qCe1vhlDDxBVpteVytUIiu0/WlKYGw7VSz6oP8kJNa593RrAQtncIwpeU1ha+nAQTM
         44a7vDKGuUOrxd8Afd1a9MbGxGcR3txaYPiQ0=
MIME-Version: 1.0
In-Reply-To: <20090614012457.GD5986@nowhere>
References: <20090613222440.GA5986@nowhere> <1244938913-11775-1-git-send-email-vapier@gentoo.org> 
	<20090614012457.GD5986@nowhere>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 13 Jun 2009 21:52:18 -0400
Message-ID: <8bd0f97a0906131852r255a30a5p1d602a6eb7778ff4@mail.gmail.com>
Subject: Re: [PATCH v3] ftrace: document basic ftracer/ftracer graph needs
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 21:24, Frederic Weisbecker wrote:
> On Sat, Jun 13, 2009 at 08:21:53PM -0400, Mike Frysinger wrote:
>> +HAVE_FUNCTION_GRAPH_TRACER
>
> Should be HAVE_FUNCTION_TRACER, right?

yes

> There is one crucial missing thing, I mean "save all state needed by the ABI"
> can be more detailed. do_trace _must_
> save the scratch and argument registers to the stack because
> the traced function may have parameters passed by registers,
> initialized things on scratch registers, and this state
> must be left intact before calling ftrace_trace_function()

parameters passed by registers, yes, but as for scratch registers,
that depends on the toolchain and where the mcount invocation occurs.
if it's before the function prolog, then no, it doesnt need to worry
about any scratch registers.  if it's after, then yes, it probably
needs to worry about those things.  but this is why i have a paragraph
saying "go read your abi documentation" and review glibc.

>> +For information on how to implement prepare_ftrace_return(), simply look at
>> +the x86 version.  The only architecture-specific piece in it is the setup of
>> +the fault recovery table (the asm(...) code).  The rest should be the same
>> +across architectures.
>> +
>> +Here is the pseudo code for the new return_to_handler assembly function.  Note
>> +that the ABI that applies here is different from what applies to the mcount
>> +code.  Here you are returning from a function, so you might be able to skimp
>> +on things saved/restored.
>
> It would be nice to add details about that, especially about a constant rule:
> return_to_handler must save/restore the return value of the current exiting
> function around ftrace_return_to_handler call.
>
> And this return value might be stored in more than one register for
> 64 bits return values.
>
> But we don't need to save/restore the other scratch  registers because the
> traced function is exiting and won't need anymore values stored in them.

i'm not familiar with other architectures and crazy shit that might go
down here which is why i kind of skimped on details.  for the Blackfin
port, i know what i have to do -- just save/restore the return
registers (r0 for 32bits, +r1 for 64bits, +p0 for >64bits).  but i
purposefully tried to avoid ABI details because i dont want this
turning into "on <arch>, do <whole bunch of details>, on <arch2>, do
<whole bunch of details>, ....".

the scratch register is more because the exit code is coming after the
function epilog rather than "exiting it" ...

i dont mind adding tips, but the last thing i want is people
complaining that they did what the docs said and now things crashed
because they didnt fully grasp the "it's your ABI, so it's your
problem".

> Also, we had some problems with return_to_handler in x86-64.
> We needed to allocate a large stack room (0x80 bytes) before calling
> ftrace_return_to_handler(). The funny thing is that we still don't know
> why we needed to do that, but omitting that resulted in crashes :-)

without knowing anything about x86-64 treating of the stack, it does
seem weird.  with the Blackfin arch, the called function is
responsible for allocating its own space.

>> +HAVE_FTRACE_SYSCALLS
>> +---------------------
>> +
>> +<details to be filled>
>
> This part doesn't need more for now because it may change soon
> since the syscall tracing is currently reworked.
> We'll fill it once it reaches a more established state.
>
>> +HAVE_DYNAMIC_FTRACE
>> +---------------------
>> +
>> +<details to be filled>
>
> But this part is important :)

i filled in what i could reverse engineer ... and these two bits
looked way more complicated than was worth me trying to figure out.
these are what i'd be interested in next though.
-mike
