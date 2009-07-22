Return-Path: <linux-kernel-owner+w=401wt.eu-S1751331AbZGVEf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbZGVEf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 00:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbZGVEf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 00:35:57 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:44456 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbZGVEf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 00:35:56 -0400
Subject: Re: [RFCv2][PATCH] flexible array implementation
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       bblum@google.com, linux-kernel@vger.kernel.org, menage@google.com,
       vda.linux@googlemail.com, mikew@google.com
In-Reply-To: <4A66868F.4010001@cn.fujitsu.com>
References: <20090721220017.60A219D3@kernel>
	 <4A66868F.4010001@cn.fujitsu.com>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 21:34:52 -0700
Message-Id: <1248237292.24021.2.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 11:25 +0800, Li Zefan wrote:
> > +/**
> > + * flex_array_put - copy data into the array at @element_nr
> > + * @src:	address of data to copy into the array
> > + * @element_nr:	index of the position in which to insert
> > + * 		the new element.
> 
> @fa and @flags are not documented.

True...  But one of my pet peeves are kerneldocs like this:

	@fa: the flex array
	@flags: GFP flags

It's so trivially obvious from looking at the types and the variable
names that I'm not sure it's worth the cost of the lines.  

> > + *
> > + * Note that this *copies* the contents of @src into
> > + * the array.  If you are trying to store an array of
> > + * pointers, make sure to pass in &ptr instead of ptr.
> > + *
> > + * Locking must be provided by the caller.
> > + */
> > +int flex_array_put(struct flex_array *fa, int element_nr, void *src, gfp_t flags)
> > +{
> > +	int part_nr = fa_element_to_part_nr(fa, element_nr);
> > +	struct flex_array_part *part;
> > +	void *dst;
> > +
> > +	part = __fa_get_part(fa, part_nr, flags);
> > +	if (!part)
> > +		return -ENOMEM;
> 
> So this may allocate memory, and has disavantages:
> 
> - If flex_array_put() is called in atomic context, flags has to be GFP_ATOMIC.
> - and thus it may fail.
> 
> Since we pass the total_elem to flex_array_alloc(), how about add a flag,
> and if the flag is set, the alloc() will also allocate all fa_parts?
> 
> And add __flex_array_put(), which assumes fa_parts has been allocated.

How about flex_array_prealloc()?  It seems to work for all the radix
tree users.

-- Dave

