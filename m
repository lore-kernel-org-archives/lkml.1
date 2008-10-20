Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbYJTMOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbYJTMOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 08:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYJTMOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 08:14:25 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59319 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751916AbYJTMOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 08:14:24 -0400
Date: Mon, 20 Oct 2008 14:14:12 +0200
From: Pavel Machek <pavel@suse.cz>
To: Bodo Eggert <7eggert@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] softpanic - halt booting, but allow reading why
Message-ID: <20081020121412.GA10214@ucw.cz>
References: <alpine.LSU.0.999.0810161353100.5381@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.0.999.0810161353100.5381@be1.lrz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-10-16 13:58:12, Bodo Eggert wrote:
> While booting, certain panic()s have the purpose of just stopping the
> machnine. This has the unfortunate side effect of preventing the user
> from scrolling and looking at the cause.
> 
> This patch adds a softpanic() function, which behaves similar to panic()
> in stopping the boot and possibly rebooting after a timeout, but it
> does allow background activity.
> 
> Signed-off-by: Bodo Eggert <7eggert@gmx.de>

ACK. Can you send it to akpm so that it gets queued?
								Pavel


> ---
> 
> I thought about merging both functions, but I don't think it would work out.
> 
> diff -pruNXdontdiff linux-2.6.27/include/linux/kernel.h linux-2.6.27.softpanic/include/linux/kernel.h
> --- linux-2.6.27/include/linux/kernel.h	2008-10-10 13:18:43.000000000 +0200
> +++ linux-2.6.27.softpanic/include/linux/kernel.h	2008-10-10 19:23:43.000000000 +0200
> @@ -144,6 +144,12 @@ extern struct atomic_notifier_head panic
>  extern long (*panic_blink)(long time);
>  NORET_TYPE void panic(const char * fmt, ...)
>  	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
> +#ifdef CONFIG_SOFTPANIC
> +NORET_TYPE void softpanic(const char * fmt, ...)
> +	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
> +#else
> +# define softpanic(...) do { panic(__VA_ARGS__); } while (0)
> +#endif
>  extern void oops_enter(void);
>  extern void oops_exit(void);
>  extern int oops_may_print(void);
> diff -pruNXdontdiff linux-2.6.27/init/Kconfig linux-2.6.27.softpanic/init/Kconfig
> --- linux-2.6.27/init/Kconfig	2008-10-10 13:18:44.000000000 +0200
> +++ linux-2.6.27.softpanic/init/Kconfig	2008-10-10 18:32:03.000000000 +0200
> @@ -618,6 +618,14 @@ config BUG
>            option for embedded systems with no facilities for reporting errors.
>            Just say Y.
>  
> +config SOFTPANIC
> +	bool "Enable softpanic for boot errors" if EMBEDDED
> +	default y
> +	help
> +		Enabling this option changes a hard panic on boot errors to a
> +		soft panic, which does not stop the system completely.
> +		You can still scroll the screen and read the messages.
> +
>  config ELF_CORE
>  	default y
>  	bool "Enable ELF core dumps" if EMBEDDED
> diff -pruNXdontdiff linux-2.6.27/init/do_mounts.c linux-2.6.27.softpanic/init/do_mounts.c
> --- linux-2.6.27/init/do_mounts.c	2008-10-10 13:18:44.000000000 +0200
> +++ linux-2.6.27.softpanic/init/do_mounts.c	2008-10-10 18:32:03.000000000 +0200
> @@ -263,7 +263,7 @@ retry:
>  		printk("Please append a correct \"root=\" boot option; here are the available partitions:\n");
>  
>  		printk_all_partitions();
> -		panic("VFS: Unable to mount root fs on %s", b);
> +		softpanic("VFS: Unable to mount root fs on %s", b);
>  	}
>  
>  	printk("List of all partitions:\n");
> @@ -275,7 +275,7 @@ retry:
>  #ifdef CONFIG_BLOCK
>  	__bdevname(ROOT_DEV, b);
>  #endif
> -	panic("VFS: Unable to mount root fs on %s", b);
> +	softpanic("VFS: Unable to mount root fs on %s", b);
>  out:
>  	putname(fs_names);
>  }
> diff -pruNXdontdiff linux-2.6.27/init/main.c linux-2.6.27.softpanic/init/main.c
> --- linux-2.6.27/init/main.c	2008-10-10 13:18:44.000000000 +0200
> +++ linux-2.6.27.softpanic/init/main.c	2008-10-10 18:32:03.000000000 +0200
> @@ -621,7 +621,7 @@ asmlinkage void __init start_kernel(void
>  	 */
>  	console_init();
>  	if (panic_later)
> -		panic(panic_later, panic_param);
> +		softpanic(panic_later, panic_param);
>  
>  	lockdep_info();
>  
> @@ -830,7 +830,7 @@ static int noinline init_post(void)
>  	run_init_process("/bin/init");
>  	run_init_process("/bin/sh");
>  
> -	panic("No init found.  Try passing init= option to kernel.");
> +	softpanic("No init found.  Try passing init= option to kernel.");
>  }
>  
>  static int __init kernel_init(void * unused)
> diff -pruNXdontdiff linux-2.6.27/kernel/panic.c linux-2.6.27.softpanic/kernel/panic.c
> --- linux-2.6.27/kernel/panic.c	2008-10-10 13:18:45.000000000 +0200
> +++ linux-2.6.27.softpanic/kernel/panic.c	2008-10-10 20:13:37.000000000 +0200
> @@ -140,9 +140,68 @@ NORET_TYPE void panic(const char * fmt, 
>  		i++;
>  	}
>  }
> -
>  EXPORT_SYMBOL(panic);
>  
> +#ifdef CONFIG_SOFTPANIC
> +NORET_TYPE void softpanic(const char * fmt, ...)
> +{
> +	long i;
> +	static char buf[1024];
> +	va_list args;
> +#if defined(CONFIG_S390)
> +        unsigned long caller = (unsigned long) __builtin_return_address(0);
> +#endif
> +
> +	va_start(args, fmt);
> +	vsnprintf(buf, sizeof(buf), fmt, args);
> +	va_end(args);
> +	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
> +
> +	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
> +
> +	if (!panic_blink)
> +		panic_blink = no_blink;
> +
> +	if (panic_timeout > 0) {
> +		/*
> +	 	 * Delay timeout seconds before rebooting the machine. 
> +		 * We can't use the "normal" timers since we just panicked..
> +	 	 */
> +		printk(KERN_EMERG "Rebooting in %d seconds..",panic_timeout);
> +		for (i = 0; i < panic_timeout*1000; ) {
> +			touch_nmi_watchdog();
> +			i += panic_blink(i);
> +			mdelay(1);
> +			i++;
> +		}
> +		/*	This will not be a clean reboot, with everything
> +		 *	shutting down.  But if there is a chance of
> +		 *	rebooting the system it will be rebooted.
> +		 */
> +		kernel_restart(NULL);
> +	}
> +#ifdef __sparc__
> +	{
> +		extern int stop_a_enabled;
> +		/* Make sure the user can actually press Stop-A (L1-A) */
> +		stop_a_enabled = 1;
> +		printk(KERN_EMERG "Press Stop-A (L1-A) to return to the boot prom\n");
> +	}
> +#endif
> +#if defined(CONFIG_S390)
> +        disabled_wait(caller);
> +#endif
> +	for (i = 0;;) {
> +		touch_softlockup_watchdog();
> +		i += panic_blink(i);
> +		msleep(1);
> +		i++;
> +	}
> +}
> +EXPORT_SYMBOL(softpanic);
> +#endif
> +
> +
>  /**
>   *	print_tainted - return a string to represent the kernel taint state.
>   *
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
