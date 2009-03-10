Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbZCJUak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbZCJUak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 16:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755020AbZCJUab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 16:30:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42024 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753629AbZCJUaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 16:30:30 -0400
Date: Tue, 10 Mar 2009 16:30:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ingo Molnar <mingo@elte.hu>
cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
 Breakpoint interfaces
In-Reply-To: <20090310172605.GA28767@elte.hu>
Message-ID: <Pine.LNX.4.44L0.0903101620390.4325-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, Ingo Molnar wrote:

> > More generally, it's there because kernel & userspace 
> > breakpoints can be installed and uninstalled while a task is 
> > running -- and yes, this is partially because breakpoints are 
> > prioritized.  (Although it's worth pointing out that even your 
> > suggestion of always prioritizing kernel breakpoints above 
> > userspace breakpoints would have the same effect.)  However 
> > the fact that the breakpoints are stored in a list rather than 
> > an array doesn't seem to be relevant.
> > 
> > > A list needs to be maintained and when updated it's 
> > > reloaded.
> > 
> > The same is true of an array.
> 
> Not if what we do what the previous code did: reloaded the full 
> array unconditionally. (it's just 4 entries)

But that array still has to be set up somehow.  It is private to the 
task; the only logical place to set it up is when the CPU switches to 
that task.

In the old code, it wasn't possible for task B or the kernel to
affect the contents of task A's debug registers.  With hw-breakpoints 
it _is_ possible, because the balance between debug registers allocated 
to kernel breakpoints and debug registers allocated to userspace 
breakpoints can change.  That's why the additional complexity is 
needed.

> > Yes, kernel breakpoints have to be kept separate from 
> > userspace breakpoints.  But even if you focus just on 
> > userspace breakpoints, you still need to use a list because 
> > debuggers can try to register an arbitrarily large number of 
> > breakpoints.
> 
> That 'arbitrarily larg number of breakpoints' worries me. It's a 
> pretty broken concept for a 4-items resource that cannot be 
> time-shared and hence cannot be overcommitted.

Suppose we never allow callers to register more breakpoints than will
fit in the CPU's registers.  Do we then use a simple first-come
first-served algorithm, with no prioritization?  If we do prioritize
some breakpoint registrations more highly than others, how do we inform
callers that their breakpoint has been kicked out by one of higher
priority?  And how do we let them know when the higher-priority
breakpoint has been unregistered, so they can try again?

> Seems to me that much of the complexity of this patchset:
> 
>  28 files changed, 2439 insertions(+), 199 deletions(-)
> 
> Could be eliminated via a very simple exclusive reservation 
> mechanism.

Can it really be as simple as all that?

Roland, what do you think?

Alan Stern

