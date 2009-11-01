Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852AbZKAWpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbZKAWpr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 17:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753681AbZKAWpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 17:45:46 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:56845 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbZKAWpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 17:45:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=VGgTvGnVr3EswCal2vR5vomH+y0S2E915f/cJVqhgttuMk0RLQ5Sm00ITeiNw2Fg12
         1JpW5UMA5VX7XXGBvch27Jt6msRyJnIsEF3mgKMiwx79NPaprimTbm8w4hsKcJzVTh0B
         8MvYruyQ2PQU2LNO2HeIeZdwAtZ3iw2N7/BXo=
Date: Sun, 1 Nov 2009 23:45:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>
Cc: laijs@cn.fujitsu.com, mingo@elte.hu, davem@davemloft.net,
       akpm@linux-foundation.org, harvey.harrison@gmail.com,
       linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vsprintf: reduce code size, clean up
Message-ID: <20091101224547.GB5263@nowhere>
References: <b8bf37780911010901i3426f143ve394ae569be74ec1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8bf37780911010901i3426f143ve394ae569be74ec1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 01, 2009 at 03:01:40PM -0200, André Goddard Rosa wrote:
> +static char null[] = "(null)";
> +


This should be static const.
Also, may be chose a better name, as "null" is too much
generic and somehow collide with NULL.

null_str ?


> @@ -735,8 +737,9 @@ static char *ip6_compressed_string(char *p, const
> char *addr)
>  				p = pack_hex_byte(p, hi);
>  			else
>  				*p++ = hex_asc_lo(hi);
> +			p = pack_hex_byte(p, lo);
>  		}
> -		if (hi || lo > 0x0f)
> +		else if (lo > 0x0f)
>  			p = pack_hex_byte(p, lo);
>  		else
>  			*p++ = hex_asc_lo(lo);



I'm not sure the above is really a simplification.
It's more a matter of personal preference :-)

But the previous version factorized the action.



> @@ -822,30 +825,34 @@ static char *pointer(const char *fmt, char *buf,
> char *end, void *ptr,
>  			struct printf_spec spec)
>  {
>  	if (!ptr)
> -		return string(buf, end, "(null)", spec);
> +		return string(buf, end, null, spec);
> 
> -	switch (*fmt) {
> -	case 'F':
> +	switch (TOLOWER(*fmt)) {
>  	case 'f':
> +	/* or case 'F' */
>  		ptr = dereference_function_descriptor(ptr);
> -	case 's':
>  		/* Fallthrough */
> -	case 'S':
> +	case 's':
> +	/* or case 'S' */
>  		return symbol_string(buf, end, ptr, spec, *fmt);
>  	case 'R':
>  		return resource_string(buf, end, ptr, spec);



What happens if we have %pr ?
It will behave like %pR but it shouldn't.

I don't think this is a good thing to do this switch(TO_LOWER(..))
thing.

We might want to change the behaviour for x but not for X in the future
(x being whatever letter in %px) and this code factorization breaks such
flexibility.

That also means we'll need to handle exceptions like %pr and perhaps we'll
even need to revert these changes once we add another %px without a
matching %pX


> @@ -970,8 +977,8 @@ precision:
>  qualifier:
>  	/* get the conversion qualifier */
>  	spec->qualifier = -1;
> -	if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L' ||
> -	    *fmt == 'Z' || *fmt == 'z' || *fmt == 't') {
> +	if (*fmt == 'h' || TOLOWER(*fmt) == 'l' ||
> +	    TOLOWER(*fmt) == 'z' || *fmt == 't') {
>  		spec->qualifier = *fmt++;
>  		if (unlikely(spec->qualifier == *fmt)) {
>  			if (spec->qualifier == 'l') {
> @@ -1038,7 +1045,7 @@ qualifier:
>  			spec->type = FORMAT_TYPE_LONG;
>  		else
>  			spec->type = FORMAT_TYPE_ULONG;
> -	} else if (spec->qualifier == 'Z' || spec->qualifier == 'z') {
> +	} else if (TOLOWER(spec->qualifier) == 'z') {




But there the TO_LOWER is fine.


> @@ -1798,13 +1802,14 @@ int vsscanf(const char * buf, const char *
> fmt, va_list args)
>  				}
>  			}
>  		}
> -		base = 10;
> -		is_sign = 0;
> 
>  		if (!*fmt || !*str)
>  			break;
> 
> -		switch(*fmt++) {
> +		base = 10;
> +		is_sign = 0;
> +
> +		switch (TOLOWER(*fmt++)) {
>  		case 'c':
>  		{
> 			char *s = (char *) va_arg(args,char*);


Please don't do that, this breaks the scanf format.

What happens if we have %C or %S or...?


Ok, the rest looks good.
But you should split up this patch into several more targeted patches,
because:

1) Several more divided/targeted/focused patches are easier to review,
and people will be more keen to review them.

2) vsprintf.c is a bit sensible as a tiny change might break printk()
and other things, which means you need the desired effect in 1)  :)

3) It will make the bisection easier, which makes 2) smoother to deal with
(if you break printk)

I would suggest you:

	- Factorize null string
	- Whitespaces/checkpatch.pl fixes
	- TO_LOWER things
	- Move local vars to bloc local vars
	- CASE statement factorization ?

Hm?

