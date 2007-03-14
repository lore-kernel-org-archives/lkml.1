Return-Path: <linux-kernel-owner+w=401wt.eu-S1751461AbXCNPiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbXCNPiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbXCNPiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:38:08 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:5544 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbXCNPiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:38:04 -0400
Message-ID: <45F816D7.7090600@fr.ibm.com>
Date: Wed, 14 Mar 2007 16:37:59 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Pavel Emelianov <xemul@sw.ru>
CC: Andrew Morton <akpm@osdl.org>, Paul Menage <menage@google.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       devel@openvz.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       containers@lists.osdl.org, Kirill Korotaev <dev@sw.ru>
Subject: Re: [RFC][PATCH 4/7] RSS accounting hooks over the code
References: <45ED7DEC.7010403@sw.ru> <45ED81F2.80402@sw.ru>
In-Reply-To: <45ED81F2.80402@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> --- linux-2.6.20.orig/mm/migrate.c	2007-02-04 21:44:54.000000000 +0300
> +++ linux-2.6.20-0/mm/migrate.c	2007-03-06 13:33:28.000000000 +0300
> @@ -134,6 +134,7 @@ static void remove_migration_pte(struct 
>  	pte_t *ptep, pte;
>   	spinlock_t *ptl;
>  	unsigned long addr = page_address_in_vma(new, vma);
> +	struct page_container *pcont;
> 
>  	if (addr == -EFAULT)
>  		return;
> @@ -157,6 +158,11 @@ static void remove_migration_pte(struct 
>   		return;
>   	}
> 
> +	if (container_rss_prepare(new, vma, &pcont)) {
> +		pte_unmap(ptep);
> +		return;
> +	}
> +
>   	ptl = pte_lockptr(mm, pmd);
>   	spin_lock(ptl);
>  	pte = *ptep;
> @@ -175,16 +181,19 @@ static void remove_migration_pte(struct 
>  	set_pte_at(mm, addr, ptep, pte);
> 
>  	if (PageAnon(new))
> -		page_add_anon_rmap(new, vma, addr);
> +		page_add_anon_rmap(new, vma, addr, pcont);
>  	else
> -		page_add_file_rmap(new);
> +		page_add_file_rmap(new, pcont);
> 
>  	/* No need to invalidate - it was non-present before */
>  	update_mmu_cache(vma, addr, pte);
>  	lazy_mmu_prot_update(pte);
> +	pte_unmap_unlock(ptep, ptl);
> +	return;
> 
>  out:
>  	pte_unmap_unlock(ptep, ptl);
> +	container_rss_release(pcont);
>  }
> 
>  /*

you missed out an include in mm/migrate.c

cheers,

C.
Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
---
 mm/migrate.c |    1 +
 1 file changed, 1 insertion(+)

Index: 2.6.20/mm/migrate.c
===================================================================
--- 2.6.20.orig/mm/migrate.c
+++ 2.6.20/mm/migrate.c
@@ -28,6 +28,7 @@
 #include <linux/mempolicy.h>
 #include <linux/vmalloc.h>
 #include <linux/security.h>
+#include <linux/rss_container.h>
 
 #include "internal.h"

