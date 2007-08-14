Return-Path: <linux-kernel-owner+w=401wt.eu-S935171AbXHNUHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935171AbXHNUHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 16:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbXHNUHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 16:07:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbXHNUHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 16:07:23 -0400
Date: Tue, 14 Aug 2007 16:06:47 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ulrich Kunitz <kune@deine-taler.de>, Bret Towe <magnade@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] PIE executable randomization
Message-ID: <20070814200647.GN2063@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <Pine.LNX.4.64.0708081552010.11054@jikos.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708081552010.11054@jikos.suse.cz>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 04:03:07PM +0200, Jiri Kosina wrote:
> @@ -870,11 +917,15 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
>  			 * default mmap base, as well as whatever program they
>  			 * might try to exec.  This is because the brk will
>  			 * follow the loader, and is not movable.  */
> +#ifdef CONFIG_X86
> +			load_bias = 0;
> +#else
>  			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
> +#endif
>  		}
>  
>  		error = elf_map(bprm->file, load_bias + vaddr, elf_ppnt,
> -				elf_prot, elf_flags);
> +				elf_prot, elf_flags,0);
>  		if (BAD_ADDR(error)) {
>  			send_sig(SIGKILL, current, 0);
>  			retval = IS_ERR((void *)error) ?

If I'm reading the above hunk correctly, this means we will randomize
all PIEs and even all dynamic linkers invoked as executables on i?86 and
x86_64, and on the rest of arches we won't randomize at all, instead
load ET_DYN objects at ELF_ET_DYN_BASE address.

But I don't see anything i?86/x86_64 specific on this.

What would make much more sense to me would be conditionalizing on
whether we are loading a dynamic linker (in which case loading it
at ELF_ET_DYN_BASE is desirable or not (PIEs, ...; and for PIEs we
want to randomize on all architectures).

So something like
			if (elf_interpreter)
				load_bias = 0;
			else
				/* Probably dynamic linker invoked as
				   /lib*/ld*so* program args - load at
				   ELF_ET_DYN_BASE.  */
				load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
instead of
#ifdef CONFIG_X86
			load_bias = 0;
#else
			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
#endif

	Jakub
