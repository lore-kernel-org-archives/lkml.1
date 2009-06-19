Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbZFSDTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbZFSDTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 23:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZFSDTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 23:19:07 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:34036 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbZFSDTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 23:19:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ivGLfLFmVNUcPMdfn0GcemAPJN6PojDhpg6TvVRvMiiKHv8xSGUSkP71xXoUjwqzRN
         8Ky+yssGZF9ZiqD6xTbAm9CvXgFeqtalGAlZSvsNGCXZizvUAhThO8KGsT0pnGyk3XEj
         DRqEL8tiKe9FTXSDtEY/OecUWJzPonE61f0+A=
Date: Fri, 19 Jun 2009 05:19:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/2] ksym_tracer:Fix line-wrapping after removal of
	ksym tracer entry
Message-ID: <20090619031905.GG7903@nowhere>
References: <20090616225257.041883212@prasadkr_t60p.in.ibm.com> <20090616230504.GB14753@in.ibm.com> <20090617050605.GC7411@nowhere> <20090618083852.GA5793@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090618083852.GA5793@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 02:08:52PM +0530, K.Prasad wrote:
> On Wed, Jun 17, 2009 at 07:06:07AM +0200, Frederic Weisbecker wrote:
> > On Wed, Jun 17, 2009 at 04:35:04AM +0530, K.Prasad wrote:
> > > Removal of a ksym entry results in missing information and an early return with
> > > TRACE_TYPE_PARTIAL_LINE code (minus the line return). This patch modifies the
> > > output function to unconditionally add a line return irrespective of the
> > > return code. 
> > > 
> > > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > > ---
> > >  kernel/trace/trace_ksym.c |   27 +++++++++++++++------------
> > >  1 file changed, 15 insertions(+), 12 deletions(-)
> > > 
> > > Index: linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
> > > ===================================================================
> > > --- linux-2.6-tip.hbkpt.orig/kernel/trace/trace_ksym.c
> > > +++ linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
> > > @@ -391,29 +391,32 @@ static enum print_line_t ksym_trace_outp
> > >  
> > >  	ret = trace_seq_printf(s, "%-15s %-5d %-3d %-20s ", field->p_name,
> > >  				entry->pid, iter->cpu, field->ksym_name);
> > > -	if (!ret)
> > > -		return TRACE_TYPE_PARTIAL_LINE;
> > > +	if (!ret) {
> > > +		ret = TRACE_TYPE_PARTIAL_LINE;
> > > +		goto err_ret;
> > > +	}
> > >  
> > > +	ret = TRACE_TYPE_PARTIAL_LINE;
> > >  	switch (field->ksym_hbp->info.type) {
> > >  	case HW_BREAKPOINT_WRITE:
> > > -		ret = trace_seq_printf(s, " W  ");
> > > +		if (!trace_seq_printf(s, " W  "))
> > > +			goto err_ret;
> > >  		break;
> > >  	case HW_BREAKPOINT_RW:
> > > -		ret = trace_seq_printf(s, " RW ");
> > > +		if (!trace_seq_printf(s, " RW  "))
> > > +			goto err_ret;
> > >  		break;
> > >  	default:
> > > -		return TRACE_TYPE_PARTIAL_LINE;
> > > +		goto err_ret;
> > >  	}
> > >  
> > > -	if (!ret)
> > > -		return TRACE_TYPE_PARTIAL_LINE;
> > > -
> > >  	sprint_symbol(str, field->ip);
> > >  	ret = trace_seq_printf(s, "%-20s\n", str);
> > > -	if (!ret)
> > > -		return TRACE_TYPE_PARTIAL_LINE;
> > > -
> > > -	return TRACE_TYPE_HANDLED;
> > > +	if (ret)
> > > +		return TRACE_TYPE_HANDLED;
> > > +err_ret:
> > > +	trace_seq_printf(s, "\n");
> > > +	return ret;
> > 
> > 
> > As told in my email just before, TRACE_TYPE_PARTIAL_LINE
> > won't print a truncated line or a partial line. Instead, it
> > will be ignored and entirely retried later.
> > Then your newline will be ignored.
> > 
> > ..unless we have a bug in trace.c
> > 
> 
> Yes, I see that TRACE_TYPE_PARTIAL_LINE isn't the cause but the early
> return that happens (without printing the \n character) because of
> missing data.
> 
> > I'm not sure what it the origin of the concatenated printed entries
> > Ingo has reported.
> > 
> 
> The existing code in -tip reads like this:
> 
> 397         switch (field->ksym_hbp->info.type) {
> 398         case HW_BREAKPOINT_WRITE:
> 399                 ret = trace_seq_printf(s, " W  ");
> 400                 break;
> 401         case HW_BREAKPOINT_RW:
> 402                 ret = trace_seq_printf(s, " RW ");
> 403                 break;
> 404         default:
> 405                 return TRACE_TYPE_PARTIAL_LINE;
> 406         }
> 407 
> 408         if (!ret)
> 409                 return TRACE_TYPE_PARTIAL_LINE;
> 410 
> 411         sprint_symbol(str, field->ip);
> 412         ret = trace_seq_printf(s, "%-20s\n", str);
> 413         if (!ret)
> 414                 return TRACE_TYPE_PARTIAL_LINE;
> 415 
> 
> Si, if the control returns early at line 405 it skips the line at 412
> which prints a newline character. Line 405 is executed if
> field->ksym_hbp->info.type is 0 which is true for an entry that is
> removed from the filter (e.g. echo jiffies:--- > ksym_trace_filter) and
> no amount of retries will help it get some new data (as it is already
> free-ed).



Ok, I guess a straightforward copy to the ring buffer (and not
a pointer to your info) would solve it.


 
> > Did you reproduce it and then this patch fixed it?
> >
> 
> Yes, it was reproduced and tested but actually it is the second patch that
> helps resolve this. The "trace_seq_printf(s, "\n");" isn't required at
> all.
> 
> I will re-send a new patch to you which fixes the line concatenation and
> machine stall issue (after symbol removal in ksym_tracer).


Ok.

Thanks.


> Thanks,
> K.Prasad
> 

