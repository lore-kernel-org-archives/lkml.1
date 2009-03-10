Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbZCJMVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbZCJMVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 08:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZCJMVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 08:21:12 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:58964 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbZCJMVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 08:21:10 -0400
Date: Tue, 10 Mar 2009 17:51:02 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>, Maneesh Soni <maneesh@in.ibm.com>
Subject: Re: [Patch 11/11] ftrace plugin for kernel symbol tracing using HW
	Breakpoint interfaces - v2
Message-ID: <20090310122102.GA15140@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090307045120.039324630@linux.vnet.ibm.com> <20090307050747.GL23959@in.ibm.com> <20090307222955.25A7.A69D9226@jp.fujitsu.com> <20090308100929.GA14133@elte.hu> <20090308110038.GA5000@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090308110038.GA5000@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 08, 2009 at 12:00:40PM +0100, Frederic Weisbecker wrote:
> On Sun, Mar 08, 2009 at 11:09:29AM +0100, Ingo Molnar wrote:
> > 
> > * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> > > Hi
> > > 
> > > > This patch adds an ftrace plugin to detect and profile memory access over
> > > > kernel variables. It uses HW Breakpoint interfaces to 'watch memory
> > > > addresses.
> > > > 
> > > > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com> 
> > > > ---
> > > >  kernel/trace/Kconfig          |    6 
> > > >  kernel/trace/Makefile         |    1 
> > > >  kernel/trace/trace.h          |   16 +
> > > >  kernel/trace/trace_ksym.c     |  448 ++++++++++++++++++++++++++++++++++++++++++
> > > >  kernel/trace/trace_selftest.c |   36 +++
> > > >  5 files changed, 507 insertions(+)
> > > 
> > > Could you please update Documentation/ftrace.txt?
> > > I guess many user interesting this patch. :)
> > 
> > Yeah, it has become a really nice feature this way. As i told it 
> > to K.Prasad before: we need this tracer because the data tracer 
> > will likely become the most common usecase of this facility. We 
> > will get the hw breakpoints facility tested and used.
> > 
> > And in fact we can go one step further: it would also be nice to 
> > wire it up with the ftrace histogram code: so that we can get 
> > usage histograms of kernel symbol read/write activities without 
> > the overhead of tracing. (The branch tracer already has this.)
> > 
> > Especially frequently used variables generate a _lot_ of events.
> > 
> > 	Ingo
> 
> Right, it will even be an occasion to improve and further test
> the histogram tracing.
> K. Prasad if you need some help on how to use it, don't hesitate to tell.
> 
> Frederic.
>

Hi Frederic,
	Thanks for the offer of help.

As I try to get ksym tracer generate histogram information, I see a few
challenges and would like to know your thoughts about them.

- Unlike branch tracer which stores the branch stats in statically
  declared data structures ('struct ftrace_branch_data'), ksym
  generates data at runtime (during every memory access of interest on
the target variable) and would require dynamic memory allocation. Let's
consider the case where we want the information shown below in the
histogram:

Access_Type     Symbol_name    Function   Counter
------------    -----------    --------   -------
    W            Sym_A          Fn_A       10
    W            Sym_A          Fn_B       15
   RW            Sym_C          Fn_C       20

We need a data structure to store the above information and a new
instance of it for every new Fn_X that accesses Sym_X, while all this
information captured in the context of the hardware breakpoint
exception. I am not sure if dynamically allocating GFP_ATOMIC memory for
such a huge requirement is a good idea.

- Alternatively if we choose to statically declare a data section (as
  done by the branch tracer). It should be accompanied by code to check
if we reached the end of section and wrap the pointer around. In effect, it
would become a ring-buffer containing only statistics about the
'snapshot' in the buffer, and not historically aggregated data.

- Removal of the 'Function' column to display only aggregate 'hit'
  statistics would help reduce the complexity to a large extent, as the
counter can be embedded in the data structures containing
'ksym_trace_filter' information. But indeed, we are trading useful
information for simplicity.

- Perhaps your proposed enhancements to the 'trace_stat' infrastructure,
  say - a generic buffering mechanism to store histogram related
information (or a framework to read through data in the ring-buffer)
would help solve many of the issues. Or is 'histogram' best done in
user-space?

Thanks,
K.Prasad
P.S.: You can refer me as 'Prasad' although I sign as above, which is a
patronymic nomenclature
(http://en.wikipedia.org/wiki/Patronymic_name#Indian_subcontinent).
Here's an illustration from another IBMer:
http://www.almaden.ibm.com/u/mohan/#name :-)

