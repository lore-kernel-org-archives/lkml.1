Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbZBTRbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbZBTRbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbZBTRbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:31:15 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:40451 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbZBTRbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:31:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bL4u+MMGnDrbXnOTWpTkFmNSx9mvfw+TfZQs9e2AhEexQ9i3QCW2KE/2UHogCavMIg
         oVYEn4ApaStL++xDJI1yjuffvkBsbilK1e1i9W6McIZJQLm2s/EdBl1JMoLXJQ4PO7t/
         ltMHATXsZjfgLr/fOCsx6BsryveJ4PpdO3ptY=
Date: Fri, 20 Feb 2009 18:31:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
Message-ID: <20090220173107.GH5732@nowhere>
References: <499edf47.1818d00a.060b.2b8d@mx.google.com> <499EE162.4050008@oracle.com> <20090220172241.GF24538@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220172241.GF24538@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 06:22:41PM +0100, Ingo Molnar wrote:
> 
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > > This is what happens on the following build error:
> > > 
> > > kernel/built-in.o: In function `marker_update_probe_range':
> > > (.text+0x52f64): undefined reference to `tracepoint_probe_register_noupdate'
> > > kernel/built-in.o: In function `marker_update_probe_range':
> > > (.text+0x52f74): undefined reference to `tracepoint_probe_unregister_noupdate'
> > > kernel/built-in.o: In function `marker_update_probe_range':
> > > (.text+0x52fb9): undefined reference to `tracepoint_probe_unregister_noupdate'
> > > kernel/built-in.o: In function `marker_update_probes':
> > > marker.c:(.text+0x530ba): undefined reference to `tracepoint_probe_update_all'
> > > 
> > > CONFIG_KVM_TRACE will select CONFIG_MARKER, but the latter 
> > > depends on CONFIG_TRACEPOINTS which will not be selected.
> > > 
> > > A temporary fix is to make CONFIG_MARKER select 
> > > CONFIG_TRACEPOINTS, though it doesn't fix the source KConfig 
> > > dependency handling problem.
> > > 
> > > Reported-by: Ingo Molnar <mingo@elte.hu>
> > > Cc: Roman Zippel <zippel@linux-m68k.org>
> > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > ---
> > >  init/Kconfig |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/init/Kconfig b/init/Kconfig
> > > index b6400a5..a93f957 100644
> > > --- a/init/Kconfig
> > > +++ b/init/Kconfig
> > > @@ -975,7 +975,7 @@ config TRACEPOINTS
> > >  
> > >  config MARKERS
> > >  	bool "Activate markers"
> > > -	depends on TRACEPOINTS
> > > +	select TRACEPOINTS
> > >  	help
> > >  	  Place an empty function call at each marker site. Can be
> > >  	  dynamically changed for a probe function.
> > 
> > but using "select" instead of "depends on" just causes the 
> > kind of problem that you described, whereas using "depends on" 
> > does follow dependency chains.
> 
> Well, as long as the secondary selects are 'expanded' along the 
> line of dependencies, it should still be fine. With an 
> increasing number of dependencies it quickly becomes ugly 
> though. This might be one of the cases where it works.
> 
> Eventually we should eliminate markers, their uses can either be 
> converted to new-style tracepoints, or to ftrace_printk().
> 
> 	Ingo

ftrace_printk adds more overhead if not used since it inconditionally
send the trace, unless the related TRACE_ITER_PRINTK flag on ftrace is unset.

I don't know how markers work, but the documentation describes that a single branch
check is done in case the probe is disabled.

With ftrace_printk, even if TRACE_ITER_PRINTK is unset, this is still
one call and one branch check. So for hot callsite it's unappropriate.

IMHO, tracepoints are more suited to replace markers if they have to.

