Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbZFVJjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbZFVJjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 05:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755612AbZFVJiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 05:38:50 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:44482
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753038AbZFVJir convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 05:38:47 -0400
X-SpamScore: -34
X-BigFish: VPS-34(z34a4jz1432R98dR936eN1805M9371Pzz1202hzzz32i6bh17ch43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KLMW4F-01-NE4-01
Date: Mon, 22 Jun 2009 11:38:13 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <marcelo@kvack.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] kvm/mmu: add support for another level to page
	walker
Message-ID: <20090622093813.GC5139@amd.com>
References: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com> <1245417389-5527-7-git-send-email-joerg.roedel@amd.com> <4A3CC5D4.7040905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A3CC5D4.7040905@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 22 Jun 2009 09:38:13.0458 (UTC) FILETIME=[299DD320:01C9F31D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 20, 2009 at 02:19:48PM +0300, Avi Kivity wrote:
> On 06/19/2009 04:16 PM, Joerg Roedel wrote:
>> The page walker may be used with nested paging too when accessing mmio areas.
>> Make it support the additional page-level too.
>>
>> Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
>> ---
>>   arch/x86/kvm/mmu.c         |    6 ++++++
>>   arch/x86/kvm/paging_tmpl.h |   16 ++++++++++++++++
>>   2 files changed, 22 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index ef2396d..fc0e2fc 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -117,6 +117,11 @@ module_param(oos_shadow, bool, 0644);
>>   #define PT64_DIR_BASE_ADDR_MASK \
>>   	(PT64_BASE_ADDR_MASK&  ~((1ULL<<  (PAGE_SHIFT + PT64_LEVEL_BITS)) - 1))
>>
>> +#define PT64_PDPE_BASE_ADDR_MASK \
>> +	(PT64_BASE_ADDR_MASK&  ~(1ULL<<  (PAGE_SHIFT + (2 * PT64_LEVEL_BITS))))
>> +#define PT64_PDPE_OFFSET_MASK \
>> +	(PT64_BASE_ADDR_MASK&  (1ULL<<  (PAGE_SHIFT + (2 * PT64_LEVEL_BITS))))
>> +
>>   #define PT32_BASE_ADDR_MASK PAGE_MASK
>>   #define PT32_DIR_BASE_ADDR_MASK \
>>   	(PAGE_MASK&  ~((1ULL<<  (PAGE_SHIFT + PT32_LEVEL_BITS)) - 1))
>> @@ -130,6 +135,7 @@ module_param(oos_shadow, bool, 0644);
>>   #define PFERR_RSVD_MASK (1U<<  3)
>>   #define PFERR_FETCH_MASK (1U<<  4)
>> +static gfn_t gpte_to_gfn_pdpe(pt_element_t gpte)
>> +{
>> +	return (gpte&  PT64_PDPE_BASE_ADDR_MASK)>>  PAGE_SHIFT;
>> +}
>> +
>>   static bool FNAME(cmpxchg_gpte)(struct kvm *kvm,
>>   			 gfn_t table_gfn, unsigned index,
>>   			 pt_element_t orig_pte, pt_element_t new_pte)
>> @@ -201,6 +207,15 @@ walk:
>>   			break;
>>   		}
>>
>> +		if (walker->level == PT_PDPE_LEVEL&&
>> +		    (pte&  PT_PAGE_SIZE_MASK)&&
>> +		    is_long_mode(vcpu)) {
>> +			walker->gfn  = gpte_to_gfn_pdpe(pte);
>> +			walker->gfn += (addr&  PT64_PDPE_OFFSET_MASK)
>> +					>>  PAGE_SHIFT;
>> +			break;
>> +		}
>> +
>>   		pt_access = pte_access;
>>    
>
> It would be cleaner to merge this with the 2MB check earlier (and to  
> rename and parametrise gpte_to_gfn_pde() rather than duplicate it).

Ok, I will merge it into the previous function.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

