Return-Path: <linux-kernel-owner+w=401wt.eu-S964793AbXDVGXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793AbXDVGXB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 02:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964862AbXDVGXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 02:23:00 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:32802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964793AbXDVGXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 02:23:00 -0400
Date: Sat, 21 Apr 2007 23:22:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix parsing kernelcore boot option for ia64
Message-Id: <20070421232248.431ef2da.akpm@linux-foundation.org>
In-Reply-To: <20070413140533.A239.Y-GOTO@jp.fujitsu.com>
References: <20070413140533.A239.Y-GOTO@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 14:26:22 +0900 Yasunori Goto <y-goto@jp.fujitsu.com> wrote:

> Hello.
> 
> cmdline_parse_kernelcore() should return the next pointer of boot option
> like memparse() doing. If not, it is cause of eternal loop on ia64 box.
> This patch is for 2.6.21-rc6-mm1.
> 
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> 
> ----
> 
>  arch/ia64/kernel/efi.c |    2 +-
>  include/linux/mm.h     |    2 +-
>  mm/page_alloc.c        |    4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> Index: current_test/arch/ia64/kernel/efi.c
> ===================================================================
> --- current_test.orig/arch/ia64/kernel/efi.c	2007-04-12 17:33:28.000000000 +0900
> +++ current_test/arch/ia64/kernel/efi.c	2007-04-13 12:13:21.000000000 +0900
> @@ -424,7 +424,7 @@ efi_init (void)
>  		} else if (memcmp(cp, "max_addr=", 9) == 0) {
>  			max_addr = GRANULEROUNDDOWN(memparse(cp + 9, &cp));
>  		} else if (memcmp(cp, "kernelcore=",11) == 0) {
> -			cmdline_parse_kernelcore(cp+11);
> +			cmdline_parse_kernelcore(cp+11, &cp);
>  		} else if (memcmp(cp, "min_addr=", 9) == 0) {
>  			min_addr = GRANULEROUNDDOWN(memparse(cp + 9, &cp));
>  		} else {
> Index: current_test/mm/page_alloc.c
> ===================================================================
> --- current_test.orig/mm/page_alloc.c	2007-04-12 18:25:37.000000000 +0900
> +++ current_test/mm/page_alloc.c	2007-04-13 12:12:58.000000000 +0900
> @@ -3736,13 +3736,13 @@ void __init free_area_init_nodes(unsigne
>   * kernelcore=size sets the amount of memory for use for allocations that
>   * cannot be reclaimed or migrated.
>   */
> -int __init cmdline_parse_kernelcore(char *p)
> +int __init cmdline_parse_kernelcore(char *p, char **retp)
>  {
>  	unsigned long long coremem;
>  	if (!p)
>  		return -EINVAL;
>  
> -	coremem = memparse(p, &p);
> +	coremem = memparse(p, retp);
>  	required_kernelcore = coremem >> PAGE_SHIFT;
>  
>  	/* Paranoid check that UL is enough for required_kernelcore */
> Index: current_test/include/linux/mm.h
> ===================================================================
> --- current_test.orig/include/linux/mm.h	2007-04-11 14:15:33.000000000 +0900
> +++ current_test/include/linux/mm.h	2007-04-13 12:12:20.000000000 +0900
> @@ -1051,7 +1051,7 @@ extern unsigned long find_max_pfn_with_a
>  extern void free_bootmem_with_active_regions(int nid,
>  						unsigned long max_low_pfn);
>  extern void sparse_memory_present_with_active_regions(int nid);
> -extern int cmdline_parse_kernelcore(char *p);
> +extern int cmdline_parse_kernelcore(char *p, char **retp);
>  #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
>  extern int early_pfn_to_nid(unsigned long pfn);
>  #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
> 

This will cause all other architectures to crash when kernelcore= is used.

I wasn't even aware of this kernelcore thing.  It's pretty nasty-looking. 
yet another reminder that this code hasn't been properly reviewed in the
past year or three.

