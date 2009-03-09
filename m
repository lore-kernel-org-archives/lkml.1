Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbZCIRir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbZCIRir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 13:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbZCIRig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 13:38:36 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:56595 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZCIRif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 13:38:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jshOIY/ZE5bNzHrpDuu3SCOa6SbpFICS8pSVjg0WIKFPqWoGzhpcRbAdm9BqIJn+Ej
         p8tsCGT5V7G8YqDboQeVn8fArrdlFM1W+sURb/OElUjb6inrGESSCPWAklhLq9+ITrIX
         0g1PoZHjOqxa9x6WiGSX12Bz9rltg29NbReVc=
Date: Mon, 9 Mar 2009 18:38:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/printk] tracing: optimize trace_printk()
Message-ID: <20090309173827.GA4913@nowhere>
References: <1236356510-8381-5-git-send-email-fweisbec@gmail.com> <tip-7bffc23e56e92c14b787bf4d95249a32085bfed5@git.kernel.org> <alpine.DEB.2.00.0903091322050.2203@gandalf.stny.rr.com> <alpine.DEB.2.00.0903091324020.2203@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903091324020.2203@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 01:24:50PM -0400, Steven Rostedt wrote:
> 
> 
> 
> On Mon, 9 Mar 2009, Steven Rostedt wrote:
> 
> > 
> > On Mon, 9 Mar 2009, Ingo Molnar wrote:
> > > 
> > > tracing: optimize trace_printk()
> > > 
> > > Impact: micro-optimization
> > > 
> > > trace_printk() does this unconditionally:
> > > 
> > > 	trace_printk_fmt = fmt;
> > > 
> > > Where trace_printk_fmt is an entry into a global array. This is
> > > very SMP-unfriendly.
> > > 
> > > So only write it once per bootup.
> > > 
> > > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > > Cc: Steven Rostedt <rostedt@goodmis.org>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > LKML-Reference: <1236356510-8381-5-git-send-email-fweisbec@gmail.com>
> > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > 
> > > 
> > > ---
> > >  include/linux/kernel.h |   10 ++++++++--
> > >  1 files changed, 8 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > > index 4e726b9..7742798 100644
> > > --- a/include/linux/kernel.h
> > > +++ b/include/linux/kernel.h
> > > @@ -454,7 +454,10 @@ do {									\
> > >  do {									\
> > >  	static const char *trace_printk_fmt				\
> > >  	__attribute__((section("__trace_printk_fmt")));			\
> 
> A I missed the semicolon. I wonder if we could make it a static init?
> 
> -- Steve


Actually I first tried to make it like this:
static const char *trace_printk_fmt 
___attribute__((section("__trace_printk_fmt"))) = fmt;

But gcc slapped me. That's why I moved it in the following line.



 
> > > -	trace_printk_fmt = fmt;					\
> > > +									\
> > > +	if (!trace_printk_fmt)						\
> > > +		trace_printk_fmt = fmt;					\
> > > +									\
> > 
> > But this is a static init. That is, it is done at initialization and not
> > every time.
> > 
> > The change actually slows down the system.
> > 
> > >  	__trace_printk_check_format(fmt, ##args);			\
> > >  	__trace_printk(_THIS_IP_, trace_printk_fmt, ##args);		\
> > >  } while (0)
> > > @@ -467,7 +470,10 @@ __trace_printk(unsigned long ip, const char *fmt, ...)
> > >  do {									\
> > >  	static const char *trace_printk_fmt				\
> > >  	__attribute__((section("__trace_printk_fmt")));			\
> > > -	trace_printk_fmt = fmt;					\
> > > +									\
> > > +	if (!trace_printk_fmt)						\
> > > +		trace_printk_fmt = fmt;					\
> > > +									\
> > 
> > Same here.
> > 
> > -- Steve
> > 
> > >  	__ftrace_vprintk(_THIS_IP_, trace_printk_fmt, vargs);		\
> > >  } while (0)
> > >  
> > > 
> > 

