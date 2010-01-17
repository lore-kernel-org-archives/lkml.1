Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255Ab0AQRx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab0AQRx2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 12:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191Ab0AQRx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 12:53:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44915 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab0AQRx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 12:53:27 -0500
Date: Sun, 17 Jan 2010 15:53:06 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Kirill Smelkov <kirr@landau.phys.spbu.ru>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 1/6] perf top: teach it to autolocate vmlinux
Message-ID: <20100117175306.GL24958@ghostprotocols.net>
References: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
 <de6bae3b8d61ea3db1a797f31ebea6e3ed8c00a8.1262952612.git.kirr@landau.phys.spbu.ru>
 <20100113133952.GD2934@ghostprotocols.net>
 <20100117165935.GA4957@landau.phys.spbu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100117165935.GA4957@landau.phys.spbu.ru>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Jan 17, 2010 at 07:59:36PM +0300, Kirill Smelkov escreveu:
> Arnaldo, All,
> 
> Thanks for replying, and I'm sorry for the delay in sending my reply
> back. Please find my not so thoughtful reply below:
                                                        |
That is okaish, lets get down (literally) to the bottom v
 
> On Wed, Jan 13, 2010 at 11:39:52AM -0200, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Jan 08, 2010 at 03:23:04PM +0300, Kirill Smelkov escreveu:
> > > By relying on logic in dso__load_kernel_sym(), we can automatically load
> > > vmlinux.
> > > 
> > > The only thing which needs to be adjusted, is how --sym-annotate option
> > > is handled - now we can't rely on vmlinux been loaded until full
> > > successful pass of dso__load_vmlinux(), but that's not the case if we'll
> > > do sym_filter_entry setup in symbol_filter().
> > > 
> > > So move this step right after event__process_sample() where we know the
> > > whole dso__load_kernel_sym() pass is done.
> > > 
> > > By the way, though conceptually similar `perf top` still can't annotate
> > > userspace - see next patches with fixes.
> > > 
> > > Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
> > > Cc: Mike Galbraith <efault@gmx.de>
> > > ---
> > 
> > <SNIP>
> > 
> > > @@ -951,6 +953,13 @@ static void event__process_sample(const event_t *self,
> > >  	    al.sym == NULL || al.filtered)
> > >  		return;
> > >  
> > > +	/* let's see, whether we need to install initial sym_filter_entry */
> > > +	if (sym_filter_entry_sched) {
> > > +		sym_filter_entry = sym_filter_entry_sched;
> > > +		sym_filter_entry_sched = NULL;
> > > +		parse_source(sym_filter_entry);
> > > +	}
> > > +
> > 
> > You're assuming that the first sample is for the kernel, right? It may
> 
> Not quite so.
> 
> > be not and then the vmlinux won't be loaded at this point.
> 
> I agree, that there is an ambiguity, that e.g. for 'strstr' symbol there
> are variants of which strstr to annotate - the kernel one, or the glibc
> one (or even some other debug version of strstr preloaded by user
> through LD_PRELOAD).

yup

> We'll get here on the first sample which hits function with name equal
> to sym_filter. Sometimes this will be from vmlinux, sometimes not (but
> if a symbol is only from vmlinux and produces sample hits, we'll get
> here eventually for sure).

Definitely, its not the perfect filter, but a good one even then :-)
 
> So yes, there is an ambiguity from which DSO we want sym_filter.

violent agreement.

> > 
> > I think that the right way is to force it to be loaded by calling:
> > 
> > 	map__load(session->vmlinux_maps[MAP__FUNCTION], session, filter);
> > 
> > after perf_session__create_kernel_maps and before parse_source(), ok?
> > 
> > 	You can even create a helper:
> > 
> > int perf_session__load_vmlinux(struct perf_session *self,
> >                                symbol_filter_t filter)
> > {
> > 	return map__load(session->vmlinux_maps[MAP__FUNCTION],
> > 			 session, filter);
> > }
> > 
> > 	As this probably will be of interest for tools such as 'perf
> > probe', etc.
> 
> I see your point.
> 
> Yes, you kernel people are almost always interested in kernel profile in
> the first place :), but won't this be an ad-hock solution? I mean why
> kernel (and only) kernel first?

Even now I don't think I qualify, ad hoc? Sure the current situation is
at best that.

> In case of ambiguity, I'd better let users specify something like
> vmlinux:strstr or libc.so.6:strstr to precisely define info for which
> symbols they are going to see.

In times of 'perf probe' being something that can and will help
integration with other 'people', yeah, we need to precisely define that
we can as well specify something in the Morton'ish test case domain[1]!

> Anyway, as I see it, this days perf is used for kernel development
> mostly, so I'd agree with ad-hoc kernel rule for now.

Yes, definetely agreed, perf must not sound, feel or be a kernel only
medicine, albeit it started from there (that is a good start,
neverthless, I'd say :-)).

> 
> The problem is my spare time is very limited this month - I have only
> few hours through weekends and this weekend I've already spent them all
> :(.  Sorry, maybe next week ...

Don't worry, the amount of feedback I got in this message seems enough
for me to come up with some patches tomorrow, thanks a lot and
dasvidanya!

- Arnaldo

[1] userspace
