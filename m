Return-Path: <linux-kernel-owner+w=401wt.eu-S935722AbZFOVfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935722AbZFOVfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934528AbZFOVfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:35:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:52515 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933185AbZFOVfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:35:33 -0400
Date: Mon, 15 Jun 2009 23:35:31 +0200 (CEST)
From: Jiri Kosina <trivial@kernel.org>
X-X-Sender: jkosina@wotan.suse.de
To: Zygo Blaxell <zygo.blaxell@xandros.com>
Cc: linux-kernel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] LIB: remove unmatched write_lock() in gen_pool_destroy
In-Reply-To: <E1MGFiZ-0006oN-UW@dactyl.ottawa.xandros.ca>
Message-ID: <alpine.LNX.2.00.0906152333080.7457@wotan.suse.de>
References: <E1MGFiZ-0006oN-UW@dactyl.ottawa.xandros.ca>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, Zygo Blaxell wrote:

> Fix mismatch between calls to write_lock() and write_unlock() in
> gen_pool_destroy by removing the write_lock().
> 
> Signed-off-by: Zygo Blaxell <zygo.blaxell@xandros.com>
> ---
> There is a call to write_lock() in gen_pool_destroy which is not balanced
> by any corresponding write_unlock().  This causes problems with preemption
> because the preemption-disable counter is incremented in the write_lock()
> call, but never decremented by any call to write_unlock().  This bug is
> difficult to observe in the field because only two in-tree drivers call
> gen_pool_destroy, and one of them is non-x86 arch-specific code.
> 
> To fix this, I have chosen removing the write_lock() over adding a
> write_unlock() because the lock in question is inside a structure which
> is being freed.  Any other thread that waited to acquire such a lock
> while gen_pool_destroy was running would find itself holding a lock
> in recently-freed or about-to-be-freed memory.  This would result in
> memory corruption or a crash whether &pool->lock is held or not.
> 
> Using a pool while it is in the process of being destroyed is a bug that
> must be resolved outside of the gen_pool_destroy function.
> 
>  lib/genalloc.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/genalloc.c b/lib/genalloc.c
> index f6d276d..eed2bdb 100644
> --- a/lib/genalloc.c
> +++ b/lib/genalloc.c
> @@ -85,7 +85,6 @@ void gen_pool_destroy(struct gen_pool *pool)
>  	int bit, end_bit;
>  
>  
> -	write_lock(&pool->lock);
>  	list_for_each_safe(_chunk, _next_chunk, &pool->chunks) {
>  		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
>  		list_del(&chunk->next_chunk);
> -- 
> 1.5.6.5
> 

Hi Zygo,

this doesn't really qualify for trivial tree, as it introduces a 
significant code change. Adding some CCs.

Thanks,

-- 
Jiri Kosina
SUSE Labs

