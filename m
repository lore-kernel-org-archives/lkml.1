Return-Path: <linux-kernel-owner+w=401wt.eu-S1758304AbXKZCMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbXKZCMh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 21:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbXKZCM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 21:12:26 -0500
Received: from smtp19.orange.fr ([80.12.242.18]:41651 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbXKZCMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 21:12:25 -0500
X-ME-UUID: 20071126011603994.F2CBF5400083@mwinf1901.orange.fr
Date: Mon, 26 Nov 2007 10:17:47 +0100
From: Samuel Ortiz <samuel@sortiz.org>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
       irda-users@lists.sourceforge.net
Subject: Re: [PATCH] net/irda/parameters.c: Trivial fixes
Message-ID: <20071126091747.GB3165@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
References: <20071124203232.6370.65534.sendpatchset@thinktank.campus.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071124203232.6370.65534.sendpatchset@thinktank.campus.ltu.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Sat, Nov 24, 2007 at 09:44:05PM +0100, Richard Knutsson wrote:
> Make a single va_start() -> va_end() path + fixing:
Ok, this should be 2 separate patches then.
The warning fixes are all good, but I fail to see the point of the va_end()
one. That doesn't seem to bring any sort of improvement while adding one
variable to the stack and one loop test. Any explanation here ?

I'll push the warning fix for now, thanks.

Cheers,
Samuel.


>   CHECK   /home/kernel/src/net/irda/parameters.c
> /home/kernel/src/net/irda/parameters.c:466:2: warning: Using plain integer as NULL pointer
> /home/kernel/src/net/irda/parameters.c:520:2: warning: Using plain integer as NULL pointer
> /home/kernel/src/net/irda/parameters.c:573:2: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
> ---
> Compile-tested on i386 with allyesconfig and allmodconfig.
> 
> 
> diff --git a/net/irda/parameters.c b/net/irda/parameters.c
> index 2627dad..bf19071 100644
> --- a/net/irda/parameters.c
> +++ b/net/irda/parameters.c
> @@ -368,10 +368,11 @@ int irda_param_pack(__u8 *buf, char *fmt, ...)
>  	va_list args;
>  	char *p;
>  	int n = 0;
> +	int retval = 0;
>  
>  	va_start(args, fmt);
>  
> -	for (p = fmt; *p != '\0'; p++) {
> +	for (p = fmt; *p != '\0' && retval == 0; p++) {
>  		switch (*p) {
>  		case 'b':  /* 8 bits unsigned byte */
>  			buf[n++] = (__u8)va_arg(args, int);
> @@ -392,13 +393,12 @@ int irda_param_pack(__u8 *buf, char *fmt, ...)
>  			break;
>  #endif
>  		default:
> -			va_end(args);
> -			return -1;
> +			retval = -1;
>  		}
>  	}
>  	va_end(args);
>  
> -	return 0;
> +	return retval;
>  }
>  EXPORT_SYMBOL(irda_param_pack);
>  
> @@ -411,10 +411,11 @@ static int irda_param_unpack(__u8 *buf, char *fmt, ...)
>  	va_list args;
>  	char *p;
>  	int n = 0;
> +	int retval = 0;
>  
>  	va_start(args, fmt);
>  
> -	for (p = fmt; *p != '\0'; p++) {
> +	for (p = fmt; *p != '\0' && retval == 0; p++) {
>  		switch (*p) {
>  		case 'b':  /* 8 bits byte */
>  			arg.ip = va_arg(args, __u32 *);
> @@ -436,14 +437,13 @@ static int irda_param_unpack(__u8 *buf, char *fmt, ...)
>  			break;
>  #endif
>  		default:
> -			va_end(args);
> -			return -1;
> +			retval = -1;
>  		}
>  
>  	}
>  	va_end(args);
>  
> -	return 0;
> +	return retval;
>  }
>  
>  /*
> @@ -463,7 +463,7 @@ int irda_param_insert(void *self, __u8 pi, __u8 *buf, int len,
>  	int n = 0;
>  
>  	IRDA_ASSERT(buf != NULL, return ret;);
> -	IRDA_ASSERT(info != 0, return ret;);
> +	IRDA_ASSERT(info != NULL, return ret;);
>  
>  	pi_minor = pi & info->pi_mask;
>  	pi_major = pi >> info->pi_major_offset;
> @@ -517,7 +517,7 @@ static int irda_param_extract(void *self, __u8 *buf, int len,
>  	int n = 0;
>  
>  	IRDA_ASSERT(buf != NULL, return ret;);
> -	IRDA_ASSERT(info != 0, return ret;);
> +	IRDA_ASSERT(info != NULL, return ret;);
>  
>  	pi_minor = buf[n] & info->pi_mask;
>  	pi_major = buf[n] >> info->pi_major_offset;
> @@ -570,7 +570,7 @@ int irda_param_extract_all(void *self, __u8 *buf, int len,
>  	int n = 0;
>  
>  	IRDA_ASSERT(buf != NULL, return ret;);
> -	IRDA_ASSERT(info != 0, return ret;);
> +	IRDA_ASSERT(info != NULL, return ret;);
>  
>  	/*
>  	 * Parse all parameters. Each parameter must be at least two bytes

