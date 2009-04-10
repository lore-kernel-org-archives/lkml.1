Return-Path: <linux-kernel-owner+w=401wt.eu-S935047AbZDJQeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935047AbZDJQeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 12:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759355AbZDJQeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 12:34:05 -0400
Received: from www.tglx.de ([62.245.132.106]:55414 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758808AbZDJQeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 12:34:02 -0400
Date: Fri, 10 Apr 2009 18:33:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [tip PATCH] futex: fix futex_wait_setup key handling
In-Reply-To: <20090410162324.12330.37348.stgit@Aeon>
Message-ID: <alpine.LFD.2.00.0904101831380.21577@localhost.localdomain>
References: <20090410162324.12330.37348.stgit@Aeon>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009, Darren Hart wrote:

> If the get_futex_key() call were to fail, the existing code would
> try and put_futex_key() prior to returning.  This patch makes sure
> we only put_futex_key() if get_futex_key() succeeded.
> 
> Please apply to -rt and to tip:/core/futexes.
> 
> Reported-by: Clark Williams <williams@redhat.com>
> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
> 
>  kernel/futex.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 185c981..4357f06 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -1657,7 +1657,7 @@ retry_private:
>  
>  		ret = get_user(uval, uaddr);
>  		if (ret)
> -			goto out;
> +			goto out_put_key;
>  
>  		if (!fshared)
>  			goto retry_private;
> @@ -1671,9 +1671,10 @@ retry_private:
>  		ret = -EWOULDBLOCK;
>  	}
>  
> -out:
> +out_put_key:
>  	if (ret)
>  		put_futex_key(fshared, &q->key);
> +out:
>  	return ret;

Yikes. Can we please convert the places which do "goto out;" to
"return ret;" ?

Thanks,

	tglx
