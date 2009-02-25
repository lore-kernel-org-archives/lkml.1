Return-Path: <linux-kernel-owner+w=401wt.eu-S1758066AbZBYOGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbZBYOGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 09:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbZBYOGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 09:06:39 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36893 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbZBYOGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 09:06:38 -0500
Date: Wed, 25 Feb 2009 09:06:23 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
       Frank Seidel <frank@f-seidel.de>, akpm@linux-foundation.org,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, lho@amcc.com, kaber@trash.net,
       darrenrjenkins@gmail.com
Subject: Re: [PATCH][trivial] crypto: tcrypt - reduce stack size
Message-ID: <20090225140623.GC16150@hmsreliant.think-freely.org>
References: <49A54C23.8090209@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A54C23.8090209@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 02:48:19PM +0100, Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> Applying kernel janitors todos (printk calls need KERN_*
> constants on linebeginnings, reduce stack footprint where
> possible) to tcrypts test_hash_speed (where stacks
> memory footprint was very high (on i386 1184 bytes to
> 292 now).
> 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>
> ---
>  
>  	if (IS_ERR(tfm)) {
> -		printk("failed to load transform for %s: %ld\n", algo,
> +		printk(KERN_ERR "failed to load transform for %s: %ld\n", algo,
>  		       PTR_ERR(tfm));
> +		kfree(output);
>  		return;
Its just a stylistic nit, but I think I'd rather see this be a goto to the kfree
at the end of the function.  You can move the out label down to just the kfree,
and rename the current out usage to out_free_tfm.  I think if you're going to
add the kfree at the bottom, you might as well make use of it for all cases.

If you change that, I'll ack this.

Thanks & Regards
Neil

>  	}
>  
>  	desc.tfm = tfm;
>  	desc.flags = 0;
>  
> -	if (crypto_hash_digestsize(tfm) > sizeof(output)) {
> -		printk("digestsize(%u) > outputbuffer(%zu)\n",
> -		       crypto_hash_digestsize(tfm), sizeof(output));
> +	if (crypto_hash_digestsize(tfm) > output_size) {
> +		printk(KERN_ERR "digestsize(%u) > outputbuffer(%zu)\n",
> +		       crypto_hash_digestsize(tfm), output_size);
>  		goto out;
>  	}
>  
> @@ -427,12 +435,14 @@ static void test_hash_speed(const char *
>  
>  	for (i = 0; speed[i].blen != 0; i++) {
>  		if (speed[i].blen > TVMEMSIZE * PAGE_SIZE) {
> -			printk("template (%u) too big for tvmem (%lu)\n",
> +			printk(KERN_ERR
> +			       "template (%u) too big for tvmem (%lu)\n",
>  			       speed[i].blen, TVMEMSIZE * PAGE_SIZE);
>  			goto out;
>  		}
>  
> -		printk("test%3u (%5u byte blocks,%5u bytes per update,%4u updates): ",
> +		printk(KERN_INFO "test%3u "
> +		       "(%5u byte blocks,%5u bytes per update,%4u updates): ",
>  		       i, speed[i].blen, speed[i].plen, speed[i].blen / speed[i].plen);
>  
>  		if (sec)
> @@ -443,13 +453,14 @@ static void test_hash_speed(const char *
>  					       speed[i].plen, output);
>  
>  		if (ret) {
> -			printk("hashing failed ret=%d\n", ret);
> +			printk(KERN_ERR "hashing failed ret=%d\n", ret);
>  			break;
>  		}
>  	}
>  
>  out:
>  	crypto_free_hash(tfm);
> +	kfree(output);
>  }
>  
>  static void test_available(void)
> 
