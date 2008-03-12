Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbYCLDW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbYCLDW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 23:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbYCLDWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 23:22:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:48015 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbYCLDWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 23:22:48 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Hibernation: Fix mark_nosave_pages()
Date: Tue, 11 Mar 2008 23:21:55 -0400
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200803120034.58615.rjw@sisk.pl>
In-Reply-To: <200803120034.58615.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803112321.55618.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied to acpi test tree.

thanks,
-len

On Tuesday 11 March 2008, Rafael J. Wysocki wrote:
> Hi Len,
> 
> The following patch fixes http://bugzilla.kernel.org/show_bug.cgi?id=9966 .
> 
> Although the problem has been there for quite some time (since before 2.6.22,
> apparently), it would be good to have in 2.6.25, because it may fix booting
> problems on the affected systems.
> 
> Please note that it doesn't modify the code behavior on the systems which are
> not affected by bug #9966 .
> 
> Thanks,
> Rafael
> 
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> There is a problem in the hibernation code that triggers on some NUMA
> systems on which pfn_valid() returns 'true' for some PFNs that don't
> belong to any zone.  Namely, there is a BUG_ON() in
> memory_bm_find_bit() that triggers for PFNs not belonging to any
> zone and passing the pfn_valid() test.  On the affected systems it
> triggers when we mark PFNs reported by the platform as not saveable,
> because the PFNs in question belong to a region mapped directly using
> iorepam() (i.e. the ACPI data area) and they pass the pfn_valid()
> test.
> 
> Modify memory_bm_find_bit() so that it returns an error if given PFN
> doesn't belong to any zone instead of crashing the kernel and ignore
> the result returned by it in mark_nosave_pages(), while marking the
> "nosave" memory regions.
> 
> This doesn't affect the hibernation functionality, as we won't touch
> the PFNs in question anyway.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  kernel/power/snapshot.c |   41 ++++++++++++++++++++++++++++++++++-------
>  1 file changed, 34 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6/kernel/power/snapshot.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/snapshot.c
> +++ linux-2.6/kernel/power/snapshot.c
> @@ -447,7 +447,7 @@ static void memory_bm_free(struct memory
>   *	of @bm->cur_zone_bm are updated.
>   */
>  
> -static void memory_bm_find_bit(struct memory_bitmap *bm, unsigned long pfn,
> +static int memory_bm_find_bit(struct memory_bitmap *bm, unsigned long pfn,
>  				void **addr, unsigned int *bit_nr)
>  {
>  	struct zone_bitmap *zone_bm;
> @@ -461,7 +461,8 @@ static void memory_bm_find_bit(struct me
>  		while (pfn < zone_bm->start_pfn || pfn >= zone_bm->end_pfn) {
>  			zone_bm = zone_bm->next;
>  
> -			BUG_ON(!zone_bm);
> +			if (!zone_bm)
> +				return -EFAULT;
>  		}
>  		bm->cur.zone_bm = zone_bm;
>  	}
> @@ -479,23 +480,40 @@ static void memory_bm_find_bit(struct me
>  	pfn -= bb->start_pfn;
>  	*bit_nr = pfn % BM_BITS_PER_CHUNK;
>  	*addr = bb->data + pfn / BM_BITS_PER_CHUNK;
> +	return 0;
>  }
>  
>  static void memory_bm_set_bit(struct memory_bitmap *bm, unsigned long pfn)
>  {
>  	void *addr;
>  	unsigned int bit;
> +	int error;
>  
> -	memory_bm_find_bit(bm, pfn, &addr, &bit);
> +	error = memory_bm_find_bit(bm, pfn, &addr, &bit);
> +	BUG_ON(error);
>  	set_bit(bit, addr);
>  }
>  
> +static int mem_bm_set_bit_check(struct memory_bitmap *bm, unsigned long pfn)
> +{
> +	void *addr;
> +	unsigned int bit;
> +	int error;
> +
> +	error = memory_bm_find_bit(bm, pfn, &addr, &bit);
> +	if (!error)
> +		set_bit(bit, addr);
> +	return error;
> +}
> +
>  static void memory_bm_clear_bit(struct memory_bitmap *bm, unsigned long pfn)
>  {
>  	void *addr;
>  	unsigned int bit;
> +	int error;
>  
> -	memory_bm_find_bit(bm, pfn, &addr, &bit);
> +	error = memory_bm_find_bit(bm, pfn, &addr, &bit);
> +	BUG_ON(error);
>  	clear_bit(bit, addr);
>  }
>  
> @@ -503,8 +521,10 @@ static int memory_bm_test_bit(struct mem
>  {
>  	void *addr;
>  	unsigned int bit;
> +	int error;
>  
> -	memory_bm_find_bit(bm, pfn, &addr, &bit);
> +	error = memory_bm_find_bit(bm, pfn, &addr, &bit);
> +	BUG_ON(error);
>  	return test_bit(bit, addr);
>  }
>  
> @@ -709,8 +729,15 @@ static void mark_nosave_pages(struct mem
>  				region->end_pfn << PAGE_SHIFT);
>  
>  		for (pfn = region->start_pfn; pfn < region->end_pfn; pfn++)
> -			if (pfn_valid(pfn))
> -				memory_bm_set_bit(bm, pfn);
> +			if (pfn_valid(pfn)) {
> +				/*
> +				 * It is safe to ignore the result of
> +				 * mem_bm_set_bit_check() here, since we won't
> +				 * touch the PFNs for which the error is
> +				 * returned anyway.
> +				 */
> +				mem_bm_set_bit_check(bm, pfn);
> +			}
>  	}
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


