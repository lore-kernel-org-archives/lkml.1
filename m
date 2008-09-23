Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbYIWWIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbYIWWIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 18:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYIWWIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 18:08:44 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41634 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbYIWWIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 18:08:43 -0400
Subject: Re: mmotm 2008-09-22-01-36 uploaded (memory_hotplug)
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <20080922125731.0ee87e05.akpm@linux-foundation.org>
References: <200809220838.m8M8cwC2031790@imap1.linux-foundation.org>
	 <20080922112918.c6ea4e05.randy.dunlap@oracle.com>
	 <20080922125731.0ee87e05.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 23 Sep 2008 15:08:22 -0700
Message-Id: <1222207702.6491.10.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-22 at 12:57 -0700, Andrew Morton wrote:
> On Mon, 22 Sep 2008 11:29:18 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > On Mon, 22 Sep 2008 01:38:58 -0700 akpm@linux-foundation.org wrote:
> > 
> > > The mm-of-the-moment snapshot 2008-09-22-01-36 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > > 
> > > It contains the following patches against 2.6.27-rc7:
> > 
> > 
> > mm/built-in.o: In function `remove_memory':
> > (.text+0x497ed): multiple definition of `remove_memory'
> > arch/x86/mm/built-in.o:(.text+0x3d8): first defined here
> > make[1]: *** [vmlinux.o] Error 1
> > 
> > 
> > so it is defined in both mm/memory_hotplug.c and
> > arch/x86/mm/init_64.c when CONFIG_MEMORY_HOTREMOVE=y.
> > 
> 
> OK, thanks, it looks like people are changing things under our feet.
> 
> Badari, can you please check this fix against
> mm-cleanup-to-make-remove_memory-arch-neutral.patch?
> 


When I made the patch, only ppc64, ia64 and s390 had
memory_remove() support in mainline. I sent a patch against
x86 to add hotplug memory remove support. I guess you
merged Gary's patch and sh-arch patch.

I noticed that you cleaned up all these and added to -mm.
Do you want me to merge all these into a single patch and 
resend it (against -mm) ? (It will look exactly the same
anyway).


Thanks,
Badari

> 
> diff -puN arch/sh/mm/init.c~mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix arch/sh/mm/init.c
> --- a/arch/sh/mm/init.c~mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix
> +++ a/arch/sh/mm/init.c
> @@ -293,20 +293,4 @@ int memory_add_physaddr_to_nid(u64 addr)
>  EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
>  #endif
> 
> -#ifdef CONFIG_MEMORY_HOTREMOVE
> -int remove_memory(u64 start, u64 size)
> -{
> -	unsigned long start_pfn = start >> PAGE_SHIFT;
> -	unsigned long end_pfn = start_pfn + (size >> PAGE_SHIFT);
> -	int ret;
> -
> -	ret = offline_pages(start_pfn, end_pfn, 120 * HZ);
> -	if (unlikely(ret))
> -		printk("%s: Failed, offline_pages() == %d\n", __func__, ret);
> -
> -	return ret;
> -}
> -EXPORT_SYMBOL_GPL(remove_memory);
> -#endif
> -
>  #endif /* CONFIG_MEMORY_HOTPLUG */
> diff -puN arch/x86/mm/init_64.c~mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix arch/x86/mm/init_64.c
> --- a/arch/x86/mm/init_64.c~mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix
> +++ a/arch/x86/mm/init_64.c
> @@ -796,24 +796,6 @@ int memory_add_physaddr_to_nid(u64 start
>  EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
>  #endif
> 
> -#ifdef CONFIG_MEMORY_HOTREMOVE
> -int remove_memory(u64 start, u64 size)
> -{
> -	unsigned long start_pfn, end_pfn;
> -	unsigned long timeout = 120 * HZ;
> -	int ret;
> -	start_pfn = start >> PAGE_SHIFT;
> -	end_pfn = start_pfn + (size >> PAGE_SHIFT);
> -	ret = offline_pages(start_pfn, end_pfn, timeout);
> -	if (ret)
> -		goto out;
> -	/* Arch-specific calls go here */
> -out:
> -	return ret;
> -}
> -EXPORT_SYMBOL_GPL(remove_memory);
> -#endif /* CONFIG_MEMORY_HOTREMOVE */
> -
>  #endif /* CONFIG_MEMORY_HOTPLUG */
> 
>  /*
> _
> 

