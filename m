Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbZJSNId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbZJSNId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 09:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbZJSNId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 09:08:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54623 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbZJSNIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 09:08:32 -0400
Date: Mon, 19 Oct 2009 15:08:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robin Holt <holt@sgi.com>
Cc: tglx@linutronix.de, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Martin Hicks <mort@sgi.com>
Subject: Re: [patch 1/1] x86, UV: uv_hub_send_ipi Needs to set
	DELIVERY_MODE=4 for vector=NMI_VECTOR.
Message-ID: <20091019130821.GC9030@elte.hu>
References: <20091019091854.696198000@alcatraz.americas.sgi.com> <20091019091919.050247000@alcatraz.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019091919.050247000@alcatraz.americas.sgi.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robin Holt <holt@sgi.com> wrote:

> When sending a NMI_VECTOR IPI using the UV_HUB_IPI_INT register,
> we need to ensure the delivery mode field of that register has NMI
> delivery selected.
> 
> To: Ingo Molnar <mingo@elte.hu>
> To: tglx@linutronix.de
> Signed-off-by: Robin Holt <holt@sgi.com>
> Acked-by: Jack Steiner <steiner@sgi.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@kernel.org
> Cc: Martin Hicks <mort@sgi.com>
> 
> ---
>  arch/x86/include/asm/uv/uv_hub.h |    6 ++++++
>  1 file changed, 6 insertions(+)
> Index: linux-x86/arch/x86/include/asm/uv/uv_hub.h
> ===================================================================
> --- linux-x86.orig/arch/x86/include/asm/uv/uv_hub.h	2009-10-19 04:07:07.000000000 -0500
> +++ linux-x86/arch/x86/include/asm/uv/uv_hub.h	2009-10-19 04:07:09.000000000 -0500
> @@ -19,6 +19,7 @@
>  #include <asm/types.h>
>  #include <asm/percpu.h>
>  #include <asm/uv/uv_mmrs.h>
> +#include <asm/irq_vectors.h>
>  
>  
>  /*
> @@ -435,9 +436,14 @@ static inline void uv_set_cpu_scir_bits(
>  static inline void uv_hub_send_ipi(int pnode, int apicid, int vector)
>  {
>  	unsigned long val;
> +	unsigned long dmode = 0; /* Directed Delivery */
> +
> +	if (vector == NMI_VECTOR)
> +		dmode = 4; /* NMI Delivery */
>  
>  	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
>  			((apicid) << UVH_IPI_INT_APIC_ID_SHFT) |
> +			(dmode << UVH_IPI_INT_DELIVERY_MODE_SHFT) |
>  			(vector << UVH_IPI_INT_VECTOR_SHFT);
>  	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);

Hm, would be cleaner to create an enum for that '4' (and for 0) in 
uv_mmrs.h and use it here. (We have similar constants for delivery modes 
in io_apic.h, see dest_*.)

	Ingo
