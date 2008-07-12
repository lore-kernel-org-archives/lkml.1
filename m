Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbYGLUbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbYGLUbS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 16:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYGLUbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 16:31:03 -0400
Received: from THAUM.MIT.EDU ([18.95.3.27]:49133 "EHLO luto.stanford.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751925AbYGLUbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 16:31:01 -0400
Message-ID: <48791484.4010408@myrealbox.com>
Date: Sat, 12 Jul 2008 16:31:00 -0400
From: Andy Lutomirski <luto@myrealbox.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: luto@myrealbox.com, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       kernel-testers-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
References: <200807010148.02135.rjw@sisk.pl> <486A96C1.2020106@firstfloor.org> <48784F51.1010407@myrealbox.com> <200807122051.25634.rjw@sisk.pl>
In-Reply-To: <200807122051.25634.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Saturday, 12 of July 2008, Andy Lutomirski wrote:
>> My Lenovo X61s fails to resume if I suspend it from within X, on both 
>> 2.6.26-rc9 and recent wireless-testing.  2.6.26-rc8 is fine, as is 
>> wireless-testing with 4b4f7280 reverted.  My in-progress bisect between 
>> -rc8 and -rc9 is also consistent with this being the problem.
>>
>> The symptom is that, when I push the power button to resume, the hard 
>> drive light turns on, the fan turns on, then the hard drive light turns 
>> off, the sleep light stays on, and the fan keeps running.  Sometimes the 
>> battery light will blink off very briefly (1/4 sec, maybe) every few 
>> seconds.  The system is locked hard at this point.
>>
>> I'm using Ubuntu Hardy userspace.
> 
> Well, that's bad.
> 
> There is the bugzilla entry at http://bugzilla.kernel.org/show_bug.cgi?id=11064
> for this bug and you've just confirmed my suspicion that this particular
> commit is to blame.
> 
> Can you please see if the appended patch changes anything?

I suspended and resumed OK.  Then I rebooted and tried again, and it failed.

--Andy

> 
> Thanks,
> Rafael
> 
> ---
> From: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Date: Mon, 30 Jun 2008 23:48:35 -0700
> Subject: [PATCH] x86 acpi: on wakeup, ljmp directly after writing CR0.PE
> 
> Impact: possible resume failures on AMD Elan, others?
> 
> Intel documents that writing cr0 should be immediately followed by a
> ljmp, and that "failures are readily seen" if the processor enters SMM
> at this point.  We believe this has been observed on the AMD Elan, so
> stick strictly to the script and do an ljmp immediately after a change
> to CR0.PE in all circumstances.
> 
> Signed-off-by: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/kernel/acpi/realmode/wakeup.S |   11 ++++-------
>  arch/x86/kernel/acpi/realmode/wakeup.h |    6 ++----
>  arch/x86/kernel/acpi/sleep.c           |    4 +++-
>  3 files changed, 9 insertions(+), 12 deletions(-)
> 
> Index: linux-next/arch/x86/kernel/acpi/realmode/wakeup.S
> ===================================================================
> --- linux-next.orig/arch/x86/kernel/acpi/realmode/wakeup.S
> +++ linux-next/arch/x86/kernel/acpi/realmode/wakeup.S
> @@ -25,10 +25,8 @@ pmode_gdt:	.quad	0
>  realmode_flags:	.long	0
>  real_magic:	.long	0
>  trampoline_segment:	.word 0
> -_pad1:		.byte	0
> -wakeup_jmp:	.byte	0xea	/* ljmpw */
> -wakeup_jmp_off:	.word	3f
> -wakeup_jmp_seg:	.word	0
> +wakeup_seg_ptr:	.word	3f-2	/* the segment in the ljmpw */
> +_pad:		.long	0
>  wakeup_gdt:	.quad	0, 0, 0
>  signature:	.long	0x51ee1111
>  
> @@ -49,8 +47,7 @@ _start:
>  	movl	%cr0, %eax
>  	orb	$X86_CR0_PE, %al
>  	movl	%eax, %cr0
> -	jmp	1f
> -1:	ljmpw	$8, $2f
> +	ljmpw	$8, $2f
>  2:
>  	movw	%cx, %ds
>  	movw	%cx, %es
> @@ -60,7 +57,7 @@ _start:
>  
>  	andb	$~X86_CR0_PE, %al
>  	movl	%eax, %cr0
> -	jmp	wakeup_jmp
> +	ljmpw	$0, $3f
>  3:
>  	/* Set up segments */
>  	movw	%cs, %ax
> Index: linux-next/arch/x86/kernel/acpi/realmode/wakeup.h
> ===================================================================
> --- linux-next.orig/arch/x86/kernel/acpi/realmode/wakeup.h
> +++ linux-next/arch/x86/kernel/acpi/realmode/wakeup.h
> @@ -24,10 +24,8 @@ struct wakeup_header {
>  	u32 realmode_flags;
>  	u32 real_magic;
>  	u16 trampoline_segment;	/* segment with trampoline code, 64-bit only */
> -	u8  _pad1;
> -	u8  wakeup_jmp;
> -	u16 wakeup_jmp_off;
> -	u16 wakeup_jmp_seg;
> +	u16 wakeup_seg_ptr;
> +	u32 _pad;
>  	u64 wakeup_gdt[3];
>  	u32 signature;		/* To check we have correct structure */
>  } __attribute__((__packed__));
> Index: linux-next/arch/x86/kernel/acpi/sleep.c
> ===================================================================
> --- linux-next.orig/arch/x86/kernel/acpi/sleep.c
> +++ linux-next/arch/x86/kernel/acpi/sleep.c
> @@ -34,6 +34,7 @@ static char temp_stack[10240];
>  int acpi_save_state_mem(void)
>  {
>  	struct wakeup_header *header;
> +	u16 *wakeup_seg;
>  
>  	if (!acpi_realmode) {
>  		printk(KERN_ERR "Could not allocate memory during boot, "
> @@ -43,6 +44,7 @@ int acpi_save_state_mem(void)
>  	memcpy((void *)acpi_realmode, &wakeup_code_start, WAKEUP_SIZE);
>  
>  	header = (struct wakeup_header *)(acpi_realmode + HEADER_OFFSET);
> +	wakeup_seg = (u16 *)(acpi_realmode + header->wakeup_seg_ptr);
>  	if (header->signature != 0x51ee1111) {
>  		printk(KERN_ERR "wakeup header does not match\n");
>  		return -EINVAL;
> @@ -50,7 +52,7 @@ int acpi_save_state_mem(void)
>  
>  	header->video_mode = saved_video_mode;
>  
> -	header->wakeup_jmp_seg = acpi_wakeup_address >> 4;
> +	*wakeup_seg = acpi_wakeup_address >> 4;
>  	/* GDT[0]: GDT self-pointer */
>  	header->wakeup_gdt[0] =
>  		(u64)(sizeof(header->wakeup_gdt) - 1) +

