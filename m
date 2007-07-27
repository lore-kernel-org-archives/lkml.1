Return-Path: <linux-kernel-owner+w=401wt.eu-S965460AbXG0Xl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965460AbXG0Xl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 19:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937003AbXG0XlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 19:41:19 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:47414 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936968AbXG0XlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 19:41:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EWFB/pBDuFtNV9m6/PgLFKzitoHGOjIZL1T8vJCcdx5IRGuHI9KxUh56vGpmZiQRZFjhDCj3SpmgCwQj+z9Gg5YUuEqYhpOLgYXES8o8JyNWACbR5CK6fhE2BzgdaI6AgYplu1DN0DAmJM3jDFEeJcOfgNxzaB16McmdOnWml74=
Message-ID: <a781481a0707271641n20353a12u7467d093346f2f4c@mail.gmail.com>
Date: Sat, 28 Jul 2007 05:11:17 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Rodolfo Giometti" <giometti@enneenne.com>
Subject: Re: LinuxPPS & spinlocks
Cc: "Chris Friesen" <cfriesen@nortel.com>,
       "David Woodhouse" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070717180550.GA24759@enneenne.com>
	 <1185284942.14697.319.camel@pmac.infradead.org>
	 <20070724142050.GD4074@enneenne.com>
	 <1185288769.14697.339.camel@pmac.infradead.org>
	 <20070727184418.GV9840@enneenne.com> <46AA42CA.4060004@nortel.com>
	 <20070727192848.GW9840@enneenne.com> <46AA4A1E.8040302@nortel.com>
	 <20070727194516.GX9840@enneenne.com>
	 <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 7/28/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> Hi Rodolfo,
>
> On 7/28/07, Rodolfo Giometti <giometti@enneenne.com> wrote:
> > On Fri, Jul 27, 2007 at 01:40:14PM -0600, Chris Friesen wrote:
> > >
> > > My point is that the lock should be used to protect specific data. Thus, it
> > > would be more correct to say, "spinlock foo is taken because
> > > pps_register_source() accesses variable bar".
> > >
> > > That way, if someone else wants to access "bar", they know that they need
> > > to take lock "foo".
> >
> > Ah, ok! I see. :)
>
> I only glanced through the code, so could be wrong, but I noticed that
> the only global / shared data you have in there is a global "pps_source"
> array of pps_s structs. That's accessed / modified from the various
> syscalls introduced in the API exported to userspace, as well as the
> register/unregister/pps_event API exported to in-kernel client subsystems,
> yes? So it looks like you need to introduce proper locking for it, simply
> type-qualifying it as "volatile" is not enough.
>
> However, I think you've introduced two locks for it. The syscalls (that
> run in process context, obviously) seem to use a pps_mutex and
> pps_event() seems to be using the pps_lock spinlock (because that
> gets executed from interrupt context) -- and from the looks of it, the
> register/unregister functions are using /both/ the mutex and spinlock (!)
>
> This isn't quite right, (in fact there's nothing to protect pps_event from
> racing against a syscall), so you should use *only* the spinlock for
> synchronization -- the spin_lock_irqsave/restore() variants, in fact.

Take the race between the time_pps_setparams() syscall and a concurrent
pps_event() from an interrupt for instance. From sys_time_pps_setparams,
the parameters for an existing source are not modified / set atomically,
which means a pps_event() called on the same source in between will see
invalid parameters ... and bad things will happen.

> [ Also, have you considered making pps_source a list and not an array?
> It'll help you lose a whole lot of MAX_SOURCES, pps_is_allocated, etc
> kind of gymnastics in there, and you _can_ return a pointer to the
> corresponding pps source struct from the register() function to the in-kernel
> users, so that way you get to retain the O(1) access to the corresponding
> source when a client calls into pps_event(), similar to how you're using the
> array index presently. ]

I think the above would be sane and safe -- your driver has pretty simple
lifetime rules, and "sources" are only created / destroyed from within kernel,
as and when clients call pps_register_source() and pps_unregister_source().
So pps_event() can be called on a given source only between the
corresponding register() and unregister() -- which means register() can
return us a reference/pointer on the source after allocating / adding it to
the list (instead of the fixed array index as it presently is), which remains
valid for the entire duration of the source, till unregister() is called, after
which we can't be calling pps_event() on the same source anyway.

> I also noticed code like (from pps_event):
>
> +       /* Try to grab the lock, if not we prefere loose the event... */
> +       if (!spin_trylock(&pps_lock))
> +               return;
>
> which looks worrisome and unnecessary. That spinlock looks to be of
> fine enough granularity to me, do you think there'd be any contention
> on it? I /think/ you can simply make that a spin_lock().
>
> Overall the code looks simple / straightforward enough to me (except for
> the parport / uart stuff that I have no clue about), and I'll also read up on
> the relevant RFC for this and would hopefully try and give you a more
> meaningful review over the weekend.

Ok, I've looked through (most of) the RFC and code now, and am only
commenting on a design-level for now. Anyway, I didn't like the way
you've significantly drifted from the RFC in several ways:

1. The RFC mandates no such userspace interface / syscall as the
time_pps_cmd() that you've implemented -- it looks, smells, and feels
like an ioctl, in fact that's what it is for practical purposes. I'm confused
as to why didn't you just go ahead and implement the special-file-and-
file-descriptor based approach as advocated / mandated there.

[ You've implemented the (optional, as per RFC) time_pps_findsource
operation in the kernel using the above "pseudo-ioctl", but that wasn't
necessary -- as the RFC itself illustrates, it's something that can easily
be done (in fact should be done) completely in userspace itself. ]

2. If you fix the above two issues, you'll notice that you don't need to
short-circuit the (RFC-mandated) time_pps_create/destroy(handle)
syscalls in the userspace header/library anymore, as you presently are.

Here's how I'd go about desiging/implementing this:

* At the time of pps_register_source()  -- called by an in-kernel client
subsystem that creates a PPS source -- allocate a pps source, generate
an identifier for it, instantiate a special file -- the RFC does not mention
whether a char or block device, but char device (I noticed an example
in the RFC where they've used /dev/ppsXX as a possible path) would be
proper for this. Finally add it to the list of sources. This returns a
reference/pointer on that source back to the in-kernel client, which then
passes *that* to pps_event(), similar to how you're presently using the
array index.

[ The way you've passed the path of the parport/uart device itself
(/dev/lpXX or [/dev/%s%d, drv->name, port->line]) to register_source()
in pps_info.path doesn't quite look right to me. Note that the userspace is
expected to open(2) the special file corresponding to the *PPS* source,
as instantiated from the above code, and not the /dev/xyz special file of
the *physical* port through which a pulse-generating device may be
connected to the PC. ]

* Userspace will open(2) the special file, and get an fd. Then calls the
time_pps_create(fd, &handle) syscall -- kernel will find the pps source
that matches that passed fd from the list of sources, and instantiates a
"handle" associated with that source and returns that back to userspace.

The rest would happen as usual / as you've currently implemented.

I /think/ the RFC does envision such an implementation, so it helps us
comply with that standard, and would also get rid of a lot of kludgy
"findpath" and "findsource" stuff that we otherwise have to do in-kernel
and userspace, as we're presently doing in the patch.

[ BTW, it would be nice if you submit this stuff as a patchset that brings
in functionality over a series of multiple patches -- the sysfs interface bits
can be introduced in a different patch from the syscalls, which can be
introduced in a different patch from the kernel-side API, etc ... that helps
a code-level review. ]


Satyam
