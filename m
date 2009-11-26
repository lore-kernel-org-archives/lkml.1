Return-Path: <linux-kernel-owner+w=401wt.eu-S1751100AbZKZRzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100AbZKZRzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 12:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750706AbZKZRzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 12:55:49 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47905 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbZKZRzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 12:55:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Zx2N1qwnL6AgT47Kl7GrnpbySqY/OGzprYjThOqdYWnokDAP09IiELAOEN2rw9UiZw
         G9Lp0QaveHhwZVKlugY2NYGubbrd2mE7fgCOqgKB6jIoAZKUbcSX/ohXBBEp96JWEDas
         /aB3fwppQBtqOX0OvfPfVY7fMjQsvuhr7Er98=
Date: Thu, 26 Nov 2009 18:55:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] events: Rename TRACE_EVENT_TEMPLATE() to
	DECLARE_EVENT_CLASS()
Message-ID: <20091126175548.GC4997@nowhere>
References: <4B0E286A.2000405@cn.fujitsu.com> <tip-091ad3658e3c76c5fb05f65bfb64a0246f8f31b5@git.kernel.org> <1259224390.21397.87.camel@gandalf.stny.rr.com> <20091126084039.GA15919@elte.hu> <1259246730.21397.97.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259246730.21397.97.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 09:45:30AM -0500, Steven Rostedt wrote:
> On Thu, 2009-11-26 at 09:40 +0100, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> 
> > > I would like to hear what others think about this change before we go 
> > > ahead and implement it.
> > 
> > You mean TRACE_EVENT() -> DEFINE_SINGLE_EVENT()? Sure, we want todo it 
> > in a more quiet moment of the kernel cycle, not now.
> > 
> > (TRACE_EVENT_TEMPLATE OTOH has existed for just a few days so it's not a 
> > problem.)
> 
> Yes the template name is new, I'm not talking about that on
> particularly.


I personally don't mind much about the name, especially
between class and template. Both make equally sense to me.

But DECLARE sounds like a misnomer here (like DEFINE_EVENT
somehow) as TRACE_EVENT, DEFINE_EVENT and TRACE_EVENT_TEMPLATE
all behave either as a declaration or a definition, depending
on the CREATE_TRACE_POINT macro.

Also, considering the arising question of notifiers and TRACE_EVENT
that are starting to collide in that we have two event callbacks
subsystems that could be gathered in one, I guess TRACE_EVENT will
become too general in the future.

If we consider improving the TRACE_EVENT to support tracing (like
it does already) but also blocking notifiers, atomic notifiers, etc...
by migrating the notifier code to TRACE_EVENT,
then the name should probably be reconsidered as a more general thing.

KERNEL_EVENT ? NOTIFY_EVENT ?

And then the CPP callbacks we are currently using for tracing should
probably be renamed as they won't concern the notifier callbacks.

TP_printk could be renamed as TRACE_print, TP_fast_assing could be
TRACE_fast_assign, etc...

 
> > 
> > > A lot of developers have just learned about TRACE_EVENT and now it 
> > > just disappeared. Well, not really, but in the sense of ' find 
> > > linux.git -name '*.[ch]' | xargs grep TRACE_EVENT' it no longer 
> > > exists.
> > 
> > A second problem with the TRACE_EVENT name is that it's not just for 
> > tracing - we dont necessarily 'trace' events here. We can use the event 
> > callbacks to collect pure counts:
> 
> Then we might as well rename the "trace_*" all over the kernel.


I think this should be kept. Although if notifier goes migrated in
TRACE_EVENT, having notify_event() would gather the two meanings of
trace_* and notify_*

 
> > DEFINE_SINGLE_EVENT() solves all these problems:
> > 
> >  - It's obvious what it does
> > 
> >  - It suggests users of it that there's another non-single-event 
> >    facility, gently nudging them towards the use of the more efficient
> >    DEFINE_EVENT_CLASS() + DEFINE_EVENT() method.
> > 
> >  - It fits nicely into the rest of the naming scheme.
> 
> Like I said earlier, I'm not really attached to the name. Except that
> there's already a lot of documentation (I've given tutorials about it)
> using the TRACE_EVENT name. But who am I to decide?


Not that I like much DEFINE_SINGLE_EVENT(), because DEFINE is ambiguous
and SINGLE too (single can indeed be interpreted as something that doesn't
need a class, but is also confusing as it suggests that DEFINE_EVENT defines
several events in once), but I think a tutorial shouldn't paralyze a
subsystem progression.

Why not having BUILD_EVENT_CLASS(), BUILD_EVENT_FROM_CLASS(), and BUILD_EVENT() ?

That said, TRACE_EVENT() can still remain as an alias.

