Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbYEERhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbYEERhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 13:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbYEERhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 13:37:37 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:58762 "EHLO
	outbound6-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799AbYEERhf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 13:37:35 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [microblaze-uclinux] [PATCH 09/56] microblaze_v2: cache support
Date: Mon, 5 May 2008 10:37:33 -0700
In-reply-to: <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [microblaze-uclinux] [PATCH 09/56] microblaze_v2: cache support
Thread-Index: AciuuOdg6X3lbMZWTnSUV66TJ1nTswAHTdFw
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu> <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
From: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
To: <microblaze-uclinux@itee.uq.edu.au>, <linux-kernel@vger.kernel.org>
Cc: <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
       "John Linn" <linnj@xilinx.com>, <john.williams@petalogix.com>,
       <matthew@wil.cx>, <will.newton@gmail.com>, <drepper@redhat.com>,
       <grant.likely@secretlab.ca>, "Michal Simek" <monstr@monstr.eu>
X-OriginalArrivalTime: 05 May 2008 17:37:34.0136 (UTC) FILETIME=[B3B64380:01C8AED6]
Message-Id: <20080505173734.AB0E485805C@mail199-va3.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The microblaze has a write through data cache, hence 'flush' is really a
misnomer here and interesting methods are 'invalidate'.  In addition,
most of these functions should be used directly by an implementation of
dma-coherent.c (which I can't find in your patches).  

I'll try to cook up a patch for you with this today.

Steve

> +#define flush_cache_all()			__flush_cache_all()
> +#define flush_cache_mm(mm)			do { } while (0)
> +#define flush_cache_range(vma, start, end)	__flush_cache_all()
> +#define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
> +
> +#define flush_dcache_range(start, end)
__flush_dcache_range(start, end)
> +#define flush_dcache_page(page)		do { } while (0)
> +#define flush_dcache_mmap_lock(mapping)		do { } while (0)
> +#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
> +
> +#define flush_icache_range(start, len)
__flush_icache_range(start, len)
> +#define flush_icache_page(vma, pg)		do { } while (0)
> +#define flush_icache_user_range(start, len)	do { } while (0)
> +
> +#define flush_cache_vmap(start, end)		do { } while (0)
> +#define flush_cache_vunmap(start, end)		do { } while (0)
> +
> +struct page;
> +struct mm_struct;
> +struct vm_area_struct;
> +
> +/* see arch/microblaze/kernel/cache.c */
> +extern void __flush_icache_all(void);
> +extern void __flush_icache_range(unsigned long start, unsigned long
end);
> +extern void __flush_icache_page(struct vm_area_struct *vma, struct
page *page);
> +extern void __flush_icache_user_range(struct vm_area_struct *vma,
> +				struct page *page,
> +				unsigned long adr, int len);
> +extern void __flush_cache_sigtramp(unsigned long addr);
> +
> +extern void __flush_dcache_all(void);
> +extern void __flush_dcache_range(unsigned long start, unsigned long
end);
> +extern void __flush_dcache_page(struct vm_area_struct *vma, struct
page *page);
> +extern void __flush_dcache_user_range(struct vm_area_struct *vma,
> +				struct page *page,
> +				unsigned long adr, int len);
> +
> +extern inline void __flush_cache_all(void)
> +{
> +	__flush_icache_all();
> +	__flush_dcache_all();
> +}
> +
> +#define copy_to_user_page(vma, page, vaddr, dst, src, len) \
> +do { memcpy(dst, src, len); \
> +	flush_icache_user_range(vma, page, vaddr, len); \
> +} while (0)
> +#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
> +	memcpy(dst, src, len)
> +
> +#endif /* _ASM_MICROBLAZE_CACHEFLUSH_H */
> --
> 1.5.4.GIT
> 
> ___________________________
> microblaze-uclinux mailing list
> microblaze-uclinux@itee.uq.edu.au
> Project Home Page :
http://www.itee.uq.edu.au/~jwilliams/mblaze-uclinux
> Mailing List Archive :
http://www.itee.uq.edu.au/~listarch/microblaze-uclinux/
> 


