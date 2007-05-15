Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbXEOSax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbXEOSax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 14:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbXEOSao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 14:30:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38670 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114AbXEOSan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 14:30:43 -0400
Date: Tue, 15 May 2007 11:30:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: select(0, ..) is valid ?
Message-Id: <20070515113033.75d7bff6.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705151109021.31972@schroedinger.engr.sgi.com>
References: <1179250159.2836.117.camel@dyn9047017100.beaverton.ibm.com>
	<20070515104453.f901e91f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705151109021.31972@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 11:10:22 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 15 May 2007, Andrew Morton wrote:
> 
> > I _think_ we can just do
> > 
> > --- a/fs/compat.c~a
> > +++ a/fs/compat.c
> > @@ -1566,9 +1566,13 @@ int compat_core_sys_select(int n, compat
> >  	 */
> >  	ret = -ENOMEM;
> >  	size = FDS_BYTES(n);
> > -	bits = kmalloc(6 * size, GFP_KERNEL);
> > -	if (!bits)
> > -		goto out_nofds;
> > +	if (likely(size)) {
> > +		bits = kmalloc(6 * size, GFP_KERNEL);
> > +		if (!bits)
> > +			goto out_nofds;
> > +	} else {
> > +		bits = NULL;
> > +	}
> >  	fds.in      = (unsigned long *)  bits;
> >  	fds.out     = (unsigned long *) (bits +   size);
> >  	fds.ex      = (unsigned long *) (bits + 2*size);
> > _
> > 
> > I mean, if that oopses then I'd be very interested in finding out why.
> > 
> > But I'm starting to suspect that it would be better to permit kmalloc(0) in
> > slub.  It depends on how many more of these things need fixing.
> > 
> > otoh, a kmalloc(0) could be a sign of some buggy/inefficient/weird code, so
> > there's some value in forcing us to go look at all the callsites.
>  
> Hmmm... We could have kmalloc(0) return a pointer to the zero page? That 
> would catch any writers?

Returning NULL would have the same effect..

But the problem is that we won't get 100% coverage of all codepaths
for ages, so any oopses we added won't get found.

otoh, any code which does dereference that pointer is buggy anwyay.

The problem here is that code which does

	kmalloc(some-expression-which-returns-0)

will go and assume that the kmalloc(0) got an ENOMEM and it'll take the
error path.

Oh well, let's persist with things as they now are.

Perhaps putting a size=0 detector into slab also would speed this
process up.
