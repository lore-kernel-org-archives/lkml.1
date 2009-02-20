Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbZBTRXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbZBTRXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbZBTRWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:22:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44844 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbZBTRWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:22:52 -0500
Date: Fri, 20 Feb 2009 18:22:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
Message-ID: <20090220172241.GF24538@elte.hu>
References: <499edf47.1818d00a.060b.2b8d@mx.google.com> <499EE162.4050008@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499EE162.4050008@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> > This is what happens on the following build error:
> > 
> > kernel/built-in.o: In function `marker_update_probe_range':
> > (.text+0x52f64): undefined reference to `tracepoint_probe_register_noupdate'
> > kernel/built-in.o: In function `marker_update_probe_range':
> > (.text+0x52f74): undefined reference to `tracepoint_probe_unregister_noupdate'
> > kernel/built-in.o: In function `marker_update_probe_range':
> > (.text+0x52fb9): undefined reference to `tracepoint_probe_unregister_noupdate'
> > kernel/built-in.o: In function `marker_update_probes':
> > marker.c:(.text+0x530ba): undefined reference to `tracepoint_probe_update_all'
> > 
> > CONFIG_KVM_TRACE will select CONFIG_MARKER, but the latter 
> > depends on CONFIG_TRACEPOINTS which will not be selected.
> > 
> > A temporary fix is to make CONFIG_MARKER select 
> > CONFIG_TRACEPOINTS, though it doesn't fix the source KConfig 
> > dependency handling problem.
> > 
> > Reported-by: Ingo Molnar <mingo@elte.hu>
> > Cc: Roman Zippel <zippel@linux-m68k.org>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  init/Kconfig |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/init/Kconfig b/init/Kconfig
> > index b6400a5..a93f957 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -975,7 +975,7 @@ config TRACEPOINTS
> >  
> >  config MARKERS
> >  	bool "Activate markers"
> > -	depends on TRACEPOINTS
> > +	select TRACEPOINTS
> >  	help
> >  	  Place an empty function call at each marker site. Can be
> >  	  dynamically changed for a probe function.
> 
> but using "select" instead of "depends on" just causes the 
> kind of problem that you described, whereas using "depends on" 
> does follow dependency chains.

Well, as long as the secondary selects are 'expanded' along the 
line of dependencies, it should still be fine. With an 
increasing number of dependencies it quickly becomes ugly 
though. This might be one of the cases where it works.

Eventually we should eliminate markers, their uses can either be 
converted to new-style tracepoints, or to ftrace_printk().

	Ingo
