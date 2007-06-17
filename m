Return-Path: <linux-kernel-owner+w=401wt.eu-S1752604AbXFQPY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbXFQPY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 11:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbXFQPYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 11:24:49 -0400
Received: from il.qumranet.com ([82.166.9.18]:58637 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbXFQPYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 11:24:48 -0400
Message-ID: <4675523C.9020703@qumranet.com>
Date: Sun, 17 Jun 2007 18:24:44 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [BUG] Oops with KVM-27
References: <20070612175246.GA5864@dreamland.darkstar.lan> <466FB1ED.3090905@qumranet.com> <20070613204948.GA14710@dreamland.darkstar.lan> <4670FBB5.70707@qumranet.com> <20070614225324.GA4088@dreamland.darkstar.lan> <20070614231359.GA5705@dreamland.darkstar.lan> <68676e00706141627s3cb87391sa0ee6711d2f7933f@mail.gmail.com> <467256AA.1040001@qumranet.com> <20070615214915.GA10536@dreamland.darkstar.lan> <4673949B.1070505@qumranet.com> <20070617151452.GA21971@dreamland.darkstar.lan>
In-Reply-To: <20070617151452.GA21971@dreamland.darkstar.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luca Tettamanti wrote:
>> Actually we haven't; just before the memcpy(), we can put a memcmp() to
>> guard the kvm_mmu_pte_write(), which is the really expensive operation,
>> especially with guest smp.
>>     
>
> Yup, but it seemed wasteful to map (at least when highmem is in use) a
> page just to check for something that we already knew. That was a
> preemptive optmization though, I haven't actually benchmarked the cost
> of setting up the mapping ;-)
>
>   

It's negligible compared to the vmexit cost and to the emulation  (which 
does a kmap_atomic() for every byte of the instruction; this can be 
easily optimized away).

In any case, I expect that performance sensitive uses will use x86_64, 
whereas i386 is mostly for desktops.


>> I think we can simply remove the if ().  For the register case, the
>> check is more expensive that the write; for mmio, we don't want it; and
>> for memory writes, we can put it in emulator_write_phys().
>>     
>
> Ok, this way it's simpler. How does this look:
>
> --- a/kernel/x86_emulate.c	2007-06-15 21:13:51.000000000 +0200
> +++ b/kernel/x86_emulate.c	2007-06-17 16:57:50.000000000 +0200
> @@ -1057,40 +1057,38 @@
>  	}
>  
>  writeback:
> -	if ((d & Mov) || (dst.orig_val != dst.val)) {
> -		switch (dst.type) {
> -		case OP_REG:
> -			/* The 4-byte case *is* correct: in 64-bit mode we zero-extend. */
> -			switch (dst.bytes) {
> -			case 1:
> -				*(u8 *)dst.ptr = (u8)dst.val;
> -				break;
> -			case 2:
> -				*(u16 *)dst.ptr = (u16)dst.val;
> -				break;
> -			case 4:
> -				*dst.ptr = (u32)dst.val;
> -				break;	/* 64b: zero-ext */
> -			case 8:
> -				*dst.ptr = dst.val;
> -				break;
> -			}
> +	switch (dst.type) {
> +	case OP_REG:
> +		/* The 4-byte case *is* correct: in 64-bit mode we zero-extend. */
> +		switch (dst.bytes) {
> +		case 1:
> +			*(u8 *)dst.ptr = (u8)dst.val;
>  			break;
> -		case OP_MEM:
> -			if (lock_prefix)
> -				rc = ops->cmpxchg_emulated((unsigned long)dst.
> -							   ptr, &dst.orig_val,
> -							   &dst.val, dst.bytes,
> -							   ctxt);
> -			else
> -				rc = ops->write_emulated((unsigned long)dst.ptr,
> -							 &dst.val, dst.bytes,
> -							 ctxt);
> -			if (rc != 0)
> -				goto done;
> -		default:
> +		case 2:
> +			*(u16 *)dst.ptr = (u16)dst.val;
> +			break;
> +		case 4:
> +			*dst.ptr = (u32)dst.val;
> +			break;	/* 64b: zero-ext */
> +		case 8:
> +			*dst.ptr = dst.val;
>  			break;
>  		}
> +		break;
> +	case OP_MEM:
> +		if (lock_prefix)
> +			rc = ops->cmpxchg_emulated((unsigned long)dst.
> +						   ptr, &dst.orig_val,
> +						   &dst.val, dst.bytes,
> +						   ctxt);
> +		else
> +			rc = ops->write_emulated((unsigned long)dst.ptr,
> +						 &dst.val, dst.bytes,
> +						 ctxt);
> +		if (rc != 0)
> +			goto done;
> +	default:
> +		break;
>  	}
>  
>  	/* Commit shadow register state. */
>
> --- a/kernel/kvm_main.c	2007-06-15 21:18:08.000000000 +0200
> +++ b/kernel/kvm_main.c	2007-06-17 16:59:33.000000000 +0200
> @@ -1139,8 +1139,10 @@
>  		return 0;
>  	mark_page_dirty(vcpu->kvm, gpa >> PAGE_SHIFT);
>  	virt = kmap_atomic(page, KM_USER0);
> -	kvm_mmu_pte_write(vcpu, gpa, virt + offset, val, bytes);
> -	memcpy(virt + offset_in_page(gpa), val, bytes);
> +	if (memcmp(virt + offset_in_page(gpa), val, bytes)) {
> +		kvm_mmu_pte_write(vcpu, gpa, virt + offset, val, bytes);
> +		memcpy(virt + offset_in_page(gpa), val, bytes);
> +	}
>  	kunmap_atomic(virt, KM_USER0);
>  	return 1;
>  }
>
>
>   

Excellent.  We win back a precious indentation level and fix a bug at 
the same time.  Please test, send me a changelog and a signoff and I'll 
commit it.


-- 
error compiling committee.c: too many arguments to function

