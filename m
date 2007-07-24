Return-Path: <linux-kernel-owner+w=401wt.eu-S1759779AbXGXEy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759779AbXGXEy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 00:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbXGXEyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 00:54:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44481 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752514AbXGXEyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 00:54:18 -0400
Date: Mon, 23 Jul 2007 21:53:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 03/10] readahead: combine
 file_ra_state.prev_index/prev_offset into prev_pos
Message-Id: <20070723215310.0a032635.akpm@linux-foundation.org>
In-Reply-To: <385252215.04204@ustc.edu.cn>
References: <20070724020009.677809022@mail.ustc.edu.cn>
	<385243122.57859@ustc.edu.cn>
	<20070723205535.d08338fc.akpm@linux-foundation.org>
	<385252215.04204@ustc.edu.cn>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007 12:32:15 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:

> On Mon, Jul 23, 2007 at 08:55:35PM -0700, Andrew Morton wrote:
> > On Tue, 24 Jul 2007 10:00:12 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> > 
> > > @@ -342,11 +342,9 @@ ondemand_readahead(struct address_space 
> > >  		   bool hit_readahead_marker, pgoff_t offset,
> > >  		   unsigned long req_size)
> > >  {
> > > -	int max;	/* max readahead pages */
> > > -	int sequential;
> > > -
> > > -	max = ra->ra_pages;
> > > -	sequential = (offset - ra->prev_index <= 1UL) || (req_size > max);
> > > +	int	max = ra->ra_pages;	/* max readahead pages */
> > > +	pgoff_t prev_offset;
> > > +	int	sequential;
> > >  
> > >  	/*
> > >  	 * It's the expected callback offset, assume sequential access.
> > > @@ -360,6 +358,9 @@ ondemand_readahead(struct address_space 
> > >  		goto readit;
> > >  	}
> > >  
> > > +	prev_offset = ra->prev_pos >> PAGE_CACHE_SHIFT;
> > > +	sequential = offset - prev_offset <= 1UL || req_size > max;
> > 
> > It's a bit pointless using an opaque type for prev_offset here, and then
> > encoding the knowledge that it is implemented as "unsigned long".
> > 
> > It's a minor thing, but perhaps just "<= 1" would make more sense here.
> 
> Yeah, "<= 1" is OK.  But the expression still requires pgoff_t to be
> 'unsigned' to work correctly.
> 
> So what about "<= 1U"?

umm, if one really cared one could do

	<expr> == 1 || <expr> == 0

or something.  But whatever - let's leave it as-is.
