Return-Path: <linux-kernel-owner+w=401wt.eu-S1758603AbXGXEsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603AbXGXEsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 00:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbXGXEsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 00:48:39 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:33645 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752190AbXGXEsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 00:48:38 -0400
Message-ID: <385252508.22609@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 24 Jul 2007 12:37:08 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 03/10] readahead: combine file_ra_state.prev_index/prev_offset into prev_pos
Message-ID: <20070724043708.GA6627@mail.ustc.edu.cn>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
References: <20070724020009.677809022@mail.ustc.edu.cn> <385243122.57859@ustc.edu.cn> <20070723205535.d08338fc.akpm@linux-foundation.org> <20070724043215.GA6317@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724043215.GA6317@mail.ustc.edu.cn>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 12:32:15PM +0800, Fengguang Wu wrote:
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

I wrote a test case and find that if pgoff_t is 'signed long',
"<= 1U" still yields the wrong result. Only "<= 1UL" does the trick :(

