Return-Path: <linux-kernel-owner+w=401wt.eu-S1759100AbXKANsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100AbXKANsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 09:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbXKANsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 09:48:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbXKANsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 09:48:00 -0400
Message-ID: <4729D92E.2030108@redhat.com>
Date: Thu, 01 Nov 2007 11:48:30 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070811)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com, tglx@linutronix.de,
       jun.nakajima@intel.com, glommer@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/16] read/write_crX, clts and wbinvd for 64-bit paravirt
References: <1193858101367-git-send-email-gcosta@redhat.com> <11938581073775-git-send-email-gcosta@redhat.com> <11938581133479-git-send-email-gcosta@redhat.com> <1193858118284-git-send-email-gcosta@redhat.com> <47295AA7.9090507@goop.org>
In-Reply-To: <47295AA7.9090507@goop.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jeremy Fitzhardinge escreveu:
> Glauber de Oliveira Costa wrote:
>> This patch introduces, and patch callers when needed, native
>> versions for read/write_crX functions, clts and wbinvd.
>>
>> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
>> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>> Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
>> ---
>>  arch/x86/mm/pageattr_64.c   |    3 +-
>>  include/asm-x86/system_64.h |   60 ++++++++++++++++++++++++++++++------------
>>  2 files changed, 45 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/x86/mm/pageattr_64.c b/arch/x86/mm/pageattr_64.c
>> index c40afba..59a52b0 100644
>> --- a/arch/x86/mm/pageattr_64.c
>> +++ b/arch/x86/mm/pageattr_64.c
>> @@ -12,6 +12,7 @@
>>  #include <asm/processor.h>
>>  #include <asm/tlbflush.h>
>>  #include <asm/io.h>
>> +#include <asm/paravirt.h>
>>  
>>  pte_t *lookup_address(unsigned long address)
>>  { 
>> @@ -77,7 +78,7 @@ static void flush_kernel_map(void *arg)
>>  	   much cheaper than WBINVD. */
>>  	/* clflush is still broken. Disable for now. */
>>  	if (1 || !cpu_has_clflush)
>> -		asm volatile("wbinvd" ::: "memory");
>> +		wbinvd();
>>  	else list_for_each_entry(pg, l, lru) {
>>  		void *adr = page_address(pg);
>>  		clflush_cache_range(adr, PAGE_SIZE);
>> diff --git a/include/asm-x86/system_64.h b/include/asm-x86/system_64.h
>> index 4cb2384..b558cb2 100644
>> --- a/include/asm-x86/system_64.h
>> +++ b/include/asm-x86/system_64.h
>> @@ -65,53 +65,62 @@ extern void load_gs_index(unsigned);
>>  /*
>>   * Clear and set 'TS' bit respectively
>>   */
>> -#define clts() __asm__ __volatile__ ("clts")
>> +static inline void native_clts(void)
>> +{
>> +	asm volatile ("clts");
>> +}
>>  
>> -static inline unsigned long read_cr0(void)
>> -{ 
>> +static inline unsigned long native_read_cr0(void)
>> +{
>>  	unsigned long cr0;
>>  	asm volatile("movq %%cr0,%0" : "=r" (cr0));
>>  	return cr0;
>>  }
>>   
> 
> This is a pre-existing bug, but it seems to me that these read/write crX
> asms should have a constraint to stop the compiler from reordering them
> with respect to each other.  The brute-force approach would be to add
> "memory" clobbers, but the subtle fix would be to add a variable which
> is only used to sequence:
> 
I in fact have seen bugs with mixed reads and writes to the same cr,
(cr4), but adding the volatile
flag to the read function seemed to fix it. Yet, I agree with you that
the theorectical problem exists for the reorder, and your proposed fix
seems fine (although if we're really desperate about memory usage, we
can use a char instead a int and save 3 bytes!)

It also just ocurred to me that this part of the patch can also go into
the consolidation part. So I'll respin it.

Thanks for the comment
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Remi - http://enigmail.mozdev.org

iD8DBQFHKdkujYI8LaFUWXMRAhV2AKDPIjwGQnoLtldys/OWtIEs6biwxwCg1Jd/
o36S+qcb4sWJ6peqhrSRnos=
=YmeC
-----END PGP SIGNATURE-----
