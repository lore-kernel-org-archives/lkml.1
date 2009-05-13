Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbZEMGUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbZEMGUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 02:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZEMGUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 02:20:06 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:28727 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbZEMGUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 02:20:04 -0400
X-BigFish: VPS-23(zz1432R98dR1805M936fJzz1202hzz5a6ciz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KJKK6Y-02-OOO-01
Date: Wed, 13 May 2009 08:18:01 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       Robert Richter <robert.richter@amd.com>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 6/10 -tip] x86: early_init_intel() user of Advanced
	Power Management features
Message-ID: <20090513061801.GD9991@alberich.amd.com>
References: <1242142530.2547.11.camel@ht.satnam> <1242142623.2547.13.camel@ht.satnam> <1242142692.2547.15.camel@ht.satnam> <1242142753.2547.16.camel@ht.satnam> <1242142807.2547.18.camel@ht.satnam> <1242142849.2547.19.camel@ht.satnam> <1242142908.2547.20.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1242142908.2547.20.camel@ht.satnam>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 May 2009 06:18:30.0336 (UTC) FILETIME=[A2988400:01C9D392]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 09:11:48PM +0530, Jaswinder Singh Rajput wrote:
> 
> use X86_FEATURE_CONSTANT_TSC to determine TSC Invariance
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

I'd like to NAK this as well.

You didn't get to the point what's the difference between
X86_FEATURE_CONSTANT_TSC and X86_FEATURE_NONSTOP_TSC, did you?
I guess you never checked the related commit messages. (I.e. using git
blame to see how code evolved over time and _why_ was it changed.)
In this case it would have been commit 40fb17152c50a69dc304dd632131c2f41281ce44
(x86: support always running TSC on Intel CPUs), see
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=40fb17152c50a69dc304dd632131c2f41281ce44

>  arch/x86/kernel/cpu/intel.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 7437fa1..62130a0 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -61,14 +61,14 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
>  		c->x86_phys_bits = 36;
>  
>  	/*
> -	 * c->x86_power is 8000_0007 edx. Bit 8 is TSC runs at constant rate
> -	 * with P/T states and does not stop in deep C-states.
> +	 * Advanced power management is 8000_0007 edx.
> +	 * Bit 8 is TSC runs at constant rate with P/T states
> +	 * and does not stop in deep C-states.
>  	 *
>  	 * It is also reliable across cores and sockets. (but not across
>  	 * cabinets - we turn it off in that case explicitly.)
>  	 */
> -	if (c->x86_power & (1 << 8)) {
> -		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
> +	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
>  		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
>  		set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
>  		sched_clock_stable = 1;

This code would mark some Intel CPUs as having
X86_FEATURE_NONSTOP_TSC which is certainly wrong in some cases.

You missed this snippet.

        if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
                (c->x86 == 0x6 && c->x86_model >= 0x0e))
                set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);

in early_init_intel().


Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


