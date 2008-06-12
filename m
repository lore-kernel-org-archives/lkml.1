Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbYFLP3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbYFLP3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 11:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbYFLP24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 11:28:56 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:58412 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbYFLP2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 11:28:55 -0400
Subject: Re: [PATCH] Version 3: Reworked Cell OProfile: SPU mutex lock fix
From: Carl Love <cel@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Maynard Johnson <maynardj@us.ibm.com>, acjohnso <acjohnso@us.ibm.com>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       cbe-oss-dev@ozlabs.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200806121431.53596.arnd@arndb.de>
References: <1213139954.6763.244.camel@carll-linux-desktop>
	 <200806111452.46619.arnd@arndb.de> <484FE6EA.2060403@us.ibm.com>
	 <200806121431.53596.arnd@arndb.de>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 08:25:39 -0700
Message-Id: <1213284339.6655.119.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-12 at 14:31 +0200, Arnd Bergmann wrote:
> On Wednesday 11 June 2008, Maynard Johnson wrote:
> 
> > >
> > > I like the approach in general, but would prefer to have it more generic,
> > > so that other subsystems can use the same infrastructure if necessary:
> > >   
> > I believe Carl's thoughts on implementation would result in
> > model-specific buffer create/destroy routines, to be invoked by the
> > generic routine.  This would give the flexibility for architectures to
> > implement their own unique buffering mechanism.  I don't think it would
> > be worthwhile to go beyond this level in trying to build some generic
> > mechanism since the generic mechanism already exists and has been
> > sufficient for all other architectures.
> 
> Well, the amount of code should be the same either way. We currently
> have an interface between the cpu_buffer and its users, which the
> interface between the event_buffer and the cpu_buffer is private
> to the oprofile layer.
> 
> The logical extension of this would be to have another buffer in
> common oprofile code, and have its users in the architecture code,
> rather than interface the architecture with the private event_buffer.
> 
> > > I think the dependency on the size of the per cpu buffers is a bit
> > > artificial. How about making this independently tunable with
> > > another oprofilefs file and a reasonable default?
> > > You could either create the extra files in oprofile_create_files
> > > or in oprofile_ops.create_files.
> > >   
> > With the right scaling factor, we should be able to avoid the buffer
> > overflows for the most part.  Adding a new file in oprofilefs for an
> > arch-specific buffer size would have to be documented on the user side,
> > as well as providing a new option on the opcontrol command to adjust the
> > value.  Granted, the system-wide buffer that Carl is proposing for Cell
> > clashes with the "cpu buffer" construct, but some other architecture in
> > the future may want to make use of this new model-specific buffer
> > management routines and perhaps their buffers *would* be per-cpu.  I'm
> > not sure there  would be much value add in exposing this implementation
> > detail to the user as long as we can effectively use the existing user
> > interface mechanism for managing buffer size.
> 
> But we're already exposing the implementation detail for the cpu buffers,
> which are similar enough, just not the same. Since the file and opcontrol
> option are called cpu-buffer-size, its rather unobvious how this should
> control the size of a global buffer. As I mentioned, with a reasonable
> default, you should not need to tune this anyway.
> Changing opcontrol is a real disadvantage, but if a user needs to tune
> this without a new opcontrol tool, it's always possible to directly
> write to the file system.

Not exactly. First of all I have to have a special escape sequence
header to say that the following data is of a special type.  In the case
of the SPU PC data samples it means I use up twice as much memory, one
entry for the header and one for the data.  This is true for each data
sample.  Secondly there is no locking of the CPU buffer when data is
removed.  Hence the need for the extra code in the sync_buffer routine
to be very careful to make sure the entire sequence of header plus data
was written to the per CPU buffer before removing it.  If we did have a
dedicated system-wide buffer, we could eliminate the escape sequence
overhead in the storage space requirement.  Since there are 4x the
number of SPUs then CPUs the per system buffer size would need to be
4*NUMCPUS*per-cpu-buffer-size.  We need to have a way for the arch code
to tell OProfile at buffer creation time to either create the
system-wide buffer or the per-cpu buffers or possibly both for
generality.  SPU profiling will not use cpu buffers.  Please note you
can not do any CPU profiling (event counter based or timer based) while
doing SPU profiling.  In theory if an architecture wanted to use
per-cpu-buffer and system-wide buffer we would need to be able to tune
the sizes independently.  Now we are adding a lot more complexity to
make something very general.  Currently there is only one architecture
that needs this feature.  The probability of another arch needing this
feature is probably low.  I say we keep it simple until we know that we
need a more complex general solution.  

The whole point is the user would not have to know that they were
manipulating a system-wide buffer.  From a black box perspective it
would be acting as if there were per cpu buffers being manipulated.

We have to allow for the size of the system-wide buffer to be tuned for
the same reason that the per cpu buffers have to be tunable.  The the
number of samples collected is a function of the frequency the event
occurs.  If you make the buffer fixed and large enough that it will
always be big enough, then you will be using a lot of kernel memory to
cover a worst case when in fact most of the time that memory will not
get used. 
> 
> > > As a general design principle, I'd always try to have locks close
> > > to the data. What this means is that I think the SPU_BUFFER should
> > > be in drivers/oprofile, similar to the cpu_buffer. In that case,
> > > it may be better to change the name to something more generic, e.g.
> > > aux_buffer.
> > >   
> > I agree -- in principle -- however, I really don't think a system-wide
> > buffer is something we want to put into generic code.  It is not
> > generally useful.  Also, putting this new code in drivers/oprofile would
> > not fit well with the general technique of adding model-specific
> > function pointers to 'struct oprofile_operations'.
> 
> > This assumes we can get the oprofile maintainer to review and comment on
> > the new patch, which has been difficult to do lately.  I agree that we
> > should not avoid making changes to common code when there's a good
> > justification for it, but I would say that this is not such a case.
> 
> You have to change the oprofile code either way, because the existing
> interface is not sufficient. However, there is no point in trying to do
> a minimal change to the existing code when a larger change clearly gives
> us a better resulting code.

I don't completely agree here.  See comment above about adding
complexity when it is not generally needed.  Secondly, adding the system
wide buffer into the general code would encourage people to use it when
they should use per cpu buffers to get better scalability with the
number of processors. 
> 
> 	Arnd <><

