Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbZGURWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbZGURWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 13:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbZGURWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 13:22:33 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57060 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104AbZGURWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 13:22:33 -0400
Subject: Re: [RFC][PATCH] flexible array implementation
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mike Waychison <mikew@google.com>
Cc: akpm@linux-foundation.org, menage@google.com,
       containers@lists.linux-foundation.org, bblum@google.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <4A65F13D.6060506@google.com>
References: <20090721160333.96AA4D3D@kernel>  <4A65F13D.6060506@google.com>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 10:22:30 -0700
Message-Id: <1248196950.13249.5515.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 12:47 -0400, Mike Waychison wrote:
> > +/*
> > + * This is meant to replace cases where an array-like
> > + * structure has gotten to big to fit into kmalloc()
> 
> s/to/too/g

Gah, thanks.

> > + * and the developer is getting tempted to use
> > + * vmalloc().
> > + */
> > +
> > +struct flex_array {
> > +	union {
> > +		struct {
> > +			int nr_elements;
> > +			int element_size;
> > +			struct flex_array_part *parts[0];
> > +		};
> > +		/*
> > +		 * This little trick makes sure that
> > +		 * sizeof(flex_array) == PAGE_SIZE
> > +		 */
> > +		char padding[FLEX_ARRAY_BASE_SIZE];
> > +	};
> > +};
> > +
> > +struct flex_array *alloc_flex_array(int element_size, int total, gfp_t flags);
> > +void free_flex_array(struct flex_array *fa);
> > +int flex_array_put(struct flex_array *fa, void *src, gfp_t flags);
> > +void *flex_array_get(struct flex_array *fa, int element_nr);
> 
> Would a single routine that acted like an lvalue be a bit clearer?  Here 
> it looks like the interface is a push to write, but random access to 
> read.  Something like:
> 
> void **__flex_array_idx(struct flex_rray *fa, int element_nr);
> #define flex_array_idx(fa, element_nr) (*__flex_array_idx(fa, element_nr))
> 
> may be a bit easier to read so users of the interface could just do:
> 
> flex_array_idx(fa, n) = pointer;
> pointer = flex_array_idx(fa, n);
> 
> I guess this would require that flex_array only store actual pointers 
> though, instead of objects.  Hmm.

Yeah, possibly.  

I was hoping I'd get some suggestions for places in the kernel that
could use this.  I'll see if another interface looks better once I get
some users. :)

> Is there any reason you defer allocation of parts to flex_array_put() 
> given that alloc_flex_array() is told the total number of elements?

Yeah, I guess it's just in the hope that it won't all get filled.  I
think I also started with it not being passed the total size.  But, I
figured later on that it was better to fail as early as possible rather
than screwing the user later on when we fill up. 

> > +struct flex_array_part {
> > +	char elements[FLEX_ARRAY_PART_SIZE];
> > +};
> > +
> > +static inline int __elements_per_part(int element_size)
> > +{
> > +	return FLEX_ARRAY_PART_SIZE / element_size;
> 
> Micro-optimization, but perhaps the general case could use a bit shift 
> stored inside the flex_array?  That way we could avoid excessive divide 
> operations.

Possibly, but that of course precludes having objects with
non-power-of-two sizes being packed very well.  It's certainly worth
thinking about.

> > +void *flex_array_get(struct flex_array *fa, int element_nr)
> > +{
> > +	int part_nr = fa_element_to_part_nr(fa, element_nr);
> > +	struct flex_array_part *part;
> > +	int offset;
> > +
> > +	if (part_nr > __nr_part_ptrs())
> 
> if (part_nr >= __nr_part_ptrs())

Yep.  Good catch.

> > +		return NULL;
> 
> ERR_PTR(-EINVAL) ?

I guess this helps users differentiate bad arguments from memory
allocation failures.  But, I'd rather not make users check ERR_PTR()
just because I want to keep it simple.  

> Would it make sense to WARN here?  A more precise test could be to 
> compare element_nr vs fa->nr_elements?

My immediate goal here was just to avoid oopses and overflows.  You're
right that fa->nr_elements would be more precise.  But, I guess if you
overflow an array you get an oops, so why should this be any different?
A WARN() is potentially noisy, but way less noisy than an oops.  

Thanks for the feedback!

-- Dave

