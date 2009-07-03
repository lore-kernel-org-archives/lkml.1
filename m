Return-Path: <linux-kernel-owner+w=401wt.eu-S1756472AbZGCSFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbZGCSFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 14:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbZGCSE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 14:04:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34329 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbZGCSE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 14:04:58 -0400
Date: Fri, 3 Jul 2009 20:04:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: atomic64: inline atomic64_read()
Message-ID: <20090703180450.GB3405@elte.hu>
References: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain> <tip-9103cab145a93cef13378632b332a824758a2f6f@git.kernel.org> <4A4E1AA2.30002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4E1AA2.30002@gmail.com>
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


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Now atomic64_read() is light weight (no register pressure and 
> small icache), we can inline it again.
> 
> Also use "=&A" constraint instead of "+A" to avoid warning about 
> unitialized 'res' variable. (gcc had to force 0 in eax/edx)
> 
> 
> $ size vmlinux.prev vmlinux.after
>    text    data     bss     dec     hex filename
> 4908667  451676 1684868 7045211  6b805b vmlinux.prev
> 4908651  451676 1684868 7045195  6b804b vmlinux.after

ok, but:

> +static inline u64 atomic64_read(atomic64_t *ptr)
> +{
> +	u64 res;
> +
> +	asm volatile(
> +		"mov %%ebx, %%eax\n\t"
> +		"mov %%ecx, %%edx\n\t"
> +		LOCK_PREFIX "cmpxchg8b %1\n"
> +			: "=&A" (res)
> +			: "m" (*ptr) 
> +		);

That clobbers or affects eax, ebx, ecx, edx. The only registers it 
does not clobber is esi, edi and rbp.

So it's not quite lightweight. But your patch reduced the kernel 
image size by 17 bytes so i guess it counts as an improvement - and 
we also avoid function calls.

Linus, what's your preference in this case?

	Ingo
