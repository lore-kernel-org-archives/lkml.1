Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab0CDCam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 21:30:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51105 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab0CDCag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 21:30:36 -0500
Message-ID: <4B8F1B2A.5070500@zytor.com>
Date: Wed, 03 Mar 2010 18:30:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: linux-kernel@vger.kernel.org, rjw@sisk.pl, mingo@elte.hu,
       colin.king@canonical.com
Subject: Re: [PATCH] i386: do a global tlb flush in S4 resume
References: <1267665799-670-1-git-send-email-shaohua.li@intel.com>
In-Reply-To: <1267665799-670-1-git-send-email-shaohua.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 05:23 PM, Shaohua Li wrote:
> Colin reported a strange oops in S4 resume code path (see below). The test
> system has i5/i7 CPU. The kernel doesn't open PAE, so 4M page table is used.
> The oops always happen a virtual address 0xc03ff000, which is mapped to the
> last 4k of first 4M memory. Doing a global tlb flush fixes the issue.
> 
> EIP: 0060:[<c0493a01>] EFLAGS: 00010086 CPU: 0
> EIP is at copy_loop+0xe/0x15
> EAX: 36aeb000 EBX: 00000000 ECX: 00000400 EDX: f55ad46c
> ESI: 0f800000 EDI: c03ff000 EBP: f67fbec4 ESP: f67fbea8
>  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> ...
> ...
> CR2: 00000000c03ff000
> 
> Tested-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---
>  arch/x86/power/hibernate_asm_32.S |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/power/hibernate_asm_32.S b/arch/x86/power/hibernate_asm_32.S
> index b641388..9e4ef64 100644
> --- a/arch/x86/power/hibernate_asm_32.S
> +++ b/arch/x86/power/hibernate_asm_32.S
> @@ -27,10 +27,21 @@ ENTRY(swsusp_arch_suspend)
>  	ret
>  
>  ENTRY(restore_image)
> +	movl	mmu_cr4_features, %ecx
>  	movl	resume_pg_dir, %eax
>  	subl	$__PAGE_OFFSET, %eax
>  	movl	%eax, %cr3
>  
> +	jecxz	1f	# cr4 Pentium and higher, skip if zero
> +	movl	%ecx, %edx
> +	andl	$~(X86_CR4_PGE), %edx
> +	movl	%edx, %cr4;  # turn off PGE
> +1:
> +	movl	%cr3, %eax;  # flush TLB
> +	movl	%eax, %cr3
> +	jecxz	1f	# cr4 Pentium and higher, skip if zero
> +	movl	%ecx, %cr4;  # turn PGE back on
> +1:
>  	movl	restore_pblist, %edx
>  	.p2align 4,,7
>  

Since we're about to do another global page flush a bit further down in
the same code, why not just leave PGE off until then?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

