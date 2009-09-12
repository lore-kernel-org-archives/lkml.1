Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbZILOmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbZILOmH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 10:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbZILOmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 10:42:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:19070 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465AbZILOmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 10:42:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,376,1249282800"; 
   d="scan'208";a="186913297"
Date: Sat, 12 Sep 2009 22:41:57 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "mtosatti@redhat.com" <mtosatti@redhat.com>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
       "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
       "avi@qumranet.com" <avi@qumranet.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] devmem: introduce size_inside_page()
Message-ID: <20090912144157.GB6511@localhost>
References: <20090911022333.324128054@intel.com> <20090911023200.649862599@intel.com> <20090911165543.d2485e0e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911165543.d2485e0e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12, 2009 at 07:55:43AM +0800, Andrew Morton wrote:
> On Fri, 11 Sep 2009 10:23:35 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > Introduce size_inside_page() to replace duplicate /dev/mem code.
> > 
> > Also apply it to /dev/kmem, whose alignment logic was buggy.
> > 
> > 
> > CC: Marcelo Tosatti <mtosatti@redhat.com>
> > CC: Greg Kroah-Hartman <gregkh@suse.de>
> > CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > CC: Johannes Berg <johannes@sipsolutions.net>
> > CC: Avi Kivity <avi@qumranet.com>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> >  drivers/char/mem.c |   60 +++++++++++++------------------------------
> >  1 file changed, 19 insertions(+), 41 deletions(-)
> > 
> > --- linux.orig/drivers/char/mem.c
> > +++ linux/drivers/char/mem.c
> > @@ -35,6 +35,19 @@
> >  # include <linux/efi.h>
> >  #endif
> >  
> > +static inline unsigned long size_inside_page(unsigned long start,
> > +					     unsigned long size)
> > +{
> > +	unsigned long sz;
> > +
> > +	if (-start & (PAGE_SIZE - 1))
> > +		sz = -start & (PAGE_SIZE - 1);
> 
> What on earth is this doing?  Negating an unsigned number?
> 
> Can we get rid of these party tricks and use something more
> conventional here?  In a separate patch I guess.

OK. See the followed patches.

> > +	else
> > +		sz = PAGE_SIZE;
> > +
> > +	return min_t(unsigned long, sz, size);
> 
> Can use min() here.

Done.

> > +}
> 
> Please have a think about the types.  Should we be using unsigned long,
> or size_t?  Which makes more sense?  Which maps better onto reality?
> 
> I suspect that the min_t which you inherited was added somewhere
> because someone didn't get the types right: int-vs-size_t or something.
> If we actually get the types right, this sort of thing goes away.

I tend to just use unsigned long because even though the value itself
is small, it will be elevated to unsigned long in majority use cases.

Does that make sense?

> 
> > @@ -462,10 +451,8 @@ static ssize_t read_kmem(struct file *fi
> >  		if (!kbuf)
> >  			return -ENOMEM;
> >  		while (count > 0) {
> > -			int len = count;
> > +			int len = size_inside_page(p, count);
> 
> int?

Err, changed it to unsigned long sz.

Thanks,
Fengguang
