Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbZGNKeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbZGNKeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 06:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbZGNKet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 06:34:49 -0400
Received: from relay3.sgi.com ([192.48.156.57]:47300 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754482AbZGNKes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 06:34:48 -0400
To: Julia Lawall <julia@diku.dk>
Cc: felixb@sgi.com, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] fs/xfs: Drop unnecessary NULL test
References: <Pine.LNX.4.64.0907131209250.6808@ask.diku.dk>
From: Olaf Weber <olaf@sgi.com>
Date: Tue, 14 Jul 2009 12:34:43 +0200
Message-ID: <bzy7hybzh6k.fsf@fransum.emea.sgi.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.3 (irix)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall writes:

> From: Julia Lawall <julia@diku.dk>
> The result of container_of should not be NULL.  In particular, in this case
> the argument to the enclosing function has passed though INIT_DELAYED_WORK,
> which dereferences it, implying that its container cannot be NULL.

Given the defn of container_of() it seems clear that neither its input
pointer nor its result should ever be NULL.

In this particular case, there is a check for NULL and early exit in
xfs_mru_cache_create(), the function that does the INIT_DELAYED_WORK().

Olaf

> The semantic match that finds this problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)

> // <smpl>
> @@
> expression x,e;
> @@
> x = container_of(...)
> ... when != x = e
> * x == NULL
> // </smpl>

> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-By: Olaf Weber <olaf@sgi.com>

> ---
>  fs/xfs/xfs_mru_cache.c              |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

> diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
> index 4b0613d..0651ce7 100644
> --- a/fs/xfs/xfs_mru_cache.c
> +++ b/fs/xfs/xfs_mru_cache.c
> @@ -280,8 +280,8 @@ _xfs_mru_cache_reap(
>  	xfs_mru_cache_t		*mru = container_of(work, xfs_mru_cache_t, work.work);
>  	unsigned long		now, next;
 
> -	ASSERT(mru && mru->lists);
> -	if (!mru || !mru->lists)
> +	ASSERT(mru->lists);
> +	if (!mru->lists)
>  		return;
 
>  	spin_lock(&mru->lock);

-- 
Olaf Weber                 SGI               Phone:  +31(0)30-6696752
                           Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-7151
Storage Software           The Netherlands   Email:  olaf@sgi.com
