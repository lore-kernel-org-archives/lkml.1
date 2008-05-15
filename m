Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbYEOC1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbYEOC1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 22:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbYEOC1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 22:27:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:43066 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbYEOC07 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 22:26:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,489,1204531200"; 
   d="scan'208";a="247034763"
Subject: Re: [PATCH -mm] kexec jump -v9
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080514205204.GJ30469@redhat.com>
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
	 <20080514205204.GJ30469@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 15 May 2008 10:32:42 +0800
Message-ID: <1210818762.23707.102.camel@caritas-dev.intel.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 15 May 2008 02:26:17.0066 (UTC) FILETIME=[0DC4FCA0:01C8B633]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-14 at 16:52 -0400, Vivek Goyal wrote:
[...]
> Ok, I have done some testing on this patch. Currently I have just
> tested switching back and forth between two kernels and it is working for
> me.

Thanks.

[...]
> > +/*
> > + * Entry point for jumping back from kexeced kernel, the paging is
> > + * turned off.
> > + */
> > +kexec_jump_back_entry:
> > +	call	1f
> > +1:
> > +	popl	%ebx
> > +	subl	$(1b - kexec_relocate_page), %ebx
> > +	movl	%edi, KJUMP_ENTRY_OFF(%ebx)
> > +	movl	CP_VA_CONTROL_PAGE(%ebx), %edi
> > +	lea	STACK_TOP(%ebx), %esp
> > +	movl	CP_PA_SWAP_PAGE(%ebx), %eax
> > +	movl	CP_PA_BACKUP_PAGES_MAP(%ebx), %edx
> > +	pushl	%eax
> > +	pushl	%edx
> > +	call	swap_pages
> > +	addl	$8, %esp
> > +	movl	CP_PA_PGD(%ebx), %eax
> > +	movl	%eax, %cr3
> > +	movl	%cr0, %eax
> > +	orl	$(1<<31), %eax
> > +	movl	%eax, %cr0
> > +	lea	STACK_TOP(%edi), %esp
> > +	movl	%edi, %eax
> > +	addl	$(virtual_mapped - kexec_relocate_page), %eax
> > +	pushl	%eax
> > +	ret
> 
> Upon re-entering the kernel, what happens to GDT table? So gdtr will be
> pointing to GDT of other kernel (which is not there as pages have been
> swapped)? Do we need to reload the gdtr upon re-entering the kernel.

After re-entering the kernel and returning from machine_kexec,
restore_processor_state() is called, where the GDTR and some other CPU
state such as FPU, IDT, etc are restored.

> [..]
> > @@ -197,8 +282,54 @@ identity_mapped:
> >  	xorl	%eax, %eax
> >  	movl	%eax, %cr3
> >  
> > +	movl	CP_PA_SWAP_PAGE(%edi), %eax
> > +	pushl	%eax
> > +	pushl	%ebx
> > +	call	swap_pages
> > +	addl	$8, %esp
> > +
> > +	/* To be certain of avoiding problems with self-modifying code
> > +	 * I need to execute a serializing instruction here.
> > +	 * So I flush the TLB, it's handy, and not processor dependent.
> > +	 */
> > +	xorl	%eax, %eax
> > +	movl	%eax, %cr3
> > +
> > +	/* set all of the registers to known values */
> > +	/* leave %esp alone */
> > +
> > +	movl	KJUMP_MAGIC_OFF(%edi), %eax
> > +	cmpl	$KJUMP_MAGIC_NUMBER, %eax
> > +	jz 1f
> > +	xorl	%edi, %edi
> > +	xorl	%eax, %eax
> > +	xorl	%ebx, %ebx
> > +	xorl    %ecx, %ecx
> > +	xorl    %edx, %edx
> > +	xorl    %esi, %esi
> > +	xorl    %ebp, %ebp
> > +	ret
> > +1:
> > +	popl	%edx
> > +	movl	CP_PA_SWAP_PAGE(%edi), %esp
> > +	addl	$PAGE_SIZE_asm, %esp
> > +	pushl	%edx
> > +2:
> > +	call	*%edx
> 
> > +	movl	%edi, %edx
> > +	popl	%edi
> > +	pushl	%edx
> > +	jmp	2b
> > +
> 
> What does above piece of code do? Looks like redundant for switching
> between the kernels? After call *%edx, we never return here. Instead
> we come back to "kexec_jump_back_entry"?

For switching between the kernels, this is redundant. Originally another
feature of kexec jump is to call some code in physical mode. ﻿This is
used to provide a C ABI to called code.

Now, Eric suggests to use a C ABI compatible mode to pass the jump back
entry point too, that is, use the return address on stack instead of %
edi. I think that is reasonable. Maybe we can revise this code to be
compatible with C ABI and provide a convenient interface for both kernel
and other physical mode code.

> [..]
> > --- /dev/null
> > +++ b/Documentation/i386/jump_back_protocol.txt
> > @@ -0,0 +1,66 @@
> > +		THE LINUX/I386 JUMP BACK PROTOCOL
> > +		---------------------------------
> > +
> > +		Huang Ying <ying.huang@intel.com>
> > +		    Last update 2007-12-19
> > +
> > +Currently, the following versions of the jump back protocol exist.
> > +
> > +Protocol 1.00:	Jumping between original kernel and kexeced kernel
> > +		support. Calling ordinary C function support.
> > +
> > +
> > +*** JUMP BACK ENTRY
> > +
> > +At jump back entry of callee, the CPU must be in 32-bit protected mode
> > +with paging disabled; the CS, DS, ES and SS must be 4G flat segments;
> > +CS must have execute/read permission, and DS, ES and SS must have
> > +read/write permission; interrupt must be disabled; the contents of
> > +registers and corresponding memory must be as follow:
> > +
> > +Offset/Size	Meaning
> > +
> > +%edi		Real jump back entry of caller if supported,
> > +		otherwise 0.
> > +%esp		Stack top pointer, the size of stack is about 4k bytes.
> > +(%esp)/4	Helper jump back entry of caller if %edi != 0,
> > +		otherwise undefined.
> > +
> 
> I am not sure what is helper jump back entry? I understand that you 
> are using %edi to pass around entry point between two kernels. Can
> you please shed some more light on this?

Helper jump back entry is used to provide a C ABI to some physical mode
code other than kernel. It is the above redundant code.

Best Regards,
Huang Ying

