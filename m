Return-Path: <linux-kernel-owner+w=401wt.eu-S1757684AbZCJRLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684AbZCJRLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbZCJRLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:11:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56317 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756763AbZCJRLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:11:12 -0400
Date: Tue, 10 Mar 2009 13:11:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ingo Molnar <mingo@elte.hu>
cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
 Breakpoint interfaces
In-Reply-To: <20090310151828.GM3850@elte.hu>
Message-ID: <Pine.LNX.4.44L0.0903101244140.3979-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, Ingo Molnar wrote:

> > > why this redirection, why dont just use the structure as-is? 
> > > If there's any arch weirdness then that arch should have 
> > > arch-special accessors - not the generic code.
> > 
> > These _are_ the arch-specific accessors.  Look at the 
> > filename: arch/x86/include/asm/hw_breakpoint.h.
> 
> I very well know which file this is, you need to read my reply 
> again.
> 
> These are very generic-sounding fields and they should not be 
> hidden via pointless wrappers by the generic code. Dont let the 
> tail wag the dog. If there's architecture weirdness that does 
> not fit the generic code, then _that_ architecture should have 
> the ugliness - not the generic code. (note that these accessors 
> are used by the generic code so the uglification spreads there)

Hm.  I haven't been keeping careful track of all the updates Prasad has
been making.  In my fairly-old copy of the hw-breakpoint work, the
accessors are _not_ used by the generic code.  They are there for
future users of the API, not for internal use by the API itself.  Is 
there something I'm missing?

I have the feeling that this doesn't really address your comment, but
I'm not sure if that's because I don't understand your point or you
don't understand mine...

> These are very generic-sounding fields ...

Would you be happier if the field names were changed to be less 
generic-sounding?

> > > > + int num_installed; /* Number of installed bps */ + 
> > > > unsigned gennum; /* update-generation number */
> > > 
> > > i suspect the gennum we can get rid of if we get rid of the 
> > > notion of priorities, right?
> > 
> > No.  gennum has nothing to do with priorities.
> 
> Well it's introduced because we have a priority-sorted list of 
> breakpoints not an array.

More generally, it's there because kernel & userspace breakpoints can
be installed and uninstalled while a task is running -- and yes, this
is partially because breakpoints are prioritized.  (Although it's worth
pointing out that even your suggestion of always prioritizing kernel
breakpoints above userspace breakpoints would have the same effect.)  
However the fact that the breakpoints are stored in a list rather than
an array doesn't seem to be relevant.

> A list needs to be maintained and when 
> updated it's reloaded.

The same is true of an array.

> I was thinking about possibly getting rid 
> of that list complication and go back to the simpler array. But 
> it's hard because the lifetime of a kernel space breakpoint 
> spans context-switches so there has to be separation.

Yes, kernel breakpoints have to be kept separate from userspace 
breakpoints.  But even if you focus just on userspace breakpoints, you 
still need to use a list because debuggers can try to register an 
arbitrarily large number of breakpoints.

Alan Stern

