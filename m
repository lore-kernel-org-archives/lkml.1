Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbZGaSEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbZGaSEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 14:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZGaSEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 14:04:35 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:28466 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbZGaSEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 14:04:34 -0400
Date: Fri, 31 Jul 2009 11:03:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: rusty@rustcorp.com.au, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, lguest@ozlabs.org,
       sfr@canb.auug.org.au
Subject: Re: [PATCH] next-20090730 lguest build breaks with pfn_pmd()
Message-Id: <20090731110356.cd0bc550.randy.dunlap@oracle.com>
In-Reply-To: <20090730120533.GB4955@linux.vnet.ibm.com>
References: <20090729173611.b82478cd.sfr@canb.auug.org.au>
	<20090730120533.GB4955@linux.vnet.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.4A73321B.00B9:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jul 2009 17:35:33 +0530 Kamalesh Babulal wrote:

> Hi Rusty,
> 
> 	next-20090729 allmodconfig build breaks at
> 
> drivers/lguest/page_tables.c: In function 'setup_pagetables':
> drivers/lguest/page_tables.c:987: error: incompatible type for argument 2 of 'pfn_pmd'
> drivers/lguest/page_tables.c:994: error: expected ';' before ')' token
> drivers/lguest/page_tables.c:994: error: expected statement before ')' token
> make[2]: *** [drivers/lguest/page_tables.o] Error 1
> 
> build failure is introduced by commit e07dd6220a4bf81a2549e7e37523a2557547d9d7
> I have tested the patch for the build failure only.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> --
>  drivers/lguest/page_tables.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
> index 8c86446..c610b82 100644
> --- a/drivers/lguest/page_tables.c
> +++ b/drivers/lguest/page_tables.c
> @@ -984,14 +984,14 @@ static unsigned long setup_pagetables(struct lguest *lg,
>  	for (i = j = 0; i < mapped_pages && j < PTRS_PER_PMD;
>  	     i += PTRS_PER_PTE, j++) {
>  		pmd = pfn_pmd(((unsigned long)&linear[i] - mem_base)/PAGE_SIZE,
> -			      _PAGE_PRESENT | _PAGE_RW | _PAGE_USER);
> +			      __pgrot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER));

s/__pgrot/__pgprot/


>  
>  		if (copy_to_user(&pmds[j], &pmd, sizeof(pmd)) != 0)
>  			return -EFAULT;
>  	}
>  
>  	/* One PGD entry, pointing to that PMD page. */
> -	pgd = __pgd(((unsigned long)pmds - mem_base) | _PAGE_PRESENT));
> +	pgd = __pgd(((unsigned long)pmds - mem_base) | _PAGE_PRESENT);
>  	/* Copy it in as the first PGD entry (ie. addresses 0-1G). */
>  	if (copy_to_user(&pgdir[0], &pgd, sizeof(pgd)) != 0)
>  		return -EFAULT;


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
