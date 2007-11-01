Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbXKAEsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbXKAEsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 00:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbXKAEsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 00:48:45 -0400
Received: from gw.goop.org ([64.81.55.164]:43201 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbXKAEso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 00:48:44 -0400
Message-ID: <47295AA7.9090507@goop.org>
Date: Wed, 31 Oct 2007 21:48:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com, tglx@linutronix.de,
       jun.nakajima@intel.com, glommer@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/16] read/write_crX, clts and wbinvd for 64-bit paravirt
References: <1193858101367-git-send-email-gcosta@redhat.com> <11938581073775-git-send-email-gcosta@redhat.com> <11938581133479-git-send-email-gcosta@redhat.com> <1193858118284-git-send-email-gcosta@redhat.com>
In-Reply-To: <1193858118284-git-send-email-gcosta@redhat.com>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> This patch introduces, and patch callers when needed, native
> versions for read/write_crX functions, clts and wbinvd.
>
> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> ---
>  arch/x86/mm/pageattr_64.c   |    3 +-
>  include/asm-x86/system_64.h |   60 ++++++++++++++++++++++++++++++------------
>  2 files changed, 45 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/mm/pageattr_64.c b/arch/x86/mm/pageattr_64.c
> index c40afba..59a52b0 100644
> --- a/arch/x86/mm/pageattr_64.c
> +++ b/arch/x86/mm/pageattr_64.c
> @@ -12,6 +12,7 @@
>  #include <asm/processor.h>
>  #include <asm/tlbflush.h>
>  #include <asm/io.h>
> +#include <asm/paravirt.h>
>  
>  pte_t *lookup_address(unsigned long address)
>  { 
> @@ -77,7 +78,7 @@ static void flush_kernel_map(void *arg)
>  	   much cheaper than WBINVD. */
>  	/* clflush is still broken. Disable for now. */
>  	if (1 || !cpu_has_clflush)
> -		asm volatile("wbinvd" ::: "memory");
> +		wbinvd();
>  	else list_for_each_entry(pg, l, lru) {
>  		void *adr = page_address(pg);
>  		clflush_cache_range(adr, PAGE_SIZE);
> diff --git a/include/asm-x86/system_64.h b/include/asm-x86/system_64.h
> index 4cb2384..b558cb2 100644
> --- a/include/asm-x86/system_64.h
> +++ b/include/asm-x86/system_64.h
> @@ -65,53 +65,62 @@ extern void load_gs_index(unsigned);
>  /*
>   * Clear and set 'TS' bit respectively
>   */
> -#define clts() __asm__ __volatile__ ("clts")
> +static inline void native_clts(void)
> +{
> +	asm volatile ("clts");
> +}
>  
> -static inline unsigned long read_cr0(void)
> -{ 
> +static inline unsigned long native_read_cr0(void)
> +{
>  	unsigned long cr0;
>  	asm volatile("movq %%cr0,%0" : "=r" (cr0));
>  	return cr0;
>  }
>   

This is a pre-existing bug, but it seems to me that these read/write crX
asms should have a constraint to stop the compiler from reordering them
with respect to each other.  The brute-force approach would be to add
"memory" clobbers, but the subtle fix would be to add a variable which
is only used to sequence:

static int __cr_seq;

static inline unsigned long native_read_cr0(void)
{
	unsigned long cr0;
	asm volatile("mov %%cr0, %0" : "=r" (cr0), "=m" (__cr_seq));
}

static inline void native_write_cr0(unsigned long val)
{
	asm volatile("mov %1, %%cr0" : "+m" (__cr_seq) : "r" (val));
}


    J
