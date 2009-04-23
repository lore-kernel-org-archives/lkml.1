Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbZDWMEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbZDWMEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbZDWMD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:03:59 -0400
Received: from cmpxchg.org ([85.214.51.133]:48957 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbZDWMD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:03:59 -0400
Date: Thu, 23 Apr 2009 14:02:19 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: arjan@linux.intel.com, linux-kernel@vger.kernel.org, torvalds@osdl.org,
       akpm@osdl.org
Subject: Re: [PATCH] Eliminate thousands of warnings in WARN_ON with gcc 3.2 build
Message-ID: <20090423120219.GA23479@cmpxchg.org>
References: <20090422221134.GA1753@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422221134.GA1753@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Thu, Apr 23, 2009 at 12:11:34AM +0200, Andi Kleen wrote:
> Eliminate thousands of warnings with gcc 3.2 build
> 
> When building with gcc 3.2 I get thousands of warnings about passing
> a NULL format string to warn_on_slowpath(). Split this case out
> into a separate call. This should also shrink the kernel
> slightly in theory (haven't done numbers)
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  include/asm-generic/bug.h |    7 ++++---
>  kernel/panic.c            |   12 +++++++++---
>  2 files changed, 13 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6.30-rc2-ak/include/asm-generic/bug.h
> ===================================================================
> --- linux-2.6.30-rc2-ak.orig/include/asm-generic/bug.h	2009-01-11 20:20:40.000000000 +0100
> +++ linux-2.6.30-rc2-ak/include/asm-generic/bug.h	2009-04-22 23:52:48.000000000 +0200
> @@ -58,12 +58,13 @@
>   */
>  #ifndef __WARN
>  #ifndef __ASSEMBLY__
> -extern void warn_slowpath(const char *file, const int line,
> +extern void warn_slowpath_fmt(const char *file, const int line,
>  		const char *fmt, ...) __attribute__((format(printf, 3, 4)));
> +extern void warn_slowpath_null(const char *file, const int line);
>  #define WANT_WARN_ON_SLOWPATH
>  #endif
> -#define __WARN()		warn_slowpath(__FILE__, __LINE__, NULL)
> -#define __WARN_printf(arg...)	warn_slowpath(__FILE__, __LINE__, arg)
> +#define __WARN()		warn_slowpath_null(__FILE__, __LINE__)
> +#define __WARN_printf(arg...)	warn_slowpath_fmt(__FILE__, __LINE__, arg)
>  #else
>  #define __WARN_printf(arg...)	do { printk(arg); __WARN(); } while (0)
>  #endif
> Index: linux-2.6.30-rc2-ak/kernel/panic.c
> ===================================================================
> --- linux-2.6.30-rc2-ak.orig/kernel/panic.c	2009-04-19 19:29:07.000000000 +0200
> +++ linux-2.6.30-rc2-ak/kernel/panic.c	2009-04-22 23:53:55.000000000 +0200
> @@ -342,7 +342,7 @@
>  }
>  
>  #ifdef WANT_WARN_ON_SLOWPATH
> -void warn_slowpath(const char *file, int line, const char *fmt, ...)
> +void warn_slowpath_fmt(const char *file, int line, const char *fmt, ...)
>  {
>  	va_list args;
>  	char function[KSYM_SYMBOL_LEN];
> @@ -358,7 +358,7 @@
>  	if (board)
>  		printk(KERN_WARNING "Hardware name: %s\n", board);
>  
> -	if (fmt) {
> +	if (*fmt) {
>  		va_start(args, fmt);
>  		vprintk(fmt, args);
>  		va_end(args);
> @@ -369,7 +369,13 @@
>  	print_oops_end_marker();
>  	add_taint(TAINT_WARN);
>  }
> -EXPORT_SYMBOL(warn_slowpath);
> +EXPORT_SYMBOL(warn_slowpath_fmt);
> +
> +void warn_slowpath_null(const char *file, int line)
> +{
> +	warn_slowpath_fmt(file, line, "");
> +}
> +EXPORT_SYMBOL(warn_slowpath_null);

That should still emit a warning due to passing in a zero-length
format string.  Using (const char *){ 0 } as the literal would
suppress it (on gcc 4.3.3 at least) but I'm not sure if it's worth the
uglyness...
