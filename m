Return-Path: <linux-kernel-owner+w=401wt.eu-S1759115AbZBFPa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115AbZBFPa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbZBFPaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:30:06 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:64393 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753936AbZBFPaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:30:01 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
In-Reply-To: <ab45a6865df539a36a75.1233862277@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
	 <ab45a6865df539a36a75.1233862277@abulafia.goop.org>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 15:29:10 +0000
Message-Id: <1233934150.20597.26.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH 35 of 36] x86: make pgd/pud/pmd/pte_none consistent
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=NkRAZMAOj8gA:10 a=x2RMdOTEVusA:10 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=46H59DIldnaYA86hrAYA:9 a=2uzKpvonEZhOZxAvE-cA:7 a=ZSw4XztRxBLTKmt5rNDB1xgO1ZcA:4 a=LY0hPdMaydYA:10 a=6O0IECtVFhoA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-05 at 11:31 -0800, Jeremy Fitzhardinge wrote:
> The _none test is done differently for every level of the pagetable.
> Standardize them by:
> 
>  1: Use the native_X_val to extract the raw entry, with no need to go
>     via paravirt_ops, diff -r 1d0646d0d319 arch/x86/include/asm/pgtable.h, and
>  2: Compare with 0 rather than using a boolean !, since they are actually values
>     and not booleans.

In a 32 bit Xen guest this one causes

        [    8.354898] 1 multicall(s) failed: cpu 1
        [    8.354921] Pid: 2213, comm: bootclean Not tainted 2.6.29-rc3-x86_32p-xenU-tip #135
        [    8.354937] Call Trace:
        [    8.354955]  [<c01036e3>] xen_mc_flush+0x133/0x1b0
        [    8.354971]  [<c0105d2a>] ? xen_force_evtchn_callback+0x1a/0x30
        [    8.354988]  [<c0105a60>] xen_flush_tlb_others+0xb0/0xd0
        [    8.355003]  [<c0126643>] flush_tlb_page+0x53/0xa0
        [    8.355018]  [<c0176a80>] do_wp_page+0x2a0/0x7c0
        [    8.355034]  [<c0238f0a>] ? notify_remote_via_irq+0x3a/0x70
        [    8.355049]  [<c0178950>] handle_mm_fault+0x7b0/0xa50
        [    8.355065]  [<c0131a3e>] ? wake_up_new_task+0x8e/0xb0
        [    8.355079]  [<c01337b5>] ? do_fork+0xe5/0x320
        [    8.355095]  [<c0121919>] do_page_fault+0xe9/0x240
        [    8.355109]  [<c0121830>] ? do_page_fault+0x0/0x240
        [    8.355125]  [<c032457a>] error_code+0x72/0x78
        [    8.355139]   call  1/1: op=2863311530 arg=[aaaaaaaa] result=-38	xen_flush_tlb_others+0x41/0xd0
        [    8.355161] ------------[ cut here ]------------
        [    8.355172] kernel BUG at /local/scratch/ianc/devel/kernels/paravirt/arch/x86/xen/multicalls.c:182!
        [    8.355189] invalid opcode: 0000 [#1] SMP 
        [    8.355207] last sysfs file: /sys/class/net/lo/operstate
        [    8.355218] Modules linked in:
        [    8.355230] 
        [    8.355239] Pid: 2213, comm: bootclean Not tainted (2.6.29-rc3-x86_32p-xenU-tip #135) 
        [    8.355254] EIP: 0061:[<c010374b>] EFLAGS: 00010002 CPU: 1
        [    8.355267] EIP is at xen_mc_flush+0x19b/0x1b0
        [    8.355278] EAX: 00000000 EBX: 00000000 ECX: c10cc060 EDX: 00000000
        [    8.355290] ESI: 00000000 EDI: 00000001 EBP: c4c61e70 ESP: c4c61e40
        [    8.355302]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0069
        [    8.355314] Process bootclean (pid: 2213, ti=c4c60000 task=c5ad3460 task.ti=c4c60000)
        [    8.355328] Stack:
        [    8.355336]  c0367d84 00000001 00000001 aaaaaaaa aaaaaaaa ffffffda c01059f1 c10cc060
        [    8.355372]  c10c0060 c4c7a6d4 bfabf790 bfabf790 c4c61e80 c0105a60 c4c7a6d4 c4c7a580
        [    8.355413]  c4c61ea0 c0126643 00000000 80000000 00000025 08428067 80000000 c4c
        
Didn't figure out why yet.

> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> ---
>  arch/x86/include/asm/pgtable.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -503,7 +503,7 @@
>  {
>  	/* Only check low word on 32-bit platforms, since it might be
>  	   out of sync with upper half. */
> -	return !(unsigned long)native_pmd_val(pmd);
> +	return (unsigned long)native_pmd_val(pmd) == 0;
>  }
>  
>  static inline unsigned long pmd_page_vaddr(pmd_t pmd)
> @@ -568,7 +568,7 @@
>  #if PAGETABLE_LEVELS > 2
>  static inline int pud_none(pud_t pud)
>  {
> -	return pud_val(pud) == 0;
> +	return native_pud_val(pud) == 0;
>  }
>  
>  static inline int pud_present(pud_t pud)
> @@ -643,7 +643,7 @@
>  
>  static inline int pgd_none(pgd_t pgd)
>  {
> -	return !pgd_val(pgd);
> +	return !native_pgd_val(pgd);
>  }
>  #endif	/* PAGETABLE_LEVELS > 3 */
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
-- 
Ian Campbell

I can resist anything but temptation.

