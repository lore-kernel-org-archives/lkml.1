Return-Path: <linux-kernel-owner+w=401wt.eu-S1760408AbZAWGOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760408AbZAWGOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbZAWGON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:14:13 -0500
Received: from ns.suse.de ([195.135.220.2]:54103 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbZAWGOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:14:12 -0500
Date: Fri, 23 Jan 2009 07:14:06 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [patch] SLQB slab allocator
Message-ID: <20090123061405.GK20098@wotan.suse.de>
References: <20090121143008.GV24891@wotan.suse.de> <20090121145918.GA11311@elte.hu> <20090121165600.GA16695@wotan.suse.de> <20090121174010.GA2998@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090121174010.GA2998@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 06:40:10PM +0100, Ingo Molnar wrote:
> -static inline void slqb_stat_inc(struct kmem_cache_list *list,
> -				enum stat_item si)
> +static inline void
> +slqb_stat_inc(struct kmem_cache_list *list, enum stat_item si)
>  {

Hmm, I'm not entirely fond of this style. The former scales to longer lines
with just a single style change (putting args into new lines), wheras the
latter first moves its prefixes to a newline, then moves args as the
line grows even longer.

I guess it is a matter of taste, not wrong either way... but I think most
of the mm code I'm used to looking at uses the former. Do you feel strongly?


> +static void
> +trace(struct kmem_cache *s, struct slqb_page *page, void *object, int alloc)
>  {
> -	if (s->flags & SLAB_TRACE) {
> -		printk(KERN_INFO "TRACE %s %s 0x%p inuse=%d fp=0x%p\n",
> -			s->name,
> -			alloc ? "alloc" : "free",
> -			object, page->inuse,
> -			page->freelist);
> +	if (likely(!(s->flags & SLAB_TRACE)))
> +		return;

I think most of your flow control changes are improvements (others even
more than this, but this is the first one so I comment here). Thanks.


> @@ -1389,7 +1402,9 @@ static noinline void *__remote_slab_allo
>  	}
>  	if (likely(object))
>  		slqb_stat_inc(l, ALLOC);
> +
>  	spin_unlock(&n->list_lock);
> +
>  	return object;
>  }
>  #endif

Whitespace, I never really know if I'm "doing it right" or not :) And
often it is easy to tell a badly wrong one, but harder to tell what is
better between two reasonable ones. But I guess I'm the same way with
paragraphs in my writing...


> @@ -1399,12 +1414,12 @@ static noinline void *__remote_slab_allo
>   *
>   * Must be called with interrupts disabled.
>   */
> -static __always_inline void *__slab_alloc(struct kmem_cache *s,
> -				gfp_t gfpflags, int node)
> +static __always_inline void *
> +__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node)
>  {
> -	void *object;
> -	struct kmem_cache_cpu *c;
>  	struct kmem_cache_list *l;
> +	struct kmem_cache_cpu *c;
> +	void *object;

Same with order of local variables. You like longest lines to
shortest I know. I think I vaguely try to arrange them from the
most important or high level "actor" to the least, and then in
order of when they get discovered/used.

For example, in the above function, "object" is the raison d'etre.
kmem_cache_cpu is found first, and from that, kmem_cache_list is
found. Which slightly explains the order.


> +static __always_inline void *
> +slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node, void *addr)
>  {
> -	void *object;
>  	unsigned long flags;
> +	void *object;

And here, eg. flags comes last because mostly inconsequential to
the bigger picture.

Your method is easier though, I'll grant you that :)


>  static void init_kmem_cache_list(struct kmem_cache *s,
>  				struct kmem_cache_list *l)
>  {
> -	l->cache		= s;
> -	l->freelist.nr		= 0;
> -	l->freelist.head	= NULL;
> -	l->freelist.tail	= NULL;
> -	l->nr_partial		= 0;
> -	l->nr_slabs		= 0;
> +	l->cache		 = s;
> +	l->freelist.nr		 = 0;
> +	l->freelist.head	 = NULL;
> +	l->freelist.tail	 = NULL;
> +	l->nr_partial		 = 0;
> +	l->nr_slabs		 = 0;
>  	INIT_LIST_HEAD(&l->partial);

Hmm, we seem to have gathered an extra space...

>  
>  #ifdef CONFIG_SMP
> -	l->remote_free_check	= 0;
> +	l->remote_free_check	 = 0;
>  	spin_lock_init(&l->remote_free.lock);
> -	l->remote_free.list.nr	= 0;
> +	l->remote_free.list.nr	 = 0;
>  	l->remote_free.list.head = NULL;
>  	l->remote_free.list.tail = NULL;
>  #endif

... ah, to line up with this guy. TBH, I prefer not to religiously
line things up like this. If there is the odd long-line, just give
it the normal single space. I find it just keeps it easier to
maintain. Although you might counter that of course it is easier to
keep something clean if one relaxes their definition of "clean".


>  static s8 size_index[24] __cacheline_aligned = {
> -	3,	/* 8 */
> -	4,	/* 16 */
> -	5,	/* 24 */
> -	5,	/* 32 */
> -	6,	/* 40 */
> -	6,	/* 48 */
> -	6,	/* 56 */
> -	6,	/* 64 */
> +	 3,	/* 8 */
> +	 4,	/* 16 */
> +	 5,	/* 24 */
> +	 5,	/* 32 */
> +	 6,	/* 40 */
> +	 6,	/* 48 */
> +	 6,	/* 56 */
> +	 6,	/* 64 */

However justifying numbers, like this, I'm happy to do (may as well
align the numbers in the comments too while we're here).


> @@ -2278,9 +2294,8 @@ static struct kmem_cache *get_slab(size_
>  
>  void *__kmalloc(size_t size, gfp_t flags)
>  {
> -	struct kmem_cache *s;
> +	struct kmem_cache *s = get_slab(size, flags);
>  
> -	s = get_slab(size, flags);
>  	if (unlikely(ZERO_OR_NULL_PTR(s)))
>  		return s;

I've got yet the same problem with these... I mostly try to avoid
doing this, although there are some cases where it works well
(eg. constants, or a simple assignment of an argument to a local).

At some point, you start putting real code in there, at which point
the space after the local vars doesn't seem to serve much purpose.
get_slab I feel logically belongs close to the subsequent check,
because that's basically sanitizing its return value / extracting
the error case from it and leaving the rest of the function to work
on the common case.


> -static int sysfs_available __read_mostly = 0;
> +static int sysfs_available __read_mostly;

These, I actually like initializing to zero explicitly. I'm pretty
sure gcc no longer makes it any more expensive than leaving out.
Yes of course everybody who knows C has to know this, but.... I
just don't feel much harm in leaving it.

Lots of good stuff, lots I'm on the fence with, some I dislike ;)
I'll concentrate on picking up the obvious ones, and get the bugs
fixed. Will see where the discussion goes with the rest.

Thanks,
Nick
