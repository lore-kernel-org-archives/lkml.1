Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbZC0MqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbZC0MqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 08:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbZC0MqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 08:46:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48834 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbZC0MqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:46:11 -0400
Date: Fri, 27 Mar 2009 08:46:07 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: kill some magic numbers
In-Reply-To: <20090327122113.GD5976@nowhere>
Message-ID: <alpine.DEB.2.00.0903270841230.1917@gandalf.stny.rr.com>
References: <49CC7870.9000309@cn.fujitsu.com> <20090327122113.GD5976@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Mar 2009, Frederic Weisbecker wrote:

> On Fri, Mar 27, 2009 at 02:55:44PM +0800, Li Zefan wrote:
> > Impact: cleanup
> > 
> > Use USEC_PER_SEC and NSEC_PER_SEC instead of 1000000 and 1000000000.

Nothing against the patch, but the subject is a bit misleading. I was 
expecting to see removals of "64" or some other "magic" numbers.

But 1000000 and 1000000000 are not magic numbers. They are known 
constants that represent usecs per second and nsecs per second.

I know this is just a nit, but the subject should have been

 tracing: replace number constants with meaningful names

But for the patch itself...

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve


> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > ---
> >  kernel/trace/trace_boot.c      |    5 +++--
> >  kernel/trace/trace_mmiotrace.c |    6 ++++--
> >  2 files changed, 7 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
> > index 7a30fc4..a29ef23 100644
> > --- a/kernel/trace/trace_boot.c
> > +++ b/kernel/trace/trace_boot.c
> > @@ -9,6 +9,7 @@
> >  #include <linux/debugfs.h>
> >  #include <linux/ftrace.h>
> >  #include <linux/kallsyms.h>
> > +#include <linux/time.h>
> >  
> >  #include "trace.h"
> >  #include "trace_output.h"
> > @@ -67,7 +68,7 @@ initcall_call_print_line(struct trace_iterator *iter)
> >  	trace_assign_type(field, entry);
> >  	call = &field->boot_call;
> >  	ts = iter->ts;
> > -	nsec_rem = do_div(ts, 1000000000);
> > +	nsec_rem = do_div(ts, NSEC_PER_SEC);
> >  
> >  	ret = trace_seq_printf(s, "[%5ld.%09ld] calling  %s @ %i\n",
> >  			(unsigned long)ts, nsec_rem, call->func, call->caller);
> > @@ -92,7 +93,7 @@ initcall_ret_print_line(struct trace_iterator *iter)
> >  	trace_assign_type(field, entry);
> >  	init_ret = &field->boot_ret;
> >  	ts = iter->ts;
> > -	nsec_rem = do_div(ts, 1000000000);
> > +	nsec_rem = do_div(ts, NSEC_PER_SEC);
> >  
> >  	ret = trace_seq_printf(s, "[%5ld.%09ld] initcall %s "
> >  			"returned %d after %llu msecs\n",
> > diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
> > index 8e37fcd..d53b45e 100644
> > --- a/kernel/trace/trace_mmiotrace.c
> > +++ b/kernel/trace/trace_mmiotrace.c
> > @@ -9,6 +9,8 @@
> >  #include <linux/kernel.h>
> >  #include <linux/mmiotrace.h>
> >  #include <linux/pci.h>
> > +#include <linux/time.h>
> > +
> >  #include <asm/atomic.h>
> >  
> >  #include "trace.h"
> > @@ -174,7 +176,7 @@ static enum print_line_t mmio_print_rw(struct trace_iterator *iter)
> >  	struct mmiotrace_rw *rw;
> >  	struct trace_seq *s	= &iter->seq;
> >  	unsigned long long t	= ns2usecs(iter->ts);
> > -	unsigned long usec_rem	= do_div(t, 1000000ULL);
> > +	unsigned long usec_rem	= do_div(t, USEC_PER_SEC);
> >  	unsigned secs		= (unsigned long)t;
> >  	int ret = 1;
> >  
> > @@ -221,7 +223,7 @@ static enum print_line_t mmio_print_map(struct trace_iterator *iter)
> >  	struct mmiotrace_map *m;
> >  	struct trace_seq *s	= &iter->seq;
> >  	unsigned long long t	= ns2usecs(iter->ts);
> > -	unsigned long usec_rem	= do_div(t, 1000000ULL);
> > +	unsigned long usec_rem	= do_div(t, USEC_PER_SEC);
> >  	unsigned secs		= (unsigned long)t;
> >  	int ret;
> >  
> > -- 
> > 1.5.4.rc3
> 
> 
> Thanks!
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> 
