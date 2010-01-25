Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151Ab0AYReK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab0AYReK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 12:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415Ab0AYReJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 12:34:09 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:50337 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab0AYReH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:34:07 -0500
Message-ID: <4B5DD607.6000108@us.ibm.com>
Date: Mon, 25 Jan 2010 09:33:59 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2.6.33-rc5] futex_lock_pi() key refcnt fix
References: <19291.27613.146510.938088@pilspetsen.it.uu.se>
In-Reply-To: <19291.27613.146510.938088@pilspetsen.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> This fixes a futex key reference count bug in futex_lock_pi(),
> where a key's reference count is incremented twice but decremented
> only once, causing the backing object to not be released.
> 
> If the futex is created in a temporary file in an ext3 file system,
> this bug causes the file's inode to become an "undead" orphan,
> which causes an oops from a BUG_ON() in ext3_put_super() when the
> file system is unmounted. glibc's test suite is known to trigger this,
> see <http://bugzilla.kernel.org/show_bug.cgi?id=14256>.
> 
> The bug is a regression from 2.6.28-git3, namely Peter Zijlstra's
> 38d47c1b7075bd7ec3881141bb3629da58f88dab "[PATCH] futex: rely on
> get_user_pages() for shared futexes". That commit made get_futex_key()
> also increment the reference count of the futex key, and updated its
> callers to decrement the key's reference count before returning.
> Unfortunately the normal exit path in futex_lock_pi() wasn't corrected:
> the reference count is incremented by get_futex_key() and queue_lock(),
> but the normal exit path only decrements once, via unqueue_me_pi().
> The fix is to put_futex_key() after unqueue_me_pi(), since 2.6.31
> this is easily done by 'goto out_put_key' rather than 'goto out'.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>

Nice catch. I think we need to do something to make the reference 
counting more explicit in futex.c. For now, this is the right fix.

Acked-by: Darren Hart <dvhltc@us.ibm.com>

> Cc: <stable@kernel.org>
> ---
> This patch also works for backports to 2.6.32 and 2.6.31,
> but 2.6.30 and 2.6.29 need a "put_futex_key(fshared, &q.key);"
> after "unqueue_me_pi(&q);" instead. I can supply patches
> for these older kernels if necessary.
> 
>  kernel/futex.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -rupN linux-2.6.33-rc5/kernel/futex.c linux-2.6.33-rc5.futex_lock_pi-key-refcnt-fix/kernel/futex.c
> --- linux-2.6.33-rc5/kernel/futex.c	2010-01-22 01:21:57.000000000 +0100
> +++ linux-2.6.33-rc5.futex_lock_pi-key-refcnt-fix/kernel/futex.c	2010-01-23 21:00:14.000000000 +0100
> @@ -1971,7 +1971,7 @@ retry_private:
>  	/* Unqueue and drop the lock */
>  	unqueue_me_pi(&q);
> 
> -	goto out;
> +	goto out_put_key;
> 
>  out_unlock_put_key:
>  	queue_unlock(&q, hb);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
