Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbYGGPMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbYGGPMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 11:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbYGGPMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 11:12:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753493AbYGGPMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 11:12:00 -0400
Message-ID: <4872319B.9040809@linux-foundation.org>
Date: Mon, 07 Jul 2008 10:09:15 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: gerald.schaefer@de.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] Make CONFIG_MIGRATION available for s390
References: <1215354957.9842.19.camel@localhost.localdomain>
In-Reply-To: <1215354957.9842.19.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerald Schaefer wrote:

> Index: linux-2.6/include/linux/migrate.h
> ===================================================================
> --- linux-2.6.orig/include/linux/migrate.h
> +++ linux-2.6/include/linux/migrate.h
> @@ -13,6 +13,7 @@ static inline int vma_migratable(struct 
>  {
>  	if (vma->vm_flags & (VM_IO|VM_HUGETLB|VM_PFNMAP|VM_RESERVED))
>  		return 0;
> +#ifdef CONFIG_NUMA
>  	/*
>  	 * Migration allocates pages in the highest zone. If we cannot
>  	 * do so then migration (at least from node to node) is not
> @@ -22,6 +23,7 @@ static inline int vma_migratable(struct 
>  		gfp_zone(mapping_gfp_mask(vma->vm_file->f_mapping))
>  								< policy_zone)
>  			return 0;
> +#endif
>  	return 1;
>  }

This will extend the number of pages that are migratable and lead to strange
semantics in the NUMA case. There suddenly vma_is migratable will forbid hotplug
to migrate certain pages. 

I think we need two functions:

vma_migratable()	General migratability

vma_policy_migratable()	Migratable under NUMA policies.


> Index: linux-2.6/include/linux/mm.h
> ===================================================================
> --- linux-2.6.orig/include/linux/mm.h
> +++ linux-2.6/include/linux/mm.h
> @@ -193,6 +193,8 @@ struct vm_operations_struct {
>  	 */
>  	struct mempolicy *(*get_policy)(struct vm_area_struct *vma,
>  					unsigned long addr);
> +#endif
> +#ifdef CONFIG_MIGRATION
>  	int (*migrate)(struct vm_area_struct *vma, const nodemask_t *from,
>  		const nodemask_t *to, unsigned long flags);
>  #endif

That wont work since the migrate function takes a nodemask! The point of
the function is to move memory from node to node which is something that you
*cannot* do in a non NUMA configuration. So leave this chunk out.


> Index: linux-2.6/mm/Kconfig
> ===================================================================
> --- linux-2.6.orig/mm/Kconfig
> +++ linux-2.6/mm/Kconfig
> @@ -174,7 +174,7 @@ config SPLIT_PTLOCK_CPUS
>  config MIGRATION
>  	bool "Page migration"
>  	def_bool y
> -	depends on NUMA
> +	depends on NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE
>  	help
>  	  Allows the migration of the physical location of pages of processes
>  	  while the virtual addresses are not changed. This is useful for

Hmmm... Okay. I tried to make MIGRATION as independent of CONFIG_NUMA as possible so hopefully this will work.



