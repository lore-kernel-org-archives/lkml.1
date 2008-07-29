Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbYG2Em4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbYG2Em4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 00:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYG2Emr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 00:42:47 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:47160 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYG2Emq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 00:42:46 -0400
Date: Tue, 29 Jul 2008 14:42:43 +1000
From: Simon Horman <horms@verge.net.au>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, Chandru <chandru@in.ibm.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Terry Loftin <terry.loftin@hp.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 3/5] ia64: Define elfcorehdr_addr in arch dependent
	section
Message-ID: <20080729044241.GA23514@verge.net.au>
References: <20080727234529.GM6175@verge.net.au> <20080728015117.GA12055@verge.net.au> <20080728024526.GB3334@verge.net.au> <20080728034007.GA30450@verge.net.au> <20080728211025.GA9985@redhat.com> <20080728211156.GB9985@redhat.com> <20080728211314.GC9985@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728211314.GC9985@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 05:13:14PM -0400, Vivek Goyal wrote:
> 
> o Move elfcorehdr_addr definition in arch dependent crash dump file. This is
>   equivalent to defining elfcorehdr_addr under CONFIG_CRASH_DUMP instead of
>   CONFIG_PROC_VMCORE. This is needed by is_kdump_kernel() which can be
>   used irrespective of the fact whether CONFIG_PROC_VMCORE is enabled or
>   not.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
> 
>  arch/ia64/kernel/setup.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff -puN arch/ia64/kernel/setup.c~fix-elfcorehdr_addr-parsing-ia64 arch/ia64/kernel/setup.c
> --- linux-2.6.27-pre-rc1/arch/ia64/kernel/setup.c~fix-elfcorehdr_addr-parsing-ia64	2008-07-28 12:16:40.000000000 -0400
> +++ linux-2.6.27-pre-rc1-root/arch/ia64/kernel/setup.c	2008-07-28 12:16:40.000000000 -0400
> @@ -478,7 +478,12 @@ static __init int setup_nomca(char *s)
>  }
>  early_param("nomca", setup_nomca);
>  
> -#ifdef CONFIG_PROC_VMCORE
> +/*
> + * Note: elfcorehdr_addr is not just limited to vmcore. It is also used by
> + * is_kdump_kernel() to determine if we are booting after a panic. Hence
> + * ifdef it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
> + */
> +#ifdef CONFIG_CRASH_DUMP
>  /* elfcorehdr= specifies the location of elf core header
>   * stored by the crashed kernel.
>   */
> @@ -491,7 +496,9 @@ static int __init parse_elfcorehdr(char 
>  	return 0;
>  }
>  early_param("elfcorehdr", parse_elfcorehdr);
> +#endif
>  
> +#ifdef CONFIG_PROC_VMCORE
>  int __init reserve_elfcorehdr(unsigned long *start, unsigned long *end)
>  {
>  	unsigned long length;
> _

Hi Vivek,

I think that you also need the following in arch/ia64/kernel/crash_dump.c.
With this change your code compiles on ia64.

Signed-off-by: Simon Horman <horms@verge.net.au>


Index: linux-2.6/arch/ia64/kernel/crash_dump.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/crash_dump.c	2008-07-29 14:06:57.000000000 +1000
+++ linux-2.6/arch/ia64/kernel/crash_dump.c	2008-07-29 14:09:55.000000000 +1000
@@ -8,10 +8,14 @@
 
 #include <linux/errno.h>
 #include <linux/types.h>
+#include <linux/crash_dump.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
 
+/* Stores the physical address of elf header of crash image. */
+unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
+
 /**
  * copy_oldmem_page - copy one page from "oldmem"
  * @pfn: page frame number to be copied

