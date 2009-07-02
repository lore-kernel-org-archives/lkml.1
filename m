Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395AbZGBFqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbZGBFqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 01:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750726AbZGBFqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 01:46:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713AbZGBFqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 01:46:39 -0400
Date: Wed, 1 Jul 2009 22:46:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] Fix virt_to_phys() warnings
Message-Id: <20090701224627.0b2704df.akpm@linux-foundation.org>
In-Reply-To: <910ba280decc9ee53d9971ba04f73fab@localhost>
References: <910ba280decc9ee53d9971ba04f73fab@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009 17:13:20 -0700 Kevin Cernekee <cernekee@gmail.com> wrote:

> These warnings were observed on MIPS32 using 2.6.31-rc1 and gcc-4.2.0:
> 
> mm/page_alloc.c: In function 'alloc_pages_exact':
> mm/page_alloc.c:1986: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast
> 
> drivers/usb/mon/mon_bin.c: In function 'mon_alloc_buff':
> drivers/usb/mon/mon_bin.c:1264: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> ---
> diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
> index f8d9045..0f7a30b 100644
> --- a/drivers/usb/mon/mon_bin.c
> +++ b/drivers/usb/mon/mon_bin.c
> @@ -1261,7 +1261,7 @@ static int mon_alloc_buff(struct mon_pgmap *map, int npages)
>  			return -ENOMEM;
>  		}
>  		map[n].ptr = (unsigned char *) vaddr;
> -		map[n].pg = virt_to_page(vaddr);
> +		map[n].pg = virt_to_page((void *) vaddr);
>  	}
>  	return 0;
>  }
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5d714f8..f6180db 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1983,7 +1983,7 @@ void *alloc_pages_exact(size_t size, gfp_t gfp_mask)
>  		unsigned long alloc_end = addr + (PAGE_SIZE << order);
>  		unsigned long used = addr + PAGE_ALIGN(size);
>  
> -		split_page(virt_to_page(addr), order);
> +		split_page(virt_to_page((void *)addr), order);
>  		while (used < alloc_end) {
>  			free_page(used);
>  			used += PAGE_SIZE;

The virt_to_foo() functions were written back in the Linux dark ages and
they're horrid.  A byzantine mixture of macros and typecasts which make
it really hard to work out what type their argument actually should be.

virt_to_page() takes an argument of type `unsigned long'.  (except for
the include/asm-generic/page.h version which takes any damn type at
all).

virt_to_phys() takes an argument of `const void *' (weird, huh?)

But arch/mips/include/asm/page.h does

#define virt_to_page(kaddr)        pfn_to_page(PFN_DOWN(virt_to_phys(kaddr)))

thereby passing an `unsigned long' where a void* was expected.


So perhaps something along these lines:


--- a/arch/mips/include/asm/page.h~a
+++ a/arch/mips/include/asm/page.h
@@ -184,7 +184,11 @@ typedef struct { unsigned long pgprot; }
 
 #endif
 
-#define virt_to_page(kaddr)	pfn_to_page(PFN_DOWN(virt_to_phys(kaddr)))
+static inline struct page *virt_to_page(unsigned long kaddr)
+{
+	return pfn_to_page(PFN_DOWN(virt_to_phys((void *)kaddr)));
+}
+
 #define virt_addr_valid(kaddr)	pfn_valid(PFN_DOWN(virt_to_phys(kaddr)))
 
 #define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
_

