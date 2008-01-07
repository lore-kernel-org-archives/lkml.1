Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbYAHNAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbYAHNAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 08:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbYAHNA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 08:00:26 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4467 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750724AbYAHNAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 08:00:25 -0500
Date: Mon, 7 Jan 2008 15:03:49 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Ingo Oeser <ioe-lkml@rameria.de>, Bernd Schubert <bernd-schubert@gmx.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: sleep before boot panic
Message-ID: <20080107150349.GA6523@ucw.cz>
References: <9II6K-1Pg-9@gated-at.bofh.it> <9IJ2M-3l2-3@gated-at.bofh.it> <9IJme-3Nb-13@gated-at.bofh.it> <9IKrY-5vk-15@gated-at.bofh.it> <E1JBqS9-0003Xp-Sh@be1.7eggert.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JBqS9-0003Xp-Sh@be1.7eggert.dyndns.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Introduce config CONFIG_SOFTPANIC
> Enabling this option changes a hard panic on boot errors to a
> soft panic, which does not stop the system completely.
> You can still scroll the screen and read the messages.
> 
> Signed-Off-By: Bodo Eggert <7eggert@gmx.de>

Looks good to me... but should this be configurable? IMO we should
just do the right thing.
							Pavel

> diff -pruN linux-2.6.23.base/include/linux/kernel.h
> linux-2.6.23.softpanic/include/linux/kernel.h
> --- linux-2.6.23.base/include/linux/kernel.h    2007-10-11 14:15:39.000000000 +0200
> +++ linux-2.6.23.softpanic/include/linux/kernel.h       2007-10-11 14:45:15.000000000
> +0200
> @@ -108,6 +108,12 @@ extern struct atomic_notifier_head panic
>  extern long (*panic_blink)(long time);
>  NORET_TYPE void panic(const char * fmt, ...)
>         __attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
> +#ifdef SOFTPANIC
> +NORET_TYPE void softpanic(const char * fmt, ...)
> +       __attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
> +#else
> +# define softpanic(...) do { panic(__VA_ARGS__); } while (0)
> +#endif
>  extern void oops_enter(void);
>  extern void oops_exit(void);
>  extern int oops_may_print(void);
> diff -pruN linux-2.6.23.base/init/Kconfig linux-2.6.23.softpanic/init/Kconfig
> --- linux-2.6.23.base/init/Kconfig      2007-10-11 14:15:42.000000000 +0200
> +++ linux-2.6.23.softpanic/init/Kconfig 2007-10-11 15:19:07.000000000 +0200
> @@ -441,6 +441,14 @@ config BUG
>            option for embedded systems with no facilities for reporting errors.
>            Just say Y.
>  
> +config SOFTPANIC
> +       bool "Enable softpanic for boot errors" if EMBEDDED
> +       default y
> +       help
> +               Enabling this option changes a hard panic on boot errors to a
> +               soft panic, which does not stop the system completely.
> +               You can still scroll the screen and read the messages.
> +
>  config ELF_CORE
>         default y
>         bool "Enable ELF core dumps" if EMBEDDED
> diff -pruN linux-2.6.23.base/init/do_mounts.c
> linux-2.6.23.softpanic/init/do_mounts.c
> --- linux-2.6.23.base/init/do_mounts.c  2007-10-11 14:15:42.000000000 +0200
> +++ linux-2.6.23.softpanic/init/do_mounts.c     2007-10-11 14:48:51.000000000 +0200
> @@ -330,7 +330,7 @@ retry:
>                 printk("Please append a correct \"root=\" boot option; here are the available
> partitions:\n");
>  
>                 printk_all_partitions();
> -               panic("VFS: Unable to mount root fs on %s", b);
> +               softpanic("VFS: Unable to mount root fs on %s", b);
>         }
>  
>         printk("List of all partitions:\n");
> @@ -342,7 +342,7 @@ retry:
>  #ifdef CONFIG_BLOCK
>         __bdevname(ROOT_DEV, b);
>  #endif
> -       panic("VFS: Unable to mount root fs on %s", b);
> +       softpanic("VFS: Unable to mount root fs on %s", b);
>  out:
>         putname(fs_names);
>  }
> diff -pruN linux-2.6.23.base/init/main.c linux-2.6.23.softpanic/init/main.c
> --- linux-2.6.23.base/init/main.c       2007-10-11 14:15:42.000000000 +0200
> +++ linux-2.6.23.softpanic/init/main.c  2007-10-11 14:40:06.000000000 +0200
> @@ -590,7 +590,7 @@ asmlinkage void __init start_kernel(void
>          */
>         console_init();
>         if (panic_later)
> -               panic(panic_later, panic_param);
> +               softpanic(panic_later, panic_param);
>  
>         lockdep_info();
>  
> @@ -807,7 +807,7 @@ static int noinline init_post(void)
>         run_init_process("/bin/init");
>         run_init_process("/bin/sh");
>  
> -       panic("No init found.  Try passing init= option to kernel.");
> +       softpanic("No init found.  Try passing init= option to kernel.");
>  }
>  
>  static int __init kernel_init(void * unused)
> diff -pruN linux-2.6.23.base/kernel/panic.c
> linux-2.6.23.softpanic/kernel/panic.c
> --- linux-2.6.23.base/kernel/panic.c    2007-10-11 14:15:42.000000000 +0200
> +++ linux-2.6.23.softpanic/kernel/panic.c       2007-10-11 14:53:42.000000000 +0200
> @@ -139,7 +139,66 @@ NORET_TYPE void panic(const char * fmt, 
>         }
>  }
>  
> +#ifdef SOFTPANIC
> +NORET_TYPE void softpanic(const char * fmt, ...)
> +{
> +       long i;
> +       static char buf[1024];
> +       va_list args;
> +#if defined(CONFIG_S390)
> +        unsigned long caller = (unsigned long) __builtin_return_address(0);
> +#endif
> +
> +       va_start(args, fmt);
> +       vsnprintf(buf, sizeof(buf), fmt, args);
> +       va_end(args);
> +       printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
> +
> +       atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
> +
> +       if (!panic_blink)
> +               panic_blink = no_blink;
> +
> +       if (panic_timeout > 0) {
> +               /*
> +                * Delay timeout seconds before rebooting the machine. 
> +                * We can't use the "normal" timers since we just panicked..
> +                */
> +               printk(KERN_EMERG "Rebooting in %d seconds..",panic_timeout);
> +               for (i = 0; i < panic_timeout*1000; ) {
> +                       touch_nmi_watchdog();
> +                       i += panic_blink(i);
> +                       mdelay(1);
> +                       i++;
> +               }
> +               /*      This will not be a clean reboot, with everything
> +                *      shutting down.  But if there is a chance of
> +                *      rebooting the system it will be rebooted.
> +                */
> +               kernel_restart(NULL);
> +       }
> +#ifdef __sparc__
> +       {
> +               extern int stop_a_enabled;
> +               /* Make sure the user can actually press Stop-A (L1-A) */
> +               stop_a_enabled = 1;
> +               printk(KERN_EMERG "Press Stop-A (L1-A) to return to the boot prom\n");
> +       }
> +#endif
> +#if defined(CONFIG_S390)
> +        disabled_wait(caller);
> +#endif
> +       for (i = 0;;) {
> +               touch_softlockup_watchdog();
> +               i += panic_blink(i);
> +               msleep(1);
> +               i++;
> +       }
> +}
> +#endif
> +
>  EXPORT_SYMBOL(panic);
> +EXPORT_SYMBOL(softpanic);
>  
>  /**
>   *     print_tainted - return a string to represent the kernel taint state.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
