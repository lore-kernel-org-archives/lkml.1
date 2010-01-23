Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497Ab0AWA2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab0AWA2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756479Ab0AWA2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:28:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756459Ab0AWA2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:28:12 -0500
Date: Fri, 22 Jan 2010 16:27:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Joe Perches <joe@perches.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/2] string: simplify stricmp()
Message-Id: <20100122162740.11410ac4.akpm@linux-foundation.org>
In-Reply-To: <16ee7c5e218e89f22a28247e4bd3877355f5ae5c.1263675077.git.andre.goddard@gmail.com>
References: <cover.1263675077.git.andre.goddard@gmail.com>
	<16ee7c5e218e89f22a28247e4bd3877355f5ae5c.1263675077.git.andre.goddard@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jan 2010 18:57:00 -0200
Andr__ Goddard Rosa <andre.goddard@gmail.com> wrote:

> Removes 32 bytes on core2 with gcc 4.4.1:
>    text    data     bss     dec     hex filename
>    3196       0       0    3196     c7c lib/string-BEFORE.o
>    3164       0       0    3164     c5c lib/string-AFTER.o
> 
> Signed-off-by: Andr__ Goddard Rosa <andre.goddard@gmail.com>
> cc: Joe Perches <joe@perches.com>
> cc: Frederic Weisbecker <fweisbec@gmail.com>
> cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  lib/string.c |   34 +++++++++++++++-------------------
>  1 files changed, 15 insertions(+), 19 deletions(-)
> 
> diff --git a/lib/string.c b/lib/string.c
> index a1cdcfc..0f86245 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -36,25 +36,21 @@ int strnicmp(const char *s1, const char *s2, size_t len)
>  	/* Yes, Virginia, it had better be unsigned */
>  	unsigned char c1, c2;
>  
> -	c1 = c2 = 0;
> -	if (len) {
> -		do {
> -			c1 = *s1;
> -			c2 = *s2;
> -			s1++;
> -			s2++;
> -			if (!c1)
> -				break;
> -			if (!c2)
> -				break;
> -			if (c1 == c2)
> -				continue;
> -			c1 = tolower(c1);
> -			c2 = tolower(c2);
> -			if (c1 != c2)
> -				break;
> -		} while (--len);
> -	}
> +	if (!len)
> +		return 0;
> +
> +	do {
> +		c1 = *s1++;
> +		c2 = *s2++;
> +		if (!c1 || !c2)
> +			break;
> +		if (c1 == c2)
> +			continue;
> +		c1 = tolower(c1);
> +		c2 = tolower(c2);
> +		if (c1 != c2)
> +			break;
> +	} while (--len);
>  	return (int)c1 - (int)c2;
>  }
>  EXPORT_SYMBOL(strnicmp);

hm, that function seems a little broken.

If it reaches the end of s1 or s2 it will return (c1 - c2).  If however
it detects a difference due to other than end-of-string, it returns
(tolower(c1) - tolower(c2)).

IOW, perhaps it should be performing tolower() in the
I-reached-end-of-string case.

I wonder what strnicmp() is _supposed_ to return..
