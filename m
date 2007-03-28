Return-Path: <linux-kernel-owner+w=401wt.eu-S933681AbXC1Gn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933681AbXC1Gn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 02:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbXC1Gn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 02:43:57 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49199 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbXC1Gnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 02:43:55 -0400
Date: Wed, 28 Mar 2007 12:13:53 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Simon Horman <horms@verge.net.au>
Cc: fastboot@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdump/kexec: calculate note size at compile time
Message-ID: <20070328064353.GD4941@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070328061855.GA9576@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328061855.GA9576@verge.net.au>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 03:18:58PM +0900, Simon Horman wrote:
> Currently the size of the per-cpu region reserved to save crash
> notes is set by the per-architecture value MAX_NOTE_BYTES. Which
> in turn is currently set to 1024 on all supported architectures.
> 
> While testing ia64 I recently discovered that this value is
> in fact too small. The particular setup I was using actually
> needs 1172 bytes. This lead to very tedious failure mode
> where the tail of one elf note would overwrite the head of 
> another if they ended up being alocated sequentially by kmalloc,
> which was often the case.
> 
> It seems to me that a far better approach is to caclculate the size
> that the area needs to be. This patch does just that.
> 
> If a simpler stop-gap patch for ia64 to be squeezed into 2.6.21(.X) 
> is needed then this should be as easy as making MAX_NOTE_BYTES
> larger in arch/asm-ia64/kexec.h. Perhaps 2048 would be a good choice.
> However, I think that the approach in this patch is a much more robust idea.
> 

Makes sense to me. Calculating the size based on elf_prstatus is better
than hardcoding it to some value.

A minor query is inlined below.

[..]
> ===================================================================
> --- linux-2.6.orig/include/linux/kexec.h	2007-03-28 09:42:14.000000000 +0900
> +++ linux-2.6/include/linux/kexec.h	2007-03-28 12:32:50.000000000 +0900
> @@ -7,6 +7,8 @@
>  #include <linux/linkage.h>
>  #include <linux/compat.h>
>  #include <linux/ioport.h>
> +#include <linux/elfcore.h>
> +#include <linux/elf.h>
>  #include <asm/kexec.h>
> 
>  /* Verify architecture specific macros are defined */
> @@ -31,6 +33,13 @@
>  #error KEXEC_ARCH not defined
>  #endif
> 
> +#define KEXEC_NOTE_NAME "CORE"
> +#define KEXEC_NOTE_HEAD_BYTES ALIGN(sizeof(struct elf_note), 4)
> +#define KEXEC_NOTE_NAME_BYTES ALIGN(strlen(KEXEC_NOTE_NAME) + 1, 4)
> +#define KEXEC_NOTE_BODY_BYTES ALIGN(sizeof(struct elf_prstatus), 4)
> +#define KEXEC_NOTE_BYTES ( (KEXEC_NOTE_HEAD_BYTES * 2) + \

Why are we multiplying KEXEC_NOTE_HEAD_BYTES with 2?

Thanks
Vivek
