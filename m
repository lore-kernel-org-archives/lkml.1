Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbYENUxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbYENUxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 16:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbYENUxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 16:53:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbYENUxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 16:53:42 -0400
Date: Wed, 14 May 2008 16:52:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm] kexec jump -v9
Message-ID: <20080514205204.GJ30469@redhat.com>
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204773188.4707.109.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 11:13:08AM +0800, Huang, Ying wrote:
> This is a minimal patch with only the essential features. All
> additional features are split out and can be discussed later. I think
> it may be easier to get consensus on this minimal patch.
> 
> Best Regards,
> Huang Ying
> 
> ------------------------------------>
> 
> This patch provides an enhancement to kexec/kdump. It implements
> the following features:
> 
> - Jumping between the original kernel and the kexeced kernel.
> 
> - Backup/restore memory used by both the original kernel and the
>   kexeced kernel.
> 
> - Save/restore CPU and devices state before after kexec.
> 

Hi Huang,

Ok, I have done some testing on this patch. Currently I have just
tested switching back and forth between two kernels and it is working for
me.

Just that I had to put LAPIC and IOAPIC in legacy mode for it to work. Few
comments/questions are inline.

[..]
>  	.text
>  	.align PAGE_ALIGNED
> +	.global kexec_relocate_page
> +kexec_relocate_page:
> +
> +/*
> + * Entry point for jumping back from kexeced kernel, the paging is
> + * turned off.
> + */
> +kexec_jump_back_entry:
> +	call	1f
> +1:
> +	popl	%ebx
> +	subl	$(1b - kexec_relocate_page), %ebx
> +	movl	%edi, KJUMP_ENTRY_OFF(%ebx)
> +	movl	CP_VA_CONTROL_PAGE(%ebx), %edi
> +	lea	STACK_TOP(%ebx), %esp
> +	movl	CP_PA_SWAP_PAGE(%ebx), %eax
> +	movl	CP_PA_BACKUP_PAGES_MAP(%ebx), %edx
> +	pushl	%eax
> +	pushl	%edx
> +	call	swap_pages
> +	addl	$8, %esp
> +	movl	CP_PA_PGD(%ebx), %eax
> +	movl	%eax, %cr3
> +	movl	%cr0, %eax
> +	orl	$(1<<31), %eax
> +	movl	%eax, %cr0
> +	lea	STACK_TOP(%edi), %esp
> +	movl	%edi, %eax
> +	addl	$(virtual_mapped - kexec_relocate_page), %eax
> +	pushl	%eax
> +	ret

Upon re-entering the kernel, what happens to GDT table? So gdtr will be
pointing to GDT of other kernel (which is not there as pages have been
swapped)? Do we need to reload the gdtr upon re-entering the kernel.

[..]
> @@ -197,8 +282,54 @@ identity_mapped:
>  	xorl	%eax, %eax
>  	movl	%eax, %cr3
>  
> +	movl	CP_PA_SWAP_PAGE(%edi), %eax
> +	pushl	%eax
> +	pushl	%ebx
> +	call	swap_pages
> +	addl	$8, %esp
> +
> +	/* To be certain of avoiding problems with self-modifying code
> +	 * I need to execute a serializing instruction here.
> +	 * So I flush the TLB, it's handy, and not processor dependent.
> +	 */
> +	xorl	%eax, %eax
> +	movl	%eax, %cr3
> +
> +	/* set all of the registers to known values */
> +	/* leave %esp alone */
> +
> +	movl	KJUMP_MAGIC_OFF(%edi), %eax
> +	cmpl	$KJUMP_MAGIC_NUMBER, %eax
> +	jz 1f
> +	xorl	%edi, %edi
> +	xorl	%eax, %eax
> +	xorl	%ebx, %ebx
> +	xorl    %ecx, %ecx
> +	xorl    %edx, %edx
> +	xorl    %esi, %esi
> +	xorl    %ebp, %ebp
> +	ret
> +1:
> +	popl	%edx
> +	movl	CP_PA_SWAP_PAGE(%edi), %esp
> +	addl	$PAGE_SIZE_asm, %esp
> +	pushl	%edx
> +2:
> +	call	*%edx

> +	movl	%edi, %edx
> +	popl	%edi
> +	pushl	%edx
> +	jmp	2b
> +

What does above piece of code do? Looks like redundant for switching
between the kernels? After call *%edx, we never return here. Instead
we come back to "kexec_jump_back_entry"?


[..]
> --- /dev/null
> +++ b/Documentation/i386/jump_back_protocol.txt
> @@ -0,0 +1,66 @@
> +		THE LINUX/I386 JUMP BACK PROTOCOL
> +		---------------------------------
> +
> +		Huang Ying <ying.huang@intel.com>
> +		    Last update 2007-12-19
> +
> +Currently, the following versions of the jump back protocol exist.
> +
> +Protocol 1.00:	Jumping between original kernel and kexeced kernel
> +		support. Calling ordinary C function support.
> +
> +
> +*** JUMP BACK ENTRY
> +
> +At jump back entry of callee, the CPU must be in 32-bit protected mode
> +with paging disabled; the CS, DS, ES and SS must be 4G flat segments;
> +CS must have execute/read permission, and DS, ES and SS must have
> +read/write permission; interrupt must be disabled; the contents of
> +registers and corresponding memory must be as follow:
> +
> +Offset/Size	Meaning
> +
> +%edi		Real jump back entry of caller if supported,
> +		otherwise 0.
> +%esp		Stack top pointer, the size of stack is about 4k bytes.
> +(%esp)/4	Helper jump back entry of caller if %edi != 0,
> +		otherwise undefined.
> +

I am not sure what is helper jump back entry? I understand that you 
are using %edi to pass around entry point between two kernels. Can
you please shed some more light on this?

Thanks
Vivek
