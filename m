Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970Ab0CLNZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 08:25:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54891 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab0CLNZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 08:25:21 -0500
Date: Fri, 12 Mar 2010 10:25:09 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH v2 5/5] perf report: Initial TUI using newt
Message-ID: <20100312132509.GN14180@ghostprotocols.net>
References: <1268349164-5822-1-git-send-email-acme@infradead.org> <1268349164-5822-5-git-send-email-acme@infradead.org> <20100312094533.GA13177@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100312094533.GA13177@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 12, 2010 at 10:45:33AM +0100, Ingo Molnar escreveu:
> 
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> 
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> > Newt has widespread availability and provides a rather simple API as can be 
> > seen by the size of this patch.
> > 
> > The work needed to support it will benefit other frontends too.
> > 
> > In this initial patch it just checks if the output is a tty, if not it falls 
> > back to the previous behaviour, also if newt-devel/libnewt-dev is not 
> > installed the previous behaviour is maintaned.
> > 
> > Pressing enter on a symbol will annotate it, ESC in the annotation window will
> > return to the report symbol list.
> 
> Very nice!
> 
> a few observations. Firstly, could we perhaps make most of the interface 
> functions GUI/TUI invariant? I.e. things like:
> 
> > +	if (use_browser)
> > +		r = vfprintf(fp, fmt, args);
> > +	else
> > +		r = color_vfprintf(fp, color, fmt, args);
> 
> should be abstracted away into a single method:
> 
> 	r = color_vprintf(fp, color, fmt, args);
> 
> where color_vprintf() knows about which current GUI front-end to use.

Yeah, I'll get to that, its just that I wanted to have something out as
small as possible and that pointed to the places that need refactoring
to properly support multiple UI frontends.
 
> (The old color_printf() should be renamed to ascii_color_printf() or so, and 
> put into a front-end driver structure perhaps - instead of explicit flags.)

Right
 
> There's a similar situation here too:
> 
> > -		ret = vfprintf(stderr, fmt, args);
> > +		if (use_browser)
> > +			ret = browser__show_help(fmt, args);
> > +		else
> > +			ret = vfprintf(stderr, fmt, args);
> 
> Plus a few other observations about the newt TUI itself:
> 
>  - The most important first-impression thing in a TUI is to make it obvious to
>    exit it. I eventually found that Escape would exit - but it would be nice 
>    to map 'Q' and 'Ctrl-C' to it as well. Nothing is more annoying than a TUI 
>    you cannot exit from.

Newt's default is F12, I had to killall perf while developing and
getting to know newtFormAddHotKey to exit, will add the other usual keys to
exit.
 
>  - There's still a 'perf annotate' bug that has been introduced recently, and 
>    it shows up in the TUI too. The bug is due to us passing this to objdump 
>    and grep:
> 
>      18573 execve("/bin/sh", ["sh", "-c", "objdump --start-address=0xffffffff81387b36
>        --stop-address=0xffffffff81387b4f -dS [kernel.kallsyms]|grep -v [kernel.kallsyms]"]
> 
>    Look at how [kernel.kallsyms] goes unquoted to the shell, so globbing will 
>    match it on random file names in the current directory - which will then be 
>    showed by objdump, much to the surprise of the user!

Will fix that, if we don't find a vmlinux file, the kernel symbols will
be marked non annotable in some way.
 
>  - I suspect we should finally make use of the .perfconfig parser and enable people
>    to use a different front-end from Newt? Just in case they prefer ASCII.
> 
>  - When i hit enter on a symbol to annotate it, but the annotation fails, the TUI
>    just does nothing currently. Instead it should print something informative 
>    (and eye-catching) into a status line at the top or the bottom of the 
>    screen, possibly printed in red characters or so. Not a separate window as that
>    needs extra key-hits to get rid of - just a sufficiently visible status 
>    line would be perfect. There can be a few reasons why some functions can be 
>    annotated while others cannot be.

Right.
 
>  - [ call-graph data is not represented yet :-) ]

It will
 
> Anyway, very nice stuff!

Thanks!

- Arnaldo
