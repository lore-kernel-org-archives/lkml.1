Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbYKURjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbYKURjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756717AbYKURjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:39:01 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41062 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756626AbYKURi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:38:59 -0500
Message-ID: <4926F21D.7030709@sandeen.net>
Date: Fri, 21 Nov 2008 11:38:37 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-kernel@vger.kernel.org, davem@davemloft.net, tony.luck@intel.com,
       ralf@linux-mips.org, kyle@mcmartin.ca, schwidefsky@de.ibm.com
Subject: Re: [PATCH] generic compat_sys_ustat
References: <20081121084105.GA7155@lst.de>
In-Reply-To: <20081121084105.GA7155@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> Due to a different size of ino_t ustat needs a compat handler, but
> currently only x86 and mips provide one.  Add a generic compat_sys_ustat
> and switch all architectures over to it.
> 
> Found by Eric Sandeen when running xfstests/017 on ppc64, which causes
> stack smashing warnings on RHEL/Fedora due to the too large amount of
> data writen by the syscall.

...

> Index: linux-2.6/fs/compat.c
> ===================================================================
> --- linux-2.6.orig/fs/compat.c	2008-11-20 20:09:52.000000000 +0100
> +++ linux-2.6/fs/compat.c	2008-11-20 20:16:05.000000000 +0100
> @@ -378,6 +378,24 @@ out:
>  	return error;
>  }
>  
> +asmlinkage long compat_sys_ustat(unsigned dev, struct compat_ustat __user *u32)

Oh, I had also suggested that the use of "u32" here was slightly
confusing, it at least made me do a double-take with the unsigned 32 bit
type... not a big deal, but just thought I'd mention it.

Thanks,
-Eric

> +{
> +	struct ustat *u = compat_alloc_user_space(sizeof(*u));
> +	int ret;
> +
> +	ret = sys_ustat(dev, u);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!access_ok(VERIFY_WRITE, u32, sizeof(*u32)) ||
> +	    __put_user((compat_daddr_t) u->f_tfree, &u32->f_tfree) ||
> +	    __put_user((compat_ino_t) u->f_tinode, &u32->f_tfree) ||
> +	    __copy_to_user(&u32->f_fname, u->f_fname, sizeof(u32->f_fname)) ||
> +	    __copy_to_user(&u32->f_fpack, u->f_fpack, sizeof(u32->f_fpack)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
