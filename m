Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086Ab0AQQ7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab0AQQ7m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 11:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228Ab0AQQ7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 11:59:41 -0500
Received: from landau.phys.spbu.ru ([195.19.235.38]:50185 "EHLO
	landau.phys.spbu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab0AQQ7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 11:59:41 -0500
Date: Sun, 17 Jan 2010 19:59:36 +0300
From: Kirill Smelkov <kirr@landau.phys.spbu.ru>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 1/6] perf top: teach it to autolocate vmlinux
Message-ID: <20100117165935.GA4957@landau.phys.spbu.ru>
References: <cover.1262952612.git.kirr@landau.phys.spbu.ru> <de6bae3b8d61ea3db1a797f31ebea6e3ed8c00a8.1262952612.git.kirr@landau.phys.spbu.ru> <20100113133952.GD2934@ghostprotocols.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100113133952.GD2934@ghostprotocols.net>
Organization: St.Petersburg State University
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo, All,

Thanks for replying, and I'm sorry for the delay in sending my reply
back. Please find my not so thoughtful reply below:

On Wed, Jan 13, 2010 at 11:39:52AM -0200, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jan 08, 2010 at 03:23:04PM +0300, Kirill Smelkov escreveu:
> > By relying on logic in dso__load_kernel_sym(), we can automatically load
> > vmlinux.
> > 
> > The only thing which needs to be adjusted, is how --sym-annotate option
> > is handled - now we can't rely on vmlinux been loaded until full
> > successful pass of dso__load_vmlinux(), but that's not the case if we'll
> > do sym_filter_entry setup in symbol_filter().
> > 
> > So move this step right after event__process_sample() where we know the
> > whole dso__load_kernel_sym() pass is done.
> > 
> > By the way, though conceptually similar `perf top` still can't annotate
> > userspace - see next patches with fixes.
> > 
> > Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
> > Cc: Mike Galbraith <efault@gmx.de>
> > ---
> 
> <SNIP>
> 
> > @@ -951,6 +953,13 @@ static void event__process_sample(const event_t *self,
> >  	    al.sym == NULL || al.filtered)
> >  		return;
> >  
> > +	/* let's see, whether we need to install initial sym_filter_entry */
> > +	if (sym_filter_entry_sched) {
> > +		sym_filter_entry = sym_filter_entry_sched;
> > +		sym_filter_entry_sched = NULL;
> > +		parse_source(sym_filter_entry);
> > +	}
> > +
> 
> You're assuming that the first sample is for the kernel, right? It may

Not quite so.

> be not and then the vmlinux won't be loaded at this point.

I agree, that there is an ambiguity, that e.g. for 'strstr' symbol there
are variants of which strstr to annotate - the kernel one, or the glibc
one (or even some other debug version of strstr preloaded by user
through LD_PRELOAD).


We'll get here on the first sample which hits function with name equal
to sym_filter. Sometimes this will be from vmlinux, sometimes not (but
if a symbol is only from vmlinux and produces sample hits, we'll get
here eventually for sure).

So yes, there is an ambiguity from which DSO we want sym_filter.


> 
> I think that the right way is to force it to be loaded by calling:
> 
> 	map__load(session->vmlinux_maps[MAP__FUNCTION], session, filter);
> 
> after perf_session__create_kernel_maps and before parse_source(), ok?
> 
> 	You can even create a helper:
> 
> int perf_session__load_vmlinux(struct perf_session *self,
>                                symbol_filter_t filter)
> {
> 	return map__load(session->vmlinux_maps[MAP__FUNCTION],
> 			 session, filter);
> }
> 
> 	As this probably will be of interest for tools such as 'perf
> probe', etc.

I see your point.

Yes, you kernel people are almost always interested in kernel profile in
the first place :), but won't this be an ad-hock solution? I mean why
kernel (and only) kernel first?

In case of ambiguity, I'd better let users specify something like
vmlinux:strstr or libc.so.6:strstr to precisely define info for which
symbols they are going to see.

Anyway, as I see it, this days perf is used for kernel development
mostly, so I'd agree with ad-hoc kernel rule for now.


The problem is my spare time is very limited this month - I have only
few hours through weekends and this weekend I've already spent them all
:(.  Sorry, maybe next week ...


Kirill


P.S. how about patches 4/6 and 5/6? They fix `perf annotate`
(independently for this vmlinux loading thing) and `perf top->annotate`
fix is somewhat orthogonal to the patch we are discussing...
