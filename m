Return-Path: <linux-kernel-owner+w=401wt.eu-S1762567AbYCAUJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762567AbYCAUJX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 15:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759982AbYCAUIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 15:08:55 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:3627 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759523AbYCAUIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 15:08:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=MNABWbDoBiI6r2wPsyTVrFwZSTNhUCuSPaD+5ASFVbnBlLCEarmDgO0UWZzVhNTm4wncBNIbkGPSbeq3OeabUt8O8a3dk7AGzkMb17wH+fd+yG11M2i3PtBtog/Dk0/62UfTBvu2FkRQikHCf2C0g7OpOOi4deMX8PRNDpxMkBA=
From: Mike Frysinger <vapier.adi@gmail.com>
Organization: ADI
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: regression: ntfs build failure in linux-2.6.git on no-mmu: no is_vmalloc_addr()
Date: Sat, 1 Mar 2008 15:08:45 -0500
User-Agent: KMail/1.9.9
Cc: uclinux-dist-devel@blackfin.uclinux.org, cooloney@kernel.org
References: <20080301112959.89C8AA506AF@snoopy.ad.analog.com>
In-Reply-To: <20080301112959.89C8AA506AF@snoopy.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803011508.45913.vapier.adi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 March 2008 06:29:59 vapier@blackfin.uclinux.org wrote:
> --- blackfin-2.6/BF548-EZKIT.BF542
> --- blackfin-2.6/BF548-EZKIT.BF544
> --- blackfin-2.6/BF548-EZKIT.BF547
> --- blackfin-2.6/BF548-EZKIT.BF548
> --- blackfin-2.6/BF548-EZKIT.BF549
> --- linux-2.6/BF548-EZKIT.BF542
> --- linux-2.6/BF548-EZKIT.BF544
> --- linux-2.6/BF548-EZKIT.BF547
> --- linux-2.6/BF548-EZKIT.BF548
> --- linux-2.6/BF548-EZKIT.BF549
> --- next-20080229/BF548-EZKIT.BF542
> --- next-20080229/BF548-EZKIT.BF544
> --- next-20080229/BF548-EZKIT.BF547
> --- next-20080229/BF548-EZKIT.BF548
> --- next-20080229/BF548-EZKIT.BF549
> <stdin>:1377:2: warning: #warning syscall timerfd_create not implemented
> <stdin>:1389:2: warning: #warning syscall timerfd_settime not implemented
> <stdin>:1393:2: warning: #warning syscall timerfd_gettime not implemented
> In file included from fs/ntfs/attrib.c:32:
> fs/ntfs/malloc.h: In function 'ntfs_free':
> fs/ntfs/malloc.h:88: error: implicit declaration of function
> 'is_vmalloc_addr' make[2]: *** [fs/ntfs/attrib.o] Error 1
> make[1]: *** [fs/ntfs] Error 2
> make: *** [fs] Error 2

commit 9e2779fa281cfda13ac060753d674bbcaa23367e changed fs/ntfs/malloc.h from
using VMALLOC_* defines to is_vmalloc_addr() (which makes sense), but Blackfin
was defining VMALLOC_* (to basically the range of all memory addresses like
most no-mmu ports)

so we can drop CONFIG_MMU around is_vmalloc_addr() in include/linux/mm.h, or
we can just make it return 1 all the time for no-mmu.  the former sounds
easier.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3f3ccfe..3b3e134 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -235,7 +235,6 @@ static inline int get_page_unless_zero(struct page *page)
 struct page *vmalloc_to_page(const void *addr);
 unsigned long vmalloc_to_pfn(const void *addr);
 
-#ifdef CONFIG_MMU
 /* Determine if an address is within the vmalloc range */
 static inline int is_vmalloc_addr(const void *x)
 {
@@ -243,7 +242,6 @@ static inline int is_vmalloc_addr(const void *x)
 
 	return addr >= VMALLOC_START && addr < VMALLOC_END;
 }
-#endif
 
 static inline struct page *compound_head(struct page *page)
 {
