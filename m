Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbZIOIWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbZIOIWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 04:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758184AbZIOIWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 04:22:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:21682 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758185AbZIOIWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 04:22:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,388,1249282800"; 
   d="scan'208";a="187717767"
Date: Tue, 15 Sep 2009 16:22:00 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Nick Piggin <npiggin@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] /proc/kmem cleanups and hwpoison bits
Message-ID: <20090915082200.GA2588@localhost>
References: <20090915021851.168285585@intel.com> <20090915120939.bcc571e1.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915120939.bcc571e1.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 11:09:39AM +0800, KAMEZAWA Hiroyuki wrote:
> On Tue, 15 Sep 2009 10:18:51 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > Hi Kame,
> > 
> > Here are 3 more kmem patches in my queue. Comments are welcome.
> > If you feel good about them, I can send all recent kmem cleanup
> > patches for you.
> > 
> 
> This is my quick hack. But I don't want to be an obstacle for you.
> So, I'll wait for your updates.

Thanks. This is also a bug fix: vmalloc_to_page() will otherwise BUG()
on !is_vmalloc_or_module_addr() pages.

> ==
> Now, /dev/kmem's read/write vmalloc area doesn't do
> range-check. Because vread/vwrite traverse vmalloc area list
> under system-wide spinlock, it's better to avoid unnecessary
> to do unnecessary calls to vread/vwrite.

is_vmalloc_or_module_addr() could be put to either read_kmem()
or aligned_vread(), and I'm fine with both.

It looks like vread can be shared by kmem and kcore :)

> And, vread/vwrite returns 0 if we accessed memory holes.
> We can avoid copy-to-user in read side, we just ignore at write.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  drivers/char/mem.c |   27 +++++++++++++++++++--------
>  1 file changed, 19 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6.31/drivers/char/mem.c
> ===================================================================
> --- linux-2.6.31.orig/drivers/char/mem.c
> +++ linux-2.6.31/drivers/char/mem.c
> @@ -437,17 +437,19 @@ static ssize_t read_kmem(struct file *fi
>  	}
>  
>  	if (count > 0) {
> -		kbuf = (char *)__get_free_page(GFP_KERNEL);
> +		kbuf = (char *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
>  		if (!kbuf)
>  			return -ENOMEM;
>  		while (count > 0) {
>  			sz = size_inside_page(p, count);
> -			sz = vread(kbuf, (char *)p, sz);
> -			if (!sz)
> -				break;
> -			if (copy_to_user(buf, kbuf, sz)) {
> -				free_page((unsigned long)kbuf);
> -				return -EFAULT;
> +			if (is_vmalloc_or_module_addr((void*)p)) {
> +				/* returns Non-zero if a page is found */
> +				if (vread(kbuf, (char *)p, sz))
> +					if (copy_to_user(buf, kbuf, sz)) {
> +						free_page((unsigned long)kbuf);
> +						return -EFAULT;
> +					}
> +				}
>  			}
>  			count -= sz;
>  			buf += sz;
> @@ -541,6 +543,11 @@ static ssize_t write_kmem(struct file * 
>  			unsigned long sz = size_inside_page(p, count);
>  			unsigned long n;
>  
> +			if (is_vmalloc_or_module_addr((void*)p)) {

!is_vmalloc_or_module_addr() ?

> +				free_page((unsignedl long)kbuf);
> +				retrun -EFAULT;
> +			}
> +
>  			n = copy_from_user(kbuf, buf, sz);
>  			if (n) {
>  				if (wrote + virtr)
> @@ -548,7 +555,11 @@ static ssize_t write_kmem(struct file * 
>  				free_page((unsigned long)kbuf);
>  				return -EFAULT;
>  			}
> -			sz = vwrite(kbuf, (char *)p, sz);
> +			/*
> +			 * returns non-zero if copied successfully....
> +			 * But we don't care it. just make a progress.
> +			 */
> +			vwrite(kbuf, (char *)p, sz);

vwrite could return error code which should not be ignored.

Thanks,
Fengguang

>  			count -= sz;
>  			buf += sz;
>  			virtr += sz;
> 
