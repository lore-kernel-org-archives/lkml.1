Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791Ab0AVLpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab0AVLpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 06:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614Ab0AVLpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 06:45:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:57846 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab0AVLpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 06:45:51 -0500
Date: Fri, 22 Jan 2010 09:45:37 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] perf tools: fix dc8d6ab typo prohibiting perf top
	symbol annotation
Message-ID: <20100122114537.GD1244@ghostprotocols.net>
References: <1264142379.8074.3.camel@marge.simson.net> <20100122112231.GC1244@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100122112231.GC1244@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 22, 2010 at 09:22:31AM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Fri, Jan 22, 2010 at 07:39:39AM +0100, Mike Galbraith escreveu:
> > 
> > perf tools: fix dc8d6ab typo prohibiting perf top symbol annotation
> > 
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > LKML-Reference: <new-submission>
> > 
> > diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> > index 6f30fe1..af2e224 100644
> > --- a/tools/perf/util/symbol.c
> > +++ b/tools/perf/util/symbol.c
> > @@ -1669,7 +1669,7 @@ do_kallsyms:
> >  	free(kallsyms_allocated_filename);
> >  
> >  out_try_fixup:
> > -	if (err > 0) {
> > +	if (err <= 0) {
> >  out_fixup:
> >  		if (kallsyms_filename == NULL)
> >  			dso__set_long_name(self, strdup("[kernel.kallsyms]"));
> 
> Strange, we need to fixup the map only if we found some symbol, so all
> the routines there return the number of symbols found or -1 for errors,
> investigating perf top symbol annotation now...

So the sequence is, right now, without Kirill's patch to autofind the
right vmlinux: one needs to specify a --vmlinux /path/to/vmlinux, and
that, dc8d6ab, made the only file to be considered.

This means that if dso__load_vmlinux for this specified file fails, we
won't have kernel symbols, and in my test it failed because the buildid
for the running kernel (/sys/kernel/notesr) didn't match the one in the
specified vmlinux file...

But that is only appearing if --verbose is used and even then, because
we use such a simple interface to refresh the screen, gets lost, I only
saw this while in gdb:

build_id in /lib/modules/2.6.33-rc4-tip+/build/vmlinux is
d04f055cae38f29e0bdef3610743acac9e80738c while expected is
74f9930ee94475b6b3238caf3725a50d59cb994b, ignoring it

I'll fix this now by making perf top fail and print this, even with it
being able to still be useful to see kernel modules and userspace
symbols. Longer term we need to move it to a ncurses interface and have
a status bar where such errors can be given proper "sticky" visibility.

Just a sec...

- Arnaldo
