Return-Path: <linux-kernel-owner+w=401wt.eu-S1759155AbYGPUus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759155AbYGPUus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 16:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757055AbYGPUul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 16:50:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:36942 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281AbYGPUuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 16:50:40 -0400
Subject: Re: [PATCH] : A better approach to compute int_sqrt in
	lib/int_sqrt.c
From: Peter Zijlstra <peterz@infradead.org>
To: Soumyadip Das Mahapatra <soumya.linux@yahoo.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <551692.52350.qm@web59507.mail.ac4.yahoo.com>
References: <551692.52350.qm@web59507.mail.ac4.yahoo.com>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 22:51:09 +0200
Message-Id: <1216241469.5232.59.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-16 at 13:19 -0700, Soumyadip Das Mahapatra wrote:
> Hello everybody !!
>       The patch below is what i think is a better approach to
> compute int_sqrt().
> 
> What about it ?

Indeed, what about it?

How is it better;
 - is it cheaper
   - how so
   - on what platform

 - it is more accurate
   - who needs it

Please provide a little more information about why you suggest this
change.

> Thanks !!
> 
> ---
> --- a/lib/int_sqrt.c    2008-04-17 08:19:44.000000000 +0530
> +++ b/lib/int_sqrt.c    2008-07-02 11:37:01.000000000 +0530
> @@ -1,4 +1,3 @@
> -
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  
> @@ -7,26 +6,21 @@
>   * @x: integer of which to calculate the sqrt
>   *
>   * A very rough approximation to the sqrt() function.
> + * Improved version from the previous one.

With the previuos one being gone, this comment adds little but
confusion..

>   */
>  unsigned long int_sqrt(unsigned long x)
>  {
> -    unsigned long op, res, one;
> -
> -    op = x;
> -    res = 0;
> -
> -    one = 1UL << (BITS_PER_LONG - 2);
> -    while (one > op)
> -        one >>= 2;
> -
> -    while (one != 0) {
> -        if (op >= res + one) {
> -            op = op - (res + one);
> -            res = res +  2 * one;
> -        }
> -        res /= 2;
> -        one /= 4;
> -    }
> -    return res;
> +    unsigned long ub, lb, m;
> +    lb = 1;                /* lower bound */
> +    ub = (x >> 5) + 8;        /* upper bound */
> +    do {
> +        m = (ub + lb) >>  1;    /* middle value */
> +        if((m * m) > x)
> +            ub = m - 1;
> +        else
> +            lb = m + 1;
> +    } while(ub >= lb);
> +    
> +    return lb - 1;
>  }
>  EXPORT_SYMBOL(int_sqrt);
> 
> 
> 
>       
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

