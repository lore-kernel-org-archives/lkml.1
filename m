Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbZFTNiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbZFTNiR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 09:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbZFTNiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 09:38:07 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:38989 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbZFTNiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 09:38:05 -0400
Date: Sat, 20 Jun 2009 19:07:52 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 2/3] ksym_tracer: Allow bulk removal using empty or
	wildcard string input
Message-ID: <20090620133752.GA20214@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090619172035.443923337@prasadkr_t60p.in.ibm.com> <20090619172512.GC26071@in.ibm.com> <20090619231641.GB4700@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090619231641.GB4700@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 20, 2009 at 01:16:41AM +0200, Frederic Weisbecker wrote:
> On Fri, Jun 19, 2009 at 10:55:12PM +0530, K.Prasad wrote:
> > Accept an empty string or wildcard input (of the form *:---) as input for
> > ksym_trace_filter to perform bulk removal of all monitored entries.
> >
> > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > ---
> >  kernel/trace/trace_ksym.c |   75 +++++++++++++++++++++++++---------------------
> >  1 file changed, 42 insertions(+), 33 deletions(-)
> > 
<snipped>
> >  /*
> >   * There can be several possible malformed requests and we attempt to capture
> >   * all of them. We enumerate some of the rules
> > @@ -163,7 +191,7 @@ static int parse_ksym_trace_str(char *in
> >  	/* Check for malformed request: (2), (1) and (5) */
> >  	if ((!input_string) ||
> >  		(strlen(input_string) != (KSYM_TRACER_OP_LEN + 1)) ||
> > -			(*addr == 0))
> > +			((*addr == 0) && strncmp(*ksymname, "*", strlen("*"))))
> 
> 
> I guess you can just use strcmp() here, no? As in other use
> of this same strncmp() in this patch.
> 

I see both functions being used in the kernel at random (what happened
to all the buffer-overflow scare?)! Isn't an strncmp() preferred over
the plain strcmp() (atleast it cannot be the other way round)?

> > @@ -251,9 +280,11 @@ static ssize_t ksym_trace_filter_write(s
> >  	unsigned long ksym_addr = 0;
> >  	int ret, op, changed = 0;
> >  
> > -	/* Ignore echo "" > ksym_trace_filter */
> > -	if (count == 0)
> > -		return 0;
> > +	/* Clear all breakpoint requests if echo "" > ksym_trace_filter */
> > +	if (count == 1) {
> > +		ksym_trace_reset(NULL);
> > +		return count;
> > +	}
> 
> 
> And then if I do:
> 
> echo -n 1 > ksym_trace_filter
> 
> That would also clean these breakpoints?
> 
> Frederic.
>

No, I did not think about this scenario and I am changing the patch to
handle such a case. Also, the value of 'count' cannot be '0' as such
inputs are ignored (e.g. echo -n "" > ksym_trace_filter is simply
ignored) and so I'm removing the check for the same.

Please find a new version of the patch sent here:
http://lkml.org/lkml/2009/6/20/73.

Thanks,
K.Prasad

 
