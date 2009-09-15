Return-Path: <linux-kernel-owner+w=401wt.eu-S1752044AbZIOIBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbZIOIBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 04:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbZIOIBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 04:01:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33918 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbZIOIBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 04:01:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 15 Sep 2009 16:58:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: viro@zeniv.linux.org.uk, Andrew Morton <akpm@linux-foundation.org>,
       "mtosatti@redhat.com" <mtosatti@redhat.com>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
       "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
       "avi@qumranet.com" <avi@qumranet.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Question: how to handle too big f_pos Re: [PATCH] devmem: handle
 partial kmem write/read
Message-Id: <20090915165852.032d164f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090914032901.GA16189@localhost>
References: <20090914032901.GA16189@localhost>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm writing a patch against /dev/kmem...I found a problem.

/dev/kmem (and /proc/<pid>/mem) puts virtual addres to f->f_pos.

And, f->f_pos is loff_t .... signed value (not unsigned)

Then, this check
rw_verify_area(READ, file, pos, count);
=>
        pos = *ppos;
        if (unlikely((pos < 0) || (loff_t) (pos + count) < 0))
                return retval;
	
always returns -EINVAL when I read /dev/kmem's valid address.

Then, how should I do for read /dev/kmem ? Any idea ?
(Added Al Viro to CC:)

What I'm really afraid of is /proc/<pid>/mem. IIUC, it's used by gdb to snoop
memory, (for example, at gcore).
I think gdb uses ptrace if it fails to read /proc/<pid>/mem but...it's deadly
slow.

Thanks,
-Kame

p.s. no problems in /proc/kcore..its offset is not bare addresss.





On Mon, 14 Sep 2009 11:29:01 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

