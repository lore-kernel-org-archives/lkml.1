Return-Path: <linux-kernel-owner+w=401wt.eu-S1758347AbZCMJ1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347AbZCMJ1B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbZCMJ0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:26:52 -0400
Received: from www.tglx.de ([62.245.132.106]:53422 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbZCMJ0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:26:51 -0400
Date: Fri, 13 Mar 2009 10:26:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] futex: remove the pointer math from double_unlock_hb
In-Reply-To: <20090312221118.11146.68610.stgit@Aeon>
Message-ID: <alpine.LFD.2.00.0903131022440.29264@localhost.localdomain>
References: <20090312221118.11146.68610.stgit@Aeon>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009, Darren Hart wrote:
> I mistakenly included the pointer value ordering in the double_unlock_hb
> in my previous patch.  It's only necessary in the double_lock_hb
> function.  This patch removes it.
> 
> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> ---
> 
>  kernel/futex.c |   10 ++--------
>  1 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 9c97f67..2331b73 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -658,14 +658,8 @@ double_lock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
>  static inline void
>  double_unlock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
>  {
> -	if (hb1 <= hb2) {
> -		spin_unlock(&hb2->lock);
> -		if (hb1 < hb2)
> -			spin_unlock(&hb1->lock);
> -	} else { /* hb1 > hb2 */
> -		spin_unlock(&hb1->lock);
> -		spin_unlock(&hb2->lock);
> -	}
> +	spin_unlock(&hb1->lock);
> +	spin_unlock(&hb2->lock);

This is missing the check for hb1 == hb2. As I said before:

> Can we just put the code into double_unlock_hb() which gets replaced ?
>
> i.e:
>
>        spin_unlock(&hb1->lock);
>        if (hb1 != hb2)
>              spin_unlock(&hb2->lock);

Thanks,

	tglx
