Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab0BYOOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 09:14:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932629Ab0BYOOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 09:14:16 -0500
Date: Thu, 25 Feb 2010 11:13:51 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, a.p.zijlstra@chello.nl,
       paulus@samba.org, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: perf per-symbol histogram causes memory corruption
Message-ID: <20100225141351.GA8553@ghostprotocols.net>
References: <20100225.022618.256301798.davem@davemloft.net> <20100225111148.GA5754@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100225111148.GA5754@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 25, 2010 at 12:11:48PM +0100, Ingo Molnar escreveu:
> 
> (Added Arnaldo to the Cc: - he's maintaining the symbol lookup bits of perf.)
> 
> * David Miller <davem@davemloft.net> wrote:
> 
> > When builtin-annotate.c processes sample events via
> > process_sample_event() it uses 'sample_filter'
> > 
> > sample_filter() sizes the histogram object for a symbol based upon the
> > size, calculated as "sym->end - sym->start", to determine the number
> > of IP sample slots to allocate.
> > 
> > The problem is, the sym->end value is not stable at this point.
> > 
> > For example, dso__load_sym() first loads all of the symbols, then it
> > makes another pass over the symbols by calling symbols__fixup_end()
> > which will adjust the sym->end values of various symbols.
> > 
> > At this point, the histogram IP sample array allocated by
> > sample_filter() can become too small, and hits recorded can thus
> > access past the end of the array corrupting memory.
> > 
> > I get this very reliably on sparc64, and it took me a few days to root
> > cause this. :-)
> > 
> > I don't see an immediate way to fix this, any ideas?

This was reported by Anton as well, I guess the right way to fix this is
to first load all symbols and then iterate thru them allocating the
resources that need to have ->end fixed up.

As we already fix up the symbols when we finish loading them, annotate
would have meaningful ->end members.

I.e. 'perf annotate' is not using this mechanism as a filter. Its a post
processing phase.

I'll provide a patch.

- Arnaldo
