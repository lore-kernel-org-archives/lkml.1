Return-Path: <linux-kernel-owner+w=401wt.eu-S965196AbYBAHpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965196AbYBAHpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935151AbYBAHjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:39:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56662 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935132AbYBAHjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:39:13 -0500
Date: Thu, 31 Jan 2008 23:39:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: yi.y.yang@intel.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] Add new string functions strict_strto* and
 convert kernel params to use them, take 2
Message-Id: <20080131233923.fe230a63.akpm@linux-foundation.org>
In-Reply-To: <1201817503.3925.5.camel@yangyi-dev.bj.intel.com>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
	<1201043126.3861.5.camel@yangyi-dev.bj.intel.com>
	<1201562058.12722.9.camel@yangyi-dev.bj.intel.com>
	<1201650080.3875.1.camel@yangyi-dev.bj.intel.com>
	<1201742302.6500.7.camel@yangyi-dev.bj.intel.com>
	<1201817503.3925.5.camel@yangyi-dev.bj.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Feb 2008 06:11:43 +0800 Yi Yang <yi.y.yang@intel.com> wrote:

> --- a/include/linux/kernel.h	2008-01-31 00:41:46.000000000 +0800
> --- b/include/linux/kernel.h	2008-02-01 04:30:49.000000000 +0800
> @@ -141,6 +141,10 @@ extern unsigned long simple_strtoul(cons
>  extern long simple_strtol(const char *,char **,unsigned int);
>  extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
>  extern long long simple_strtoll(const char *,char **,unsigned int);
> +extern int strict_strtoul(const char *, unsigned int, unsigned long *);
> +extern int strict_strtol(const char *, unsigned int, long *);
> +extern int strict_strtoull(const char *, unsigned int, unsigned long long *);
> +extern int strict_strtoll(const char *, unsigned int, long long *);
>  extern int sprintf(char * buf, const char * fmt, ...)
>  	__attribute__ ((format (printf, 2, 3)));
>  extern int vsprintf(char *buf, const char *, va_list)
> --- a/lib/vsprintf.c	2008-01-30 08:13:03.000000000 +0800
> --- b/lib/vsprintf.c	2008-02-01 04:33:27.000000000 +0800
> @@ -126,6 +126,52 @@ long long simple_strtoll(const char *cp,
>  	return simple_strtoull(cp,endp,base);
>  }
>  
> +#define define_strict_strtoux(type, valtype)				\
> +int strict_strtou##type(const char *cp, unsigned int base, valtype *res)\
> +{									\
> +	char *tail;							\
> +	valtype val;							\
> +	size_t len;							\
> +									\
> +	*res = 0;							\
> +	len = strlen(cp);						\
> +	if (len == 0)							\
> +		return -EINVAL;						\
> +									\
> +	val = simple_strtoul(cp, &tail, base);				\
> +	if ((*tail == '\0') ||						\
> +		(len == (size_t)(tail - cp) + 1) && (*tail == '\n')) {	\
> +		*res = val;						\
> +		return 0;						\
> +	}								\
> +									\
> +	return -EINVAL;							\
> +}									\
> +
> +#define define_strict_strtox(type, valtype)				\
> +int strict_strto##type(const char *cp, unsigned int base, valtype *res)	\
> +{									\
> +	int ret;							\
> +	if (*cp == '-') {						\
> +		ret = strict_strtou##type(cp+1, base, res);		\
> +		if (ret != 0)						\
> +			*res = -(*res);					\
> +	} else								\
> +		ret = strict_strtou##type(cp+1, base, res);		\
> +									\
> +	return ret;							\
> +}									\
> +
> +define_strict_strtoux(l, unsigned long)
> +define_strict_strtox(l, long)
> +define_strict_strtoux(ll, unsigned long long)
> +define_strict_strtox(ll, long long)
> +
> +EXPORT_SYMBOL(strict_strtoul);
> +EXPORT_SYMBOL(strict_strtol);
> +EXPORT_SYMBOL(strict_strtoll);
> +EXPORT_SYMBOL(strict_strtoull);

These are global, exported-to-modules library functions.  Documentation is
compulsory (as far as I'm concerned).

Could you please add a comment block in there which at least explains how
they differ from the other strto* functions?


