Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbXLKVar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbXLKVar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 16:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbXLKVai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 16:30:38 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:54943 "EHLO
	outbound1-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880AbXLKVag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 16:30:36 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
Date: Tue, 11 Dec 2007 22:26:28 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Ingo Molnar" <mingo@elte.hu>
cc: "Andi Kleen" <ak@suse.de>, dor.laor@qumranet.com,
       "kvm-devel" <kvm-devel@lists.sourceforge.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] Performance overhead of get_cycles_sync
Message-ID: <20071211212628.GB6537@amd.com>
References: <475E8C8B.7070308@qumranet.com>
 <20071211133738.GA8150@elte.hu> <475E9A92.4030001@qumranet.com>
 <20071211142717.GA15903@elte.hu>
MIME-Version: 1.0
In-Reply-To: <20071211142717.GA15903@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 11 Dec 2007 21:26:28.0757 (UTC)
 FILETIME=[7DDF9C50:01C83C3C]
X-WSS-ID: 6B41DF050QK4464888-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 03:27:17PM +0100, Ingo Molnar wrote:
> 
> * Dor Laor <dor.laor@gmail.com> wrote:
> 
> > Here [include/asm-x86/tsc.h]:
> >
> > /* Like get_cycles, but make sure the CPU is synchronized. */
> > static __always_inline cycles_t get_cycles_sync(void)
> > {
> >    unsigned long long ret;
> >    unsigned eax, edx;
> >
> >    /*
> >       * Use RDTSCP if possible; it is guaranteed to be synchronous
> >      * and doesn't cause a VMEXIT on Hypervisors
> >     */
> >    alternative_io(ASM_NOP3, ".byte 0x0f,0x01,0xf9", X86_FEATURE_RDTSCP,
> >               ASM_OUTPUT2("=a" (eax), "=d" (edx)),
> >               "a" (0U), "d" (0U) : "ecx", "memory");
> >    ret = (((unsigned long long)edx) << 32) | ((unsigned long long)eax);
> >    if (ret)
> >        return ret;
> >
> >    /*
> >     * Don't do an additional sync on CPUs where we know
> >     * RDTSC is already synchronous:
> >     */
> > //    alternative_io("cpuid", ASM_NOP2, X86_FEATURE_SYNC_RDTSC,
> > //              "=a" (eax), "0" (1) : "ebx","ecx","edx","memory");
> >    rdtscll(ret);
> 
> The patch below should resolve this - could you please test and Ack it? 
> But this CPUID was present in v2.6.23 too, so why did it only show up in 
> 2.6.24-rc for you?
> 
> 	Ingo
> 
> -------------->
> Subject: x86: fix get_cycles_sync() overhead
> From: Ingo Molnar <mingo@elte.hu>
> 
> get_cycles_sync() is causing massive overhead in KVM networking:
> 
>    http://lkml.org/lkml/2007/12/11/54
> 
> remove the explicit CPUID serialization - it causes VM exits and is
> pointless: we care about GTOD coherency but that goes to user-space
> via a syscall, and syscalls are serialization points anyway.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/asm-x86/tsc.h |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> Index: linux-x86.q/include/asm-x86/tsc.h
> ===================================================================
> --- linux-x86.q.orig/include/asm-x86/tsc.h
> +++ linux-x86.q/include/asm-x86/tsc.h
> @@ -39,8 +39,8 @@ static __always_inline cycles_t get_cycl
>  	unsigned eax, edx;
>  
>  	/*
> -  	 * Use RDTSCP if possible; it is guaranteed to be synchronous
> - 	 * and doesn't cause a VMEXIT on Hypervisors
> +	 * Use RDTSCP if possible; it is guaranteed to be synchronous
> +	 * and doesn't cause a VMEXIT on Hypervisors
>  	 */
>  	alternative_io(ASM_NOP3, ".byte 0x0f,0x01,0xf9", X86_FEATURE_RDTSCP,
>  		       ASM_OUTPUT2("=a" (eax), "=d" (edx)),
> @@ -50,11 +50,11 @@ static __always_inline cycles_t get_cycl
>  		return ret;
>  
>  	/*
> -	 * Don't do an additional sync on CPUs where we know
> -	 * RDTSC is already synchronous:
> +	 * Use RDTSC on other CPUs. This might not be fully synchronous,
> +	 * but it's not a problem: the only coherency we care about is
> +	 * the GTOD output to user-space, and syscalls are synchronization
> +	 * points anyway:
>  	 */
> -	alternative_io("cpuid", ASM_NOP2, X86_FEATURE_SYNC_RDTSC,
> -			  "=a" (eax), "0" (1) : "ebx","ecx","edx","memory");
>  	rdtscll(ret);
>  
>  	return ret;

I don't think this is a good idea. I discussed exactly this item with
Andi Kleen a while ago and afair the serializing instruction was
necessary to fix a backwards walking gettimeofday() on some K8
revisions. Andi Kleen can tell more details, I added him to the CC list.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


