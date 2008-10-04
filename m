Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbYJDJgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbYJDJgO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 05:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYJDJf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 05:35:58 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:10641 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbYJDJf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 05:35:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wU3MCaTMhYmPXUMS+C0sNb0PYAz6cRtdEQbvK7lz9yFY1grD7A0ihnJNHdjfwHmqM1
         UfslmOpPGgwxQyRmEKxpcDidn43/KlQlmHu9b7wb0dyD0oRjU+LrJ10Axki5h7+V07BE
         2GELVW6PYsX5Q+OxnfosbkONgpHNRreEUJxRo=
Message-ID: <851fc09e0810040235g2ab97bdai612c0a2829f83f5c@mail.gmail.com>
Date: Sat, 4 Oct 2008 17:35:56 +0800
From: "huang ying" <huang.ying.caritas@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [RFC PATCH] x86: make 64bit efi to use ioremap_cache for efi_ioremap
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Huang Ying" <ying.huang@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1223101400-8819-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223101400-8819-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Yinghai,

On Sat, Oct 4, 2008 at 2:23 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
[...]
> --- linux-2.6.orig/arch/x86/kernel/efi.c
> +++ linux-2.6/arch/x86/kernel/efi.c
> @@ -475,10 +475,7 @@ void __init efi_enter_virtual_mode(void)
>                size = md->num_pages << EFI_PAGE_SHIFT;
>                end = md->phys_addr + size;
>
> -               if (PFN_UP(end) <= max_low_pfn_mapped)
> -                       va = __va(md->phys_addr);
> -               else
> -                       va = efi_ioremap(md->phys_addr, size);
> +               va = efi_ioremap(md->phys_addr, size);

Using __va and efi_ioremap() here is to make EFI support compatible
with kexec. Because EFI provide only efi_enter_virtual_mode(), no
efi_leave_virtual_mode(), we should make EFI runtime memory area
mapped to same virtual memory area in original kernel and kexeced
kernel, so that the EFI runtime services can be used in kexeced
kernel.

[...]
> --- linux-2.6.orig/arch/x86/kernel/efi_64.c
> +++ linux-2.6/arch/x86/kernel/efi_64.c
> @@ -46,8 +46,8 @@ static void __init early_mapping_set_exe
>  {
>        unsigned long num_pages;
>
> -       start &= PMD_MASK;
> -       end = (end + PMD_SIZE - 1) & PMD_MASK;
> +       start &= PAGE_MASK;
> +       end = (end + PAGE_SIZE - 1) & PAGE_MASK;
>        num_pages = (end - start) >> PAGE_SHIFT;
>        if (executable)
>                set_memory_x((unsigned long)__va(start), num_pages);

early_mapping_set_exe() may be called before page allocator is
available. Using PAGE_MASK may make set_memory_x() allocate new page,
while using PMD_MASK will not.

Best Regards,
Huang Ying
