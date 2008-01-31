Return-Path: <linux-kernel-owner+w=401wt.eu-S934403AbYAaRF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934403AbYAaRF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764019AbYAaRFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:05:44 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:28237 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763489AbYAaRFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:05:42 -0500
Date: Thu, 31 Jan 2008 09:03:45 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: yi.y.yang@intel.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.24] Add new string functions real_strtoul and change
 kernel params to use them
Message-Id: <20080131090345.92bce974.randy.dunlap@oracle.com>
In-Reply-To: <1201742302.6500.7.camel@yangyi-dev.bj.intel.com>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
	<1201043126.3861.5.camel@yangyi-dev.bj.intel.com>
	<1201562058.12722.9.camel@yangyi-dev.bj.intel.com>
	<1201650080.3875.1.camel@yangyi-dev.bj.intel.com>
	<1201742302.6500.7.camel@yangyi-dev.bj.intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 09:18:22 +0800 Yi Yang wrote:

> Currently, for every sysfs node, the callers will be responsible for
> implementing store operation, so many many callers are doing duplicate
> things to validate input, they have the same mistakes because they are
> calling simple_strtol/ul/ll/ull, especially for module params, they are
> just numeric, but you can echo such values as 0x1234xxx, 07777888 and
> 1234aaa, for these cases, module params store operation just ignores
> successive invalid char and converts prefix part to a numeric although
> input is actually invalid.
> 
> This patch tries to fix the aforementioned issues and implements real_strtox
> serial functions, kernel/params.c uses them to strictly validate input,
> so module params will reject such values as 0x1234xxxx and returns an error:

How about a prefix of safe_ or strict_ or something other than real_?
real_ sounds too much like a real number function string parser.

> write error: Invalid argument
> 
> Any modules which export numeric sysfs node can use real_strtox instead of
> simple_strtox to reject any invalid input. Please consider to merge to -mm tree
> in order to test.
> 
> Here are some test results:
> 
> Before applying this patch:
> 
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]# echo 0x1000 > /sys/module/e1000/parameters/copybreak
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]# echo 0x1000g > /sys/module/e1000/parameters/copybreak
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]# echo 0x1000gggggggg > /sys/module/e1000/parameters/copybreak
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]# echo 010000 > /sys/module/e1000/parameters/copybreak
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]# echo 0100008 > /sys/module/e1000/parameters/copybreak
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]# echo 010000aaaaa > /sys/module/e1000/parameters/copybreak
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]#
> 
> 
> After applying this patch:
> 
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]# echo 0x1000 > /sys/module/e1000/parameters/copybreak
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]# echo 0x1000g > /sys/module/e1000/parameters/copybreak
> -bash: echo: write error: Invalid argument
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]# echo 0x1000gggggggg > /sys/module/e1000/parameters/copybreak
> -bash: echo: write error: Invalid argument
> [root@yangyi-dev /]# echo 010000 > /sys/module/e1000/parameters/copybreak
> [root@yangyi-dev /]# echo 0100008 > /sys/module/e1000/parameters/copybreak
> -bash: echo: write error: Invalid argument
> [root@yangyi-dev /]# echo 010000aaaaa > /sys/module/e1000/parameters/copybreak
> -bash: echo: write error: Invalid argument
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]# echo -n 4096 > /sys/module/e1000/parameters/copybreak
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]#
> 
> 
> Signed-off-by: Yi Yang <yi.y.yang@intel.com>
> ---
>  include/linux/kernel.h |    4 ++++
>  kernel/params.c        |   20 ++++++++++----------
>  lib/vsprintf.c         |   46 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 60 insertions(+), 10 deletions(-)
> 
> --- a/include/linux/kernel.h	2008-01-31 00:41:46.000000000 +0800
> +++ b/include/linux/kernel.h	2008-01-31 01:12:33.000000000 +0800
> @@ -141,6 +141,10 @@ extern unsigned long simple_strtoul(cons
>  extern long simple_strtol(const char *,char **,unsigned int);
>  extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
>  extern long long simple_strtoll(const char *,char **,unsigned int);
> +extern int real_strtoul(const char *, unsigned int, unsigned long *);
> +extern int real_strtol(const char *, unsigned int, long *);
> +extern int real_strtoull(const char *, unsigned int, unsigned long long *);
> +extern int real_strtoll(const char *, unsigned int, long long *);
>  extern int sprintf(char * buf, const char * fmt, ...)
>  	__attribute__ ((format (printf, 2, 3)));
>  extern int vsprintf(char *buf, const char *, va_list)
> --- a/lib/vsprintf.c	2008-01-30 08:13:03.000000000 +0800
> +++ b/lib/vsprintf.c	2008-01-31 05:19:31.000000000 +0800
> @@ -126,6 +126,52 @@ long long simple_strtoll(const char *cp,
>  	return simple_strtoull(cp,endp,base);
>  }
>  
> +#define define_real_strtoux(type, valtype)				\
> +int real_strtou##type(const char *cp, unsigned int base, valtype *res)	\
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
> +#define define_real_strtox(type, valtype)				\
> +int real_strto##type(const char *cp, unsigned int base, valtype *res)	\
> +{									\
> +	int ret;							\
> +	if (*cp == '-') {						\
> +		ret = real_strtou##type(cp+1, base, res);		\
> +		if (ret != 0)						\
> +			*res = -(*res);					\
> +	} else								\
> +		ret = real_strtou##type(cp+1, base, res);		\
> +									\
> +	return ret;							\
> +}									\
> +
> +define_real_strtoux(l, unsigned long)
> +define_real_strtox(l, long)
> +define_real_strtoux(ll, unsigned long long)
> +define_real_strtox(ll, long long)
> +
> +EXPORT_SYMBOL(real_strtoul);
> +EXPORT_SYMBOL(real_strtol);
> +EXPORT_SYMBOL(real_strtoll);
> +EXPORT_SYMBOL(real_strtoull);
> +
>  static int skip_atoi(const char **s)
>  {
>  	int i=0;
> --- a/kernel/params.c	2008-01-31 00:44:44.000000000 +0800
> +++ b/kernel/params.c	2008-01-31 01:11:51.000000000 +0800
> @@ -180,12 +180,12 @@ int parse_args(const char *name,
>  #define STANDARD_PARAM_DEF(name, type, format, tmptype, strtolfn)      	\
>  	int param_set_##name(const char *val, struct kernel_param *kp)	\
>  	{								\
> -		char *endp;						\
>  		tmptype l;						\
> +		int ret;						\
>  									\
>  		if (!val) return -EINVAL;				\
> -		l = strtolfn(val, &endp, 0);				\
> -		if (endp == val || ((type)l != l))			\
> +		ret = strtolfn(val, 0, &l);				\
> +		if (ret == -EINVAL || ((type)l != l))			\
>  			return -EINVAL;					\
>  		*((type *)kp->arg) = l;					\
>  		return 0;						\
> @@ -195,13 +195,13 @@ int parse_args(const char *name,
>  		return sprintf(buffer, format, *((type *)kp->arg));	\
>  	}
>  
> -STANDARD_PARAM_DEF(byte, unsigned char, "%c", unsigned long, simple_strtoul);
> -STANDARD_PARAM_DEF(short, short, "%hi", long, simple_strtol);
> -STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, simple_strtoul);
> -STANDARD_PARAM_DEF(int, int, "%i", long, simple_strtol);
> -STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, simple_strtoul);
> -STANDARD_PARAM_DEF(long, long, "%li", long, simple_strtol);
> -STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, simple_strtoul);
> +STANDARD_PARAM_DEF(byte, unsigned char, "%c", unsigned long, real_strtoul);
> +STANDARD_PARAM_DEF(short, short, "%hi", long, real_strtol);
> +STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, real_strtoul);
> +STANDARD_PARAM_DEF(int, int, "%i", long, real_strtol);
> +STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, real_strtoul);
> +STANDARD_PARAM_DEF(long, long, "%li", long, real_strtol);
> +STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, real_strtoul);
>  
>  int param_set_charp(const char *val, struct kernel_param *kp)
>  {
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


---
~Randy
