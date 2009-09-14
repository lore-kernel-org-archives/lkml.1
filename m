Return-Path: <linux-kernel-owner+w=401wt.eu-S1751133AbZINEe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133AbZINEe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 00:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbZINEez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 00:34:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:36048 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZINEez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 00:34:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,381,1249282800"; 
   d="scan'208";a="187207478"
Date: Mon, 14 Sep 2009 12:34:44 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "mtosatti@redhat.com" <mtosatti@redhat.com>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
       "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
       "avi@qumranet.com" <avi@qumranet.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       WANG Cong <xiyou.wangcong@gmail.com>, Mike Smith <scgtrp@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] devmem: handle partial kmem write/read
Message-ID: <20090914043444.GA18590@localhost>
References: <20090914032901.GA16189@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914032901.GA16189@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kame,

This patch needs more work. I first intent to fix a bug:

                        sz = vwrite(kbuf, (char *)p, sz);
                        p += sz;
                }

So if the returned len is 0, the kbuf/p pointers will mismatch. 

Then I realize it changed the write behavior. The current vwrite()
behavior is strange, it returns 0 if _whole range_ is hole, otherwise
ignores the hole silently. So holes can be treated differently even in
the original code.

I'm not really sure about the right behavior. KAME-san, do you have
any suggestions?

Thanks,
Fengguang

On Mon, Sep 14, 2009 at 11:29:01AM +0800, Wu Fengguang wrote:
> Current vwrite silently ignores vwrite() to vmap holes.
> Better behavior should be stop the write and return
> on such holes.
> 
> Also return on partial read, which may happen in future
> (eg. hit hwpoison pages).
> 
> CC: Andi Kleen <andi@firstfloor.org>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  drivers/char/mem.c |   30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)
> 
> --- linux-mm.orig/drivers/char/mem.c	2009-09-14 10:59:50.000000000 +0800
> +++ linux-mm/drivers/char/mem.c	2009-09-14 11:06:25.000000000 +0800
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
