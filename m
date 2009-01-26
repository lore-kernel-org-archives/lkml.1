Return-Path: <linux-kernel-owner+w=401wt.eu-S1751754AbZAZNH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbZAZNH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 08:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbZAZNHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 08:07:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44022 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbZAZNHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 08:07:10 -0500
Date: Mon, 26 Jan 2009 14:07:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: optimize a bit __raw_read_trylock
Message-ID: <20090126130703.GA16792@elte.hu>
References: <497cd085.2283420a.5373.49e7@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497cd085.2283420a.5373.49e7@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> The current version of __raw_read_trylock starts with decrementing the lock
> and read its new value as a separate operation after that.
> 
> That makes 3 dereferences (read, write (after sub), read) whereas
> a single atomic_dec_return does only two pointers dereferences (read, write).
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  arch/x86/include/asm/spinlock.h |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
> index 2bd6b11..139b424 100644
> --- a/arch/x86/include/asm/spinlock.h
> +++ b/arch/x86/include/asm/spinlock.h
> @@ -267,8 +267,7 @@ static inline int __raw_read_trylock(raw_rwlock_t *lock)
>  {
>  	atomic_t *count = (atomic_t *)lock;
>  
> -	atomic_dec(count);
> -	if (atomic_read(count) >= 0)
> +	if (atomic_dec_return(count) >= 0)
>  		return 1;
>  	atomic_inc(count);
>  	return 0;

nice one ... applied it to tip/x86/asm, thanks Frederic!

	Ingo
