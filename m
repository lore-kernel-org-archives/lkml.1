Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbZFWOK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbZFWOK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbZFWOKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:10:18 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:36738 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbZFWOKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:10:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N9Wbwzyc3d/oRgYvP9fiMlOzZmeZDaqpIRkuu0McHO2Xlpb5e/gIoQDmWM5+Ncojnu
         FMi7bFGicVeO9CtmfiskoeJc3Qj3SCxoZTAF1AvNpsBQBBEWabrpPMU+qdWEFhYC0/F6
         Afbfm2bEOhZc5gtYdCuQQPOJwOB95i5NuY1/g=
Date: Tue, 23 Jun 2009 16:10:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/3] ksym_tracer: Eliminate trace concatenation and
	machine stall issues post removal
Message-ID: <20090623141013.GA6010@nowhere>
References: <20090619172035.443923337@prasadkr_t60p.in.ibm.com> <20090619172453.GB26071@in.ibm.com> <20090619230348.GA4700@nowhere> <20090620035725.GA5540@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090620035725.GA5540@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 20, 2009 at 09:27:25AM +0530, K.Prasad wrote:
> On Sat, Jun 20, 2009 at 01:03:49AM +0200, Frederic Weisbecker wrote:
> > On Fri, Jun 19, 2009 at 10:54:53PM +0530, K.Prasad wrote:
> > > This patch fixes two issues reported with ksym tracer, seen after
> > > removal of a symbol from the tracer i) Concatenation of trace logs
> > > into a single line ii) Machine stall seen when logs are viewed
> > > using 'trace_pipe'.
> > > 
> > > Known issue: Upon removal, 'cat trace_pipe' (without any preceding
> > > command and any further output in the trace buffer) responds to
> > > SIGTERM quickly but only after an indeterminate amount of delay
> > > for SIGINT.
> > > 
> > > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > > ---
> > >  kernel/trace/trace.h      |   12 +++++++++---
> > >  kernel/trace/trace_ksym.c |   11 ++++-------
> > >  2 files changed, 13 insertions(+), 10 deletions(-)
> > > 
> > > Index: linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
> > > ===================================================================
> > > --- linux-2.6-tip.hbkpt.orig/kernel/trace/trace_ksym.c
> > > +++ linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
> > > @@ -71,7 +71,7 @@ void ksym_hbp_handler(struct hw_breakpoi
> > >  {
> > >  	struct ring_buffer_event *event;
> > >  	struct trace_array *tr;
> > > -	struct trace_ksym *entry;
> > > +	struct trace_ksym_rb *entry;
> > >  	int pc;
> > >  
> > >  	if (!ksym_tracing_enabled)
> > > @@ -87,7 +87,7 @@ void ksym_hbp_handler(struct hw_breakpoi
> > >  
> > >  	entry = ring_buffer_event_data(event);
> > >  	strlcpy(entry->ksym_name, hbp->info.name, KSYM_SYMBOL_LEN);
> > > -	entry->ksym_hbp = hbp;
> > > +	memcpy(&(entry->ksym_hbp), hbp, sizeof(struct hw_breakpoint));
> > 
> > 
> > That looks wasteful. You only need the type from the arch_hw_breakpoint
> > and there you copy the whole generic breakpoint.
> > 
> > Frederic.
> >
> 
> Well, the entire copy operation for ksym_name and p_name is indeed a
> much bigger waste (KSYM_SYMBOL_LEN and TASK_COMM_LEN bytes respetively)
> and the breakpoint structure size is tiny in comparison. 
> 
> The type information is an arch-specific field and it encapsulated
> within 'struct hw_breakpoint'. In any case this solution needs
> improvement more in terms of getting the tracer infrastructure to
> identify stale entries (belonging to removed symbols) and prevent their
> display. The existing trace logs contain huge redundant information due
> to multiple copies of the same data and it would yield much better results
> than such trivial optimisations.  The ksym_tracer, I believe, has just
> unearthed the opportunity for the same as it is (is it?) the first such
> ftrace plugin to partially remove entries.


Well, we had such issue by the past and the problem can't
be easily solvable. Traces can possibily stay in the ring buffer for a while
until they become consumed by a reader.

It's safe and keep the things simple to just copy the required informations
in the ring buffer.

Also your type is indeed arch dependent, but copying struct hw_breakpoint
instead of the hw_breakpoint in the ring buffer doesn't solve the problem,
you'll still have some #ifdef ARCH once you'll need to support other archs.

Copying the whole struct breakpoint in the ring buffer doesn't make sense.
You're even copying the address of the triggered callback whereas all you
need is only the type field from the struct arch_hw_breakpoint ?


Btw, that makes me remind that I really think this hardware breakpoint API
should provide a real abstraction of the arch dependent hardware breakpoints.


> 
> Thanks,
> K.Prasad
> 

