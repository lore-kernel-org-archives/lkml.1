Return-Path: <linux-kernel-owner+w=401wt.eu-S1759196AbXKQKu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759196AbXKQKu3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 05:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbXKQKuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 05:50:21 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:35667 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbXKQKuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 05:50:20 -0500
Message-ID: <473EC75F.5020208@tiscali.nl>
Date: Sat, 17 Nov 2007 11:50:07 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 7/8] UML - add virt_to_pte
References: <20071116214227.GA13877@c2.user-mode-linux.org>
In-Reply-To: <20071116214227.GA13877@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> Turn um_virt_to_phys into virt_to_pte, cleaning up a horrid interface.
> 
> It's also made non-static and declared in pgtable.h because it'll be
> needed when the stubs get a vma.
> 
> Signed-off-by: Jeff Dike <jdike@linux.intel.com>
> ---
>  arch/um/kernel/skas/uaccess.c |   56 +++++++++++++++++-------------------------
>  include/asm-um/pgtable.h      |    3 ++
>  2 files changed, 26 insertions(+), 33 deletions(-)
> 
> Index: linux-2.6.22/arch/um/kernel/skas/uaccess.c
> ===================================================================
> --- linux-2.6.22.orig/arch/um/kernel/skas/uaccess.c	2007-11-16 15:16:54.000000000 -0500
> +++ linux-2.6.22/arch/um/kernel/skas/uaccess.c	2007-11-16 15:40:25.000000000 -0500
> @@ -13,70 +13,60 @@
>  #include "kern_util.h"
>  #include "os.h"
>  
> -static void *um_virt_to_phys(struct task_struct *task, unsigned long addr,
> -			     pte_t *pte_out)
> +pte_t *virt_to_pte(struct mm_struct *mm, unsigned long addr)
>  {
>  	pgd_t *pgd;
>  	pud_t *pud;
>  	pmd_t *pmd;
> -	pte_t *pte;
> -	pte_t ptent;
>  
> -	if (task->mm == NULL)
> -		return ERR_PTR(-EINVAL);
> -	pgd = pgd_offset(task->mm, addr);
> +	if (mm == NULL)
> +		return NULL;
> +
> +	pgd = pgd_offset(mm, addr);
>  	if (!pgd_present(*pgd))
> -		return ERR_PTR(-EINVAL);
> +		return NULL;
>  
>  	pud = pud_offset(pgd, addr);
>  	if (!pud_present(*pud))
> -		return ERR_PTR(-EINVAL);
> +		return NULL;
>  
>  	pmd = pmd_offset(pud, addr);
>  	if (!pmd_present(*pmd))
> -		return ERR_PTR(-EINVAL);
> -
> -	pte = pte_offset_kernel(pmd, addr);
> -	ptent = *pte;
> -	if (!pte_present(ptent))
> -		return ERR_PTR(-EINVAL);
> +		return NULL;
>  
> -	if (pte_out != NULL)
> -		*pte_out = ptent;
> -	return (void *) (pte_val(ptent) & PAGE_MASK) + (addr & ~PAGE_MASK);
> +	return pte_offset_kernel(pmd, addr);
>  }
>  
> -static unsigned long maybe_map(unsigned long virt, int is_write)
> +static pte_t *maybe_map(unsigned long virt, int is_write)
>  {
> -	pte_t pte;
> -	int err;
> +	pte_t *pte = virt_to_pte(current->mm, virt);
> +	int err, dummy_code;
>  
> -	void *phys = um_virt_to_phys(current, virt, &pte);
> -	int dummy_code;
> -
> -	if (IS_ERR(phys) || (is_write && !pte_write(pte))) {
> +	if ((pte == NULL) || !pte_present(*pte) ||
> +	    (is_write && !pte_write(*pte))) {
>  		err = handle_page_fault(virt, 0, is_write, 1, &dummy_code);
>  		if (err)
> -			return -1UL;
> -		phys = um_virt_to_phys(current, virt, NULL);
> +			return NULL;
> +		pte = virt_to_pte(current->mm, virt);
>  	}
> -	if (IS_ERR(phys))
> -		phys = (void *) -1;
> +	if (!pte_present(*pte))
> +		pte = NULL;

shouldn't you check again for (pte == NULL)?

>  
> -	return (unsigned long) phys;
> +	return pte;
>  }
