Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbZHPKIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbZHPKIe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 06:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbZHPKIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 06:08:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42581 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbZHPKId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 06:08:33 -0400
Date: Sun, 16 Aug 2009 12:08:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemleak: Ignore the aperture memory hole on x86_64
Message-ID: <20090816100820.GA26474@elte.hu>
References: <20090812205215.GA21451@elte.hu> <1250289913.5085.17.camel@pc1117.cambridge.arm.com> <1250290118.5085.21.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1250290118.5085.21.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Catalin Marinas <catalin.marinas@arm.com> wrote:

> This block is allocated with alloc_bootmem() and scanned by kmemleak but
> the kernel direct mapping may no longer exist. This patch tells kmemleak
> to ignore this memory hole.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/aperture_64.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
> index 676debf..cb690b3 100644
> --- a/arch/x86/kernel/aperture_64.c
> +++ b/arch/x86/kernel/aperture_64.c
> @@ -94,6 +94,11 @@ static u32 __init allocate_aperture(void)
>  	 * code for safe
>  	 */
>  	p = __alloc_bootmem_nopanic(aper_size, aper_size, 512ULL<<20);
> +	/*
> +	 * Kmemleak should not scan this block as it may not be mapped via the
> +	 * kernel direct mapping.
> +	 */
> +	kmemleak_ignore(p);

i tried this in -tip, it causes this build error:

arch/x86/kernel/aperture_64.c: In function ‘allocate_aperture’:
arch/x86/kernel/aperture_64.c:101: error: implicit declaration of function ‘kmemleak_ignore’

	Ingo
