Return-Path: <linux-kernel-owner+w=401wt.eu-S1759946AbZE2Nwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946AbZE2Nwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759485AbZE2Nwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:52:45 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:38138 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759240AbZE2Nwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:52:45 -0400
Date: Fri, 29 May 2009 19:22:36 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Gibson <dwg@au1.ibm.com>, Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [Patch 06/12] Use the new wrapper routines to access debug
	registers in process/thread code
Message-ID: <20090529135236.GA3465@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090511114422.133566343@prasadkr_t60p.in.ibm.com> <20090511115344.GG25673@in.ibm.com> <20090528064238.GC3091@yookeroo.seuss> <20090529090146.GA5353@in.ibm.com> <20090529104901.GA5997@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529104901.GA5997@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 12:49:03PM +0200, Frederic Weisbecker wrote:
> On Fri, May 29, 2009 at 02:31:46PM +0530, K.Prasad wrote:
> > On Thu, May 28, 2009 at 04:42:38PM +1000, David Gibson wrote:
> > > On Mon, May 11, 2009 at 05:23:44PM +0530, K.Prasad wrote:
> > > > From: Alan Stern <stern@rowland.harvard.edu>
> > > > 
> > > > This patch enables the use of abstract debug registers in
> > > > process-handling routines.
> > > 
> > > [snip]
> > > >  
> > > > +	p->thread.io_bitmap_ptr = NULL;
> > > 
> > > Why is manipulating the io_bitmap_ptr relevant to debug register
> > > handling?
> > 
> > I *re-read* the patch but was unable to find how this change had sneaked
> > in. It shouldn't be there although it is harmless.
> 
> 
> When I reviewed this patch, I also ended stucked on it.
> But actually I guess I found the sense, this is only for
> convenience.
> 
> Look at the current copy_thread() in arch/x86/kernel/process32.c
> 
> If p->thread.io_bitmap_ptr fails to be duplicated, we set
> p->thread.io_bitmap_max = 0 and return -ENOMEM
> 
> Now look at the patch.
> If we fail to copy the hardware thread virtual registers we
> want to exit with io_bitmap_ptr = NULL
> If we fail to copy the io_bitmap, we want to free the breakpoint
> and exit.
> If we fail further, we want to free breakpoints and io_bitmap_ptr
> 
> The out section then tries to:
> 
> -free the breakpoints
> -free p->thread.io_bitmap_ptr
> 
> 
> So it's important to set io_bitmap_ptr to NULL so that
> we know whether we have to release it or not.
> 
> 

aah...yes. It tricked me! It is needed to bring the desired
error-return behaviour of copy_thread(). Please ignore this patch (the
updation of the comments can be brought in through a separate
enhancement patch...see below).

> > Hi Frederic,
> > 	I am attaching a new version of this patch 06/12 that:
> > 
> > - removes the line that assigns NULL to "p->thread.io_bitmap_ptr"
> 
> 
> Dangerous. Unless p->thread.io_bitmap_ptr is already zeroed out
> at this stage?
> 
> 
> > - Updates the comment in __switch_to() function which was stale (was
> >   relevant when 'last_debugged_task' was used to detect lazy debug
> >   register switching).
> > 
> > Kindly integrate this version in lieu of the older version sent here:
> > http://lkml.org/lkml/2009/5/21/149.
> 
> 
> Ok. Well it would be nice if you resend the whole series actually :)
> Do you have another fix pending?
> 
> Thanks!
>

In the process of responding to David Gibson's comments I agreed to 
a few minor/cosmetic changes - say like updation of comments, renaming
functions or variables, etc.

Given that the patchset is on the verge of integration into -tip tree, I
would prefer them to be done through a separate patch (on -tip) for
enhancement. Kindly let me know what you think about proceeding this
way.

Thanks,
K.Prasad




