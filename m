Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbYAFTP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbYAFTP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 14:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYAFTPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 14:15:49 -0500
Received: from tapir.sajinet.com.pe ([66.139.79.212]:42512 "EHLO
	tapir.sajinet.com.pe" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbYAFTPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 14:15:48 -0500
X-Greylist: delayed 1666 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jan 2008 14:15:48 EST
Date: Sun, 6 Jan 2008 12:57:28 -0600
From: Carlo Marcelo Arenas Belon <carenas@sajinet.com.pe>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       Marcelo Tosatti <marcelo@kvack.org>
Subject: Re: [kvm-devel] [PATCH 02/33] KVM: MMU: emulated cmpxchg8b should be atomic on i386
Message-ID: <20080106185728.GA21491@tapir>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com> <1199630379-28638-3-git-send-email-avi@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199630379-28638-3-git-send-email-avi@qumranet.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 04:39:08PM +0200, Avi Kivity wrote:
> From: Marcelo Tosatti <marcelo@kvack.org>
> 
> Emulate cmpxchg8b atomically on i386. This is required to avoid a guest
> pte walker from seeing a splitted write.
> 
> [avi: make it compile]
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Avi Kivity <avi@qumranet.com>
> ---

This one doesn't look like the one in the current tree, and avoids the reuse
of addr by moving the call to get the gpa up instead of renaming the variable
as propossed in :

  http://article.gmane.org/gmane.comp.emulators.kvm.devel/11511

IMHO renaming the parameter variable is probably better in the long run, as it
could result otherwise into scope related bugs like the one from kvm-59

> diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
> index 9db4e32..3b79684 100644
> --- a/drivers/kvm/x86.c
> +++ b/drivers/kvm/x86.c
> @@ -1674,6 +1675,31 @@ static int emulator_cmpxchg_emulated(unsigned long addr,
>  		reported = 1;
>  		printk(KERN_WARNING "kvm: emulating exchange as write\n");
>  	}
> +#ifndef CONFIG_X86_64
> +	/* guests cmpxchg8b have to be emulated atomically */
> +	if (bytes == 8) {
> +		gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
> +		struct page *page;
> +		char *addr;
> +		u64 val;
> +
> +		if (gpa == UNMAPPED_GVA ||
> +		   (gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
> +			goto emul_write;
> +
> +		if (((gpa + bytes - 1) & PAGE_MASK) != (gpa & PAGE_MASK))
> +			goto emul_write;
> +
> +		val = *(u64 *)new;
> +		page = gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
> +		addr = kmap_atomic(page, KM_USER0);
> +		set_64bit((u64 *)(addr + offset_in_page(gpa)), val);
> +		kunmap_atomic(addr, KM_USER0);
> +		kvm_release_page_dirty(page);
> +	}
> +emul_write:
> +#endif
> +
>  	return emulator_write_emulated(addr, new, bytes, vcpu);
>  }
>  
> -- 
> 1.5.3.7
