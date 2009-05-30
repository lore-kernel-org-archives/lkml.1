Return-Path: <linux-kernel-owner+w=401wt.eu-S1760153AbZE3LAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153AbZE3LAs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 07:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755803AbZE3LAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 07:00:41 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:48128 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbZE3LAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 07:00:41 -0400
Date: Sat, 30 May 2009 16:30:33 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: David Gibson <dwg@au1.ibm.com>, Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [Patch 06/12] Use the new wrapper routines to access debug
	registers in process/thread code
Message-ID: <20090530110033.GA9275@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090511114422.133566343@prasadkr_t60p.in.ibm.com> <20090511115344.GG25673@in.ibm.com> <20090528064238.GC3091@yookeroo.seuss> <20090529090146.GA5353@in.ibm.com> <20090529104901.GA5997@nowhere> <20090529135236.GA3465@in.ibm.com> <c62985530905290707y7a44a824p30f0857b31129b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530905290707y7a44a824p30f0857b31129b4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 04:07:07PM +0200, Frédéric Weisbecker wrote:
> 2009/5/29 K.Prasad <prasad@linux.vnet.ibm.com>:
> > On Fri, May 29, 2009 at 12:49:03PM +0200, Frederic Weisbecker wrote:
> >> On Fri, May 29, 2009 at 02:31:46PM +0530, K.Prasad wrote:
> >> > On Thu, May 28, 2009 at 04:42:38PM +1000, David Gibson wrote:
> >> > > On Mon, May 11, 2009 at 05:23:44PM +0530, K.Prasad wrote:
> >> > > > From: Alan Stern <stern@rowland.harvard.edu>
> >> > > >
> >> > > > This patch enables the use of abstract debug registers in
> >> > > > process-handling routines.
> >> > >
> >> > > [snip]
> >> > > >
> >> > > > +       p->thread.io_bitmap_ptr = NULL;
> >> > >
> >> > > Why is manipulating the io_bitmap_ptr relevant to debug register
> >> > > handling?
> >> >
> >> > I *re-read* the patch but was unable to find how this change had sneaked
> >> > in. It shouldn't be there although it is harmless.
> >>
> >>
> >> When I reviewed this patch, I also ended stucked on it.
> >> But actually I guess I found the sense, this is only for
> >> convenience.
> >>
> >> Look at the current copy_thread() in arch/x86/kernel/process32.c
> >>
> >> If p->thread.io_bitmap_ptr fails to be duplicated, we set
> >> p->thread.io_bitmap_max = 0 and return -ENOMEM
> >>
> >> Now look at the patch.
> >> If we fail to copy the hardware thread virtual registers we
> >> want to exit with io_bitmap_ptr = NULL
> >> If we fail to copy the io_bitmap, we want to free the breakpoint
> >> and exit.
> >> If we fail further, we want to free breakpoints and io_bitmap_ptr
> >>
> >> The out section then tries to:
> >>
> >> -free the breakpoints
> >> -free p->thread.io_bitmap_ptr
> >>
> >>
> >> So it's important to set io_bitmap_ptr to NULL so that
> >> we know whether we have to release it or not.
> >>
> >>
> >
> > aah...yes. It tricked me! It is needed to bring the desired
> > error-return behaviour of copy_thread(). Please ignore this patch (the
> > updation of the comments can be brought in through a separate
> > enhancement patch...see below).
> 
> 
> Ok.
> 
> 
> >> > Hi Frederic,
> >> >     I am attaching a new version of this patch 06/12 that:
> >> >
> >> > - removes the line that assigns NULL to "p->thread.io_bitmap_ptr"
> >>
> >>
> >> Dangerous. Unless p->thread.io_bitmap_ptr is already zeroed out
> >> at this stage?
> >>
> >>
> >> > - Updates the comment in __switch_to() function which was stale (was
> >> >   relevant when 'last_debugged_task' was used to detect lazy debug
> >> >   register switching).
> >> >
> >> > Kindly integrate this version in lieu of the older version sent here:
> >> > http://lkml.org/lkml/2009/5/21/149.
> >>
> >>
> >> Ok. Well it would be nice if you resend the whole series actually :)
> >> Do you have another fix pending?
> >>
> >> Thanks!
> >>
> >
> > In the process of responding to David Gibson's comments I agreed to
> > a few minor/cosmetic changes - say like updation of comments, renaming
> > functions or variables, etc.
> >
> > Given that the patchset is on the verge of integration into -tip tree, I
> > would prefer them to be done through a separate patch (on -tip) for
> > enhancement. Kindly let me know what you think about proceeding this
> > way.
> 
> 
> Well, indeed it would be easier for you to start iterating with a merged base.
> But I would prefer to pull-request the patchset to Ingo once the pending fixes
> are sent.
> 
> So to start the integration of this, I can apply the current patches in my tree,
> based on tracing/core. And once you have the minor fixes addressing David's
> comments, I also apply them and send the whole to Ingo.
> 
> Ok?
> But still could you resend me the whole patchset you have, including
> the fixes already posted, so that I don't mess up through several versions.
> 
> And I guess I could apply them very soon.
> 
> Thanks.
>

Hi Frederic,
	I have re-sent the patchset which includes some of the changes
that were made on them since their previous posting.

Please find the new patchset addressed to you starting here:
http://lkml.org/lkml/2009/5/30/67.

I would like to bring in some of the enhancements I agreed to David,
through a separate patchset after its integration into -tip tree. Just
as you mentioned above, it should be much easier to test once there's
a merged base.

Thanks,
K.Prasad
 
