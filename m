Return-Path: <linux-kernel-owner+w=401wt.eu-S1757149AbXJKHhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149AbXJKHhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 03:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbXJKHhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 03:37:31 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:64410 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968AbXJKHha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 03:37:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Cv6F8pQd9aGFEZLwSvfOQBm/6w92GCFBs0nLn+7QlrpxaFbdxn41O8YLOMUNI66MJ4LLbBGdRTbja1D6CUMFJabayFd8Y0VCMu+n28IAq/DYtWP5H5KZEjK7eXBWxF4yVPFlwazfH3GRbzYJmk4GA7Hgi78pCVb2FTYIEuJosQU=
Message-ID: <19f34abd0710110037q5b94992u53689269051b674c@mail.gmail.com>
Date: Thu, 11 Oct 2007 09:37:29 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: Fix printk format strings
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, "Hugh Dickins" <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071011001300.7682a93b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192085221.26648.31.camel@grianne>
	 <20071010235306.c71afe66.akpm@linux-foundation.org>
	 <19f34abd0710110004k78d103fate87558822fb631a3@mail.gmail.com>
	 <20071011001300.7682a93b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 11 Oct 2007 09:04:57 +0200 "Vegard Nossum" <vegard.nossum@gmail.com> wrote:
>
> > > > -     printk("Active:%lu inactive:%lu dirty:%lu writeback:%lu unstable:%lu\n"
> > > > -             " free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
> > > > +     printk("Active:%lu inactive:%lu dirty:%lu writeback:%lu unstable:%lu\n",
> > > >               global_page_state(NR_ACTIVE),
> > > >               global_page_state(NR_INACTIVE),
> > > >               global_page_state(NR_FILE_DIRTY),
> > > >               global_page_state(NR_WRITEBACK),
> > > > -             global_page_state(NR_UNSTABLE_NFS),
> > > > +             global_page_state(NR_UNSTABLE_NFS));
> > > > +     printk(" free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
> > > >               global_page_state(NR_FREE_PAGES),
> > > >               global_page_state(NR_SLAB_RECLAIMABLE) +
> > > >                       global_page_state(NR_SLAB_UNRECLAIMABLE),
> > >
> > > I don't understand the reason for this change.
> >
> > I'm sorry :). It helps to make one line per call only, since this
> > allows changing the printk internals for the better by reducing some
> > complexity. I believe this is a good thing. I have a patch that
> > changes printk, but it assumes that each format string only contains a
> > single line. Is this a very bad assumption to make? Or maybe I should
> > have sent that change first and made a reference to it?
> >
> > But don't you also agree, on the grounds of principle, that a single
> > line per call is better style?
>
> Well we do multiple-lines-per-printk in rather a lot of places and it has
> two advantages:
>
> - less text size (I expect)
>
> - the printk is "atomic" in that the logically-connected output lines
>   won't get tangled up with an intervening printk from another CPU, or from
>   an interrupt handler on this CPU.
>
> Those are pretty modest advantages and I guess we could live without them
> if we got a significant gain from doing so.  But it'd take quite some
> effort hunting down all the callsites, and preventing new ones from
> occuring.

I have written a sparse program to detect all callers that don't use
single-line literal strings for the printk format (posted to sparse
mailing list yesterday). So in fact, what I was doing was just that,
hunting them down and cleaning it up.

It so happens that my other patch also introduce a buffered printk
that supports atomic line continuations and multiple uninterrupted
lines, though this requires of course that the callers use these
functions. Other benefits include writing directly to the ring-buffer,
saving a 1K temporary buffer. The printk patch(es) can be viewed at
http://folk.uio.no/vegardno/xprintf/

Vegard
