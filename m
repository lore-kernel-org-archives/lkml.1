Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbXFLQDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbXFLQDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 12:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbXFLQDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 12:03:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57427 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754664AbXFLQDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 12:03:00 -0400
Date: Tue, 12 Jun 2007 09:02:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: splice: move balance_dirty_pages_ratelimited() outside of   
 splice actor
Message-Id: <20070612090230.19ab939c.akpm@linux-foundation.org>
In-Reply-To: <20070612124449.GD18832@kernel.dk>
References: <200706112159.l5BLxF5x004043@hera.kernel.org>
	<20070611163433.dbc541ec.akpm@linux-foundation.org>
	<20070612063510.GO18832@kernel.dk>
	<20070612112059.GY18832@kernel.dk>
	<20070612113101.GZ18832@kernel.dk>
	<1181649983.7348.309.camel@twins>
	<20070612121047.GB18832@kernel.dk>
	<1181650572.7348.312.camel@twins>
	<20070612124449.GD18832@kernel.dk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2007 14:44:50 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> On Tue, Jun 12 2007, Peter Zijlstra wrote:
> > On Tue, 2007-06-12 at 14:10 +0200, Jens Axboe wrote:
> > > On Tue, Jun 12 2007, Peter Zijlstra wrote:
> > > > On Tue, 2007-06-12 at 13:31 +0200, Jens Axboe wrote:
> > > > 
> > > > > Would you prefer this change, then? I'd prefer keeping the current code,
> > > > > unless it's absolutely critical that we call
> > > > > balance_dirty_pages_ratelimited() for each and every page instead of eg
> > > > > every 16 pages here.
> > > > 
> > > > For that we should call:
> > > >   balance_dirty_pages_ratelimited_nr(mapping, nr);
> > > > 
> > > > Which is ok, for small nr.
> > > 
> > > OK, then this should be better:

yup, the patch looks fine, thanks.

It will in practice be OK calling balance_dirty_pages() once per 16 pages
but one should try to be a good little kernel citizen and do the right
thing, I guess.

> > > diff --git a/fs/splice.c b/fs/splice.c
> > > index 25ec9c8..ed40967 100644
> > > --- a/fs/splice.c
> > > +++ b/fs/splice.c
> > > @@ -844,6 +883,9 @@ generic_file_splice_write_nolock(struct pipe_inode_info *pipe, struct file *out,
> > >  	sd.file = out;
> > >  	ret = __splice_from_pipe(pipe, &sd, pipe_to_file);
> > >  	if (ret > 0) {
> > > +		unsigned long nr_pages;
> > > +
> > > +		nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
> > 
> > perhaps?
> > 	nr_pages = DIV_ROUND_UP(ret, PAGE_CACHE_SIZE); 
> > 
> > not sure how horrid that turns out to be; you never know with gcc.
> 
> Well, I think such macros are horribly ugly and that the original code
> is MUCH easier to read.

I think the macros are pretty foul too (perhaps we should migrate it to
"div_round_up()").

But we should migrate to them.  Because once one has learned what a
particular helper like this does, the code becomes more readable, more
understandable and easier to verify correct behaviour.  Whereas the
open-coded arithmetic is _always_ suspect and always needs to be checked
each time one's eye passes over it.

And then there's the ongoing pitter-patter of "convert to DIV_ROUND_UP"
patches in my inbox ;)

It's not, however, our biggest problem.
