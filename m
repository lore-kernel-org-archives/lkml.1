Return-Path: <linux-kernel-owner+w=401wt.eu-S1757167AbYGZRjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbYGZRjR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 13:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYGZRjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 13:39:06 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:35885 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbYGZRjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 13:39:05 -0400
Date: Sat, 26 Jul 2008 20:38:32 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] linux/swap.h must #include <linux/pagemap.h>
Message-ID: <20080726173832.GE9301@cs181140183.pp.htv.fi>
References: <1217092685-15267-1-git-send-email-haavard.skinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1217092685-15267-1-git-send-email-haavard.skinnemoen@atmel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 07:18:05PM +0200, Haavard Skinnemoen wrote:
> This fixes the following compile error on avr32, introduced by
> commit ba92a43dbaee339cf5915ef766d3d3ffbaaf103c
> (exec: remove some includes):
> 
> In file included from include/asm/tlb.h:24,
>                  from fs/exec.c:55:
> include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
> include/asm-generic/tlb.h:76: error: implicit declaration of function 'release_pages'
> include/asm-generic/tlb.h: In function 'tlb_remove_page':
> include/asm-generic/tlb.h:105: error: implicit declaration of function 'page_cache_release'
> make[1]: *** [fs/exec.o] Error 1
> 
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> ---
>  include/asm-generic/tlb.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
> index f490e43..f85f3a2 100644
> --- a/include/asm-generic/tlb.h
> +++ b/include/asm-generic/tlb.h
> @@ -13,6 +13,7 @@
>  #ifndef _ASM_GENERIC__TLB_H
>  #define _ASM_GENERIC__TLB_H
>  
> +#include <linux/pagemap.h>
>  #include <linux/swap.h>
>  #include <asm/pgalloc.h>
>  #include <asm/tlbflush.h>

The patch is not the correct fix since the actual problem comes from 
free_pages_and_swap_cache() in swap.h

Patch is below, but it has not yet gotten enough testing that I'm 100% 
confident it doesn't break anything else...

cu
Adrian


<--  snip  -->


This patch fixes the following build error:

<--  snip  -->

...
  CC      fs/exec.o
In file included from include2/asm/tlb.h:24,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/exec.c:55:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/tlb.h:76: error: implicit declaration of function 'release_pages'
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/tlb.h: In function 'tlb_remove_page':
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/tlb.h:105: error: implicit declaration of function 'page_cache_release'
make[2]: *** [fs/exec.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
2dab88e59c7ec942df29bbdee041e54edeee1d25 
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 0b33776..f835058 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -7,6 +7,7 @@
 #include <linux/list.h>
 #include <linux/memcontrol.h>
 #include <linux/sched.h>
+#include <linux/pagemap.h>
 
 #include <asm/atomic.h>
 #include <asm/page.h>

