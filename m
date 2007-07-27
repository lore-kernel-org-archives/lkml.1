Return-Path: <linux-kernel-owner+w=401wt.eu-S936982AbXG0OQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936982AbXG0OQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 10:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbXG0OQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 10:16:31 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:58976 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760556AbXG0OQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 10:16:30 -0400
Message-ID: <46A9FE3B.7070402@bull.net>
Date: Fri, 27 Jul 2007 16:16:27 +0200
From: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.3) Gecko/20040913
X-Accept-Language: en-us, en, fr, hu
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] flush cache fixes for ia64 [2/2] sync icache dcache
References: <20070727133657.8c9c6803.kamezawa.hiroyu@jp.fujitsu.com> <20070727133936.36b047cd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070727133936.36b047cd.kamezawa.hiroyu@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 27/07/2007 16:21:07,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 27/07/2007 16:21:10,
	Serialize complete at 27/07/2007 16:21:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Do you really need a "sync_icache_dcache()" in "do_wp_page()"?
I guess it is only needed when the EXEC bit of the PTE gets turned on.

> --- linux-2.6.23-rc1.test.orig/mm/migrate.c
> +++ linux-2.6.23-rc1.test/mm/migrate.c
> @@ -172,6 +172,7 @@ static void remove_migration_pte(struct 
>  	pte = pte_mkold(mk_pte(new, vma->vm_page_prot));
>  	if (is_write_migration_entry(entry))
>  		pte = pte_mkwrite(pte);
> +	flush_icache_page(vma, new);
>  	set_pte_at(mm, addr, ptep, pte);
>  
>  	if (PageAnon(new))

I think "flush_icache_page()", or rather "flush_cache_page()" is
to be placed where migration tears down the old virtual --> physical
address translation for good.

> --- linux-2.6.23-rc1.test.orig/mm/migrate.c
> +++ linux-2.6.23-rc1.test/mm/migrate.c
> @@ -173,6 +173,7 @@ static void remove_migration_pte(struct 
>  	if (is_write_migration_entry(entry))
>  		pte = pte_mkwrite(pte);
>  	flush_icache_page(vma, new);
> +	sync_icache_dcache(pte);
>  	set_pte_at(mm, addr, ptep, pte);

Sure, I can agree to add "sync_icache_dcache()" here.

Thanks,

Zoltan
