Return-Path: <linux-kernel-owner+w=401wt.eu-S1759605AbZCYNYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605AbZCYNYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 09:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758359AbZCYNYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 09:24:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40864 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833AbZCYNYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:24:01 -0400
Date: Wed, 25 Mar 2009 09:20:56 -0400
From: Jason Baron <jbaron@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Banks <gnb@sgi.com>
Subject: Re: [PATCH 58/61] dynamic debug: combine dprintk and dynamic printk
Message-ID: <20090325132056.GA15440@redhat.com>
References: <20090325001659.GA22461@kroah.com> <1237940825-22904-58-git-send-email-gregkh@suse.de> <20090325105023.GL2341@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325105023.GL2341@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 11:50:23AM +0100, Ingo Molnar wrote:
> * Greg Kroah-Hartman <gregkh@suse.de> wrote:
> 
> > From: Jason Baron <jbaron@redhat.com>
> > 
> > This patch combines Greg Bank's dprintk() work with the existing 
> > dynamic printk patchset, we are now calling it 'dynamic debug'.
> > 
> > The new feature of this patchset is a richer /debugfs control file 
> > interface, (an example output from my system is at the bottom), 
> > which allows fined grained control over the the debug output. The 
> > output can be controlled by function, file, module, format string, 
> > and line number.
> 
> Hm, dunno this overlaps quite a bit with existing tracing 
> facilities.
> 
> There seems to be serious consolidation potential here, if you want 
> to reduce code and want to cooperate with existing tracing 
> facilities.
> 

we're definitely interested in consolidation...i had posted an optional
flag for toggling to use trace_printk() instead of printk() before...

> In particlar, this facility seems to be a subset of what is already 
> possible via trace_printk(). We could make every dprintk() site show 
> up in /debug/tracing/events/dprintk/, and make it possible to toggle 
> them on/off individually.
> 
> Furthermore it would also be possible to use the user-defined per 
> tracepoint filter expression facility. That way each dprintk site 
> can be (optionally) tailored individually.

we currently can toggle them individually, but not by pid.

> 
> For example we could enable such use:
> 
>   echo 'pid == 1234' > /debug/tracing/events/dprintk/fs/lockd/svc4proc.c:71/filter
>   echo 1             > /debug/tracing/events/dprintk/fs/lockd/svc4proc.c:71/enabled
> 
> To tailor the following dprintk() in fs/lockd/svc4proc.c (line 71):
> 
>   static __be32
>   nlm4svc_proc_null(struct svc_rqst *rqstp, void *argp, void *resp)
>   {
>           dprintk("lockd: NULL          called\n");
>           return rpc_success;
>   }
> 
> To only be printed for PID 1234.
> 
> Per subsystem filters would be available too. The subsystem 
> maintainers dont have to do anything but place dprintk() calls - 
> they'll show up under /debug/tracing/events/dprintk/ automatically.
> 
> Would you be interested in this?
> 

I don't think we want a tracepoint for each of these sites. note that
this facility ties into 'pr_debug' and 'dev_debug' as well...however i
think what you're suggesting is perhaps a new type of event that can
handle this case. Instead of register/unregistering to enable the event,
we can simply set a variable that is associated with each call site. is
this what you are suggesting? If so, i think this would be a nice way to
go...I would however, perhaps want an optional flag that makes these
into printk() and not trace_printk() for certain situations...

With respect to 2.6.30, I'm away next week, so maybe we can keep what we
already have for 2.6.30, and look at this integration for 2.6.31?

thanks,

-Jason

