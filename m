Return-Path: <linux-kernel-owner+w=401wt.eu-S1751993AbZFNCYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbZFNCYj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 22:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZFNCYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 22:24:30 -0400
Received: from ey-out-1920.google.com ([74.125.78.146]:61066 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbZFNCYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 22:24:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=iUT1675jh8FdohlXDLYfnP2DhrNR6vaRLhpEaOjyFC8bdIVTbLgcA7OwbbTcYaRlL7
         uOtcCueheya9SVTdmqujWzak55g5B9rUdbsBvBftJ10M88LdRg4SG3K5gP78PnjEb5fC
         XzynH8HUDqOey4DNn3JP9KHep5GpYIHarcYfw=
Date: Sun, 14 Jun 2009 04:24:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ftrace: document basic ftracer/ftracer graph needs
Message-ID: <20090614022427.GE5986@nowhere>
References: <20090613222440.GA5986@nowhere> <1244938913-11775-1-git-send-email-vapier@gentoo.org> <20090614012457.GD5986@nowhere> <8bd0f97a0906131852r255a30a5p1d602a6eb7778ff4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0906131852r255a30a5p1d602a6eb7778ff4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 09:52:18PM -0400, Mike Frysinger wrote:
> On Sat, Jun 13, 2009 at 21:24, Frederic Weisbecker wrote:
> > On Sat, Jun 13, 2009 at 08:21:53PM -0400, Mike Frysinger wrote:
> >> +HAVE_FUNCTION_GRAPH_TRACER
> >
> > Should be HAVE_FUNCTION_TRACER, right?
> 
> yes
> 
> > There is one crucial missing thing, I mean "save all state needed by the ABI"
> > can be more detailed. do_trace _must_
> > save the scratch and argument registers to the stack because
> > the traced function may have parameters passed by registers,
> > initialized things on scratch registers, and this state
> > must be left intact before calling ftrace_trace_function()
> 
> parameters passed by registers, yes, but as for scratch registers,
> that depends on the toolchain and where the mcount invocation occurs.
> if it's before the function prolog, then no, it doesnt need to worry
> about any scratch registers.  if it's after, then yes, it probably
> needs to worry about those things.  but this is why i have a paragraph
> saying "go read your abi documentation" and review glibc.



Ok, then in this case, just talk about it as a constraint that
may be or not handled by the arch specific mcount.

It's really a prerequisite to check on every archs so I think
it's worth showing this mandatory stage in the recipe.


 
> >> +For information on how to implement prepare_ftrace_return(), simply look at
> >> +the x86 version.  The only architecture-specific piece in it is the setup of
> >> +the fault recovery table (the asm(...) code).  The rest should be the same
> >> +across architectures.
> >> +
> >> +Here is the pseudo code for the new return_to_handler assembly function.  Note
> >> +that the ABI that applies here is different from what applies to the mcount
> >> +code.  Here you are returning from a function, so you might be able to skimp
> >> +on things saved/restored.
> >
> > It would be nice to add details about that, especially about a constant rule:
> > return_to_handler must save/restore the return value of the current exiting
> > function around ftrace_return_to_handler call.
> >
> > And this return value might be stored in more than one register for
> > 64 bits return values.
> >
> > But we don't need to save/restore the other scratch  registers because the
> > traced function is exiting and won't need anymore values stored in them.
> 
> i'm not familiar with other architectures and crazy shit that might go
> down here which is why i kind of skimped on details.  for the Blackfin
> port, i know what i have to do -- just save/restore the return
> registers (r0 for 32bits, +r1 for 64bits, +p0 for >64bits).  but i
> purposefully tried to avoid ABI details because i dont want this
> turning into "on <arch>, do <whole bunch of details>, on <arch2>, do
> <whole bunch of details>, ....".



That's not what I'm suggesting.
As I explained above, it's about a generic and cross arch constraint.

The details of implementation are only a concern for the developer.


> 
> the scratch register is more because the exit code is coming after the
> function epilog rather than "exiting it" ...


Yeah, that's what I meant by "exiting" :)


> 
> i dont mind adding tips, but the last thing i want is people
> complaining that they did what the docs said and now things crashed
> because they didnt fully grasp the "it's your ABI, so it's your
> problem".



I'm only talking about generic rules here. Every ABI has conventions
about calls, scratch registers, etc...

But here we are using tracing code in very fragile paths that have
common constraints on every archs. Those constraints concern
common properties of every CPU, the implementation which implement
these constraints is only a concern of the arch developer.


> > Also, we had some problems with return_to_handler in x86-64.
> > We needed to allocate a large stack room (0x80 bytes) before calling
> > ftrace_return_to_handler(). The funny thing is that we still don't know
> > why we needed to do that, but omitting that resulted in crashes :-)
> 
> without knowing anything about x86-64 treating of the stack, it does
> seem weird.  with the Blackfin arch, the called function is
> responsible for allocating its own space.


That's also what does x86, really that's a mystery..


> >> +HAVE_FTRACE_SYSCALLS
> >> +---------------------
> >> +
> >> +<details to be filled>
> >
> > This part doesn't need more for now because it may change soon
> > since the syscall tracing is currently reworked.
> > We'll fill it once it reaches a more established state.
> >
> >> +HAVE_DYNAMIC_FTRACE
> >> +---------------------
> >> +
> >> +<details to be filled>
> >
> > But this part is important :)
> 
> i filled in what i could reverse engineer ... and these two bits
> looked way more complicated than was worth me trying to figure out.
> these are what i'd be interested in next though.
> -mike


Never mind, this documentation can be filled through several iterations.
This patch already provides very useful explanations.

Thanks,
Frederic.

