Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbZJHMCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbZJHMCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 08:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757955AbZJHMCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 08:02:09 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55764 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757940AbZJHMCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 08:02:06 -0400
Date: Thu, 8 Oct 2009 17:31:20 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
       linux-acpi@vger.kernel.org, Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [v8 PATCH 2/8]: cpuidle: implement a list based approach to
	register a set of idle routines.
Message-ID: <20091008120120.GL20595@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20091008094828.GA20595@linux.vnet.ibm.com> <20091008095027.GC20595@linux.vnet.ibm.com> <1254998162.26976.270.camel@twins> <20091008104249.GJ20595@linux.vnet.ibm.com> <1254999033.26976.272.camel@twins> <20091008110106.GK20595@linux.vnet.ibm.com> <1255001110.26976.292.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1255001110.26976.292.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-10-08 13:25:10]:

> On Thu, 2009-10-08 at 16:31 +0530, Arun R Bharadwaj wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-10-08 12:50:33]:
> > 
> > > On Thu, 2009-10-08 at 16:12 +0530, Arun R Bharadwaj wrote:
> > > > 
> > > > > So cpuidle didn't already have a list of idle functions it takes an
> > > > > appropriate one from?
> > > > > 
> > > > 
> > > > No.. As of now, cpuidle supported only one _set_ of idle states that
> > > > can be registered. So in this one set, it would choose the appropriate
> > > > idle state. But this list mechanism(actually a stack) allows for
> > > > multiple sets.
> > > > 
> > > > This is needed because we have a hierarchy of idle states discovery
> > > > in x86. First, select_idle_routine() would select poll/mwait/default/c1e.
> > > > It doesn't know of existance of ACPI. Later when ACPI comes up,
> > > > it registers a set of routines on top of the earlier set.
> > > > 
> > > > > Then what does this governor do?
> > > > >
> > > > 
> > > > The governor would only select the best idle state available from the
> > > > set of states which is at the top of the stack. (In the above case, it
> > > > would only consider the states registered by ACPI).
> > > > 
> > > > If the top-of-the-stack set of idle states is unregistered, the next
> > > > set of states on the stack are considered.
> > > > 
> > > > > Also, does this imply the governor doesn't consider these idle routines?
> > > > >
> > > > 
> > > > As i said above, governor would only consider the idle routines which
> > > > are at the top of the stack.
> > > > 
> > > > Hope this gave a better idea..
> > > 
> > > So does it make sense to have a set of sets?
> > > 
> > > Why not integrate them all into one set to be ruled by this governor
> > > thing?
> > > 
> > 
> > Right now there is a clean hierarchy. So breaking that would mean
> > putting the registration of all idle routines under ACPI. 
> 
> Uhm, no, it would mean ACPI putting its idle routines on the same level
> as all others.
> 

Putting them all on the same level would mean, we need an
enable/disable routine to enable only the currently active routines.

Also, the way governor works is that, it assumes that idle routines
are indexed in the increasing order of power benefit that can be got
out of the state. So this would get messed up.

> > So, if ACPI
> > fails to come up or if ACPI is not supported, that would lead to
> > problems.
> 
> I think the problem is that ACPI is thinking its special, that should be
> rectified, its not.
> 
> >  Because if that happens now, we can fallback to the
> > initially registered set.
> 
> I'm thinking its all daft and we should be having one set of idle
> routines, if ACPI fails (a tautology if ever there was one) we simply
> wouldn't have its idle routines to pick from.
> 
> > Also, if a module wants to register a set of routines later on, that
> > cant be added to the initially registered set. So i think we need this
> > set of sets.
> 
> Sounds like something is wrong alright. If you can register an idle
> routine you should be able to unregister it too.
>

Yes, we can register and unregister in a clean way now.
Consider this. We have a set of routines A, B, C currently registered.
Now a module comes and registers D and E, and later on at some point
of time wants to unregister. So how do you keep track of what all idle
routines the module registered and unregister only those?
Best way to do that is a stack, which is how I have currently
implemented.

> What about making ACPI register its idle routines too, 1 for each C
> state, and have the governor make a selection out of the full set?
> 
> That also allows you to do away with this default_idle() nonsense and
> simply panic the box when there are no registered idle routines when the
> box wants to go idle.
> 
