Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbZBSMHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbZBSMHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 07:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757605AbZBSMHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 07:07:16 -0500
Received: from ozlabs.org ([203.10.76.45]:54440 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757237AbZBSMHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 07:07:15 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 09/10] percpu: implement new dynamic percpu allocator
Date: Thu, 19 Feb 2009 22:37:09 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <1234958676-27618-10-git-send-email-tj@kernel.org> <20090219021015.aac6ea43.akpm@linux-foundation.org>
In-Reply-To: <20090219021015.aac6ea43.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902192237.10080.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 February 2009 20:40:15 Andrew Morton wrote:
> afacit nobody has answered your "is num_possible_cpus() ever a lot
> larger than num_online_cpus()" question.
> 
> It is fairly important.

Hi Andrew,

  It can be: suspend a giant machine; goes down to 1 cpu.

But I don't think there's much point worrying about a potentially-giant-
but-actually-tiny machine.  Noone else has, so we wait until someone actually
creates such a thing, then they can fix this, as well as all the others.

(The only place I can see that this makes sense is in the virtualization space
when you might be on a 4096 CPU host, so all guests might want the capability
to expand to fill the machine.)

> > +	struct page		*page[];	/* #cpus * UNIT_PAGES */
> 
> "pages" ;)

Heh, disagree: users are clearer if it's page :)

> > +static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
> > +{
> > +	const gfp_t alloc_mask = GFP_KERNEL | __GFP_HIGHMEM | __GFP_COLD;
> 
> A designed decision has been made to not permit the caller to specify
> the allocation mode?
> 
> Usually a mistake.  Probably appropriate in this case.  Should be
> mentioned up-front and discussed a bit.

Yes, it derives from alloc_percpu which (1) zeroes, and (2) can sleep.

I chose this way-back-when because I didn't want to require atomic allocs
when it was implemented properly, and I couldn't think of a single sane use
case, so I'd rather that pioneer be the one to add the flags.

> > +	if (unlikely(!size))
> > +		return NULL;
> 
> hm.  Why do we do this?  Perhaps emitting this warning:

Yes, I prefer size++ myself, maybe with a warn_on until someone uses it.



> > +void free_percpu(void *ptr)
> > +{
> > +	void *addr = __pcpu_ptr_to_addr(ptr);
> > +	struct pcpu_chunk *chunk;
> > +	int off;
> > +
> > +	if (!ptr)
> > +		return;
> 
> Do we ever do this?  Should it be permitted?  Should we warn?

I want to.  Yes.  No.

Any generic free function should take NULL; it's a bug otherwise, and just
makes for gratuitous over-cautious branches in callers when we equivocate.

BTW Andrew, this was an excellent example of how to review kernel code.

Thanks,
Rusty.
