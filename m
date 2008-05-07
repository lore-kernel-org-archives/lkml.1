Return-Path: <linux-kernel-owner+w=401wt.eu-S932911AbYEGTOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbYEGTOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760097AbYEGTNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:13:54 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:64821 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810AbYEGTNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:13:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZZq3+FscvZ1Qc8v7Eez6vZB5W1EiGBkKQvDbjqn+1oGQzbhLzpDEe5gUntC8Z/pCOy5pGtVJ5ZAU+LGGJY1p+TNAsaObRPBr6YqC7dqoAR1hT0BFiu7vM6UQAGo2BXftoHD3BlKdrimwaFAljU9k/i9u3Vd5m4Uz8LnxQvW4sas=
Date: Thu, 8 May 2008 00:09:09 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] lib: vsprintf.c remove macros defining strict
	string functions
Message-ID: <20080507200909.GB5131@martell.zuzino.mipt.ru>
References: <1210184729.19279.33.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210184729.19279.33.camel@brick>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 11:25:29AM -0700, Harvey Harrison wrote:
> Directly code the strict string conversion functions rather than using
> defining macros.  Pull out a small helper to check the strict conditions
> required at the end of a string (nul-terminated or newline).

> Add additional checks in strict_strtol and strict_strtoll for numeric
> overflow of the signed types.

C interer ranges are asymmetric.

These "strict_" functions are a farce. No amount of afterchecking will
save you if there is trivial wraparound in core function.

	Alexey "kstrtonum" Dobriyan


> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -128,6 +128,18 @@ long long simple_strtoll(const char *cp, char **endp, unsigned int base)
>  	return simple_strtoull(cp, endp, base);
>  }
>  
> +/*
> + * Strictly check that the string is nul terminated or has a newline
> + * immediately following len chars.
> + */
> +static int strict_checktail(size_t len, const char *cp, const char *tail)

Name simply sucks.

> +{
> +	if ((*tail == '\0') ||
> +	    ((len == (size_t)(tail - cp) + 1) && (*tail == '\n')))
> +		return 1;
> +	else
> +		return 0;
> +}

> @@ -165,7 +196,29 @@ int strict_strtoul(const char *cp, unsigned int base, unsigned long *res);
>   * It returns 0 if conversion is successful and *res is set to the converted
>   * value, otherwise it returns -EINVAL and *res is set to 0.
>   */
> -int strict_strtol(const char *cp, unsigned int base, long *res);
> +int strict_strtol(const char *cp, unsigned int base, long *res)
> +{
> +	int ret;
> +	unsigned long tmp;
> +
> +	if (*cp == '-')
> +		ret = strict_strtoul(cp + 1, base, &tmp);
> +	else
> +		ret = strict_strtoul(cp, base, &tmp);
> +
> +	if (!ret || tmp > LONG_MAX) {
> +		*res = 0;
> +		return -EINVAL;
> +	}
> +
> +	if (*cp == '-')
> +		*res = -tmp;
> +	else
> +		*res = tmp;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(strict_strtol);
>  
>  /**
>   * strict_strtoull - convert a string to an unsigned long long strictly

