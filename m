Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbZCWQ5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbZCWQ5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758205AbZCWQ5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:57:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52866 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757703AbZCWQ5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:57:00 -0400
Date: Mon, 23 Mar 2009 17:56:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/6] slab: introduce __kfree_rcu
Message-ID: <20090323165639.GA6841@elte.hu>
References: <49AD3433.9000001@cn.fujitsu.com> <1237794502.6313.21.camel@penberg-laptop> <alpine.DEB.1.10.0903230931570.4095@qirst.com> <20090323155938.GA27151@elte.hu> <alpine.DEB.1.10.0903231234110.11796@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903231234110.11796@qirst.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux-foundation.org> wrote:

> On Mon, 23 Mar 2009, Ingo Molnar wrote:
> 
> >
> > * Christoph Lameter <cl@linux-foundation.org> wrote:
> >
> > > On Mon, 23 Mar 2009, Pekka Enberg wrote:
> > >
> > > > > +static inline void *portion_to_obj(void *portion)
> > > > > +{
> > > > > +	struct page *page = virt_to_head_page(portion);
> > > > > +	struct slab *slab = page_get_slab(page);
> > > > > +	struct kmem_cache *cache = page_get_cache(page);
> > > > > +	unsigned int offset = portion - slab->s_mem;
> > > > > +	unsigned int index = offset / cache->buffer_size;
> > > > > +
> > > > > +	return index_to_obj(cache, slab, index);
> > > > > +}
> > > >
> > > > A minor nit: I think this would be more readable if you separated
> > > > variable declarations from the initializations. Also, you can probably
> > > > drop the inline from the function declaration and let GCC decide what to
> > > > do.
> > >
> > > Thats debatable. I find the setting up a number of variables that
> > > are all dependend in the above manner very readable. They are
> > > usually repetitive. Multiple functions use similar
> > > initializations.
> >
> > I agree with Pekka, it's clearly more readable when separated out
> > nicely:
> >
> > 	struct kmem_cache *cache;
> > 	unsigned int offset;
> > 	unsigned int index;
> > 	struct page *page;
> > 	struct slab *slab;
> >
> > 	page	= virt_to_head_page(portion);
> > 	slab	= page_get_slab(page);
> > 	cache	= page_get_cache(page);
> >
> > 	offset	= portion - slab->s_mem;
> > 	index	= offset / cache->buffer_size;
> >
> > The original form is hard to read due to lack of structure.
> 
> Structure can also be established differently:
> 
> static inline void *portion_to_obj(void *portion)
> {
> 	struct page *page = virt_to_head_page(portion);
> 	struct slab *slab = page_get_slab(page);
> 	struct kmem_cache *cache = page_get_cache(page);
> 
> 	unsigned int offset = portion - slab->s_mem;
> 	unsigned int index = offset / cache->buffer_size;
> 
> 	return index_to_obj(cache, slab, index);

It's still not as readable to me as the version i posted above and 
confusing as well, due to the newline in the middle of local 
variable definitions.

> It would be good if the whole series of actions that need to be 
> taken in order for the function to "get to know" the slab the 
> object parms would be simpler. Like its done in ruby
> 
> 	(page, slab, cache) = get_slab_info(portion)
> 
> 	(offset, index) = get_position_info(slab, portion)
> 
> But how can this be done in C without weird pointer passing?

The version i posted is pretty compact visually. The actual type 
enumeration is repetitive and it's often a meaningless pattern.

What matters is this sequence of symbols:

> > 	page	= virt_to_head_page(portion);
> > 	slab	= page_get_slab(page);
> > 	cache	= page_get_cache(page);
> >
> > 	offset	= portion - slab->s_mem;
> > 	index	= offset / cache->buffer_size;

... and anyone versed in slab internals will know the type of these 
variables without having to look them up. (using variable names 
consistently through a full subsystem is important for this reason)
 
Pairing them up with their base types just obscures the real logic.

That is one reason why i generally use the 'reverse christmas tree' 
type of local variable definition blocks:

> > 	struct kmem_cache *cache;
> > 	unsigned int offset;
> > 	unsigned int index;
> > 	struct page *page;
> > 	struct slab *slab;

As the trained eye will just want to skip over this as irrelevant 
fluff and the shape makes this the easiest (the less complex a shape 
is geometrically, the less 'eye skipping overhead' there is).

Anyway, these are nuances and if you go strictly by what's minimally 
required by Documentation/CodingStyle you can stop a lot sooner than 
having to bother about such fine details. The original version was 
certainly acceptable - it's just that IMO Pekka was right that it 
can be done better.

	Ingo
