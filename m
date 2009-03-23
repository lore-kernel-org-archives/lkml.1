Return-Path: <linux-kernel-owner+w=401wt.eu-S1760428AbZCWTWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760428AbZCWTWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 15:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759539AbZCWTW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 15:22:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34205 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759639AbZCWTW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:22:28 -0400
Date: Mon, 23 Mar 2009 20:22:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 3/5] tracing/ftrace: check if debugfs is registered
	before creating files
Message-ID: <20090323192212.GA23842@elte.hu>
References: <1237759847-21025-1-git-send-email-fweisbec@gmail.com> <1237759847-21025-3-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0903231517410.3578@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903231517410.3578@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Sun, 22 Mar 2009, Frederic Weisbecker wrote:
> 
> > Impact: fix a crash with ftrace={nop,boot} parameter
> > 
> > If the nop or initcall tracers are launched as boot tracers,
> > they will attempt to create their option directory and files.
> > But these tracers are registered very early and then assigned
> > as "boot tracers" very early if asked to.
> > 
> > Since they do this before debugfs has been registered (core initcall),
> > a crash is triggered.
> > 
> > Another early tracers could also come later. So we fix it by
> > checking if debugfs is initialized before creating the root
> > tracing directory.
> > 
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  kernel/trace/trace.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index ace685c..f0e1337 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -3513,6 +3513,9 @@ struct dentry *tracing_init_dentry(void)
> >  	if (d_tracer)
> >  		return d_tracer;
> >  
> > +	if (!debugfs_initialized())
> > +		return NULL;
> > +
> >  	d_tracer = debugfs_create_dir("tracing", NULL);
> >  
> 
> Hmm, those tracers should separate out the debugfs code, and put 
> it into a fs_initcall(), where debugfs should already initialized.

indeed, this seems much cleaner and we'll have the debugfs 
structures initialized as well.

	Ingo
