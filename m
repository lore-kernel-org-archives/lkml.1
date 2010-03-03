Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab0CCFcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 00:32:23 -0500
Received: from mail-yx0-f182.google.com ([209.85.210.182]:51607 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab0CCFcV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 00:32:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Nxv2ca9g56dQ0WmI/JUPKHn5per9sdVGC6RYOacwc034YICCtBY3jfCzs7llhmv1u/
         nBqNI/JwRyD3+8PcX6ppu7bB6u+SPNq5qFWEXkoD+HWrCHmfWIAHOLPJ0uhVY7PPKSmq
         fLX9YpxOjTrS41ZkUJMaqle/U2g0SoQ0ksr3E=
MIME-Version: 1.0
In-Reply-To: <1267354697-6456-1-git-send-email-akinobu.mita@gmail.com>
References: <1267354697-6456-1-git-send-email-akinobu.mita@gmail.com>
Date: Wed, 3 Mar 2010 00:32:20 -0500
Message-ID: <b4198de61003022132q2c5f307cwaf9bd1d655ae5a4@mail.gmail.com>
Subject: Re: [PATCH] alpha: use __ratelimit
From: Matt Turner <mattst88@gmail.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 28, 2010 at 5:58 AM, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> Replace open-coded rate limiting logic with __ratelimit().
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Cc: Matt Turner <mattst88@gmail.com>
> Cc: linux-alpha@vger.kernel.org
> ---
>  arch/alpha/kernel/traps.c |   10 +++-------
>  1 files changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
> index 6ee7655..b14f015 100644
> --- a/arch/alpha/kernel/traps.c
> +++ b/arch/alpha/kernel/traps.c
> @@ -17,6 +17,7 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/kallsyms.h>
> +#include <linux/ratelimit.h>
>
>  #include <asm/gentrap.h>
>  #include <asm/uaccess.h>
> @@ -771,8 +772,7 @@ asmlinkage void
>  do_entUnaUser(void __user * va, unsigned long opcode,
>              unsigned long reg, struct pt_regs *regs)
>  {
> -       static int cnt = 0;
> -       static unsigned long last_time;
> +       static DEFINE_RATELIMIT_STATE(ratelimit, 5 * HZ, 5);
>
>        unsigned long tmp1, tmp2, tmp3, tmp4;
>        unsigned long fake_reg, *reg_addr = &fake_reg;
> @@ -783,15 +783,11 @@ do_entUnaUser(void __user * va, unsigned long opcode,
>           with the unaliged access.  */
>
>        if (!test_thread_flag (TIF_UAC_NOPRINT)) {
> -               if (cnt >= 5 && time_after(jiffies, last_time + 5 * HZ)) {
> -                       cnt = 0;
> -               }
> -               if (++cnt < 5) {
> +               if (__ratelimit(&ratelimit)) {
>                        printk("%s(%d): unaligned trap at %016lx: %p %lx %ld\n",
>                               current->comm, task_pid_nr(current),
>                               regs->pc - 4, va, opcode, reg);
>                }
> -               last_time = jiffies;
>        }
>        if (test_thread_flag (TIF_UAC_SIGBUS))
>                goto give_sigbus;
> --
> 1.6.0.6

Thanks, applied.

Matt
