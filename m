Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbYFDIRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbYFDIRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 04:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYFDIRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 04:17:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087AbYFDIRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 04:17:15 -0400
Date: Wed, 4 Jun 2008 01:16:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: David Brownell <david-b@pacbell.net>, pavel@suse.cz,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       mingo@elte.hu
Subject: Re: [PATCH] add a printk_init variant storing format strings in
 __initdata
Message-Id: <20080604011607.15dec5a7.akpm@linux-foundation.org>
In-Reply-To: <1212485252.0@pinky>
References: <20080529162257.03426e48.akpm@linux-foundation.org>
	<1212485252.0@pinky>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2008 10:27:32 +0100 Andy Whitcroft <apw@shadowen.org> wrote:

> 
> [As gcc seems unable to help us out selecting the appropriate data segment
> for the code, how about we did something like this?]
> 
> When using printk from __init functions it would be desirable to place
> the printk format strings in __initdata.  Add a printk_init() variant
> which does this.
> 
> This printk_init() is necessarily a #define so that we can declare the
> format string in static scope and mark it __initdata.  We then call a
> newly introduced __printk_init() variant which is identicle to printk() but
> marked __init itself.  By ensuring that an __init variant of printk is used
> we get proper section violation warnings when this is used incorrectly:
> 
>     WARNING: vmlinux.o(.text+0x3): Section mismatch in reference from the
> 	function something() to the variable .init.data:__printk_init_fmt.31426
>     The function something() references
>     the variable __initdata __printk_init_fmt.31426.
>     This is often because something lacks a __initdata
>     annotation or the annotation of __printk_init_fmt.31426 is wrong.
> 
> Note I have followed printk's pattern for __cold annotations.
> 

Ho hum.  This give everyone another way in which to bury everyone else
with patches.

Wouldn't it be great if checkpatch were to detect
fail-to-use-printk_init() in an __init function?

oh, speaking of checkpatch: please use it :)

> ---
>  include/linux/kernel.h |   10 ++++++++++
>  kernel/printk.c        |   12 ++++++++++++
>  2 files changed, 22 insertions(+), 0 deletions(-)
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 792bf0a..7754196 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -180,6 +180,13 @@ struct pid;
>  extern struct pid *session_of_pgrp(struct pid *pgrp);
>  
>  #ifdef CONFIG_PRINTK
> +#define printk_init(fmt, args...) \
> +do { \
> +        static char __printk_init_fmt[] __initdata = fmt; \
> +        __printk_init(__printk_init_fmt, ##args); \
> +} while (0)
> +asmlinkage int __printk_init(const char * fmt, ...)
> +	__attribute__ ((format (printf, 1, 2))) __cold;
>  asmlinkage int vprintk(const char *fmt, va_list args)
>  	__attribute__ ((format (printf, 1, 0)));
>  asmlinkage int printk(const char * fmt, ...)
> @@ -196,6 +203,9 @@ extern int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst);
>  extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
>  				   unsigned int interval_msec);
>  #else
> +asmlinkage int printk_init(const char * fmt, ...)
> +	__attribute__ ((format (printf, 1, 2))) __cold;
> +static inline int __cold printk_init(const char *s, ...) { return 0; }
>  static inline int vprintk(const char *s, va_list args)
>  	__attribute__ ((format (printf, 1, 0)));
>  static inline int vprintk(const char *s, va_list args) { return 0; }
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 8fb01c3..992a5c0 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -616,6 +616,18 @@ asmlinkage int printk(const char *fmt, ...)
>  	return r;
>  }
>  
> +asmlinkage __init int __printk_init(const char *fmt, ...)
> +{
> +	va_list args;
> +	int r;
> +
> +	va_start(args, fmt);
> +	r = vprintk(fmt, args);
> +	va_end(args);
> +
> +	return r;
> +}

We're going to want to be able to call printk_init() from modules. 
Please fix and test that, if we decide to proceed.

Oh, and we're going to need printk_meminit() and printk_cpuinit() and
whatever.  

Which probably means that __printk_init() can't be __init, unless all
the CONFIG_ settings which control __cpuinit, __meminit etc are blowing
in the right direction.

It would be good if we could get some idea of the savings here, because
boy this is going to be a pain.

