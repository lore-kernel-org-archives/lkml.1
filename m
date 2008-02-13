Return-Path: <linux-kernel-owner+w=401wt.eu-S1761999AbYBMUH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761999AbYBMUH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 15:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757720AbYBMUHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 15:07:15 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:6740 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567AbYBMUHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 15:07:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=juY+O670hAE6qYtuPb3o2cjRiKZWtWKGNa3diyX/JWebTmeHhAScSZNUUtO2TlZfQT1eWECQqf/PXi1ZSCqwg1H50FHMMpa2+HrXH/elEGFthLtdpL/kGRCoQQPGJDVnwU1VNuSxzpOg0cymTE4B7rPpqsr4r/lzIVcpINA/FcQ=
Date: Wed, 13 Feb 2008 23:07:02 +0300
To: pierre.peiffer@bull.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24-mm1 1/8] (resend) IPC/semaphores: code factorisation
Message-ID: <20080213200702.GE2144@martell.zuzino.mipt.ru>
References: <20080212161340.200976067@bull.net> <20080212162720.306787485@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212162720.306787485@bull.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 05:13:41PM +0100, pierre.peiffer@bull.net wrote:
> Trivial patch which adds some small locking functions and makes use of them
> to factorize some part of the code and to make it cleaner.

What's wrong with consolidation activity in general is that one need to
follow tags many times to realise what on earth function really does.

> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -180,6 +180,25 @@ static inline struct sem_array *sem_lock
>  	return container_of(ipcp, struct sem_array, sem_perm);
>  }
>  
> +static inline void sem_lock_and_putref(struct sem_array *sma)
> +{
> +	ipc_lock_by_ptr(&sma->sem_perm);
> +	ipc_rcu_putref(sma);
> +}
> +
> +static inline void sem_getref_and_unlock(struct sem_array *sma)
> +{
> +	ipc_rcu_getref(sma);
> +	ipc_unlock(&(sma)->sem_perm);
> +}
> +
> +static inline void sem_putref(struct sem_array *sma)
> +{

It should be called sem_lock_putref_and_unlock() at which point it
becomes obvious that this patch is from useless-wrappers land.

> +	ipc_lock_by_ptr(&sma->sem_perm);
> +	ipc_rcu_putref(sma);
> +	ipc_unlock(&(sma)->sem_perm);

On the other hand PUT is associated with atomic_dec_and_test() which
does no locking itself.
