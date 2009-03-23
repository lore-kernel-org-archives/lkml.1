Return-Path: <linux-kernel-owner+w=401wt.eu-S1759369AbZCWQAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbZCWQAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbZCWQAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:00:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55536 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876AbZCWQAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:00:06 -0400
Date: Mon, 23 Mar 2009 16:59:38 +0100
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
Message-ID: <20090323155938.GA27151@elte.hu>
References: <49AD3433.9000001@cn.fujitsu.com> <1237794502.6313.21.camel@penberg-laptop> <alpine.DEB.1.10.0903230931570.4095@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903230931570.4095@qirst.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux-foundation.org> wrote:

> On Mon, 23 Mar 2009, Pekka Enberg wrote:
> 
> > > +static inline void *portion_to_obj(void *portion)
> > > +{
> > > +	struct page *page = virt_to_head_page(portion);
> > > +	struct slab *slab = page_get_slab(page);
> > > +	struct kmem_cache *cache = page_get_cache(page);
> > > +	unsigned int offset = portion - slab->s_mem;
> > > +	unsigned int index = offset / cache->buffer_size;
> > > +
> > > +	return index_to_obj(cache, slab, index);
> > > +}
> >
> > A minor nit: I think this would be more readable if you separated
> > variable declarations from the initializations. Also, you can probably
> > drop the inline from the function declaration and let GCC decide what to
> > do.
> 
> Thats debatable. I find the setting up a number of variables that 
> are all dependend in the above manner very readable. They are 
> usually repetitive. Multiple functions use similar 
> initializations.

I agree with Pekka, it's clearly more readable when separated out 
nicely:

	struct kmem_cache *cache;
	unsigned int offset;
	unsigned int index;
	struct page *page;
	struct slab *slab;

	page	= virt_to_head_page(portion);
	slab	= page_get_slab(page);
	cache	= page_get_cache(page);

	offset	= portion - slab->s_mem;
	index	= offset / cache->buffer_size;

The original form is hard to read due to lack of structure.

	Ingo
