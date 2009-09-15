Return-Path: <linux-kernel-owner+w=401wt.eu-S934322AbZIOCr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934322AbZIOCr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 22:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758036AbZIOCrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 22:47:55 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41022 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758034AbZIOCry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 22:47:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 15 Sep 2009 11:45:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg KH <greg@kroah.com>, Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Tejun Heo <tj@kernel.org>, Nick Piggin <npiggin@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] HWPOISON: prevent /dev/kmem users from accessing
 hwpoison pages
Message-Id: <20090915114546.3663f4a3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090915022328.587059822@intel.com>
References: <20090915021851.168285585@intel.com>
	<20090915022328.587059822@intel.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009 10:18:54 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> When /dev/kmem read()/write() encounters hwpoison page, stop it
> and return the amount of work done till now.
> 

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> CC: Greg KH <greg@kroah.com>
> CC: Andi Kleen <andi@firstfloor.org>
> CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  drivers/char/mem.c |   18 +++++++++++----
>  mm/vmalloc.c       |   51 +++++++++++++++++++++++++++----------------
>  2 files changed, 47 insertions(+), 22 deletions(-)
> 
> --- linux-mm.orig/drivers/char/mem.c	2009-09-15 10:14:20.000000000 +0800
> +++ linux-mm/drivers/char/mem.c	2009-09-15 10:14:25.000000000 +0800
> @@ -429,6 +429,9 @@ static ssize_t read_kmem(struct file *fi
>  			 */
>  			kbuf = xlate_dev_kmem_ptr((char *)p);
>  
> +			if (unlikely(virt_addr_valid(kbuf) &&
> +				     PageHWPoison(virt_to_page(kbuf))))
> +				return -EIO;
>  			if (copy_to_user(buf, kbuf, sz))
>  				return -EFAULT;
>  			buf += sz;
> @@ -474,6 +477,7 @@ do_write_kmem(unsigned long p, const cha
>  {
>  	ssize_t written, sz;
>  	unsigned long copied;
> +	int err = 0;
>  
>  	written = 0;
>  #ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
> @@ -500,13 +504,19 @@ do_write_kmem(unsigned long p, const cha
>  		 */
>  		ptr = xlate_dev_kmem_ptr((char *)p);
>  
> +		if (unlikely(virt_addr_valid(ptr) &&


> +			     PageHWPoison(virt_to_page(ptr)))) {
> +			err = -EIO;
> +			break;
> +		}
> +
>  		copied = copy_from_user(ptr, buf, sz);
>  		if (copied) {
>  			written += sz - copied;
> -			if (written)
> -				break;
> -			return -EFAULT;
> +			err = -EFAULT;
> +			break;
>  		}
> +
>  		buf += sz;
>  		p += sz;
>  		count -= sz;
> @@ -514,7 +524,7 @@ do_write_kmem(unsigned long p, const cha
>  	}
>  
>  	*ppos += written;
> -	return written;
> +	return written ? written : err;
>  }
>  
>  
> --- linux-mm.orig/mm/vmalloc.c	2009-09-15 10:14:18.000000000 +0800
> +++ linux-mm/mm/vmalloc.c	2009-09-15 10:17:20.000000000 +0800
> @@ -1661,6 +1661,8 @@ static int aligned_vread(char *buf, char
>  		if (length > count)
>  			length = count;
>  		p = vmalloc_to_page(addr);
> +		if (unlikely(p && PageHWPoison(p)))
> +			break;
>  		/*
>  		 * To do safe access to this _mapped_ area, we need
>  		 * lock. But adding lock here means that we need to add
> @@ -1700,6 +1702,8 @@ static int aligned_vwrite(char *buf, cha
>  		if (length > count)
>  			length = count;
>  		p = vmalloc_to_page(addr);
> +		if (unlikely(p && PageHWPoison(p)))
> +			break;
>  		/*
>  		 * To do safe access to this _mapped_ area, we need
>  		 * lock. But adding lock here means that we need to add
> @@ -1731,8 +1735,10 @@ static int aligned_vwrite(char *buf, cha
>   *	@count:		number of bytes to be read.
>   *
>   *	Returns # of bytes which addr and buf should be increased.
> - *	(same number to @count). Returns 0 if [addr...addr+count) doesn't
> - *	includes any intersect with alive vmalloc area.
> + *	(same number to @count if no hwpoison pages encountered).
> + *
> + *	Returns 0 if [addr...addr+count) doesn't includes any intersect with
> + *	alive vmalloc area.
>   *
>   *	This function checks that addr is a valid vmalloc'ed area, and
>   *	copy data from that area to a given buffer. If the given memory range
> @@ -1740,8 +1746,6 @@ static int aligned_vwrite(char *buf, cha
>   *	proper area of @buf. If there are memory holes, they'll be zero-filled.
>   *	IOREMAP area is treated as memory hole and no copy is done.
>   *
> - *	If [addr...addr+count) doesn't includes any intersects with alive
> - *	vm_struct area, returns 0.
>   *	@buf should be kernel's buffer. Because	this function uses KM_USER0,
>   *	the caller should guarantee KM_USER0 is not used.
>   *
> @@ -1757,7 +1761,8 @@ long vread(char *buf, char *addr, unsign
>  	struct vm_struct *tmp;
>  	char *vaddr, *buf_start = buf;
>  	unsigned long buflen = count;
> -	unsigned long n;
> +	unsigned long ret = 0;
> +	unsigned long n = 0;
>  
>  	/* Don't allow overflow */
>  	if ((unsigned long) addr + count < count)
> @@ -1780,12 +1785,16 @@ long vread(char *buf, char *addr, unsign
>  		if (n > count)
>  			n = count;
>  		if (!(tmp->flags & VM_IOREMAP))
> -			aligned_vread(buf, addr, n);
> -		else /* IOREMAP area is treated as memory hole */
> +			ret = aligned_vread(buf, addr, n);
> +		else { /* IOREMAP area is treated as memory hole */
>  			memset(buf, 0, n);
> -		buf += n;
> -		addr += n;
> -		count -= n;
> +			ret = n;
> +		}
> +		buf += ret;
> +		addr += ret;
> +		count -= ret;
> +		if (ret < n)
> +			break;
>  	}
>  finished:
>  	read_unlock(&vmlist_lock);
> @@ -1796,7 +1805,7 @@ finished:
>  	if (buf != buf_start + buflen)
>  		memset(buf, 0, buflen - (buf - buf_start));
>  
> -	return buflen;
> +	return ret == n ? buflen : buflen - count;
>  }
>  
>  /**
> @@ -1806,7 +1815,7 @@ finished:
>   *	@count:		number of bytes to be read.
>   *
>   *	Returns # of bytes which addr and buf should be increased.
> - *	(same number to @count).
> + *	(same number to @count if no hwpoison pages encountered).
>   *
>   *	This function checks that addr is a valid vmalloc'ed area, and
>   *	copy data from a buffer to the given addr. If specified range of
> @@ -1829,7 +1838,9 @@ long vwrite(char *buf, char *addr, unsig
>  {
>  	struct vm_struct *tmp;
>  	char *vaddr;
> -	unsigned long n, buflen;
> +	unsigned long buflen;
> +	unsigned long ret = 0;
> +	unsigned long n = 0;
>  
>  	/* Don't allow overflow */
>  	if ((unsigned long) addr + count < count)
> @@ -1852,14 +1863,18 @@ long vwrite(char *buf, char *addr, unsig
>  		if (n > count)
>  			n = count;
>  		if (!(tmp->flags & VM_IOREMAP))
> -			aligned_vwrite(buf, addr, n);
> -		buf += n;
> -		addr += n;
> -		count -= n;
> +			ret = aligned_vwrite(buf, addr, n);
> +		else
> +			ret = n;
> +		buf += ret;
> +		addr += ret;
> +		count -= ret;
> +		if (ret < n)
> +			break;
>  	}
>  finished:
>  	read_unlock(&vmlist_lock);
> -	return buflen;
> +	return ret == n ? buflen : buflen - count;
>  }
>  
>  /**
> 
> -- 
> 
> 

