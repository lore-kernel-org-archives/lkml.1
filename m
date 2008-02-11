Return-Path: <linux-kernel-owner+w=401wt.eu-S1760870AbYBKUbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870AbYBKUbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbYBKUa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:30:57 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:12711 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbYBKUa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:30:56 -0500
Date: Mon, 11 Feb 2008 12:28:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Nur Hussein <nurhussein@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl
Subject: Re: [PATCH 1/1] Taint kernel after WARN_ON(condition)
Message-Id: <20080211122829.4035e7b5.randy.dunlap@oracle.com>
In-Reply-To: <20080211195222.GA5809@gandalf.middleearth>
References: <20080211195222.GA5809@gandalf.middleearth>
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

On Tue, 12 Feb 2008 03:52:22 +0800 Nur Hussein wrote:

> This patch will taint the kernel with a new flag, 'W', whenever a
> warning is issued with WARN_ON(condition). Whenever a warning occurs, it
> is helpful to record this within the kernel state as a taint. When a BUG
> happens, it'd be useful to know if it was also preceded by a WARN.
> 
> This patch applies to Linus's git tree.
> 
> Signed-off-by: Nur Hussein (nurhussein@gmail.com)
> ---
> 
> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> index 2632328..0633e96 100644
> --- a/include/asm-generic/bug.h
> +++ b/include/asm-generic/bug.h
> @@ -42,8 +42,10 @@ extern void warn_on_slowpath(const char *file, const int line);
>  #ifndef WARN_ON
>  #define WARN_ON(condition) ({						\
>  	int __ret_warn_on = !!(condition);				\
> -	if (unlikely(__ret_warn_on))					\
> +	if (unlikely(__ret_warn_on)) {					\
>  		__WARN();						\
> +		add_taint(TAINT_WARN);					\
> +	}								\
>  	unlikely(__ret_warn_on);					\
>  })
>  #endif
> @@ -60,6 +62,8 @@ extern void warn_on_slowpath(const char *file, const int line);
>  #ifndef HAVE_ARCH_WARN_ON
>  #define WARN_ON(condition) ({						\
>  	int __ret_warn_on = !!(condition);				\
> +	if (unlikely(__ret_warn_on)) 					\
> +		add_taint(TAINT_WARN);					\
>  	unlikely(__ret_warn_on);					\
>  })
>  #endif
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 2df44e7..d90c1a4 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -255,6 +255,7 @@ extern enum system_states {
>  #define TAINT_USER			(1<<6)
>  #define TAINT_DIE			(1<<7)
>  #define TAINT_OVERRIDDEN_ACPI_TABLE	(1<<8)
> +#define TAINT_WARN			(1<<9)
>  
>  extern void dump_stack(void) __cold;
>  
> diff --git a/kernel/panic.c b/kernel/panic.c
> index 24af9f8..e113a85 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -153,6 +153,8 @@ EXPORT_SYMBOL(panic);
>   *  'M' - System experienced a machine check exception.
>   *  'B' - System has hit bad_page.
>   *  'U' - Userspace-defined naughtiness.
> + *  'A' - ACPI table overridden.
> + *  'W' - Taint on warning.
>   *

Oops.  Both 'A' and 'W' also need to be added to
Documentation/oops-tracing.txt, please.


>   *	The string is overwritten by the next call to print_taint().
>   */
> @@ -161,7 +163,7 @@ const char *print_tainted(void)
>  {
>  	static char buf[20];
>  	if (tainted) {
> -		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c%c%c",
> +		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c%c%c%c",
>  			tainted & TAINT_PROPRIETARY_MODULE ? 'P' : 'G',
>  			tainted & TAINT_FORCED_MODULE ? 'F' : ' ',
>  			tainted & TAINT_UNSAFE_SMP ? 'S' : ' ',
> @@ -170,7 +172,8 @@ const char *print_tainted(void)
>  			tainted & TAINT_BAD_PAGE ? 'B' : ' ',
>  			tainted & TAINT_USER ? 'U' : ' ',
>  			tainted & TAINT_DIE ? 'D' : ' ',
> -			tainted & TAINT_OVERRIDDEN_ACPI_TABLE ? 'A' : ' ');
> +			tainted & TAINT_OVERRIDDEN_ACPI_TABLE ? 'A' : ' ',
> +			tainted & TAINT_WARN ? 'W' : ' ');
>  	}
>  	else
>  		snprintf(buf, sizeof(buf), "Not tainted");
> --

---
~Randy
