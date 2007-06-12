Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbXFLMrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbXFLMrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 08:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbXFLMrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 08:47:09 -0400
Received: from brick.kernel.dk ([80.160.20.94]:10216 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbXFLMrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 08:47:08 -0400
Date: Tue, 12 Jun 2007 14:44:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: splice: move balance_dirty_pages_ratelimited() outside of    splice actor
Message-ID: <20070612124449.GD18832@kernel.dk>
References: <200706112159.l5BLxF5x004043@hera.kernel.org> <20070611163433.dbc541ec.akpm@linux-foundation.org> <20070612063510.GO18832@kernel.dk> <20070612112059.GY18832@kernel.dk> <20070612113101.GZ18832@kernel.dk> <1181649983.7348.309.camel@twins> <20070612121047.GB18832@kernel.dk> <1181650572.7348.312.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181650572.7348.312.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12 2007, Peter Zijlstra wrote:
> On Tue, 2007-06-12 at 14:10 +0200, Jens Axboe wrote:
> > On Tue, Jun 12 2007, Peter Zijlstra wrote:
> > > On Tue, 2007-06-12 at 13:31 +0200, Jens Axboe wrote:
> > > 
> > > > Would you prefer this change, then? I'd prefer keeping the current code,
> > > > unless it's absolutely critical that we call
> > > > balance_dirty_pages_ratelimited() for each and every page instead of eg
> > > > every 16 pages here.
> > > 
> > > For that we should call:
> > >   balance_dirty_pages_ratelimited_nr(mapping, nr);
> > > 
> > > Which is ok, for small nr.
> > 
> > OK, then this should be better:
> > 
> > diff --git a/fs/splice.c b/fs/splice.c
> > index 25ec9c8..ed40967 100644
> > --- a/fs/splice.c
> > +++ b/fs/splice.c
> > @@ -844,6 +883,9 @@ generic_file_splice_write_nolock(struct pipe_inode_info *pipe, struct file *out,
> >  	sd.file = out;
> >  	ret = __splice_from_pipe(pipe, &sd, pipe_to_file);
> >  	if (ret > 0) {
> > +		unsigned long nr_pages;
> > +
> > +		nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
> 
> perhaps?
> 	nr_pages = DIV_ROUND_UP(ret, PAGE_CACHE_SIZE); 
> 
> not sure how horrid that turns out to be; you never know with gcc.

Well, I think such macros are horribly ugly and that the original code
is MUCH easier to read.

-- 
Jens Axboe

