Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbZIOCk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbZIOCk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 22:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758024AbZIOCkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 22:40:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48908 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021AbZIOCkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 22:40:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 15 Sep 2009 11:38:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg KH <greg@kroah.com>, Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Tejun Heo <tj@kernel.org>, Nick Piggin <npiggin@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] devmem: handle partial kmem write/read
Message-Id: <20090915113811.6b44877c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090915022328.460943370@intel.com>
References: <20090915021851.168285585@intel.com>
	<20090915022328.460943370@intel.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009 10:18:53 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> Return early on partial read/write, which may happen in future.
> (eg. hit hwpoison pages)
> 
Hmm, please modify vread() as you did in vwrite() and

==
               kbuf = (char *)__get_free_page(GFP_KERNEL);
                if (!kbuf)
                        return -ENOMEM;
==
Add __GFP_ZERO to kbuf allocation, and just ignore vread()'s return value.
Then, this will be much simpler.
Thanks,
-Kame


> CC: Greg KH <greg@kroah.com>
> CC: Andi Kleen <andi@firstfloor.org>
> CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  drivers/char/mem.c |   30 ++++++++++++++++++------------
>  mm/vmalloc.c       |   10 +---------
>  2 files changed, 19 insertions(+), 21 deletions(-)
> 
> --- linux-mm.orig/drivers/char/mem.c	2009-09-15 09:44:49.000000000 +0800
> +++ linux-mm/drivers/char/mem.c	2009-09-15 09:44:55.000000000 +0800
> @@ -444,18 +444,22 @@ static ssize_t read_kmem(struct file *fi
>  		if (!kbuf)
>  			return -ENOMEM;
>  		while (count > 0) {
> +			unsigned long n;
> +
>  			sz = size_inside_page(p, count);
> -			sz = vread(kbuf, (char *)p, sz);
> -			if (!sz)
> +			n = vread(kbuf, (char *)p, sz);
> +			if (!n)
>  				break;
> -			if (copy_to_user(buf, kbuf, sz)) {
> +			if (copy_to_user(buf, kbuf, n)) {
>  				free_page((unsigned long)kbuf);
>  				return -EFAULT;
>  			}
> -			count -= sz;
> -			buf += sz;
> -			read += sz;
> -			p += sz;
> +			count -= n;
> +			buf += n;
> +			read += n;
> +			p += n;
> +			if (n < sz)
> +				break;
>  		}
>  		free_page((unsigned long)kbuf);
>  	}
> @@ -551,11 +555,13 @@ static ssize_t write_kmem(struct file * 
>  				free_page((unsigned long)kbuf);
>  				return -EFAULT;
>  			}
> -			sz = vwrite(kbuf, (char *)p, sz);
> -			count -= sz;
> -			buf += sz;
> -			virtr += sz;
> -			p += sz;
> +			n = vwrite(kbuf, (char *)p, sz);
> +			count -= n;
> +			buf += n;
> +			virtr += n;
> +			p += n;
> +			if (n < sz)
> +				break;
>  		}
>  		free_page((unsigned long)kbuf);
>  	}
> 
> -- 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

