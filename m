Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbZD1WsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbZD1WsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 18:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbZD1Wrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 18:47:48 -0400
Received: from waste.org ([66.93.16.53]:41373 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbZD1Wrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 18:47:47 -0400
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com, andi@firstfloor.org,
       adobriyan@gmail.com, linux-mm@kvack.org
In-Reply-To: <20090428143244.4e424d36.akpm@linux-foundation.org>
References: <20090428010907.912554629@intel.com>
	 <20090428014920.769723618@intel.com>
	 <20090428143244.4e424d36.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 17:46:34 -0500
Message-Id: <1240958794.938.1045.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 14:32 -0700, Andrew Morton wrote:

> > +#define kpf_copy_bit(uflags, kflags, visible, ubit, kbit)		\
> > +	do {								\
> > +		if (visible || genuine_linus())				\
> > +			uflags |= ((kflags >> kbit) & 1) << ubit;	\
> > +	} while (0);
> 
> Did this have to be implemented as a macro?

I'm mostly to blame for that. I seem to recall the optimizer doing a
better job on this as a macro.

> It's bad, because it might or might not reference its argument, so if
> someone passes it an expression-with-side-effects, the end result is
> unpredictable.  A C function is almost always preferable if possible.

I don't think there's any use case for it outside of its one user?

> > +/* a helper function _not_ intended for more general uses */
> > +static inline int page_cap_writeback_dirty(struct page *page)
> > +{
> > +	struct address_space *mapping;
> > +
> > +	if (!PageSlab(page))
> > +		mapping = page_mapping(page);
> > +	else
> > +		mapping = NULL;
> > +
> > +	return mapping && mapping_cap_writeback_dirty(mapping);
> > +}
> 
> If the page isn't locked then page->mapping can be concurrently removed
> and freed.  This actually happened to me in real-life testing several
> years ago.

We certainly don't want to be taking locks per page to build the flags
data here. As we don't have any pretense of being atomic, it's ok if we
can find a way to do the test that's inaccurate when a race occurs, so
long as it doesn't dereference null.

But if there's not an obvious way to do that, we should probably just
drop this flag bit for this iteration.

-- 
http://selenic.com : development and support for Mercurial and Linux


