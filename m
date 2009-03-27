Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbZC0MpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbZC0MpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 08:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbZC0Mo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 08:44:59 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:45048 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbZC0Mo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ohL5jfr2ZUmgfxX1MlkR6+w9ArZgFvB1SPbmHhLjWCAcigyzadaWbpYlTbhOoMSZKy
         W/Sq9KZLJL2glsFjvT4zOShBmWLcwzMAbncX0rbDK6bUFxFm8+6xTXk15ca4erHBhAt/
         Ip8lxOPTFoNmGkGlZUkUhQYuKgvoAjii8u81c=
Date: Fri, 27 Mar 2009 13:44:53 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Add support of hh length modifier for printk
Message-ID: <20090327124451.GE5976@nowhere>
References: <49CC9739.30107@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CC9739.30107@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 05:07:05PM +0800, Zhaolei wrote:
> hh is used as length modifier for signed char or unsigned char.
> It is supported by glibc, we add kernel support now.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  lib/vsprintf.c |   37 ++++++++++++++++++++++++++++++++-----
>  1 files changed, 32 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index be3001f..908dd41 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -408,6 +408,8 @@ enum format_type {
>  	FORMAT_TYPE_LONG_LONG,
>  	FORMAT_TYPE_ULONG,
>  	FORMAT_TYPE_LONG,
> +	FORMAT_TYPE_UBYTE,
> +	FORMAT_TYPE_BYTE,
>  	FORMAT_TYPE_USHORT,
>  	FORMAT_TYPE_SHORT,
>  	FORMAT_TYPE_UINT,
> @@ -853,11 +855,15 @@ qualifier:
>  	spec->qualifier = -1;
>  	if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L' ||
>  	    *fmt == 'Z' || *fmt == 'z' || *fmt == 't') {
> -		spec->qualifier = *fmt;
> -		++fmt;
> -		if (spec->qualifier == 'l' && *fmt == 'l') {
> -			spec->qualifier = 'L';
> -			++fmt;
> +		spec->qualifier = *fmt++;
> +		if (unlikely(spec->qualifier == *fmt)) {
> +			if (spec->qualifier == 'l') {
> +				spec->qualifier = 'L';
> +				++fmt;
> +			} else if (spec->qualifier == 'h') {
> +				spec->qualifier = 'H';
> +				++fmt;
> +			}
>  		}
>  	}
>  
> @@ -919,6 +925,11 @@ qualifier:
>  		spec->type = FORMAT_TYPE_SIZE_T;
>  	} else if (spec->qualifier == 't') {
>  		spec->type = FORMAT_TYPE_PTRDIFF;
> +	} else if (spec->qualifier == 'H') {
> +		if (spec->flags & SIGN)
> +			spec->type = FORMAT_TYPE_BYTE;
> +		else
> +			spec->type = FORMAT_TYPE_UBYTE;
>  	} else if (spec->qualifier == 'h') {
>  		if (spec->flags & SIGN)
>  			spec->type = FORMAT_TYPE_SHORT;
> @@ -1094,6 +1105,12 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
>  			case FORMAT_TYPE_PTRDIFF:
>  				num = va_arg(args, ptrdiff_t);
>  				break;
> +			case FORMAT_TYPE_UBYTE:
> +				num = (unsigned char) va_arg(args, int);
> +				break;
> +			case FORMAT_TYPE_BYTE:
> +				num = (signed char) va_arg(args, int);
> +				break;
>  			case FORMAT_TYPE_USHORT:
>  				num = (unsigned short) va_arg(args, int);
>  				break;
> @@ -1372,6 +1389,10 @@ do {									\
>  			case FORMAT_TYPE_PTRDIFF:
>  				save_arg(ptrdiff_t);
>  				break;
> +			case FORMAT_TYPE_UBYTE:
> +			case FORMAT_TYPE_BYTE:
> +				save_arg(char);
> +				break;
>  			case FORMAT_TYPE_USHORT:
>  			case FORMAT_TYPE_SHORT:
>  				save_arg(short);
> @@ -1554,6 +1575,12 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
>  			case FORMAT_TYPE_PTRDIFF:
>  				num = get_arg(ptrdiff_t);
>  				break;
> +			case FORMAT_TYPE_UBYTE:
> +				num = get_arg(unsigned char);
> +				break;
> +			case FORMAT_TYPE_BYTE:
> +				num = get_arg(signed char);
> +				break;
>  			case FORMAT_TYPE_USHORT:
>  				num = get_arg(unsigned short);
>  				break;
> -- 
> 1.5.5.3
> 
> 


Looks good.

