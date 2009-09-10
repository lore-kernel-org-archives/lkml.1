Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbZIJUjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbZIJUjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbZIJUjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:39:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753274AbZIJUjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:39:21 -0400
Date: Thu, 10 Sep 2009 13:39:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make sure the value in abs() does not get truncated if
 it is greater than 2^32
Message-Id: <20090910133913.097bb9a3.akpm@linux-foundation.org>
In-Reply-To: <200909032312.10418.eike-kernel@sf-tec.de>
References: <200909032312.10418.eike-kernel@sf-tec.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Sep 2009 23:12:01 +0200
Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:

> I was just digging a bit around in linux/kernel.h and stumbled over the abs() 
> makro. For me it looks as it would return wrong results on 64 bit platforms 
> if the input value is greater than 2^32.
> 

Yes, it will truncate.

> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index d6320a3..1e6eb66 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -145,7 +145,7 @@ extern int _cond_resched(void);
>  #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
>  
>  #define abs(x) ({				\
> -		int __x = (x);			\
> +		long __x = (x);			\
>  		(__x < 0) ? -__x : __x;		\
>  	})

I wonder if that ends up producing worse code in the normal case.

We could use typeof to address that but what about

	unsigned foo = -1;
	signed bar = abs(foo);

?

That'll currently return 1 but if we use typeof it'll return
0xffffffffU which gets turned into -1.

hrm.
