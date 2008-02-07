Return-Path: <linux-kernel-owner+w=401wt.eu-S933324AbYBGUMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324AbYBGUMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933493AbYBGUG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:06:28 -0500
Received: from brick.kernel.dk ([87.55.233.238]:18747 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933485AbYBGUG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:06:26 -0500
Date: Thu, 7 Feb 2008 21:06:22 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan.Brunelle@hp.com,
       arjan@linux.intel.com, dgc@sgi.com, npiggin@suse.de,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@gmail.com>
Subject: Re: [patch] block layer: kmemcheck fixes
Message-ID: <20080207200622.GP15220@kernel.dk>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com> <1202375945-29525-5-git-send-email-jens.axboe@oracle.com> <20080207100738.GB7716@elte.hu> <20080207101727.GE15220@kernel.dk> <20080207102534.GB16735@elte.hu> <20080207103136.GG15220@kernel.dk> <20080207104901.GF16735@elte.hu> <alpine.LFD.1.00.0802070940230.2883@woody.linux-foundation.org> <20080207193140.GA19949@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207193140.GA19949@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07 2008, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Thu, 7 Feb 2008, Ingo Molnar wrote:
> > >  	INIT_HLIST_NODE(&rq->hash);
> > >  	RB_CLEAR_NODE(&rq->rb_node);
> > > -	rq->ioprio = 0;
> > > -	rq->buffer = NULL;
> > > -	rq->ref_count = 1;
> > > -	rq->q = q;
> > > -	rq->special = NULL;
> > > -	rq->data_len = 0;
> > > -	rq->data = NULL;
> > > -	rq->nr_phys_segments = 0;
> > > -	rq->sense = NULL;
> > > -	rq->end_io = NULL;
> > > -	rq->end_io_data = NULL;
> > > -	rq->completion_data = NULL;
> > > -	rq->next_rq = NULL;
> > > +	rq->completion_data		= NULL;
> > > +	/* rq->elevator_private			*/
> > > +	/* rq->elevator_private2		*/
> > > +	/* rq->rq_disk				*/
> > > +	/* rq->start_time			*/
> > > +	rq->nr_phys_segments		= 0;
> > > +	/* rq->nr_hw_segments			*/
> > > +	rq->ioprio			= 0;
> > > +	rq->special			= NULL;
> > > +	rq->buffer			= NULL;
> > ...
> > 
> > Can we please just stop doing these one-by-one assignments, and just do 
> > something like
> > 
> > 	memset(rq, 0, sizeof(*rq));
> > 	rq->q = q;
> > 	rq->ref_count = 1;
> > 	INIT_HLIST_NODE(&rq->hash);
> > 	RB_CLEAR_NODE(&rq->rb_node);
> > 
> > instead?
> > 
> > The memset() is likely faster and smaller than one-by-one assignments 
> > anyway, even if the one-by-ones can avoid initializing some field or 
> > there ends up being a double initialization..
> 
> i definitely agree and do that for all code i write.
> 
> But if someone does item by item initialization for some crazy 
> performance reason (networking folks tend to have such constructs), it 
> should be done i think how i've done it in the patch: by systematically 
> listing _every_ field in the structure, in the same order, and 
> indicating it clearly when it is not initialized and why.

That assumes that people find the references in two places when adding
members to a structure, not very likely (people are lazy!).

> and there it already shows that we do not initialize a few other members 
> that could cause problems later on:
> 
> +       rq->data_len                    = 0;
> +       /* rq->sense_len                        */
> +       rq->data                        = NULL;
> +       rq->sense                       = NULL;
> 
> why is sense_len not initialized - while data_len is? In any case, these 

because sense isn't set, when someone sets ->sense they should set
sense_len as well.

> days the memclear instructions are dirt cheap and we should just always 
> initialize everything to zero by default, especially if it's almost all 
> zero-initialized anyway.

Completely agree, some of these are just dormant bugs waiting to happen.
Clearing everything is the sanest approach.

-- 
Jens Axboe

