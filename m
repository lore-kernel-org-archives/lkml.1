Return-Path: <linux-kernel-owner+w=401wt.eu-S1762650AbXLOHTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762650AbXLOHTI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 02:19:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbXLOHSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 02:18:53 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3154 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753006AbXLOHSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 02:18:52 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: akpm@linux-foundation.org (Andrew Morton)
Subject: Re: 2.6.24-rc5-mm1 -- inconsistent {in-softirq-W} -> {softirq-on-R} usage.
Cc: miles.lane@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       mingo@elte.hu, a.p.zijlstra@chello.nl
Organization: Core
In-Reply-To: <20071214153633.5d8f609a.akpm@linux-foundation.org>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1J3RIJ-0006zH-00@gondolin.me.apana.org.au>
Date: Sat, 15 Dec 2007 15:18:43 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:
>
> I'd say you hit a networking locking bug and then when trying to report
> that bug, lockdep crashed.
> 
> The networking bug looks to be around sock_i_ino()'s taking of
> sk_callback_lock with softirq's enabled.  Perhaps this will fix it.
> 
> diff -puN net/core/sock.c~a net/core/sock.c
> --- a/net/core/sock.c~a
> +++ a/net/core/sock.c
> @@ -1115,9 +1115,9 @@ int sock_i_uid(struct sock *sk)
> {
>        int uid;
> 
> -       read_lock(&sk->sk_callback_lock);
> +       read_lock_bh(&sk->sk_callback_lock);
>        uid = sk->sk_socket ? SOCK_INODE(sk->sk_socket)->i_uid : 0;
> -       read_unlock(&sk->sk_callback_lock);
> +       read_unlock_bh(&sk->sk_callback_lock);

The callback lock is never taken for writing in BH context so
this shouldn't be needed.

Let's fix the lockdep checker first and then decide what's broken
in networking, OK?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
