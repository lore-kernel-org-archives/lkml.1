Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbYK1Q6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbYK1Q6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 11:58:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYK1Q5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 11:57:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41573 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbYK1Q5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 11:57:55 -0500
Date: Fri, 28 Nov 2008 17:57:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] warn: consolidate warn_slowpath and
	warn_on_slowpath
Message-ID: <20081128165747.GC10487@elte.hu>
References: <20081128083525.092e9859@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081128083525.092e9859@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> From 7aaa8478fe22e944adf185e465fa07799b87e573 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Fri, 28 Nov 2008 08:30:46 -0800
> Subject: [PATCH] warn: consolidate warn_slowpath and warn_on_slowpath
> 
> warn_slowpath is a superset of warn_on_slowpath; just have
> warn_on_slowpath call warn_slowpath with a NULL 3rd argument.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  kernel/panic.c |   32 ++++++++++++--------------------
>  1 files changed, 12 insertions(+), 20 deletions(-)
> 
> diff --git a/kernel/panic.c b/kernel/panic.c
> index d1ac662..2b913aa 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -324,23 +324,6 @@ void oops_exit(void)
>  }
>  
>  #ifdef WANT_WARN_ON_SLOWPATH
> -void warn_on_slowpath(const char *file, int line)
> -{
> -	char function[KSYM_SYMBOL_LEN];
> -	unsigned long caller = (unsigned long) __builtin_return_address(0);
> -	sprint_symbol(function, caller);
> -
> -	printk(KERN_WARNING "------------[ cut here ]------------\n");
> -	printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
> -		line, function);
> -	print_modules();
> -	dump_stack();
> -	print_oops_end_marker();
> -	add_taint(TAINT_WARN);
> -}
> -EXPORT_SYMBOL(warn_on_slowpath);
> -
> -
>  void warn_slowpath(const char *file, int line, const char *fmt, ...)
>  {
>  	va_list args;
> @@ -351,9 +334,12 @@ void warn_slowpath(const char *file, int line, const char *fmt, ...)
>  	printk(KERN_WARNING "------------[ cut here ]------------\n");
>  	printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
>  		line, function);
> -	va_start(args, fmt);
> -	vprintk(fmt, args);
> -	va_end(args);
> +
> +	if (fmt) {
> +		va_start(args, fmt);
> +		vprintk(fmt, args);
> +		va_end(args);
> +	}
>  
>  	print_modules();
>  	dump_stack();
> @@ -361,6 +347,12 @@ void warn_slowpath(const char *file, int line, const char *fmt, ...)
>  	add_taint(TAINT_WARN);
>  }
>  EXPORT_SYMBOL(warn_slowpath);
> +
> +void warn_on_slowpath(const char *file, int line)
> +{
> +	warn_slowpath(file, line, NULL);
> +}
> +EXPORT_SYMBOL(warn_on_slowpath);
>  #endif

well spotted! Applied to tip/core/debug, thanks Arjan!

I've also done the change below that goes one step further, and turns 
eliminates warn_on_slowpath() altogether and calls warn_slowpath(file, 
line, NULL) straight from include/asm-generic/bug.h's __WARN() 
definition.

	Ingo

------------->
>From ec5679e513305f1411753e5f5489935bd638af23 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 28 Nov 2008 17:56:14 +0100
Subject: [PATCH] debug warnings: eliminate warn_on_slowpath()

Impact: cleanup, eliminate code

now that warn_on_slowpath() uses warn_slowpath(...,NULL), we can
eliminate warn_on_slowpath() altogether and use warn_slowpath().

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-generic/bug.h |    7 +++----
 kernel/panic.c            |    6 ------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 12c07c1..b8ba694 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -33,15 +33,14 @@ struct bug_entry {
 
 #ifndef __WARN
 #ifndef __ASSEMBLY__
-extern void warn_on_slowpath(const char *file, const int line);
 extern void warn_slowpath(const char *file, const int line,
 		const char *fmt, ...) __attribute__((format(printf, 3, 4)));
 #define WANT_WARN_ON_SLOWPATH
 #endif
-#define __WARN() warn_on_slowpath(__FILE__, __LINE__)
-#define __WARN_printf(arg...) warn_slowpath(__FILE__, __LINE__, arg)
+#define __WARN()		warn_slowpath(__FILE__, __LINE__, NULL)
+#define __WARN_printf(arg...)	warn_slowpath(__FILE__, __LINE__, arg)
 #else
-#define __WARN_printf(arg...) do { printk(arg); __WARN(); } while (0)
+#define __WARN_printf(arg...)	do { printk(arg); __WARN(); } while (0)
 #endif
 
 #ifndef WARN_ON
diff --git a/kernel/panic.c b/kernel/panic.c
index 73d3651..50349a4 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -349,12 +349,6 @@ void warn_slowpath(const char *file, int line, const char *fmt, ...)
 	add_taint(TAINT_WARN);
 }
 EXPORT_SYMBOL(warn_slowpath);
-
-void warn_on_slowpath(const char *file, int line)
-{
-	warn_slowpath(file, line, NULL);
-}
-EXPORT_SYMBOL(warn_on_slowpath);
 #endif
 
 #ifdef CONFIG_CC_STACKPROTECTOR
