Return-Path: <linux-kernel-owner+w=401wt.eu-S1760687AbXJYRCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687AbXJYRCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 13:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757833AbXJYRCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 13:02:33 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33390 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbXJYRCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 13:02:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Huang, Ying" <ying.huang@intel.com>
Cc: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic runtime service support
References: <1193295473.23935.202.camel@caritas-dev.intel.com>
Date: Thu, 25 Oct 2007 11:01:54 -0600
In-Reply-To: <1193295473.23935.202.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Thu, 25 Oct 2007 14:57:53 +0800")
Message-ID: <m1myu75drx.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:

> +static void __init efi_call_phys_prelog(void) __acquires(efi_lock)
> +{
> +	unsigned long vaddress;
> +
> +	/*
> +	 * Lock sequence is different from normal case because
> +	 * efi_flags is global
> +	 */
> +	spin_lock(&efi_lock);
> +	local_irq_save(efi_flags);
> +	early_runtime_code_mapping_set_exec(1);
> +	vaddress = (unsigned long)__va(0x0UL);
> +	pgd_val(save_pgd) = pgd_val(*pgd_offset_k(0x0UL));
> +	set_pgd(pgd_offset_k(0x0UL), *pgd_offset_k(vaddress));
> +	global_flush_tlb();
> +}
> +
> +static void __init efi_call_phys_epilog(void) __releases(efi_lock)
> +{
> +	/*
> +	 * After the lock is released, the original page table is restored.
> +	 */
> +	set_pgd(pgd_offset_k(0x0UL), save_pgd);
> +	early_runtime_code_mapping_set_exec(0);
> +	global_flush_tlb();
> +	local_irq_restore(efi_flags);
> +	spin_unlock(&efi_lock);
> +}
> +
> +static efi_status_t __init phys_efi_set_virtual_address_map(
> +	unsigned long memory_map_size,
> +	unsigned long descriptor_size,
> +	u32 descriptor_version,
> +	efi_memory_desc_t *virtual_map)
> +{
> +	efi_status_t status;
> +
> +	efi_call_phys_prelog();
> +	status = lin2win4((void *)efi_phys.set_virtual_address_map,
> +			  (u64)memory_map_size, (u64)descriptor_size,
> +			  (u64)descriptor_version, (u64)virtual_map);
> +	efi_call_phys_epilog();
> +	return status;
> +}

So you still have this piece of code which makes a kernel using
efi not compatible with kexec.  But you are still supporting a physical
call mode for efi.  If you are going to do this can we please just
remove the hacks that make the EFI physical call mode early boot only
and just always use that mode.  Depending on weird call once functions
like efi_set_virtual_address_map makes me very uncomfortable.

Eric
