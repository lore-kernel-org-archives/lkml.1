Return-Path: <linux-kernel-owner+w=401wt.eu-S933590AbXFEWua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590AbXFEWua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 18:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765749AbXFEWuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 18:50:08 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:42230 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763433AbXFEWuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 18:50:05 -0400
Date: Tue, 5 Jun 2007 15:49:41 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       Alan Cox <alan@redhat.com>, drepper@redhat.com, roland@redhat.com,
       arjan@infradead.org, mingo@elte.hu, viro@zeniv.linux.org.uk,
       jmorris@namei.org, chrisw@redhat.com, sds@tycho.nsa.gov,
       sgrubb@redhat.com
Subject: Re: [PATCH] Protection for exploiting null dereference using mmap
Message-ID: <20070605224941.GD3723@sequoia.sous-sol.org>
References: <1180561713.3633.27.camel@dhcp231-215.rdu.redhat.com> <20070603205653.GE25869@devserv.devel.redhat.com> <1180964306.14220.34.camel@moss-spartans.epoch.ncsc.mil> <1181075666.3978.31.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181075666.3978.31.camel@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Paris (eparis@redhat.com) wrote:
> +mmap_protect_memory

I'm terrible at names, but something like mmap_minimum_addr would be a
little clearer at describing that it's a lower bound on mapping memory.
BTW, this is also an arch specific issue, those with disjoint kernel
and user memory space don't suffer (yet another reason to default to 0).

> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -615,6 +615,15 @@ static ctl_table kern_table[] = {
>  		.proc_handler   = &proc_dointvec,
>  	},
>  #endif
> +	{
> +		.ctl_name	= CTL_UNNUMBERED,
> +		.procname	= "mmap_protect_memory",
> +		.data		= &mmap_protect_memory,
> +		.maxlen         = sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_dointvec,
> +		.strategy	= &sysctl_intvec,

I don't think this strategy does anything without some boundary values.

> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -291,6 +291,10 @@ unsigned long do_mremap(unsigned long addr,
>  		if ((addr <= new_addr) && (addr+old_len) > new_addr)
>  			goto out;
>  
> +		ret = security_file_mmap(0, 0, 0, 0, new_addr, 1);
> +		if (ret)
> +			goto out;
> +
>  		ret = do_munmap(mm, new_addr, new_len);
>  		if (ret)
>  			goto out;
> @@ -390,9 +394,16 @@ unsigned long do_mremap(unsigned long addr,
>  
>  			new_addr = get_unmapped_area(vma->vm_file, 0, new_len,
>  						vma->vm_pgoff, map_flags);
> -			ret = new_addr;
> -			if (new_addr & ~PAGE_MASK)
> +			if (new_addr & ~PAGE_MASK) {
> +				ret = new_addr;
>  				goto out;
> +			}
> +
> +			ret = security_file_mmap(0, 0, 0, 0, new_addr, 1);
> +			if (ret)
> +				goto out;
> +
> +			ret = new_addr;

Nit: unnecessary assignment...

>  		}
>  		ret = move_vma(vma, addr, old_len, new_len, new_addr);
		^^^
...as it's overwritten immediately after.
