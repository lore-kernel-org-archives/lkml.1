Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbZCJT4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbZCJT4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 15:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbZCJT4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 15:56:07 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:49500 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbZCJT4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 15:56:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RXGaynUYmtHXmEuPoMC2EJC0txdAsdNeZRdZ4UvKYdt/ZKAm5CwA1mpi3QX38GIrFF
         fBGv0p7/ySaPJVKDm27UfhTvHpGgzy1GHujI3RCbRaCeMwY6Fe88fvulFCdSc5hdgdx6
         2xWZAbOEa9Y7iBCrt7WRqgukBqEciUVBX4W2Q=
Date: Tue, 10 Mar 2009 20:55:59 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>, Maneesh Soni <maneesh@in.ibm.com>
Subject: Re: [Patch 11/11] ftrace plugin for kernel symbol tracing using HW
	Breakpoint interfaces - v2
Message-ID: <20090310195558.GA5449@nowhere>
References: <20090307045120.039324630@linux.vnet.ibm.com> <20090307050747.GL23959@in.ibm.com> <20090307222955.25A7.A69D9226@jp.fujitsu.com> <20090308100929.GA14133@elte.hu> <20090308110038.GA5000@nowhere> <20090310122102.GA15140@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310122102.GA15140@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 05:51:02PM +0530, K.Prasad wrote:
> On Sun, Mar 08, 2009 at 12:00:40PM +0100, Frederic Weisbecker wrote:
> > On Sun, Mar 08, 2009 at 11:09:29AM +0100, Ingo Molnar wrote:
> > > 
> > > * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > 
> > > > Hi
> > > > 
> > > > > This patch adds an ftrace plugin to detect and profile memory access over
> > > > > kernel variables. It uses HW Breakpoint interfaces to 'watch memory
> > > > > addresses.
> > > > > 
> > > > > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com> 
> > > > > ---
> > > > >  kernel/trace/Kconfig          |    6 
> > > > >  kernel/trace/Makefile         |    1 
> > > > >  kernel/trace/trace.h          |   16 +
> > > > >  kernel/trace/trace_ksym.c     |  448 ++++++++++++++++++++++++++++++++++++++++++
> > > > >  kernel/trace/trace_selftest.c |   36 +++
> > > > >  5 files changed, 507 insertions(+)
> > > > 
> > > > Could you please update Documentation/ftrace.txt?
> > > > I guess many user interesting this patch. :)
> > > 
> > > Yeah, it has become a really nice feature this way. As i told it 
> > > to K.Prasad before: we need this tracer because the data tracer 
> > > will likely become the most common usecase of this facility. We 
> > > will get the hw breakpoints facility tested and used.
> > > 
> > > And in fact we can go one step further: it would also be nice to 
> > > wire it up with the ftrace histogram code: so that we can get 
> > > usage histograms of kernel symbol read/write activities without 
> > > the overhead of tracing. (The branch tracer already has this.)
> > > 
> > > Especially frequently used variables generate a _lot_ of events.
> > > 
> > > 	Ingo
> > 
> > Right, it will even be an occasion to improve and further test
> > the histogram tracing.
> > K. Prasad if you need some help on how to use it, don't hesitate to tell.
> > 
> > Frederic.
> >
> 
> Hi Frederic,
> 	Thanks for the offer of help.
> 
> As I try to get ksym tracer generate histogram information, I see a few
> challenges and would like to know your thoughts about them.
> 
> - Unlike branch tracer which stores the branch stats in statically
>   declared data structures ('struct ftrace_branch_data'), ksym
>   generates data at runtime (during every memory access of interest on
> the target variable) and would require dynamic memory allocation. Let's
> consider the case where we want the information shown below in the
> histogram:
> 
> Access_Type     Symbol_name    Function   Counter
> ------------    -----------    --------   -------
>     W            Sym_A          Fn_A       10
>     W            Sym_A          Fn_B       15
>    RW            Sym_C          Fn_C       20
> 
> We need a data structure to store the above information and a new
> instance of it for every new Fn_X that accesses Sym_X, while all this
> information captured in the context of the hardware breakpoint
> exception. I am not sure if dynamically allocating GFP_ATOMIC memory for
> such a huge requirement is a good idea.


Ah, I see... And the number of functions that will dereference it is not
predictable...

 
> - Alternatively if we choose to statically declare a data section (as
>   done by the branch tracer). It should be accompanied by code to check
> if we reached the end of section and wrap the pointer around. In effect, it
> would become a ring-buffer containing only statistics about the
> 'snapshot' in the buffer, and not historically aggregated data.


That's possible, but we could loose interesting cases of function that didn't
dereference a variable for a while but did it often, because they could be
overriden by another. Anyway, it seems a good idea.


> - Removal of the 'Function' column to display only aggregate 'hit'
>   statistics would help reduce the complexity to a large extent, as the
> counter can be embedded in the data structures containing
> 'ksym_trace_filter' information. But indeed, we are trading useful
> information for simplicity.


As you said, it would be too much a loss of useful informations.

 
> - Perhaps your proposed enhancements to the 'trace_stat' infrastructure,
>   say - a generic buffering mechanism to store histogram related
> information (or a framework to read through data in the ring-buffer)
> would help solve many of the issues. Or is 'histogram' best done in
> user-space?


For now it's just something that provides some abstracts over the seq file
and sorting facilities.
And if it can be enhanced in any way that can help, it would be great. But
I don't know how I could write something generic enough to support any kind
of problem that matches yours in its pattern.

In such case, the stat tracing looks a bit like regular events tracing: we
don't want to allocate memory for all entries because of the different context
sources and because of the allocation overhead, but we still want to store
all of the events.
Such thing could rely on the ring-buffer that we are using, but we would need to
create a sort of private instance of the ring buffer because we will store our hits
and then we will read all that from the ring buffer directly to get the stats sum.
I'm not sure we can create such private instances yet.

For now I would suggest to pre-allocate a set of entries for each breakpoints, using
a predefined number (I call it n here) of entries and count the hits for the n first
functions that were trapped on the breakpoint.
And if you missed some functions because n is too small, then increment an overrun
variable for the current breakpoint that you can display with the stats.
So that the user will know that he missed some things. 
I guess it could be accompagnied by a file to change the value of n.

It's just an opinion anyway.


> Thanks,
> K.Prasad
> P.S.: You can refer me as 'Prasad' although I sign as above, which is a
> patronymic nomenclature
> (http://en.wikipedia.org/wiki/Patronymic_name#Indian_subcontinent).
> Here's an illustration from another IBMer:
> http://www.almaden.ibm.com/u/mohan/#name :-)


Ok :-)

Thanks.

