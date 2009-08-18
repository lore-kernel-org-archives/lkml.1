Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbZHRLkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbZHRLkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 07:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZHRLkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 07:40:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbZHRLkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 07:40:24 -0400
Date: Tue, 18 Aug 2009 13:40:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: "tina.yang" <tina.yang@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sysrq: add debug message to reboot event
In-Reply-To: <4A89AC97.6030109@oracle.com>
Message-ID: <alpine.LNX.2.00.0908181339310.25797@wotan.suse.de>
References: <4A89AC97.6030109@oracle.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009, tina.yang wrote:

> Add debug message to detect keyboard vs non-keyboard
> triggered sysrq-b events.
> 
> Signed-off-by: Tina Yang <Tina.Yang@oracle.com>
> Signed-off-by: Zach Brown <Zach.Brown@oracle.com>
> 
> ---
> 
> --- linux-2.6.git/drivers/char/sysrq.c.orig     2009-08-13
> 15:43:34.000000000 -0700
> +++ linux-2.6.git/drivers/char/sysrq.c  2009-08-13 21:51:15.832694000 -0700
> @@ -135,17 +135,22 @@ static struct sysrq_key_op sysrq_crash_o
>         .enable_mask    = SYSRQ_ENABLE_DUMP,
>  };
> 
> -static void sysrq_handle_reboot(int key, struct tty_struct *tty)
> +static void sysrq_handle_reboot(int check_mask, int key, struct
> tty_struct *tty)
>  {
> +       if (check_mask)
> +               printk("<keyboard-invoked>\n");
> +        else
> +               printk("<non-keyboard-invoked: PID %d COMMAND %s>\n",
> +                               current->pid, current->comm);
>         lockdep_off();
>         local_irq_enable();
>         emergency_restart();
>  }
>  static struct sysrq_key_op sysrq_reboot_op = {
> -       .handler        = sysrq_handle_reboot,
> -       .help_msg       = "reBoot",
> -       .action_msg     = "Resetting",
> -       .enable_mask    = SYSRQ_ENABLE_BOOT,
> +       .handler_with_mask      = sysrq_handle_reboot,
> +       .help_msg               = "reBoot",
> +       .action_msg             = "Resetting",
> +       .enable_mask            = SYSRQ_ENABLE_BOOT,
>  };
> 
>  static void sysrq_handle_sync(int key, struct tty_struct *tty)
> @@ -509,7 +514,10 @@ void __handle_sysrq(int key, struct tty_
>                 if (!check_mask || sysrq_on_mask(op_p->enable_mask)) {
>                         printk("%s\n", op_p->action_msg);
>                         console_loglevel = orig_log_level;
> -                       op_p->handler(key, tty);
> +                       if (op_p->handler_with_mask)
> +                               op_p->handler_with_mask(check_mask, key,
> tty);
> +                       else
> +                               op_p->handler(key, tty);
>                 } else {
>                         printk("This sysrq operation is disabled.\n");
>                 }
> --- linux-2.6.git/include/linux/sysrq.h.orig    2009-08-13
> 20:53:48.085786000 -0700
> +++ linux-2.6.git/include/linux/sysrq.h 2009-08-13 20:54:12.625756000 -0700
> @@ -32,6 +32,7 @@ struct tty_struct;
> 
>  struct sysrq_key_op {
>         void (*handler)(int, struct tty_struct *);
> +       void (*handler_with_mask)(int, int, struct tty_struct *);
>         char *help_msg;
>         char *action_msg;
>         int enable_mask;
> 

I'd rather have this go through -mm, this doesn't really fully qualify for 
trivial tree. CCing Andrew.

-- 
Jiri Kosina
SUSE Labs
