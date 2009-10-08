Return-Path: <linux-kernel-owner+w=401wt.eu-S1757234AbZJHKng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbZJHKng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 06:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbZJHKng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 06:43:36 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:46274 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406AbZJHKne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 06:43:34 -0400
Date: Thu, 8 Oct 2009 16:12:49 +0530
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
Message-ID: <20091008104249.GJ20595@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20091008094828.GA20595@linux.vnet.ibm.com> <20091008095027.GC20595@linux.vnet.ibm.com> <1254998162.26976.270.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1254998162.26976.270.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-10-08 12:36:02]:

> On Thu, 2009-10-08 at 15:20 +0530, Arun R Bharadwaj wrote:
> > * Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-10-08 15:18:28]:
> > 
> > Implement a list based registering mechanism for architectures which
> > have multiple sets of idle routines which are to be registered.
> > 
> > Currently, in x86 it is done by merely setting pm_idle = idle_routine
> > and managing this pm_idle pointer is messy.
> > 
> > To give an example of how this mechanism works:
> > In x86, initially, idle routine is selected from the set of poll/mwait/
> > c1e/default idle loops. So the selected idle loop is registered in cpuidle
> > as one idle state cpuidle devices. Once ACPI comes up, it registers
> > another set of idle states on top of this state. Again, suppose a module
> > registers another set of idle loops, it is added to this list.
> > 
> > This provides a clean way of registering and unregistering idle state
> > routines.
> 
> So cpuidle didn't already have a list of idle functions it takes an
> appropriate one from?
> 

No.. As of now, cpuidle supported only one _set_ of idle states that
can be registered. So in this one set, it would choose the appropriate
idle state. But this list mechanism(actually a stack) allows for
multiple sets.

This is needed because we have a hierarchy of idle states discovery
in x86. First, select_idle_routine() would select poll/mwait/default/c1e.
It doesn't know of existance of ACPI. Later when ACPI comes up,
it registers a set of routines on top of the earlier set.

> Then what does this governor do?
>

The governor would only select the best idle state available from the
set of states which is at the top of the stack. (In the above case, it
would only consider the states registered by ACPI).

If the top-of-the-stack set of idle states is unregistered, the next
set of states on the stack are considered.

> Also, does this imply the governor doesn't consider these idle routines?
>

As i said above, governor would only consider the idle routines which
are at the top of the stack.

Hope this gave a better idea..

