Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbZGIE0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbZGIE0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 00:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbZGIE03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 00:26:29 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:55142 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbZGIE02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 00:26:28 -0400
Message-ID: <4A557153.8000108@gmail.com>
Date: Thu, 09 Jul 2009 06:25:55 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: netdev@vger.kernel.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, fbl@redhat.com,
       nhorman@redhat.com, htejun@gmail.com, jarkao2@gmail.com,
       oleg@redhat.com, davidel@xmailserver.org, davem@davemloft.net
Subject: Re: [PATCHv7 2/2] memory barrier: adding smp_mb__after_lock
References: <20090708220717.GB2945@jolsa.redhat.com> <20090708221031.GD2945@jolsa.redhat.com>
In-Reply-To: <20090708221031.GD2945@jolsa.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 09 Jul 2009 06:25:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa a écrit :
> Adding smp_mb__after_lock define to be used as a smp_mb call after
> a lock.
> 
> Making it nop for x86, since {read|write|spin}_lock() on x86 are
> full memory barriers.
> 
> wbr,
> jirka
> 
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

> ---
>  arch/x86/include/asm/spinlock.h |    4 ++++
>  include/linux/spinlock.h        |    5 +++++
>  include/net/sock.h              |    5 ++++-
>  3 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
> index b7e5db8..4e77853 100644
> --- a/arch/x86/include/asm/spinlock.h
> +++ b/arch/x86/include/asm/spinlock.h
> @@ -302,4 +302,8 @@ static inline void __raw_write_unlock(raw_rwlock_t *rw)
>  #define _raw_read_relax(lock)	cpu_relax()
>  #define _raw_write_relax(lock)	cpu_relax()
>  
> +/* The {read|write|spin}_lock() on x86 are full memory barriers. */
> +static inline void smp_mb__after_lock(void) { }
> +#define ARCH_HAS_SMP_MB_AFTER_LOCK
> +
>  #endif /* _ASM_X86_SPINLOCK_H */
> diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
> index 252b245..4be57ab 100644
> --- a/include/linux/spinlock.h
> +++ b/include/linux/spinlock.h
> @@ -132,6 +132,11 @@ do {								\
>  #endif /*__raw_spin_is_contended*/
>  #endif
>  
> +/* The lock does not imply full memory barrier. */
> +#ifndef ARCH_HAS_SMP_MB_AFTER_LOCK
> +static inline void smp_mb__after_lock(void) { smp_mb(); }
> +#endif
> +
>  /**
>   * spin_unlock_wait - wait until the spinlock gets unlocked
>   * @lock: the spinlock in question.
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 4eb8409..2c0da92 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1271,6 +1271,9 @@ static inline int sk_has_allocations(const struct sock *sk)
>   * in its cache, and so does the tp->rcv_nxt update on CPU2 side.  The CPU1
>   * could then endup calling schedule and sleep forever if there are no more
>   * data on the socket.
> + *
> + * The sk_has_sleeper is always called right after a call to read_lock, so we
> + * can use smp_mb__after_lock barrier.
>   */
>  static inline int sk_has_sleeper(struct sock *sk)
>  {
> @@ -1280,7 +1283,7 @@ static inline int sk_has_sleeper(struct sock *sk)
>  	 *
>  	 * This memory barrier is paired in the sock_poll_wait.
>  	 */
> -	smp_mb();
> +	smp_mb__after_lock();
>  	return sk->sk_sleep && waitqueue_active(sk->sk_sleep);
>  }
>  

