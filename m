Return-Path: <linux-kernel-owner+w=401wt.eu-S1760547AbZDGXP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760547AbZDGXP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756951AbZDGXMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:12:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753057AbZDGXMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:12:44 -0400
Date: Tue, 7 Apr 2009 16:06:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au, john@johnmccutchan.com,
       rlove@rlove.org
Subject: Re: [PATCH -V2 01/13] mutex: add atomic_dec_and_mutex_lock
Message-Id: <20090407160601.a824da99.akpm@linux-foundation.org>
In-Reply-To: <20090327200508.32007.63278.stgit@paris.rdu.redhat.com>
References: <20090327200508.32007.63278.stgit@paris.rdu.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 16:05:08 -0400
Eric Paris <eparis@redhat.com> wrote:

> Much like the atomic_dec_and_lock() function in which we take an hold a
> spin_lock if we drop the atomic to 0 this function takes and holds the
> mutex if we dec the atomic to 0.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> LKML-Reference: <20090323172417.410913479@chello.nl>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
> 
>  include/linux/mutex.h |   23 +++++++++++++++++++++++
>  1 files changed, 23 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/mutex.h b/include/linux/mutex.h
> index 3069ec7..93054fc 100644
> --- a/include/linux/mutex.h
> +++ b/include/linux/mutex.h
> @@ -151,4 +151,27 @@ extern int __must_check mutex_lock_killable(struct mutex *lock);
>  extern int mutex_trylock(struct mutex *lock);
>  extern void mutex_unlock(struct mutex *lock);
>  
> +/**
> + * atomic_dec_and_mutex_lock - return holding mutex if we dec to 0
> + * @cnt: the atomic which we are to dec
> + * @lock: the mutex to return holding if we dec to 0
> + *
> + * return true and hold lock if we dec to 0, return false otherwise
> + */
> +static inline int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock)
> +{
> +	/* dec if we can't possibly hit 0 */
> +	if (atomic_add_unless(cnt, -1, 1))
> +		return 0;
> +	/* we might hit 0, so take the lock */
> +	mutex_lock(lock);
> +	if (!atomic_dec_and_test(cnt)) {
> +		/* when we actually did the dec, we didn't hit 0 */
> +		mutex_unlock(lock);
> +		return 0;
> +	}
> +	/* we hit 0, and we hold the lock */
> +	return 1;
> +}
> +

This looks too large to be inlined?
