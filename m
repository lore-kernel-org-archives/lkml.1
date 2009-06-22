Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbZFVHbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbZFVHbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 03:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbZFVHbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 03:31:48 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:35445 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbZFVHbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 03:31:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VLCbmwxGpd+ntTufpY9l7Jr+oWQSD+OLFP1B6kauF5ypJW8HemGtYgf6gWIXz7laWD
         wWsh2rF7uxxC5fk5M4F+AJhMBJbpk0NZDNnYzW1/MTNtyjOCzvy9saukwgoxpM8GLkZc
         /w/gsXXqUjPXF7L4exPROuj/TxkvSEfp7I1N8=
Date: Mon, 22 Jun 2009 09:31:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 2/3] ksym_tracer: Allow bulk removal using empty or
	wildcard string input
Message-ID: <20090622073144.GA6015@nowhere>
References: <20090619172035.443923337@prasadkr_t60p.in.ibm.com> <20090619172512.GC26071@in.ibm.com> <20090619231641.GB4700@nowhere> <20090620133752.GA20214@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090620133752.GA20214@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 20, 2009 at 07:07:52PM +0530, K.Prasad wrote:
> On Sat, Jun 20, 2009 at 01:16:41AM +0200, Frederic Weisbecker wrote:
> > On Fri, Jun 19, 2009 at 10:55:12PM +0530, K.Prasad wrote:
> > > Accept an empty string or wildcard input (of the form *:---) as input for
> > > ksym_trace_filter to perform bulk removal of all monitored entries.
> > >
> > > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > > ---
> > >  kernel/trace/trace_ksym.c |   75 +++++++++++++++++++++++++---------------------
> > >  1 file changed, 42 insertions(+), 33 deletions(-)
> > > 
> <snipped>
> > >  /*
> > >   * There can be several possible malformed requests and we attempt to capture
> > >   * all of them. We enumerate some of the rules
> > > @@ -163,7 +191,7 @@ static int parse_ksym_trace_str(char *in
> > >  	/* Check for malformed request: (2), (1) and (5) */
> > >  	if ((!input_string) ||
> > >  		(strlen(input_string) != (KSYM_TRACER_OP_LEN + 1)) ||
> > > -			(*addr == 0))
> > > +			((*addr == 0) && strncmp(*ksymname, "*", strlen("*"))))
> > 
> > 
> > I guess you can just use strcmp() here, no? As in other use
> > of this same strncmp() in this patch.
> > 
> 
> I see both functions being used in the kernel at random (what happened
> to all the buffer-overflow scare?)! Isn't an strncmp() preferred over
> the plain strcmp() (atleast it cannot be the other way round)?


I guess it depends if the string has complicated origins :)
But a plain 1 for the len would be sufficient.
Or here you can just check **ksymname != '*'

Anyway, I'm arguing about neat things that don't matter that much.

Thanks.
 
> > > @@ -251,9 +280,11 @@ static ssize_t ksym_trace_filter_write(s
> > >  	unsigned long ksym_addr = 0;
> > >  	int ret, op, changed = 0;
> > >  
> > > -	/* Ignore echo "" > ksym_trace_filter */
> > > -	if (count == 0)
> > > -		return 0;
> > > +	/* Clear all breakpoint requests if echo "" > ksym_trace_filter */
> > > +	if (count == 1) {
> > > +		ksym_trace_reset(NULL);
> > > +		return count;
> > > +	}
> > 
> > 
> > And then if I do:
> > 
> > echo -n 1 > ksym_trace_filter
> > 
> > That would also clean these breakpoints?
> > 
> > Frederic.
> >
> 
> No, I did not think about this scenario and I am changing the patch to
> handle such a case. Also, the value of 'count' cannot be '0' as such
> inputs are ignored (e.g. echo -n "" > ksym_trace_filter is simply
> ignored) and so I'm removing the check for the same.
> 
> Please find a new version of the patch sent here:
> http://lkml.org/lkml/2009/6/20/73.
> 
> Thanks,
> K.Prasad
> 
>  

