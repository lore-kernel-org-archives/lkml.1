Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZFTLUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZFTLUN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 07:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZFTLUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 07:20:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34162 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbZFTLUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 07:20:00 -0400
Message-ID: <4A3CC5D4.7040905@redhat.com>
Date: Sat, 20 Jun 2009 14:19:48 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <marcelo@kvack.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] kvm/mmu: add support for another level to page walker
References: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com> <1245417389-5527-7-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1245417389-5527-7-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2009 04:16 PM, Joerg Roedel wrote:
> The page walker may be used with nested paging too when accessing mmio areas.
> Make it support the additional page-level too.
>
> Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> ---
>   arch/x86/kvm/mmu.c         |    6 ++++++
>   arch/x86/kvm/paging_tmpl.h |   16 ++++++++++++++++
>   2 files changed, 22 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index ef2396d..fc0e2fc 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -117,6 +117,11 @@ module_param(oos_shadow, bool, 0644);
>   #define PT64_DIR_BASE_ADDR_MASK \
>   	(PT64_BASE_ADDR_MASK&  ~((1ULL<<  (PAGE_SHIFT + PT64_LEVEL_BITS)) - 1))
>
> +#define PT64_PDPE_BASE_ADDR_MASK \
> +	(PT64_BASE_ADDR_MASK&  ~(1ULL<<  (PAGE_SHIFT + (2 * PT64_LEVEL_BITS))))
> +#define PT64_PDPE_OFFSET_MASK \
> +	(PT64_BASE_ADDR_MASK&  (1ULL<<  (PAGE_SHIFT + (2 * PT64_LEVEL_BITS))))
> +
>   #define PT32_BASE_ADDR_MASK PAGE_MASK
>   #define PT32_DIR_BASE_ADDR_MASK \
>   	(PAGE_MASK&  ~((1ULL<<  (PAGE_SHIFT + PT32_LEVEL_BITS)) - 1))
> @@ -130,6 +135,7 @@ module_param(oos_shadow, bool, 0644);
>   #define PFERR_RSVD_MASK (1U<<  3)
>   #define PFERR_FETCH_MASK (1U<<  4)
> +static gfn_t gpte_to_gfn_pdpe(pt_element_t gpte)
> +{
> +	return (gpte&  PT64_PDPE_BASE_ADDR_MASK)>>  PAGE_SHIFT;
> +}
> +
>   static bool FNAME(cmpxchg_gpte)(struct kvm *kvm,
>   			 gfn_t table_gfn, unsigned index,
>   			 pt_element_t orig_pte, pt_element_t new_pte)
> @@ -201,6 +207,15 @@ walk:
>   			break;
>   		}
>
> +		if (walker->level == PT_PDPE_LEVEL&&
> +		    (pte&  PT_PAGE_SIZE_MASK)&&
> +		    is_long_mode(vcpu)) {
> +			walker->gfn  = gpte_to_gfn_pdpe(pte);
> +			walker->gfn += (addr&  PT64_PDPE_OFFSET_MASK)
> +					>>  PAGE_SHIFT;
> +			break;
> +		}
> +
>   		pt_access = pte_access;
>    

It would be cleaner to merge this with the 2MB check earlier (and to 
rename and parametrise gpte_to_gfn_pde() rather than duplicate it).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

