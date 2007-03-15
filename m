Return-Path: <linux-kernel-owner+w=401wt.eu-S933543AbXCON0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543AbXCON0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 09:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933564AbXCON0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 09:26:22 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:34685 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933543AbXCON0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 09:26:21 -0400
Date: Thu, 15 Mar 2007 18:56:16 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Ian Campbell <Ian.Campbell@xensource.com>
Cc: Horms <horms@verge.net.au>, hbabu@us.ibm.com, fastboot@lists.osdl.org,
       linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] Allow i386 crash kernels to handle x86_64 dumps
Message-ID: <20070315132616.GH6766@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <1173891609.8591.41.camel@localhost.localdomain> <20070315014635.GC28396@verge.net.au> <20070315045536.GA6766@in.ibm.com> <20070315050754.GB22329@verge.net.au> <20070315054726.GC6766@in.ibm.com> <1173961378.8591.63.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173961378.8591.63.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 12:22:57PM +0000, Ian Campbell wrote:
> On Thu, 2007-03-15 at 11:17 +0530, Vivek Goyal wrote:
> > > > But I think changing this macro might run into issues. It is
> > > > being used at few places in kernel, for example while loading
> > > > module. This will essentially mean that we allow loading 64bit
> > > > x86_64 modules on 32bit i386 systems?
> 
> Yes, not sure how I missed that fact...
> 
> > Kexec will also not allow loading an x86_64 kernel on a 32bit machine.
> 
> For crash kernel only or for regular kexec too?
> 

I think for both. One of the possible reasons I think is that one never
knows is underlying machine has got 64bit extensions or not. So even if
we load the kernel it will never boot. Secondly, we might not be able to
handle 64bit address in 32bit kernel/user space?

> > So how about something like vmcore_elf_allowed_cross_arch()? Vmcore
> > code can continue to check elf_check_arch() and if that fails it can
> > invoke vmcore_elf_allowed_cross_arch() to find out what cross arch are
> > allowed for vmcore. 
> 
> Something like this?
> 
> Ian.
> 
> ---  
> 
> Allow i386 crash kernels to handle x86_64 dumps.
> 
> The specific case I am encountering is kdump under Xen with a 64 bit
> hypervisor and 32 bit kernel/userspace. The dump created is a 64 bit
> due to the hypervisor but the dump kernel is 32 bit in for maximum
> compatibility.
> 
> It's possibly less likely to be useful in a purely native scenario but
> I see no reason to disallow it.
> 
> Signed-off-by: Ian Campbell <ian.campbell@xensource.com>
> 
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index d960507..523e109 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -514,7 +514,7 @@ static int __init parse_crash_elf64_headers(void)
>  	/* Do some basic Verification. */
>  	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) != 0 ||
>  		(ehdr.e_type != ET_CORE) ||
> -		!elf_check_arch(&ehdr) ||
> +		!vmcore_elf_check_arch(&ehdr) ||
>  		ehdr.e_ident[EI_CLASS] != ELFCLASS64 ||
>  		ehdr.e_ident[EI_VERSION] != EV_CURRENT ||
>  		ehdr.e_version != EV_CURRENT ||
> diff --git a/include/asm-i386/kexec.h b/include/asm-i386/kexec.h
> index 4dfc9f5..c76737e 100644
> --- a/include/asm-i386/kexec.h
> +++ b/include/asm-i386/kexec.h
> @@ -47,6 +47,9 @@
>  /* The native architecture */
>  #define KEXEC_ARCH KEXEC_ARCH_386
> 
> +/* We can also handle crash dumps from 64 bit kernel. */
> +#define vmcore_elf_check_arch_cross(x) ((x)->e_machine == EM_X86_64)
> +

Ideal place for this probably should have been arch dependent crash_dump.h
file. But we don't have one and no point introducing one just for this 
macro.

This change looks good to me.

Thanks
Vivek
