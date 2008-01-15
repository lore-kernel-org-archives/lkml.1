Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbYAOIrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbYAOIrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 03:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYAOIrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 03:47:40 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:30045 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbYAOIrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 03:47:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wKvzHVfIVVs+1UuCtiKYq9F07QQGGSekf3FZj+VUhq2WKxWQEdAyuFc7Gf/tax6kMh5jiMQYA2+cZhQStzvhl3FwlYIMwvAWYs7FZJJSKvKFByq/FjcKv+B6sAkxdPStrPVl3FBIHl3oYPXuY+Zem37xoz/12uv8MTYSH2Srkzs=
Subject: Re: [PATCH] [2/31] CPA: Do a simple self test at boot
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
In-Reply-To: <20080114221633.B6A4814F93@wotan.suse.de>
References: <200801141116.534682000@suse.de>
	 <20080114221633.B6A4814F93@wotan.suse.de>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 00:47:37 -0800
Message-Id: <1200386857.16794.2.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-01-14 at 23:16 +0100, Andi Kleen wrote:
> When CONFIG_DEBUG_RODATA is enabled undo the ro mapping and redo it again.
> This gives some simple testing for change_page_attr()
> 
> Optional patch, but I find it useful.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86/Kconfig.debug |    5 +++++
>  arch/x86/mm/init_32.c  |   26 ++++++++++++++++++++++++++
>  arch/x86/mm/init_64.c  |   10 ++++++++++
>  3 files changed, 41 insertions(+)
> 
> Index: linux/arch/x86/mm/init_64.c
> ===================================================================
> --- linux.orig/arch/x86/mm/init_64.c
> +++ linux/arch/x86/mm/init_64.c
> @@ -603,6 +603,16 @@ void mark_rodata_ro(void)
>  	 * of who is the culprit.
>  	 */
>  	global_flush_tlb();

global_flush_tlb outside CONFIG_CPA_DEBUG here.

> +
> +#ifdef CONFIG_CPA_DEBUG
> +	printk("Testing CPA: undo %lx-%lx\n", start, end);
> +	change_page_attr_addr(start, (end - start) >> PAGE_SHIFT, PAGE_KERNEL);
> +	global_flush_tlb();
> +
> +	printk("Testing CPA: again\n");
> +	change_page_attr_addr(start, (end - start) >> PAGE_SHIFT, PAGE_KERNEL_RO);
> +	global_flush_tlb();
> +#endif
>  }
>  #endif
>  
> Index: linux/arch/x86/mm/init_32.c
> ===================================================================
> --- linux.orig/arch/x86/mm/init_32.c
> +++ linux/arch/x86/mm/init_32.c
> @@ -793,6 +793,20 @@ void mark_rodata_ro(void)
>  		change_page_attr(virt_to_page(start),
>  		                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
>  		printk("Write protecting the kernel text: %luk\n", size >> 10);
> +
> +#ifdef CONFIG_CPA_DEBUG
> +		global_flush_tlb();
> +

global_flush_tlb inside CONFIG_CPA_DEBUG here.

> +		printk("Testing CPA: Reverting %lx-%lx\n", start, start+size);
> +		change_page_attr(virt_to_page(start), size>>PAGE_SHIFT,
> +				 PAGE_KERNEL_EXEC);
> +		global_flush_tlb();
> +
> +		printk("Testing CPA: write protecting again\n");
> +		change_page_attr(virt_to_page(start), size>>PAGE_SHIFT,
> +				PAGE_KERNEL_RX);
> +		global_flush_tlb();
> +#endif
>  	}
>  #endif
>  	start += size;
> @@ -809,6 +823,18 @@ void mark_rodata_ro(void)
>  	 * of who is the culprit.
>  	 */
>  	global_flush_tlb();

global_flush_tlb outside CONFIG_CPA_DEBUG here.  Intentional?

> +
> +#ifdef CONFIG_CPA_DEBUG
> +	printk("Testing CPA: undo %lx-%lx\n", start, start + size);
> +	change_page_attr(virt_to_page(start), size >> PAGE_SHIFT,
> +				PAGE_KERNEL);
> +	global_flush_tlb();
> +
> +	printk("Testing CPA: write protecting again\n");
> +	change_page_attr(virt_to_page(start), size >> PAGE_SHIFT,
> +				PAGE_KERNEL_RO);
> +	global_flush_tlb();
> +#endif

Cheers,

Harvey

