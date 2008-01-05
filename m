Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbYAEFJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbYAEFJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 00:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYAEFJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 00:09:49 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:19914 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbYAEFJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 00:09:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=L5mIprvM8b3coKbLXMeXU80+ROpL/ELi0cI6I46Ciw5Ye3Y80MpDiVAUAESLfLSZRKuIkKTQKsi2aV2+EMHmbdZREqCezQ2fQlGiOGPKkCmkYi2tpR8gW56dSQc9UlI4iPC0qj7x8iiY6LbmpFNmQoDipOjtkeYYtM+nducQARQ=
Message-ID: <477F1114.4000103@gmail.com>
Date: Sat, 05 Jan 2008 08:09:40 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] move WARN_ON() out of line
References: <477C32DA.5060905@linux.intel.com>
In-Reply-To: <477C32DA.5060905@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven пишет:
> Subject: move WARN_ON() out of line
> From: Arjan van de Ven <arjan@linux.intel.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Andrew Morton <akpm@linux-foundation.org>
> 
> A quick grep shows that there are currently 1145 instances of WARN_ON
> in the kernel. Currently, WARN_ON is pretty much entirely inlined,
> which makes it hard to enhance it without growing the size of the kernel
> (and getting Andrew unhappy).
> 
> This patch moves WARN_ON() out of line entirely. I've considered keeping
> the test inline and moving only the slowpath out of line, but I decided
> against that: an out of line test reduces the pressure on the CPUs
> branch predictor logic and gives smaller code, while a function call
> to a fixed location is quite fast. Likewise I've considered doing something
> similar to BUG() (eg use a trapping instruction) but that's not really
> better (it needs the test inline again and recovering from an invalid
> instruction isn't quite fun).
> 
> The code size reduction of this patch was about 6.5Kb (on a distro style
> .config):
> 
>    text       data        bss        dec        hex    filename
> 3096493     293455    2760704    6150652     5dd9fc    vmlinux.before
> 3090006     293455    2760704    6144165     5dc0a5    vmlinux.after
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> 
> ---
>  include/asm-generic/bug.h |   13 ++++---------
>  kernel/panic.c            |   13 +++++++++++++
>  2 files changed, 17 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6.24-rc6/include/asm-generic/bug.h
> ===================================================================
> --- linux-2.6.24-rc6.orig/include/asm-generic/bug.h
> +++ linux-2.6.24-rc6/include/asm-generic/bug.h
> @@ -32,15 +32,10 @@ struct bug_entry {
>  #endif
> 
>  #ifndef HAVE_ARCH_WARN_ON
> -#define WARN_ON(condition) ({                        \
> -    int __ret_warn_on = !!(condition);                \
> -    if (unlikely(__ret_warn_on)) {                    \
> -        printk("WARNING: at %s:%d %s()\n", __FILE__,        \
> -            __LINE__, __FUNCTION__);            \
> -        dump_stack();                        \
> -    }                                \
> -    unlikely(__ret_warn_on);                    \
> -})
> +extern int do_warn_on(const unsigned long condition, const char *file,
> +    const int line, const char *function);
> +#define WARN_ON(condition) do_warn_on((unsigned long)(condition),
> __FILE__, \
> +                     __LINE__, __FUNCTION__)
>  #endif
> 
>  #else /* !CONFIG_BUG */
> Index: linux-2.6.24-rc6/kernel/panic.c
> ===================================================================
> --- linux-2.6.24-rc6.orig/kernel/panic.c
> +++ linux-2.6.24-rc6/kernel/panic.c
> @@ -20,6 +20,7 @@
>  #include <linux/kexec.h>
>  #include <linux/debug_locks.h>
>  #include <linux/random.h>
> +#include <asm/bug.h>
> 
>  int panic_on_oops;
>  int tainted;
> @@ -292,6 +293,18 @@ void oops_exit(void)
>          (unsigned long long)oops_id);
>  }
> 
> +int do_warn_on(const unsigned long condition, const char *file,
> +            const int line, const char *function)
> +{
> +    if (unlikely(condition)) {
> +        printk(KERN_WARNING "WARNING: at %s:%d %s()\n",
> +            __FILE__, __LINE__, __FUNCTION__);

Isn't this going to print "panic.c" for __FILE__, "do_warn_on" for __FUNCTION__
and whatever line number you have there for __LINE__? I put up a userspace equivalent
of what you're doing here, which confirms my suspision:

dmvo@cipher:/tmp$ cat c.c
#include <stdio.h>

#define WARN_ON(condition) do_warn_on((unsigned long)(condition), __FILE__, \
                        __LINE__, __FUNCTION__)

int do_warn_on(const unsigned long condition, const char *file,
                const int line, const char *function)
{
        if (condition) {
                printf("WARNING: at %s:%d %s()\n",
                                __FILE__, __LINE__, __FUNCTION__);
        }
        return !!condition;
}

int main()
{
        WARN_ON(1);
        return 0;
}
dmvo@cipher:/tmp$ cc c.c
dmvo@cipher:/tmp$ ./a.out
WARNING: at c.c:11 do_warn_on()
dmvo@cipher:/tmp$

I think that your intention was to propagate the parameters to the do_warn_on() routine
to the printk() call, right?

> +        dump_stack();
> +    }
> +    return !!condition;
> +}
> +EXPORT_SYMBOL(do_warn_on);
> +
>  #ifdef CONFIG_CC_STACKPROTECTOR
>  /*
>   * Called when gcc's -fstack-protector feature is used, and
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

