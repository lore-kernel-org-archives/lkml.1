Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbYGZKMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbYGZKMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 06:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbYGZKMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 06:12:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638AbYGZKMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 06:12:05 -0400
Date: Sat, 26 Jul 2008 03:10:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Chandru <chandru@in.ibm.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Vivek Goyal <vgoyal@in.ibm.com>,
       kexec@lists.infradead.org
Subject: Re: [patch] crashdump: fix undefined reference to `elfcorehdr_addr'
Message-Id: <20080726031034.82e2feef.akpm@linux-foundation.org>
In-Reply-To: <20080726092519.GA4341@elte.hu>
References: <20080726092519.GA4341@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008 11:25:19 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> please apply before -rc1.
> 
> 	Ingo
> 
> ----------->
> >From 72db7cba50b6a05825f8a287f74002cc38f04fb7 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Sat, 26 Jul 2008 11:22:33 +0200
> Subject: [PATCH] crashdump: fix undefined reference to `elfcorehdr_addr'
> 
> fix build bug introduced by 95b68dec0d5 "calgary iommu: use the first
> kernels TCE tables in kdump":
> 
>  arch/x86/kernel/built-in.o: In function `calgary_iommu_init':
>  (.init.text+0x8399): undefined reference to `elfcorehdr_addr'
>  arch/x86/kernel/built-in.o: In function `calgary_iommu_init':
>  (.init.text+0x856c): undefined reference to `elfcorehdr_addr'
>  arch/x86/kernel/built-in.o: In function `detect_calgary':
>  (.init.text+0x8c68): undefined reference to `elfcorehdr_addr'
>  arch/x86/kernel/built-in.o: In function `detect_calgary':
>  (.init.text+0x8d0c): undefined reference to `elfcorehdr_addr'
>
> make elfcorehdr_addr a generally available symbol.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/crash_dump.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
> index 6cd39a9..025e4f5 100644
> --- a/include/linux/crash_dump.h
> +++ b/include/linux/crash_dump.h
> @@ -8,7 +8,13 @@
>  #include <linux/proc_fs.h>
>  
>  #define ELFCORE_ADDR_MAX	(-1ULL)
> +
> +#ifdef CONFIG_PROC_VMCORE
>  extern unsigned long long elfcorehdr_addr;
> +#else
> +static const unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
> +#endif
> +
>  extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
>  						unsigned long, int);
>  extern const struct file_operations proc_vmcore_operations;

spose that'll fix it.  But it seems odd that is_kdump_kernel() will
return false if CONFIG_PROC_VMCORE=n, CONFIG_CRASH_DUMP=y.  I mean,
it's still a crashdump kernel, is it not?


