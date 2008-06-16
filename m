Return-Path: <linux-kernel-owner+w=401wt.eu-S1755011AbYFPRoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbYFPRoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 13:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbYFPRo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 13:44:28 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:38294 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbYFPRo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 13:44:27 -0400
Date: Mon, 16 Jun 2008 18:42:43 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andreas Herrmann <andreas.herrmann3@amd.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 5/5 v2] x86: PAT: make pat_x_mtrr_type() more readable
In-Reply-To: <20080616125821.GA5213@alberich.amd.com>
Message-ID: <Pine.LNX.4.64.0806161753060.13075@blonde.site>
References: <20080610140755.GI5024@alberich.amd.com> <20080616125821.GA5213@alberich.amd.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008, Andreas Herrmann wrote:
> I've found it inconvenient to review pat_x_mtrr_type().
> Thus I slightly changed it and added some comment to make
> it more readable.

I found it hard to read too; but it's amusing how utterly different
are our ideas to make it more readable.  Most of what it is doing
seems to me confusingly left over from earlier implementations.

I've appended my version at the bottom: my involvement in pat.c is
not very strong, so would you like to take over my patch and combine
best of both into one?  I don't particularly want to stroll along
after, undoing what you did.

> 
> I've also added BUG statements for (some) unused/unhandled PAT/MTRR
> types.

I suspect your pat_type BUG is uninteresting (given _PAGE_CACHE_MASK
only has two bits to play with), and your mtrr_type BUG dangerous -
mtrr_type_lookup may be returning other values, which the current
code tolerates, I believe intentionally; but perhaps you've read
further than I did, and convinced yourself they cannot get there.

> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
> New patch version. (against current tip/x86/pat - v2.6.26-rc6-105-gfaeca31)
> Previous version had some conflict with another commit in tip/master.
> 
> Regards,
> Andreas
> 
>  arch/x86/mm/pat.c |   50 +++++++++++++++++++++++++++-----------------------
>  1 files changed, 27 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index 4beccea..cdf2c15 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -169,35 +169,39 @@ static int pat_x_mtrr_type(u64 start, u64 end, unsigned long prot,
>  	prot &= (~_PAGE_CACHE_MASK);
>  
>  	/*
> -	 * We return the PAT request directly for types where PAT takes
> -	 * precedence with respect to MTRR and for UC_MINUS.
> +	 * We return the PAT request directly for types where PAT
> +	 * takes precedence with respect to MTRR and for UC_MINUS. In
> +	 * case of pat_type==WB we have to know mtrr_type to get the
> +	 * effective type.
> +	 *
> +	 *    effective type                ret_prot
> +	 *  pat \ mtrr  WB WC UC    pat \ mtrr  WB  WC  UC
> +	 *  WC          WC WC WC    WC          WC  WC  WC
> +	 *  UC-         UC WC UC    UC-         UC- UC- UC-
> +	 *  UC          UC UC UC    UC          UC  UC  UC
> +	 *  WB          WB WC UC    WB          WB  WC  UC

I'm inclined to think that once the obfuscations in the code are
removed, the code becomes easier to understand than your comment
table (which, to be honest, I haven't even checked through).

> +	 *
>  	 * Consistency checks with other PAT requests is done later
>  	 * while going through memtype list.
>  	 */
> -	if (pat_type == _PAGE_CACHE_WC) {
> +	if (pat_type == _PAGE_CACHE_WC)
>  		*ret_prot = prot | _PAGE_CACHE_WC;
> -		return 0;
> -	} else if (pat_type == _PAGE_CACHE_UC_MINUS) {
> +	else if (pat_type == _PAGE_CACHE_UC_MINUS)
>  		*ret_prot = prot | _PAGE_CACHE_UC_MINUS;
> -		return 0;
> -	} else if (pat_type == _PAGE_CACHE_UC) {
> -		*ret_prot = prot | _PAGE_CACHE_UC;
> -		return 0;
> -	}
> -
> -	/*
> -	 * Look for MTRR hint to get the effective type in case where PAT
> -	 * request is for WB.
> -	 */
> -	mtrr_type = mtrr_type_lookup(start, end);
> -
> -	if (mtrr_type == MTRR_TYPE_UNCACHABLE) {
> +	else if (pat_type == _PAGE_CACHE_UC)
>  		*ret_prot = prot | _PAGE_CACHE_UC;
> -	} else if (mtrr_type == MTRR_TYPE_WRCOMB) {
> -		*ret_prot = prot | _PAGE_CACHE_WC;
> -	} else {
> -		*ret_prot = prot | _PAGE_CACHE_WB;
> -	}
> +	else if (pat_type == _PAGE_CACHE_WB) {
> +		mtrr_type = mtrr_type_lookup(start, end);
> +		if (mtrr_type == MTRR_TYPE_WRBACK)
> +			*ret_prot = prot | _PAGE_CACHE_WB;
> +		else if (mtrr_type == MTRR_TYPE_WRCOMB)
> +			*ret_prot = prot | _PAGE_CACHE_WC;
> +		else if (mtrr_type == MTRR_TYPE_UNCACHABLE)
> +			*ret_prot = prot | _PAGE_CACHE_UC;
> +		else
> +			BUG();
> +	} else
> +		  BUG();
>  
>  	return 0;
>  }

Clean up over-complications in pat_x_mtrr_type().
And if reserve_memtype() ignores stray req_type bits when
pat_enabled, it's better to mask them off when not also.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 arch/x86/mm/pat.c |   47 +++++++++++---------------------------------
 1 file changed, 12 insertions(+), 35 deletions(-)

--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -145,47 +145,31 @@ static DEFINE_SPINLOCK(memtype_lock); 	/
  * The intersection is based on "Effective Memory Type" tables in IA-32
  * SDM vol 3a
  */
-static int pat_x_mtrr_type(u64 start, u64 end, unsigned long prot,
-				unsigned long *ret_prot)
+static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
 {
-	unsigned long pat_type;
 	u8 mtrr_type;
 
-	pat_type = prot & _PAGE_CACHE_MASK;
-	prot &= (~_PAGE_CACHE_MASK);
-
 	/*
 	 * We return the PAT request directly for types where PAT takes
 	 * precedence with respect to MTRR and for UC_MINUS.
 	 * Consistency checks with other PAT requests is done later
 	 * while going through memtype list.
 	 */
-	if (pat_type == _PAGE_CACHE_WC) {
-		*ret_prot = prot | _PAGE_CACHE_WC;
-		return 0;
-	} else if (pat_type == _PAGE_CACHE_UC_MINUS) {
-		*ret_prot = prot | _PAGE_CACHE_UC_MINUS;
-		return 0;
-	} else if (pat_type == _PAGE_CACHE_UC) {
-		*ret_prot = prot | _PAGE_CACHE_UC;
-		return 0;
-	}
+	if (req_type == _PAGE_CACHE_WC ||
+	    req_type == _PAGE_CACHE_UC_MINUS ||
+	    req_type == _PAGE_CACHE_UC)
+		return req_type;
 
 	/*
 	 * Look for MTRR hint to get the effective type in case where PAT
 	 * request is for WB.
 	 */
 	mtrr_type = mtrr_type_lookup(start, end);
-
-	if (mtrr_type == MTRR_TYPE_UNCACHABLE) {
-		*ret_prot = prot | _PAGE_CACHE_UC;
-	} else if (mtrr_type == MTRR_TYPE_WRCOMB) {
-		*ret_prot = prot | _PAGE_CACHE_WC;
-	} else {
-		*ret_prot = prot | _PAGE_CACHE_WB;
-	}
-
-	return 0;
+	if (mtrr_type == MTRR_TYPE_UNCACHABLE)
+		return _PAGE_CACHE_UC;
+	if (mtrr_type == MTRR_TYPE_WRCOMB)
+		return _PAGE_CACHE_WC;
+	return _PAGE_CACHE_WB;
 }
 
 /*
@@ -218,7 +202,7 @@ int reserve_memtype(u64 start, u64 end, 
 			if (req_type == -1) {
 				*ret_type = _PAGE_CACHE_WB;
 			} else {
-				*ret_type = req_type;
+				*ret_type = req_type & _PAGE_CACHE_MASK;
 			}
 		}
 		return 0;
@@ -250,14 +234,7 @@ int reserve_memtype(u64 start, u64 end, 
 		}
 	} else {
 		req_type &= _PAGE_CACHE_MASK;
-		err = pat_x_mtrr_type(start, end, req_type, &actual_type);
-	}
-
-	if (err) {
-		if (ret_type)
-			*ret_type = actual_type;
-
-		return -EINVAL;
+		actual_type = pat_x_mtrr_type(start, end, req_type);
 	}
 
 	new_entry  = kmalloc(sizeof(struct memtype), GFP_KERNEL);

