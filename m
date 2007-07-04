Return-Path: <linux-kernel-owner+w=401wt.eu-S1758477AbXGDI0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477AbXGDI0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 04:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbXGDI0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 04:26:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157AbXGDI0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 04:26:13 -0400
Date: Wed, 4 Jul 2007 04:25:54 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kratochvil <honza@jikos.cz>,
       Ingo Molnar <mingo@elte.hu>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] PIE randomization
Message-ID: <20070704082554.GQ7012@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <alpine.LRH.0.98.0705111338230.22353@twin.jikos.cz> <20070511125629.3df919cf.akpm@linux-foundation.org> <Pine.LNX.4.64.0705112211440.16923@twin.jikos.cz> <20070511133651.63f8a14d.akpm@linux-foundation.org> <Pine.LNX.4.64.0705120048230.11493@jikos.suse.cz> <Pine.LNX.4.64.0705161851120.25986@twin.jikos.cz> <alpine.LRH.0.98.0705172221440.22353@twin.jikos.cz> <20070522161642.b71ddacb.akpm@linux-foundation.org> <Pine.LNX.4.64.0705231044540.22906@jikos.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705231044540.22906@jikos.suse.cz>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 10:50:24AM +0200, Jiri Kosina wrote:
> From: Jan Kratochvil <honza@jikos.cz>
> 
> This patch is using mmap()'s randomization functionality in such a way 
> that it maps the main executable of (specially compiled/linked -pie/-fpie) 
> ET_DYN binaries onto a random address (in cases in which mmap() is allowed 
> to perform a randomization).
> 
> Origin of this patch is in exec-shield
> (http://people.redhat.com/mingo/exec-shield/)
> 
> Signed-off-by: Jan Kratochvil <honza@jikos.cz>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Roland McGrath <roland@redhat.com>
> Cc: Jakub Jelinek <jakub@redhat.com>

> -#define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
> +#define BAD_ADDR(x) ((unsigned long)(x) >= PAGE_MASK)
...
> @@ -442,8 +491,7 @@ static unsigned long load_elf_interp(str
>  			goto out_close;
>  	}
>  
> -	*interp_load_addr = load_addr;
> -	error = ((unsigned long)interp_elf_ex->e_entry) + load_addr;
> +	error = load_addr;
...
>  	if (elf_interpreter) {
> -		if (interpreter_type == INTERPRETER_AOUT)
> +		if (interpreter_type == INTERPRETER_AOUT) {
>  			elf_entry = load_aout_interp(&loc->interp_ex,
>  						     interpreter);
> -		else
> +		} else {
> +			unsigned long interp_map_addr;	/* unused */
> +
>  			elf_entry = load_elf_interp(&loc->interp_elf_ex,
>  						    interpreter,
> -						    &interp_load_addr);
> +						    &interp_map_addr,
> +						    load_bias);
> +			if (!BAD_ADDR(elf_entry)) {
> +				/*
> +				 * load_elf_interp() returns relocation
> +				 * adjustment
> +				 */
> +				interp_load_addr = elf_entry;
> +				elf_entry += loc->interp_elf_ex.e_entry;
> +			}
> +		}
>  		if (BAD_ADDR(elf_entry)) {
>  			force_sig(SIGSEGV, current);
>  			retval = IS_ERR((void *)elf_entry) ?

The above highlighted changes are the cause of random segfaults of PIE
binaries.  See
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=246623
The problem is if ld.so is prelinked to some address in the area where
the kernel actually maps it, particularly if elf_map in load_elf_interp
returns an address one page below its first PT_LOAD segments vaddr.
Then load_addr (it is a load bias actually) returned from load_elf_interp
is 0xfffff000 (on 32-bit kernels) and BAD_ADDR are all
addresses >= 0xfffff000 (on i?86).
The fix should be either changing the definition of BAD_ADDR to
e.g. IS_ERR_VALUE(x), or at least changing the if (!BAD_ADDR(elf_entry)) {
above to if (!IS_ERR_VALUE(elf_entry)) {, the second BAD_ADDR can already
stay, because at that place elf_entry is no longer a bias (difference
between actual and preferred load address), but an actual address, where
very high addresses are of course invalid.

	Jakub
