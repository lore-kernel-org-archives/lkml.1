Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbXFLMHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbXFLMHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 08:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbXFLMHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 08:07:20 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:54142 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754312AbXFLMHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 08:07:18 -0400
Message-ID: <381650021.10920@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 12 Jun 2007 20:07:06 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Jens Axboe <jens.axboe@oracle.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Pratt <slpratt@austin.ibm.com>,
       Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH 4/9] readahead: data structure and routines
Message-ID: <20070612120706.GB9624@mail.ustc.edu.cn>
Mail-Followup-To: Rusty Russell <rusty@rustcorp.com.au>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	Andi Kleen <andi@firstfloor.org>,
	Jens Axboe <jens.axboe@oracle.com>, Oleg Nesterov <oleg@tv-sign.ru>,
	Steven Pratt <slpratt@austin.ibm.com>,
	Ram Pai <linuxram@us.ibm.com>
References: <20070516224752.500812933@mail.ustc.edu.cn> <20070516224818.683288460@mail.ustc.edu.cn> <1181619050.6237.23.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181619050.6237.23.camel@localhost.localdomain>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Tue, Jun 12, 2007 at 01:30:50PM +1000, Rusty Russell wrote:
> On Thu, 2007-05-17 at 06:47 +0800, Fengguang Wu wrote: 
> > /*
> >   * Track a single file's readahead state
> > + *
> > + *  ================#============|==================#==================|
> > + *                  ^            ^                  ^                  ^
> > + *  file_ra_state.la_index    .ra_index   .lookahead_index   .readahead_index
> >   */
> >  struct file_ra_state {
> >  	unsigned long start;		/* Current window */
> > @@ -711,6 +715,12 @@ struct file_ra_state {
> >  	unsigned long prev_index;	/* Cache last read() position */
> >  	unsigned long ahead_start;	/* Ahead window */
> >  	unsigned long ahead_size;
> > +
> > +	pgoff_t la_index;               /* enqueue time */
> > +	pgoff_t ra_index;               /* begin offset */
> > +	pgoff_t lookahead_index;        /* time to do next readahead */
> > +	pgoff_t readahead_index;        /* end offset */
> > +
> 
> I found these variables a little confusing.  la_index is the last offset
> passed to ondemand_readahead, so perhaps "last_request_start" is a
> better name?  The comment "enqueue time" seems strange, too.

Yes, they are a bit confusing. Sorry for the bad naming and comments!

The precise meanings can be:
la_index - the time (where we are reading) when the readahead window is established
ra_index - where the readahead window starts
lookahead_index - the time (on reading of which) to push forward the readahead window
readahead_index - where the readahead window ends, or
                  where the next readahead should start with

In normal case, when the readahead window is pushed forward, the
following holds:
                la_index = lookahead_index; lookahead_index = new-value;
                ra_index = readahead_index; readahead_index = new-value;

> ra_index seems ok, although "readahead_start" might be better.  Perhaps
> readahead_index should be expressed as readahead_size, which is how it
> seems to be used.  Perhaps "lookahead_index" is best expressed as a
> buffer at the end of the readahead zone (readahead_min?).
> 
> ie:
> 	pgoff_t last_request_start;     /* start of req which triggered readahead */
> 	pgoff_t readahead_start;        /* Where readahead started */
> 	pgoff_t readahead_size;         /* PAGE_CACHE_SIZE units of readahead */
> 	pgoff_t readahead_min;          /* readahead_size left before we recalc */
> 
> This gets rid of many of the accessors, I think, and avoids introducing
> a new term to understand (lookahead).

Both indexes and sizes will be used in the code. So calculates may
always be necessary somewhere. If there's a good naming scheme, either
form(index/size based) is OK to me :)

In fact, there are two kind of windows and one buffer:

                    |---------- readahead window ----------->|                                                          
    ===#============|==================#=====================|                                                          
       |--- reader walking window ---->|--- async buffer --->|        

'lookahead' is not a standard term, while 'readahead_min' may be
confusing for some people?  Anyway, I'd like to propose two more
possible schemes:

	pgoff_t ahead_start;     /* readahead window */
        pgoff_t ahead_end;
	pgoff_t reader_start;    /* on read of which the ahead window was established */
	pgoff_t reader_end;      /* on read of which the ahead window will be pushed forward */

or preferably:

	pgoff_t start;                 /* where readahead started */
        unsigned long size;            /* # of readahead pages */
	unsigned long async_size;      /* do asynchronous readahead when there are only # of pages ahead */

	unsigned long async_size_old;  /* TODO: this one is not needed for now */

Any opinions? Thanks.

> > +/*
> > + * Where is the old read-ahead and look-ahead?
> > + */
> > +static inline void ra_set_index(struct file_ra_state *ra,
> > +				pgoff_t la_index, pgoff_t ra_index)
> > +{
> > +	ra->la_index = la_index;
> > +	ra->ra_index = ra_index;
> > +}
> > +
> > +/*
> > + * Where is the new read-ahead and look-ahead?
> > + */
> > +static inline void ra_set_size(struct file_ra_state *ra,
> > +				unsigned long ra_size, unsigned long la_size)
> > +{
> > +	ra->readahead_index = ra->ra_index + ra_size;
> > +	ra->lookahead_index = ra->ra_index + ra_size - la_size;
> > +}
> 
> These are only called in one place, so I think it's clearer to do this
> there directly.  But I see you exported ra_submit, too, even though it's
> only used in the same file.  Are there plans for other users?

Yes, if we are to re-introduce the adaptive readahead, the functions
will be reused.

Thank you,
Fengguang

