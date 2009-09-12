Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbZILO5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbZILO5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 10:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbZILO5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 10:57:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:45731 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569AbZILO5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 10:57:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,376,1249282800"; 
   d="scan'208";a="186915366"
Date: Sat, 12 Sep 2009 22:57:12 +0800
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
Subject: Re: [PATCH 3/3] devmem: cleanup unxlate_dev_mem_ptr() calls
Message-ID: <20090912145712.GC6511@localhost>
References: <20090911022333.324128054@intel.com> <20090911023200.767391440@intel.com> <20090911170500.8db04cb7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911170500.8db04cb7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12, 2009 at 08:05:00AM +0800, Andrew Morton wrote:
> On Fri, 11 Sep 2009 10:23:36 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > No behavior change.
> > 
> > CC: Marcelo Tosatti <mtosatti@redhat.com>
> > CC: Greg Kroah-Hartman <gregkh@suse.de>
> > CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > CC: Johannes Berg <johannes@sipsolutions.net>
> > CC: Avi Kivity <avi@qumranet.com>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> >  drivers/char/mem.c |   13 +++++--------
> >  1 file changed, 5 insertions(+), 8 deletions(-)
> > 
> > --- linux-mm.orig/drivers/char/mem.c	2009-09-10 21:59:39.000000000 +0800
> > +++ linux-mm/drivers/char/mem.c	2009-09-10 22:00:12.000000000 +0800
> > @@ -131,6 +131,7 @@ static ssize_t read_mem(struct file * fi
> >  			size_t count, loff_t *ppos)
> >  {
> >  	unsigned long p = *ppos;
> > +	unsigned long ret;
> >  	ssize_t read, sz;
> >  	char *ptr;
> >  
> > @@ -169,12 +170,10 @@ static ssize_t read_mem(struct file * fi
> >  		if (!ptr)
> >  			return -EFAULT;
> >  
> > -		if (copy_to_user(buf, ptr, sz)) {
> > -			unxlate_dev_mem_ptr(p, ptr);
> > -			return -EFAULT;
> > -		}
> > -
> > +		ret = copy_to_user(buf, ptr, sz);
> >  		unxlate_dev_mem_ptr(p, ptr);
> > +		if (ret)
> > +			return -EFAULT;
> >  
> >  		buf += sz;
> >  		p += sz;
> 
> - local var `ret' didn't need function-wide scope.  I think it's
>   better to reduce its scope if poss.

OK.

> - conventionally the identifier `ret' refers to "the value which this
>   function will return".  Ditto `retval' and `rc'.

Good to know that, thanks!

>   But that's not what `ret' does here so let's call it something
>   else?  `remaining' is rather verbose and formal, but accurate.
> 
> 
> --- a/drivers/char/mem.c~dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix
> +++ a/drivers/char/mem.c
> @@ -131,7 +131,6 @@ static ssize_t read_mem(struct file * fi
>  			size_t count, loff_t *ppos)
>  {
>  	unsigned long p = *ppos;
> -	unsigned long ret;

I got compile error because another place in read_mem() used ret.
I'll send you an updated fix.

Thanks,
Fengguang

>  	ssize_t read, sz;
>  	char *ptr;
>  
> @@ -156,6 +155,8 @@ static ssize_t read_mem(struct file * fi
>  #endif
>  
>  	while (count > 0) {
> +		unsigned long remaining;
> +
>  		sz = size_inside_page(p, count);
>  
>  		if (!range_is_allowed(p >> PAGE_SHIFT, count))
> @@ -170,9 +171,9 @@ static ssize_t read_mem(struct file * fi
>  		if (!ptr)
>  			return -EFAULT;
>  
> -		ret = copy_to_user(buf, ptr, sz);
> +		remaining = copy_to_user(buf, ptr, sz);
>  		unxlate_dev_mem_ptr(p, ptr);
> -		if (ret)
> +		if (remaining)
>  			return -EFAULT;
>  
>  		buf += sz;
> _
