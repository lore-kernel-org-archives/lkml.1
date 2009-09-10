Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbZIJKNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbZIJKNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbZIJKNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:13:40 -0400
Received: from tundra.namei.org ([65.99.196.166]:39022 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbZIJKNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:13:39 -0400
Date: Thu, 10 Sep 2009 20:12:04 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Roland McGrath <roland@redhat.com>
cc: John Reiser <jreiser@bitwagon.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: binfmt_elf PT_INTERP gets EFAULT if no PROT_WRITE
In-Reply-To: <20090909024940.850948BECA@magilla.sf.frob.com>
Message-ID: <alpine.LRH.2.00.0909102011390.3312@tundra.namei.org>
References: <4AA6F653.1010007@bitwagon.com> <20090909024940.850948BECA@magilla.sf.frob.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009, Roland McGrath wrote:

> Good catch, John.  But I prefer a different fix.  
> 
> I've reproduced the bug with the test case John included,
> and verified that my change fixes it too.

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

(cc stable).

> 
> 
> Thanks,
> Roland
> 
> ---
> [PATCH] binfmt_elf: fix PT_INTERP bss handling
> 
> In fs/binfmt_elf.c, load_elf_interp() calls padzero() for .bss even if
> the PT_LOAD has no PROT_WRITE and no .bss.  This generates EFAULT.
> 
> Here is a small test case.  (Yes, there are other, useful PT_INTERP
> which have only .text and no .data/.bss.)
> 
> 	----- ptinterp.S
> 	_start: .globl _start
> 		 nop
> 		 int3
> 	-----
> 	$ gcc -m32 -nostartfiles -nostdlib -o ptinterp ptinterp.S
> 	$ gcc -m32 -Wl,--dynamic-linker=ptinterp -o hello hello.c
> 	$ ./hello
> 	Segmentation fault  # during execve() itself
> 
> 	After applying the patch:
> 	$ ./hello
> 	Trace trap  # user-mode execution after execve() finishes
> 
> If the ELF headers are actually self-inconsistent, then dying is fine.
> But having no PROT_WRITE segment is perfectly normal and correct if
> there is no segment with p_memsz > p_filesz (i.e. bss).  John Reiser
> suggested checking for PROT_WRITE in the bss logic.  I think it makes
> most sense to simply apply the bss logic only when there is bss.
> 
> This patch looks less trivial than it is due to some reindentation.
> It just moves the "if (last_bss > elf_bss) {" test up to include the
> partial-page bss logic as well as the more-pages bss logic.
> 
> Reported-by: John Reiser <jreiser@bitwagon.com>
> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  fs/binfmt_elf.c |   28 ++++++++++++++--------------
>  1 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index b7c1603..7c1e65d 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -501,22 +501,22 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
>  		}
>  	}
>  
> -	/*
> -	 * Now fill out the bss section.  First pad the last page up
> -	 * to the page boundary, and then perform a mmap to make sure
> -	 * that there are zero-mapped pages up to and including the 
> -	 * last bss page.
> -	 */
> -	if (padzero(elf_bss)) {
> -		error = -EFAULT;
> -		goto out_close;
> -	}
> +	if (last_bss > elf_bss) {
> +		/*
> +		 * Now fill out the bss section.  First pad the last page up
> +		 * to the page boundary, and then perform a mmap to make sure
> +		 * that there are zero-mapped pages up to and including the
> +		 * last bss page.
> +		 */
> +		if (padzero(elf_bss)) {
> +			error = -EFAULT;
> +			goto out_close;
> +		}
>  
> -	/* What we have mapped so far */
> -	elf_bss = ELF_PAGESTART(elf_bss + ELF_MIN_ALIGN - 1);
> +		/* What we have mapped so far */
> +		elf_bss = ELF_PAGESTART(elf_bss + ELF_MIN_ALIGN - 1);
>  
> -	/* Map the last of the bss segment */
> -	if (last_bss > elf_bss) {
> +		/* Map the last of the bss segment */
>  		down_write(&current->mm->mmap_sem);
>  		error = do_brk(elf_bss, last_bss - elf_bss);
>  		up_write(&current->mm->mmap_sem);
> 

-- 
James Morris
<jmorris@namei.org>
