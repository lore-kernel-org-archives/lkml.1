Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbZDPP2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbZDPP2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 11:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbZDPP1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 11:27:52 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56592 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbZDPP1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 11:27:51 -0400
Date: Thu, 16 Apr 2009 10:27:39 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, dave@linux.vnet.ibm.com, mingo@elte.hu,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/30] cr: restore vDSO on i386/x86_64
Message-ID: <20090416152739.GA19712@us.ibm.com>
References: <20090410023752.GS27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410023752.GS27788@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> FIXME: check VMA has same parameters.
> FIXME: abort if target kernel has vDSO disabled (?)
> FIXME: restore pages, vDSO is writable after all.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  arch/x86/vdso/vdso32-setup.c |    6 ++
>  include/linux/cr.h           |   11 +++++
>  include/linux/mm.h           |    5 +-
>  kernel/cr/cr-mm.c            |   87 +++++++++++++++++++++++++++++++++++++++++++
>  mm/mmap.c                    |    3 +
>  5 files changed, 110 insertions(+), 2 deletions(-)
> 
> --- a/arch/x86/vdso/vdso32-setup.c
> +++ b/arch/x86/vdso/vdso32-setup.c
> @@ -328,6 +328,10 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, unsigned long start,
> 
>  	map_compat_vdso(compat);
> 
> +	if (start) {
> +		addr = start;
> +		goto map;
> +	}

Hmm, is there any safety to be gained by using
	arch_get_unmapped_area(NULL, start, PAGE_SIZE, 0, 0);
so as to make sure there is a free page?

>  	if (compat)
>  		addr = VDSO_HIGH_BASE;
>  	else {
> @@ -337,7 +341,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, unsigned long start,
>  			goto up_fail;
>  		}
>  	}
> -
> +map:
>  	if (compat_uses_vma || !compat) {
>  		/*
>  		 * MAYWRITE to allow gdb to COW and set breakpoints

thanks,
-serge
