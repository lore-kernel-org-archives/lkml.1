Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbZIPAjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbZIPAjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 20:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZIPAji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 20:39:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:1990 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZIPAjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 20:39:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,393,1249282800"; 
   d="scan'208";a="188071153"
Date: Wed, 16 Sep 2009 08:39:23 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Nick Piggin <npiggin@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] /proc/kmem cleanups and hwpoison bits
Message-ID: <20090916003923.GA7562@localhost>
References: <20090915021851.168285585@intel.com> <20090915120939.bcc571e1.kamezawa.hiroyu@jp.fujitsu.com> <20090915082200.GA2588@localhost> <Pine.LNX.4.64.0909151057020.26095@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0909151057020.26095@sister.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh,

On Tue, Sep 15, 2009 at 06:16:36PM +0800, Hugh Dickins wrote:
> Sorry guys, I'm picking this mail pretty much at random
> as something to reply to.
> 
> I'm interested to notice such work going on in drivers/char/mem.c,
> and don't have time to join in - you interact a lot faster than I
> manage, and I've other priorities to attend to; but thought I should
> at least send over the patch I've been including in my private debug
> kernels for the last couple of years (rebased to 2.6.31), which lets
> me peek and poke into /dev/kmem as I occasionally wish.
> 
> Warning: it may be rubbish, it may just be a hack which appeared to
> work for me the last time I tried, on a particular address range of a
> particular set of configurations of a particular set of architectures
> (x86_32, x86_64, powerpc64).  I've never thought it through enough to
> consider submitting, but it _might_ contain something useful for you
> to factor into your own efforts.
> 
> Sorry for chucking it over the wall to you in this way, but I guess
> that's better than just sitting quietly on it for a few more years.

It's good to see a totally different approach. Although I'm not sure
if it provides equal functionality or error handling, it does amazed
me by rewriting read_kmem/write_kmem in such short code (without any
supporting functions!).

It looks that your ENXIO makes more sense than EFAULT we used for
nonexistent address :)

Thanks,
Fengguang

> Certainly-Not-Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
> 
>  drivers/char/mem.c |  265 +++++++++++++++----------------------------
>  fs/read_write.c    |    9 +
>  2 files changed, 105 insertions(+), 169 deletions(-)
> 
> but if completed would also remove vread() and vwrite() from
> 
>  include/linux/vmalloc.h
>  mm/nommu.c
>  mm/vmalloc.c
> 
> --- 2.6.31/drivers/char/mem.c	2009-09-09 23:13:59.000000000 +0100
> +++ 2.6.31d/drivers/char/mem.c	2009-09-10 09:38:30.000000000 +0100
> @@ -405,203 +405,134 @@ static ssize_t read_oldmem(struct file *
>  static ssize_t read_kmem(struct file *file, char __user *buf, 
>  			 size_t count, loff_t *ppos)
>  {
> -	unsigned long p = *ppos;
> -	ssize_t low_count, read, sz;
> -	char * kbuf; /* k-addr because vread() takes vmlist_lock rwlock */
> -
> -	read = 0;
> -	if (p < (unsigned long) high_memory) {
> -		low_count = count;
> -		if (count > (unsigned long) high_memory - p)
> -			low_count = (unsigned long) high_memory - p;
> -
> -#ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
> -		/* we don't have page 0 mapped on sparc and m68k.. */
> -		if (p < PAGE_SIZE && low_count > 0) {
> -			size_t tmp = PAGE_SIZE - p;
> -			if (tmp > low_count) tmp = low_count;
> -			if (clear_user(buf, tmp))
> -				return -EFAULT;
> -			buf += tmp;
> -			p += tmp;
> -			read += tmp;
> -			low_count -= tmp;
> -			count -= tmp;
> -		}
> -#endif
> -		while (low_count > 0) {
> -			/*
> -			 * Handle first page in case it's not aligned
> -			 */
> -			if (-p & (PAGE_SIZE - 1))
> -				sz = -p & (PAGE_SIZE - 1);
> -			else
> -				sz = PAGE_SIZE;
> -
> -			sz = min_t(unsigned long, sz, low_count);
> -
> -			/*
> -			 * On ia64 if a page has been mapped somewhere as
> -			 * uncached, then it must also be accessed uncached
> -			 * by the kernel or data corruption may occur
> -			 */
> -			kbuf = xlate_dev_kmem_ptr((char *)p);
> -
> -			if (copy_to_user(buf, kbuf, sz))
> -				return -EFAULT;
> -			buf += sz;
> -			p += sz;
> -			read += sz;
> -			low_count -= sz;
> -			count -= sz;
> -		}
> -	}
> +	char stack_kbuf[64];
> +	char *kbuf = stack_kbuf;
> +	unsigned long kaddr = *ppos;
> +	char *kptr;
> +	size_t part;
> +	unsigned long left;
> +	ssize_t done = 0;
> +	ssize_t err = 0;
> +	mm_segment_t oldfs = get_fs();
>  
> -	if (count > 0) {
> +	if (count > sizeof(stack_kbuf)) {
>  		kbuf = (char *)__get_free_page(GFP_KERNEL);
>  		if (!kbuf)
>  			return -ENOMEM;
> -		while (count > 0) {
> -			int len = count;
> -
> -			if (len > PAGE_SIZE)
> -				len = PAGE_SIZE;
> -			len = vread(kbuf, (char *)p, len);
> -			if (!len)
> -				break;
> -			if (copy_to_user(buf, kbuf, len)) {
> -				free_page((unsigned long)kbuf);
> -				return -EFAULT;
> -			}
> -			count -= len;
> -			buf += len;
> -			read += len;
> -			p += len;
> -		}
> -		free_page((unsigned long)kbuf);
> -	}
> - 	*ppos = p;
> - 	return read;
> -}
> -
> -
> -static inline ssize_t
> -do_write_kmem(void *p, unsigned long realp, const char __user * buf,
> -	      size_t count, loff_t *ppos)
> -{
> -	ssize_t written, sz;
> -	unsigned long copied;
> -
> -	written = 0;
> -#ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
> -	/* we don't have page 0 mapped on sparc and m68k.. */
> -	if (realp < PAGE_SIZE) {
> -		unsigned long sz = PAGE_SIZE - realp;
> -		if (sz > count)
> -			sz = count;
> -		/* Hmm. Do something? */
> -		buf += sz;
> -		p += sz;
> -		realp += sz;
> -		count -= sz;
> -		written += sz;
>  	}
> -#endif
> -
> -	while (count > 0) {
> -		char *ptr;
> -		/*
> -		 * Handle first page in case it's not aligned
> -		 */
> -		if (-realp & (PAGE_SIZE - 1))
> -			sz = -realp & (PAGE_SIZE - 1);
> -		else
> -			sz = PAGE_SIZE;
> -
> -		sz = min_t(unsigned long, sz, count);
>  
> +	part = min(count, (size_t)(PAGE_SIZE - (kaddr & ~PAGE_MASK)));
> +	while (part && !err) {
>  		/*
>  		 * On ia64 if a page has been mapped somewhere as
>  		 * uncached, then it must also be accessed uncached
>  		 * by the kernel or data corruption may occur
>  		 */
> -		ptr = xlate_dev_kmem_ptr(p);
> +		kptr = (char *) kaddr;
> +		if (kptr >= (char *)PAGE_OFFSET && kptr < (char *)high_memory)
> +			kptr = xlate_dev_kmem_ptr(kptr);
> +
> +		set_fs(KERNEL_DS);
> +		pagefault_disable();
> +		left = __copy_from_user_inatomic(
> +				kbuf, (__force char __user *) kptr, part);
> +		pagefault_enable();
> +		set_fs(oldfs);
> +
> +		if (left) {
> +			err = -ENXIO;
> +			part -= left;
> +			if (!part)
> +				break;
> +		}
>  
> -		copied = copy_from_user(ptr, buf, sz);
> -		if (copied) {
> -			written += sz - copied;
> -			if (written)
> +		left = copy_to_user(buf, kbuf, part);
> +		if (left) {
> +			err = -EFAULT;
> +			part -= left;
> +			if (!part)
>  				break;
> -			return -EFAULT;
>  		}
> -		buf += sz;
> -		p += sz;
> -		realp += sz;
> -		count -= sz;
> -		written += sz;
> +
> +		buf += part;
> +		kaddr += part;
> +		done += part;
> +		count -= part;
> +		part = min(count, (size_t)PAGE_SIZE);
>  	}
>  
> -	*ppos += written;
> -	return written;
> +	if (kbuf != stack_kbuf)
> +		free_page((unsigned long)kbuf);
> + 	*ppos = kaddr;
> + 	return done? : err;
>  }
>  
> -
>  /*
>   * This function writes to the *virtual* memory as seen by the kernel.
>   */
>  static ssize_t write_kmem(struct file * file, const char __user * buf, 
>  			  size_t count, loff_t *ppos)
>  {
> -	unsigned long p = *ppos;
> -	ssize_t wrote = 0;
> -	ssize_t virtr = 0;
> -	ssize_t written;
> -	char * kbuf; /* k-addr because vwrite() takes vmlist_lock rwlock */
> -
> -	if (p < (unsigned long) high_memory) {
> -
> -		wrote = count;
> -		if (count > (unsigned long) high_memory - p)
> -			wrote = (unsigned long) high_memory - p;
> -
> -		written = do_write_kmem((void*)p, p, buf, wrote, ppos);
> -		if (written != wrote)
> -			return written;
> -		wrote = written;
> -		p += wrote;
> -		buf += wrote;
> -		count -= wrote;
> -	}
> +	char stack_kbuf[64];
> +	char *kbuf = stack_kbuf;
> +	unsigned long kaddr = *ppos;
> +	char *kptr;
> +	size_t part;
> +	unsigned long left;
> +	ssize_t done = 0;
> +	ssize_t err = 0;
> +	mm_segment_t oldfs = get_fs();
>  
> -	if (count > 0) {
> +	if (count > sizeof(stack_kbuf)) {
>  		kbuf = (char *)__get_free_page(GFP_KERNEL);
>  		if (!kbuf)
> -			return wrote ? wrote : -ENOMEM;
> -		while (count > 0) {
> -			int len = count;
> -
> -			if (len > PAGE_SIZE)
> -				len = PAGE_SIZE;
> -			if (len) {
> -				written = copy_from_user(kbuf, buf, len);
> -				if (written) {
> -					if (wrote + virtr)
> -						break;
> -					free_page((unsigned long)kbuf);
> -					return -EFAULT;
> -				}
> -			}
> -			len = vwrite(kbuf, (char *)p, len);
> -			count -= len;
> -			buf += len;
> -			virtr += len;
> -			p += len;
> +			return -ENOMEM;
> +	}
> +
> +	part = min(count, (size_t)(PAGE_SIZE - (kaddr & ~PAGE_MASK)));
> +	while (part && !err) {
> +		left = copy_from_user(kbuf, buf, part);
> +		if (left) {
> +			err = -EFAULT;
> +			part -= left;
> +			if (!part)
> +				break;
>  		}
> -		free_page((unsigned long)kbuf);
> +
> +		/*
> +		 * On ia64 if a page has been mapped somewhere as
> +		 * uncached, then it must also be accessed uncached
> +		 * by the kernel or data corruption may occur
> +		 */
> +		kptr = (char *) kaddr;
> +		if (kptr >= (char *)PAGE_OFFSET && kptr < (char *)high_memory)
> +			kptr = xlate_dev_kmem_ptr(kptr);
> +
> +		set_fs(KERNEL_DS);
> +		pagefault_disable();
> +		left = __copy_to_user_inatomic(
> +				(__force char __user *) kptr, kbuf, part);
> +		pagefault_enable();
> +		set_fs(oldfs);
> +
> +		if (left) {
> +			err = -ENXIO;
> +			part -= left;
> +			if (!part)
> +				break;
> +		}
> +
> +		buf += part;
> +		kaddr += part;
> +		done += part;
> +		count -= part;
> +		part = min(count, (size_t)PAGE_SIZE);
>  	}
>  
> - 	*ppos = p;
> - 	return virtr + wrote;
> +	if (kbuf != stack_kbuf)
> +		free_page((unsigned long)kbuf);
> + 	*ppos = kaddr;
> + 	return done? : err;
>  }
>  #endif
>  
> --- 2.6.31/fs/read_write.c	2009-09-09 23:13:59.000000000 +0100
> +++ 2.6.31d/fs/read_write.c	2009-09-10 09:38:30.000000000 +0100
> @@ -222,8 +222,13 @@ int rw_verify_area(int read_write, struc
>  	if (unlikely((ssize_t) count < 0))
>  		return retval;
>  	pos = *ppos;
> -	if (unlikely((pos < 0) || (loff_t) (pos + count) < 0))
> -		return retval;
> +	if (pos >= 0) {
> +		if (unlikely((loff_t) (pos + count) < 0))
> +			count = 1 + (size_t) LLONG_MAX - pos;
> +	} else {
> +		if (unlikely((loff_t) (pos + count) > 0))
> +			count = - pos;
> +	}
>  
>  	if (unlikely(inode->i_flock && mandatory_lock(inode))) {
>  		retval = locks_mandatory_area(
