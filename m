Return-Path: <linux-kernel-owner+w=401wt.eu-S1757667AbXFLSvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbXFLSvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 14:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757243AbXFLSut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 14:50:49 -0400
Received: from brick.kernel.dk ([80.160.20.94]:21793 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757308AbXFLSur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 14:50:47 -0400
Date: Tue, 12 Jun 2007 20:48:26 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: splice: move balance_dirty_pages_ratelimited() outside of      splice actor
Message-ID: <20070612184826.GS18832@kernel.dk>
References: <20070612112059.GY18832@kernel.dk> <20070612113101.GZ18832@kernel.dk> <1181649983.7348.309.camel@twins> <20070612121047.GB18832@kernel.dk> <1181650572.7348.312.camel@twins> <20070612124449.GD18832@kernel.dk> <20070612094615.9e5557e5.akpm@linux-foundation.org> <20070612173202.GO18832@kernel.dk> <20070612181540.GP18832@kernel.dk> <20070612114322.dfb4e90c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612114322.dfb4e90c.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12 2007, Andrew Morton wrote:
> On Tue, 12 Jun 2007 20:15:41 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Tue, Jun 12 2007, Jens Axboe wrote:
> > > On Tue, Jun 12 2007, Andrew Morton wrote:
> > > > On Tue, 12 Jun 2007 14:44:50 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > 
> > > > > splice
> > > > 
> > > > btw, I'm staring in profound mystification at this:
> > > > 
> > > > int generic_pipe_buf_steal(struct pipe_inode_info *pipe,
> > > > 			   struct pipe_buffer *buf)
> > > > {
> > > > 	struct page *page = buf->page;
> > > > 
> > > > 	if (page_count(page) == 1) {
> > > > 		lock_page(page);
> > > > 		return 0;
> > > > 	}
> > > > 
> > > > 	return 1;
> > > > }
> > > > 
> > > > 
> > > > afacit that `if page_count(page)' test could be replaced by
> > > > `if today_is_tuesday()'.  But then I don't have the foggiest idea
> > > > what it's trying to do.
> > > > 
> > > > It would be nice to get some comments in and around here.
> > > > 
> > > > Also, I was trying to work out the role and responsibility of the ->pin
> > > > callback, and gave up.
> > > > 
> > > > There isn't a lot of point in explaining this over email - one should be
> > > > able to gain an understanding of these things by reading the code.  I think
> > > > the best way of tackling this would be to comprehensively document
> > > > pipe_buf_operations and pipe_inode_info, please...
> > > 
> > > OK so I wont explain it in detail here, I'll write up a good set of
> > > comments tonight.
> > 
> > I'll merge this into the #splice branch.
> 
> Great, thanks.
> 
> > +/**
> > + * generic_pipe_buf_steal - attempt to take ownership of a @pipe_buffer
> > + * @pipe:	the pipe that the buffer belongs to
> > + * @buf:	the buffer to attempt to steal
> > + *
> > + * Description:
> > + *	This function attempts to steal the @struct page attached to
> > + *	@buf. If successful, this function returns 0 and returns with
> > + *	the page locked. The caller may then reuse the page for whatever
> > + *	he wishes, the typical use is insertion into a different file
> > + *	page cache.
> > + */
> >  int generic_pipe_buf_steal(struct pipe_inode_info *pipe,
> >  			   struct pipe_buffer *buf)
> >  {
> >  	struct page *page = buf->page;
> >  
> > +	/*
> > +	 * A reference of one is golden, that means that the owner of this
> > +	 * page is the only one holding a reference to it. lock the page
> > +	 * and return OK.
> > +	 */
> >  	if (page_count(page) == 1) {
> >  		lock_page(page);
> >  		return 0;
> 
> I still don't get this code.  I guess I should have asked for pipe_buffer
> docs too ;)

I just love commenting stuff, so I'll treat you to a pipe_buffer
commentary as well :-)

> What sorts of pages can find themselves inside a pipe_buffer, and which of
> these types of pages is the above test detecting?

Any type of page, really. But for generic_pipe_buf_steal(), it's a page
allocated through alloc_page(). The ops must match the buf contents
(hence it's placed in the pipe_buffer, not the pipe itself). So if you
shoving different pages in there, then your steal function (and others)
must reflect that.

-- 
Jens Axboe

