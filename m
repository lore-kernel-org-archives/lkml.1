Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084Ab0AEJAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab0AEJAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 04:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821Ab0AEJAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 04:00:14 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:39018 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab0AEJAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 04:00:12 -0500
Date: Tue, 5 Jan 2010 09:58:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-arch@vger.kernel.org, ebiederm@xmission.com,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/9] Add a kernel_address() that works for data too
Message-ID: <20100105085853.GA28126@merkur.ravnborg.org>
References: <20100105315.789846878@firstfloor.org> <20100105021527.1AB19B17C2@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105021527.1AB19B17C2@basil.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 03:15:27AM +0100, Andi Kleen wrote:
> 
> Add a variant of kernel_text_address() that includes kernel data.
> 
> Assumes kernel is _text ... _end - init section. True everywhere?

Tim Abbott has done a great job lately to unify the various
linker scripts used by the different architectures.

Architectures are supposed to follow the skeleton outlined
in include/asm-generic/vmlinux.lds.h

But I think the skeleton needs a small update.
It describes that we mark start of .text with _stext.
But reality is that we use _text for this.

But you can trust _etext an almost all architectures.
It is a bug if it is missing.

So [_text, _etext] is the text section.

The data section may be placed before or after - it depends on the architecture.
But again - only some architectures define _sdata.
But all? define _edata.


	Sam


> 
> Cc: linux-arch@vger.kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  include/linux/kernel.h |    1 +
>  kernel/extable.c       |   18 ++++++++++++++++++
>  2 files changed, 19 insertions(+)
> 
> Index: linux-2.6.33-rc2-ak/include/linux/kernel.h
> ===================================================================
> --- linux-2.6.33-rc2-ak.orig/include/linux/kernel.h
> +++ linux-2.6.33-rc2-ak/include/linux/kernel.h
> @@ -205,6 +205,7 @@ extern unsigned long long memparse(const
>  extern int core_kernel_text(unsigned long addr);
>  extern int __kernel_text_address(unsigned long addr);
>  extern int kernel_text_address(unsigned long addr);
> +extern int kernel_address(unsigned long addr);
>  extern int func_ptr_is_kernel_text(void *ptr);
>  
>  struct pid;
> Index: linux-2.6.33-rc2-ak/kernel/extable.c
> ===================================================================
> --- linux-2.6.33-rc2-ak.orig/kernel/extable.c
> +++ linux-2.6.33-rc2-ak/kernel/extable.c
> @@ -72,6 +72,18 @@ int core_kernel_text(unsigned long addr)
>  	return 0;
>  }
>  
> +static int core_kernel_address(unsigned long addr)
> +{
> +	if ((addr >= (unsigned long)_text &&
> +	     addr <= (unsigned long)_end)) {
> +		if (addr >= (unsigned long)__init_begin &&
> +		    addr < (unsigned long)__init_end)
> +			return system_state == SYSTEM_BOOTING;
> +		return 1;
> +	}
> +	return 0;
> +}
> +
>  int __kernel_text_address(unsigned long addr)
>  {
>  	if (core_kernel_text(addr))
> @@ -98,6 +110,12 @@ int kernel_text_address(unsigned long ad
>  	return is_module_text_address(addr);
>  }
>  
> +/* text or data in core kernel or module */
> +int kernel_address(unsigned long addr)
> +{
> +	return core_kernel_address(addr) || is_module_address(addr);
> +}
> +
>  /*
>   * On some architectures (PPC64, IA64) function pointers
>   * are actually only tokens to some data that then holds the
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
