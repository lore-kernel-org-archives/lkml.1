Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbXEDOkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbXEDOkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbXEDOkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:40:05 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43271 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbXEDOkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:40:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 3/3] boot bzImages under paravirt
References: <1178283582.23670.67.camel@localhost.localdomain>
	<1178283724.23670.70.camel@localhost.localdomain>
	<1178284052.23670.75.camel@localhost.localdomain>
Date: Fri, 04 May 2007 08:38:53 -0600
In-Reply-To: <1178284052.23670.75.camel@localhost.localdomain> (Rusty
	Russell's message of "Fri, 04 May 2007 23:07:32 +1000")
Message-ID: <m1ps5gslfm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:

> (This is kind of a bonus, but it shows how minor the change is to boot
> bzImages)
>
> Skipping over the "cli" and segment loading is enough to allow lguest
> to boot bzImages.  There are some "out" insns in the unpacking code,
> but lguest already has to emulate/skip-over them because of random x86
> probes during boot.
>
> We can no longer assume the launcher has set the bss to zero: we now
> need to zero it ourselves.

Ok.  Although we can hoist the bss zeroing, if everything needs it.

Are you booting with P=V now?  If not I expect you will run
into trouble if you set CONFIG_RELOCATABLE.

> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  Documentation/lguest/lguest.c    |  134 +++++++-------------------------------
>  arch/i386/boot/compressed/head.S |    6 +
>  drivers/lguest/core.c            |    8 +-
>  drivers/lguest/lguest.c          |    2
>  4 files changed, 41 insertions(+), 109 deletions(-)
>
> diff -r 73d71b701360 arch/i386/boot/compressed/head.S
> --- a/arch/i386/boot/compressed/head.S	Fri May 04 22:49:34 2007 +1000
> +++ b/arch/i386/boot/compressed/head.S	Fri May 04 22:51:49 2007 +1000
> @@ -32,6 +32,11 @@
>  	.globl startup_32
>  
>  startup_32:
> +#ifdef CONFIG_PARAVIRT
> +        movl %cs,%eax
> +        andl $0x3,%eax
> +        jnz calc_delta
> +#endif
>  	cld
>  	cli
>  	movl $(__BOOT_DS),%eax
> @@ -48,6 +53,7 @@ startup_32:
>   * data at 0x34-0x3f are used as the stack for this calculation.
>   * Only 4 bytes are needed.
>   */
> +calc_delta:
>  	leal 0x40(%esi), %esp
>  	call 1f
>  1:	popl %ebp

In essence this is ok.  I would like to do the research to see if we
can perhaps just remove the segment reload.  Short of that we should
at least be able to remove the unnecessary preprocessor test for
CONFIG_PARAVIRT.

Hmm.  I'm wondering about the segment reload and how much of a problem
that is.  My memory says that segment reloads are not actually a
privileged operation, so we may be able to support this even in
paravirt mode.  How hard would that be to support?  The segment
we reload is a fixed part of our boot protocol.

Anyway something to research.

> +#warning document this with reference to Documentation/i386/boot.txt
> +	u8 hdr[0x300];
> +	int r;
> +	void *p = (void *)0x100000;
> +
> +	lseek(fd, 0, SEEK_SET);
> +	read(fd, hdr, sizeof(hdr));
> +
> +	lseek(fd, (unsigned long)(hdr[0x1F1]+1) * 512, SEEK_SET);

I guess this works.  You don't handle the old case of set_sectors == 0
but I guess you don't support any kernels where that is the case.

> +
> +	while ((r = read(fd, p, 65535)) > 0)
> +		p += r;
> +
> +	return *(unsigned long *)&hdr[0x214];
>  }
>  
>  /*L:140 Loading the kernel is easy when it's a "vmlinux", but most kernels

Eric
