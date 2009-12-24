Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbZLXK70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbZLXK70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 05:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZLXK7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 05:59:25 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:53323 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbZLXK7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 05:59:24 -0500
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Dec 2009 05:59:24 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=R59S/kBBLPjgYV1jzKvaQCS4etNnN32FPQVpol0Rvqajxei441MnP0hQhtfaRtSzWF
         JssP/JGWuHZ7Pkg9I61ryYCyDhA/MVdagB1mhRyTya3sXv1qOWzvL8r/dul6rTLsxM22
         oSCx2GwqeVrsvJ+hHlVo/ATnevpM+NeaSpzLo=
Date: Thu, 24 Dec 2009 12:51:02 +0200
From: Dan Carpenter <error27@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: double unlock in rng_dev_read()
Message-ID: <20091224105102.GE23721@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
References: <20091223131552.GA17923@bicker> <20091223143658.GA30992@gondor.apana.org.au> <20091223145336.GB23721@bicker> <20091223152355.GA31379@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091223152355.GA31379@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 11:23:55PM +0800, Herbert Xu wrote:
> On Wed, Dec 23, 2009 at 04:53:36PM +0200, Dan Carpenter wrote:
> >
> > No no.  I mean when size hits zero we are rng_mutex is unlocked.
> 
> Good catch! I'll add this patch to the tree.  Please take a look
> at it.  Thanks!
> 

Great.

Acked-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter


> commit f5908267b67917b8cbd98b27fd2be9b5f62ec76f
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Wed Dec 23 23:22:34 2009 +0800
> 
>     hwrng: core - Fix double unlock in rng_dev_read
>     
>     When the loop terminates with size == 0 in rng_dev_read we will
>     unlock the rng mutex twice.
>     
>     Reported-by: Dan Carpenter <error27@gmail.com>
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index e989f67..3d9c61e 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -158,10 +158,11 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
>  			goto out;
>  		}
>  	}
> -out_unlock:
> -	mutex_unlock(&rng_mutex);
>  out:
>  	return ret ? : err;
> +out_unlock:
> +	mutex_unlock(&rng_mutex);
> +	goto out;
>  }
>  
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
