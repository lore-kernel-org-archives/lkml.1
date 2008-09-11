Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbYIKWEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbYIKWEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 18:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbYIKWEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 18:04:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52104
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754067AbYIKWEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 18:04:40 -0400
Date: Thu, 11 Sep 2008 15:04:34 -0700 (PDT)
Message-Id: <20080911.150434.99620481.davem@davemloft.net>
To: vegard.nossum@gmail.com
Cc: netdev@vger.kernel.org, tgraf@suug.ch, penberg@cs.helsinki.fi,
       mingo@elte.hu, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netlink: fix overrun in attribute iteration
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080911205933.GA20032@localhost.localdomain>
References: <20080911205933.GA20032@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 11 Sep 2008 22:59:33 +0200

> A short example illustrating this point is here:
> 
>   #include <stdio.h>
> 
>   main(void)
>   {
>           printf("%d\n", -1 >= sizeof(int));
>   }
> 
> ...which prints "1".

Someone should print that out on a huge poster, it's a good
example of why C promotion rules suck :)

> This patch adds a cast in front of the sizeof so that GCC will make
> a signed comparison and fix the illegal memory dereference. With the
> patch applied, there is no kmemcheck report.
> 
> Cc: Thomas Graf <tgraf@suug.ch>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>

Thomas, please review.

> diff --git a/include/net/netlink.h b/include/net/netlink.h
> index 18024b8..208fe5a 100644
> --- a/include/net/netlink.h
> +++ b/include/net/netlink.h
> @@ -702,7 +702,7 @@ static inline int nla_len(const struct nlattr *nla)
>   */
>  static inline int nla_ok(const struct nlattr *nla, int remaining)
>  {
> -	return remaining >= sizeof(*nla) &&
> +	return remaining >= (int) sizeof(*nla) &&
>  	       nla->nla_len >= sizeof(*nla) &&
>  	       nla->nla_len <= remaining;
>  }
> -- 
> 1.5.5.1
> 
