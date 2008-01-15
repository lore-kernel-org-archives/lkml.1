Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbYAOWIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbYAOWIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYAOWIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:08:10 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58130 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750890AbYAOWIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:08:09 -0500
Date: Tue, 15 Jan 2008 23:08:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Eric Dumazet <dada1@cosmosbay.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386 : Make arch/x86/kernel/acpi/wakeup_32.S use a
	separate text section
Message-ID: <20080115220815.GA1565@elf.ucw.cz>
References: <20080103210426.35543645.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103210426.35543645.dada1@cosmosbay.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-01-03 21:04:26, Eric Dumazet wrote:
> While examining vmlinux namelist on i386 (nm -v vmlinux) I noticed :
> 
> c01021d0 t es7000_rename_gsi
> c010221a T es7000_start_cpu
> <Big Hole>
> c0103000 T thread_saved_pc
> 
> and 
> 
> c0113218 T acpi_restore_state_mem
> c0113219 T acpi_save_state_mem
> <Big Hole>
> c0114000 t wakeup_code
> 
> This is because arch/x86/kernel/acpi/wakeup_32.S forces a .text alignment
> of 4096 bytes. (I have no idea if it is really needed, since 
> arch/x86/kernel/acpi/wakeup_64.S uses a 16 bytes alignment *only*)
> 
> So arch/x86/kernel/built-in.o also has this alignment
> 
> arch/x86/kernel/built-in.o:     file format elf32-i386
> 
> Sections:
> Idx Name          Size      VMA       LMA       File off  Algn
>   0 .text         00018c94  00000000  00000000  00001000  2**12
>                   CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
> 
> But as arch/x86/kernel/acpi/wakeup_32.o is not the first object linked
> into arch/x86/kernel/built-in.o, linker had to build several holes to meet
> alignement requirements, because of .o nestings in the kbuild process.
> 
> This can be solved by using a special section, .text.page_aligned, so that
> no holes are needed.
> 
> 
> # size vmlinux.before vmlinux.after
>    text    data     bss     dec     hex filename
> 4619942  422838  458752 5501532  53f25c vmlinux.before
> 4610534  422838  458752 5492124  53cd9c vmlinux.after
> 
> This saves 9408 bytes
> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

Seems okay to me, but I did not test it.

> diff --git a/arch/x86/kernel/acpi/wakeup_32.S b/arch/x86/kernel/acpi/wakeup_32.S
> index 1e931aa..f53e327 100644
> --- a/arch/x86/kernel/acpi/wakeup_32.S
> +++ b/arch/x86/kernel/acpi/wakeup_32.S
> @@ -1,4 +1,4 @@
> -.text
> +	.section .text.page_aligned
>  #include <linux/linkage.h>
>  #include <asm/segment.h>
>  #include <asm/page.h>
> diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
> index 7d72cce..113a831 100644
> --- a/arch/x86/kernel/vmlinux_32.lds.S
> +++ b/arch/x86/kernel/vmlinux_32.lds.S
> @@ -44,6 +44,8 @@ SECTIONS
>  
>    /* read-only */
>    .text : AT(ADDR(.text) - LOAD_OFFSET) {
> +	. = ALIGN(4096); /* not really needed, already page aligned */
> +	*(.text.page_aligned)
>  	TEXT_TEXT
>  	SCHED_TEXT
>  	LOCK_TEXT
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
