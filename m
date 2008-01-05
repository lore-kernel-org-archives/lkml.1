Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbYAENRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbYAENRA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 08:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbYAENQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 08:16:53 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:2220 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbYAENQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 08:16:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=gryuAG0SagaQMibHycV/mP2wifc2UNaaNGKQREh6PntwYRBkjZ9Rb3rhzGSh9vXbiYujt7dV69y5EHe3RUn7wkiPekb1a9hTv3dch9ZijYLag1M0PY68NWY7qwNHnwfXTP59C0uX07ttxSGpjcpdDuYfORN/xza6GbjPNnSxrck=
Message-ID: <477F833F.2030607@gmail.com>
Date: Sat, 05 Jan 2008 16:16:47 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       olof@lixom.net, mpm@selenic.com
Subject: Re: [patch 1/2] move WARN_ON() out of line
References: <477D52ED.7000403@linux.intel.com>
In-Reply-To: <477D52ED.7000403@linux.intel.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven пишет:
> Subject: move WARN_ON() out of line
> From: Arjan van de Ven <arjan@linux.intel.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Olof Johansson <olof@lixom.net>
> CC: Matt Meckall <mpm@selenic.com>
> 
> A quick grep shows that there are currently 1145 instances of WARN_ON
> in the kernel. Currently, WARN_ON is pretty much entirely inlined,
> which makes it hard to enhance it without growing the size of the kernel
> (and getting Andrew rightfully unhappy).
> 
> This patch build on top of Olof's patch that introduces __WARN,
> and places the slowpath out of line. It also uses Ingo's suggestion
> to not use __FUNCTION__ but to use kallsyms to do the lookup;
> this saves a ton of extra space since gcc doesn't need to store the
> function
> string twice now:
> 
> 3936367  833603  624736 5394706  525112 vmlinux.before
> 3917508  833603  624736 5375847  520767 vmlinux-slowpath
> 
> 15Kb savings...
> 

This looks twice as good for one of MIPS configs:

   text    data     bss     dec     hex filename
4908276  204104 2846304 7958684  79709c vmlinux.after
4941596  204104 2846304 7992004  79f2c4 vmlinux.before
$ file vmlinux
vmlinux: ELF 32-bit MSB executable, MIPS, version 1 (SYSV), statically linked, not stripped

More than 30Kb gone, thanks a lot!

Tested-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>

> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> 
> 
> ---
>  include/asm-generic/bug.h |    7 ++-----
>  kernel/panic.c            |   14 ++++++++++++++
>  2 files changed, 16 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6.24-rc6/include/asm-generic/bug.h
> ===================================================================
> --- linux-2.6.24-rc6.orig/include/asm-generic/bug.h
> +++ linux-2.6.24-rc6/include/asm-generic/bug.h
> @@ -32,11 +32,8 @@ struct bug_entry {
>  #endif
> 
>  #ifndef __WARN
> -#define __WARN() do {                            \
> -    printk("WARNING: at %s:%d %s()\n", __FILE__,            \
> -        __LINE__, __FUNCTION__);                \
> -    dump_stack();                            \
> -} while (0)
> +extern void warn_on_slowpath(const char *file, const int line);
> +#define __WARN() warn_on_slowpath(__FILE__, __LINE__)
>  #endif
> 
>  #ifndef WARN_ON
> Index: linux-2.6.24-rc6/kernel/panic.c
> ===================================================================
> --- linux-2.6.24-rc6.orig/kernel/panic.c
> +++ linux-2.6.24-rc6/kernel/panic.c
> @@ -20,6 +20,7 @@
>  #include <linux/kexec.h>
>  #include <linux/debug_locks.h>
>  #include <linux/random.h>
> +#include <linux/kallsyms.h>
> 
>  int panic_on_oops;
>  int tainted;
> @@ -292,6 +293,19 @@ void oops_exit(void)
>          (unsigned long long)oops_id);
>  }
> 
> +
> +void warn_on_slowpath(const char *file, int line)
> +{
> +    char function[KSYM_SYMBOL_LEN];
> +    unsigned long caller = (unsigned long) __builtin_return_address(0);
> +
> +    sprint_symbol(function, caller);
> +    printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
> +        line, function);
> +    dump_stack();
> +}
> +EXPORT_SYMBOL(warn_on_slowpath);
> +
>  #ifdef CONFIG_CC_STACKPROTECTOR
>  /*
>   * Called when gcc's -fstack-protector feature is used, and
> 
> 
> ------------------------------------------------------------------------
> 
> Subject: move WARN_ON() out of line
> From: Arjan van de Ven <arjan@linux.intel.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Olof Johansson <olof@lixom.net>
> CC: Matt Meckall <mpm@selenic.com>
> 
> A quick grep shows that there are currently 1145 instances of WARN_ON
> in the kernel. Currently, WARN_ON is pretty much entirely inlined,
> which makes it hard to enhance it without growing the size of the kernel
> (and getting Andrew unhappy).
> 
> This patch build on top of Olof's patch that introduces __WARN,
> and places the slowpath out of line. It also uses Ingo's suggestion
> to not use __FUNCTION__ but to use kallsyms to do the lookup;
> this saves a ton of extra space since gcc doesn't need to store the function
> string twice now:
> 
> 3936367  833603  624736 5394706  525112 vmlinux.before
> 3917508  833603  624736 5375847  520767 vmlinux-slowpath
> 
> 15Kb savings...
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> 
> 
> ---
>  include/asm-generic/bug.h |    7 ++-----
>  kernel/panic.c            |   14 ++++++++++++++
>  2 files changed, 16 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6.24-rc6/include/asm-generic/bug.h
> ===================================================================
> --- linux-2.6.24-rc6.orig/include/asm-generic/bug.h
> +++ linux-2.6.24-rc6/include/asm-generic/bug.h
> @@ -32,11 +32,8 @@ struct bug_entry {
>  #endif
>  
>  #ifndef __WARN
> -#define __WARN() do {							\
> -	printk("WARNING: at %s:%d %s()\n", __FILE__,			\
> -		__LINE__, __FUNCTION__);				\
> -	dump_stack();							\
> -} while (0)
> +extern void warn_on_slowpath(const char *file, const int line);
> +#define __WARN() warn_on_slowpath(__FILE__, __LINE__)
>  #endif
>  
>  #ifndef WARN_ON
> Index: linux-2.6.24-rc6/kernel/panic.c
> ===================================================================
> --- linux-2.6.24-rc6.orig/kernel/panic.c
> +++ linux-2.6.24-rc6/kernel/panic.c
> @@ -20,6 +20,7 @@
>  #include <linux/kexec.h>
>  #include <linux/debug_locks.h>
>  #include <linux/random.h>
> +#include <linux/kallsyms.h>
>  
>  int panic_on_oops;
>  int tainted;
> @@ -292,6 +293,19 @@ void oops_exit(void)
>  		(unsigned long long)oops_id);
>  }
>  
> +
> +void warn_on_slowpath(const char *file, int line)
> +{
> +	char function[KSYM_SYMBOL_LEN];
> +	unsigned long caller = (unsigned long) __builtin_return_address(0);
> +
> +	sprint_symbol(function, caller);
> +	printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
> +		line, function);
> +	dump_stack();
> +}
> +EXPORT_SYMBOL(warn_on_slowpath);
> +
>  #ifdef CONFIG_CC_STACKPROTECTOR
>  /*
>   * Called when gcc's -fstack-protector feature is used, and

