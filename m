Return-Path: <linux-kernel-owner+w=401wt.eu-S1757771AbZJDS7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbZJDS7H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 14:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757663AbZJDS7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 14:59:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57334 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbZJDS7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 14:59:04 -0400
Date: Sun, 4 Oct 2009 20:58:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Shane Wang <shane.wang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>
Subject: Re: [PATCH] intel_txt: add s3 userspace memory integrity
	verification
Message-ID: <20091004185801.GC1378@ucw.cz>
References: <4A9CE0B2.5060608@intel.com> <4ABF2B50.6070106@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABF2B50.6070106@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-09-27 17:07:28, Shane Wang wrote:
> This patch added verification for userspace memory integrity after s3 resume.
> Integrity verification for other memory (say kernel itself) has been done by tboot.
>

AFAICT, it verifies userspace _and_ kernel memory, that's why it does
magic stack switching. Why not verify everything in tboot?

Is kernel<->tboot abi described somewhere?

> @@ -168,6 +174,80 @@ static void tboot_create_trampoline(void
>  		      map_base, map_size);
>  }
>
> +static vmac_t mem_mac;
> +static struct crypto_hash *tfm;

Could these be automatic?

> +	for_each_online_pgdat(pgdat) {
> +		for (i = 0, pfn = pgdat->node_start_pfn;
> +			i < pgdat->node_spanned_pages;
> +			i++, pfn = pgdat->node_start_pfn + i) {
> +
> +			if (!pfn_valid(pfn) || !page_is_ram(pfn))
> +				continue;
> +
> +			page = pfn_to_page(pfn);
> +			paddr = page_to_phys(page);
> +
> +			/* If pg will be MACed by tboot, no need to MAC here */
> +			for (j = 0; j < tboot->num_mac_regions; j++) {
> +				rstart = tboot->mac_regions[j].start;
> +				rend = rstart +	tboot->mac_regions[j].size;
> +				if (((paddr + PAGE_SIZE) <= rstart)
> +					|| (rend <= paddr))
> +					continue;
> +				break;
> +			}
> +
> +			if (j == tboot->num_mac_regions) {
> +				sg_set_page(sg, page, PAGE_SIZE, 0);
> +				ret = crypto_hash_update(&desc, sg, PAGE_SIZE);
> +				if (ret)
> +					return ret;
> +			}
> +		}
> +	}

This looks over all memory, afaict. Does it correctly handle highmem?

> @@ -197,6 +277,16 @@ static int tboot_setup_sleep(void)
>  	/* kernel code + data + bss */
>  	add_mac_region(virt_to_phys(_text), _end - _text);
>
> +	/* stack */
> +	add_mac_region(virt_to_phys(current_thread_info()), THREAD_SIZE);
> +
> +	/* MAC userspace memory not handled by tboot */
> +	get_random_bytes(tboot->s3_key, sizeof(tboot->s3_key));
> +	if (tboot_gen_mem_integrity(tboot->s3_key, &mem_mac)) {
> +		panic("tboot: vmac generation failed\n");
> +		return -1;
> +	}
> +
>  	tboot->acpi_sinfo.kernel_s3_resume_vector = acpi_wakeup_address;
>
>  	return 0;
> @@ -212,6 +302,68 @@ static int tboot_setup_sleep(void)
>  }
>
>  #endif
> +
> +static struct thread_info *low_ti, *current_ti;
> +
> +static void tboot_do_stack_switch(struct thread_info *new_ti,
> +				struct thread_info *old_ti)
> +{
> +	memcpy(new_ti, old_ti, THREAD_SIZE);

Memcpy does some rather odd stuff with fpu in some
configs. Like... you may get copy of thread info with fpu marked
enabled, while it really is disabled when memcpy exits.

> +#ifdef CONFIG_X86_32
> +	asm volatile (
> +		" and %0, %%esp;        "
> +		" add %1, %%esp;        "
> +		: : "i" (THREAD_SIZE - 1), "r" (new_ti));
> +#else
> +	asm volatile (
> +		" and %0, %%rsp;        "
> +		" add %1, %%rsp;        "
> +		: : "i" (THREAD_SIZE - 1), "r" (new_ti));
> +	percpu_write(kernel_stack, (unsigned long)new_ti -
> +				KERNEL_STACK_OFFSET + THREAD_SIZE);
> +#endif
> +	current->stack = new_ti;
> +}

This is pretty subtle&fragile -- see memcpy above. Why is it needed?

> +	current_ti = current_thread_info();
> +
> +	/* If thread info is above 4G, then switch stack */
> +	if (!((PFN_PHYS(PFN_DOWN(virt_to_phys(current_ti)))
> +		+ (PFN_UP(THREAD_SIZE) << PAGE_SHIFT))
> +		& 0xffffffff00000000ULL))
> +		return;

How can thread info be above 4G on 32-bit?

Why does 4G limit matter on 64-bit?

> +void tboot_sx_resume(void)
> +{
> +	vmac_t mac;
> +
> +	if (!tboot_enabled())
> +		return;
> +
> +	if (tboot_gen_mem_integrity(tboot->s3_key, &mac))
> +		panic("tboot: vmac generation failed\n");
> +	else if (mac != mem_mac)
> +		panic("tboot: memory integrity was lost on resume\n");
> +	else
> +		pr_info("memory integrity OK\n");

So I corrupt memory, but also corrupt tboot_enabled() to return 0....

And... does panic kill the machine quickly enough that no 'bad stuff'
happens? (Whats bad stuff in this context, anyway?).

> @@ -244,7 +245,10 @@ static int acpi_suspend_enter(suspend_st
>  		break;
>
>  	case ACPI_STATE_S3:
> +		tboot_switch_stack();
>  		do_suspend_lowlevel();
> +		tboot_sx_resume();
> +		tboot_restore_stack();
>  		break;
>  	}
>

Did you audit all code before sx_resume()? If it trusts  data not
checksummed by tboot, attacker may be able to hijack code execution
and bypass your protection, no? 

What about S1? 

And what about hibernation, btw?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
