Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab0BQWiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 17:38:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42181 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297Ab0BQWiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 17:38:20 -0500
Message-ID: <4B7C6FC8.7090107@zytor.com>
Date: Wed, 17 Feb 2010 14:38:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Luca Barbieri <luca@luca-barbieri.com>
CC: mingo@elte.hu, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] x86-32: panic on !CX8 && XMM
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com> <1266406962-17463-11-git-send-email-luca@luca-barbieri.com>
In-Reply-To: <1266406962-17463-11-git-send-email-luca@luca-barbieri.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2010 03:42 AM, Luca Barbieri wrote:
> No known CPU should have this combination, and future ones are very
> unlikely to.
> 
> However, should this happen, we would generate working but non-atomic
> code, so panic instead.
> ---
>  arch/x86/lib/atomic64_32.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
> index 9ff8589..35dbd12 100644
> --- a/arch/x86/lib/atomic64_32.c
> +++ b/arch/x86/lib/atomic64_32.c
> @@ -47,6 +47,17 @@ EXPORT_SYMBOL(cx8_atomic64_inc_not_zero_cx8call);
>  union generic_atomic64_lock generic_atomic64_lock[ATOMIC64_NR_LOCKS] __cacheline_aligned_in_smp;
>  pure_initcall(init_generic_atomic64_lock);
>  
> +static int __init panic_on_sse_without_cx8(void)
> +{
> +	/* no known CPU should do this, and we generate non-atomic code in this case
> +	 * because we mix the generic spinlock-reliant code and the SSE code
> +	 */
> +	if (!boot_cpu_has(X86_FEATURE_CX8) && boot_cpu_has(X86_FEATURE_XMM))
> +		panic("CPUs without CX8 but with SSE are not supported\nBoot with clearcpuid=25 and report your CPU model to linux-kernel@vger.kernel.org\n");
> +	return 0;
> +}
> +core_initcall(panic_on_sse_without_cx8);
> +
>  EXPORT_SYMBOL(generic_atomic64_add);
>  EXPORT_SYMBOL(generic_atomic64_add_return);
>  EXPORT_SYMBOL(generic_atomic64_sub);

NAK in the extreme.

This is not how we deal with these kinds of stuff.  If this really
matters, we explicitly clear the CPU feature in the feature detect code.

	-hpa

