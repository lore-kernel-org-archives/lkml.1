Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbZK3XWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbZK3XWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 18:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZK3XWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 18:22:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:29216 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbZK3XWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 18:22:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="518481640"
Subject: Re: [RFC PATCH -tip] x86/pat: fix pat_x_mtrr_type to its essentials
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <1259237724-21260-1-git-send-email-dfeng@redhat.com>
References: <1259237724-21260-1-git-send-email-dfeng@redhat.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 30 Nov 2009 15:21:32 -0800
Message-Id: <1259623292.2651.218.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiaotian,

We look through the mtrr's only when the incoming request type is WB
(which is mostly the case for legacy /dev/mem mmap mapping). And only in
this scenario we use more conservative UC- instead of WC, if mtrr says
WC.

This will ensure the scenarios like ioremap() (which defaults to UC-) by
legacy drivers, before and after the user level mmap are consistent and
don't fail because of inconsistent mappings etc.

There is no reason why we need to use WC when especially the incoming
request was not strict enough and specified WB.

Also BTW,  your current effective return values mentioned in the below
table () is wrong.

i.e., for example, when we use UC- for PAT and mtrr has WC, effective
memory type used by cpu will be WC.

thanks,
suresh

On Thu, 2009-11-26 at 04:15 -0800, Xiaotian Feng wrote:
> Due to the IA-32 SDM vol 3a "Effective Memory Type" tables, the PAT
> and mtrr relations should be:
> 	|	UC	UC-	WC	WB	[PAT]
> --------+--------------------------------------
> UC	|	UC	UC(UC-)	WC	UC(UC-)
> WC	|	UC	WC(UC-)	WC	WC(UC-)
> WB	|	UC	UC(UC-)	WC	WB
> [MTRR]
> * In () is the current return value.
> 
> So, commit b6ff32, Fix pat_x_mtrr_type() to use UC_MINUS when the
> mtrr type return UC. But it also made mtrr type WC use UC_MINUS.
> This is not reasonable.
> 
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> ---
>  arch/x86/mm/pat.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index c37fd51..92e9627 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -228,10 +228,11 @@ static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
>  		u8 mtrr_type;
>  
>  		mtrr_type = mtrr_type_lookup(start, end);
> -		if (mtrr_type != MTRR_TYPE_WRBACK)
> -			return _PAGE_CACHE_UC_MINUS;
> -
> -		return _PAGE_CACHE_WB;
> +		if (mtrr_type == MTRR_TYPE_WRBACK)
> +			return _PAGE_CACHE_WB;
> +		else if (mtrr_type == MTRR_TYPE_WRCOMB)
> +			return _PAGE_CACHE_WC;
> +		return _PAGE_CACHE_UC_MINUS;
>  	}
>  
>  	return req_type;

