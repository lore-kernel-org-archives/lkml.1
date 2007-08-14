Return-Path: <linux-kernel-owner+w=401wt.eu-S933226AbXHNSOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226AbXHNSOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbXHNSNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:13:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43387 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbXHNSNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:13:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: + serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option.patch added to -mm tree
Date: Tue, 14 Aug 2007 20:23:23 +0200
User-Agent: KMail/1.9.5
Cc: Andres Salomon <dilinger@queued.net>, akpm@linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>
References: <200708092026.l79KQlDX017864@imap1.linux-foundation.org> <20070813142331.9b0774ae.dilinger@queued.net> <20070814103939.GJ2900@elf.ucw.cz>
In-Reply-To: <20070814103939.GJ2900@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708142023.23994.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 14 August 2007 12:39, Pavel Machek wrote:
> Hi!
> 
> > Thanks, updated below!
> > 
> > 
> > 
> > serial: turn serial console suspend a boot rather than compile time option
> > 
> > From: Andres Salomon <dilinger@debian.org>
> > 
> > Currently, there's a CONFIG_DISABLE_CONSOLE_SUSPEND that allows one to stop
> > the serial console from being suspended when the rest of the machine goes
> > to sleep.  This is incredibly useful for debugging power
> > management-related
> 
> Actually, this should not be configurable. We should simply enable
> console during suspend for consoles that can handle this,
> automatically.... this patch does just that. I hope I separated it
> correctly.
> 
> It may be that something else than netconsole is broken during
> suspend... but it should not be, we were running without suspending
> consoles for quite long; we can always fix it when we hit the bug.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 

Well, my box used to hang on suspend when the framebuffer console was enabled.

It doesn't do that any more, though, so it may be safe.

I think we can do this, but I expect some bug reports to show up as a result.

Greetings,
Rafael


> diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
> index 69233f6..7f7c2ce 100644
> --- a/drivers/net/netconsole.c
> +++ b/drivers/net/netconsole.c
> @@ -115,6 +115,7 @@ static int init_netconsole(void)
>  	if (err)
>  		return err;
>  
> +	disable_console_on_suspend++;
>  	register_console(&netconsole);
>  	printk(KERN_INFO "netconsole: network logging started\n");
>  	return 0;
> @@ -123,6 +124,7 @@ static int init_netconsole(void)
>  static void cleanup_netconsole(void)
>  {
>  	unregister_console(&netconsole);
> +	disable_console_on_suspend--;
>  	netpoll_cleanup(&np);
>  }
>  
> diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
> index 030a606..426c3d6 100644
> --- a/drivers/serial/serial_core.c
> +++ b/drivers/serial/serial_core.c
> @@ -1941,12 +1941,10 @@ int uart_suspend_port(struct uart_driver
>  
>  	mutex_lock(&state->mutex);
>  
> -#ifdef CONFIG_DISABLE_CONSOLE_SUSPEND
>  	if (uart_console(port)) {
>  		mutex_unlock(&state->mutex);
>  		return 0;
>  	}
> -#endif
>  
>  	if (state->info && state->info->flags & UIF_INITIALIZED) {
>  		const struct uart_ops *ops = port->ops;
> @@ -1989,12 +1987,10 @@ int uart_resume_port(struct uart_driver 
>  
>  	mutex_lock(&state->mutex);
>  
> -#ifdef CONFIG_DISABLE_CONSOLE_SUSPEND
>  	if (uart_console(port)) {
>  		mutex_unlock(&state->mutex);
>  		return 0;
>  	}
> -#endif
>  
>  	uart_change_pm(state, 0);
>  
> diff --git a/include/linux/console.h b/include/linux/console.h
> index 56a7bcd..2e2b9bc 100644
> --- a/include/linux/console.h
> +++ b/include/linux/console.h
> @@ -121,14 +121,11 @@ extern void console_stop(struct console 
>  extern void console_start(struct console *);
>  extern int is_console_locked(void);
>  
> -#ifndef CONFIG_DISABLE_CONSOLE_SUSPEND
> +extern int disable_console_on_suspend;
> +
>  /* Suspend and resume console messages over PM events */
>  extern void suspend_console(void);
>  extern void resume_console(void);
> -#else
> -static inline void suspend_console(void) {}
> -static inline void resume_console(void) {}
> -#endif /* CONFIG_DISABLE_CONSOLE_SUSPEND */
>  
>  int mda_console_init(void);
>  void prom_con_init(void);
> diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> index 412859f..a68e841 100644
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -44,17 +44,6 @@ config PM_VERBOSE
>  	---help---
>  	This option enables verbose messages from the Power Management code.
>  
> -config DISABLE_CONSOLE_SUSPEND
> -	bool "Keep console(s) enabled during suspend/resume (DANGEROUS)"
> -	depends on PM_DEBUG && PM_SLEEP
> -	default n
> -	---help---
> -	This option turns off the console suspend mechanism that prevents
> -	debug messages from reaching the console during the suspend/resume
> -	operations.  This may be helpful when debugging device drivers'
> -	suspend/resume routines, but may itself lead to problems, for example
> -	if netconsole is used.
> -
>  config PM_TRACE
>  	bool "Suspend/resume event tracing"
>  	depends on PM_DEBUG && X86 && PM_SLEEP && EXPERIMENTAL
> diff --git a/kernel/printk.c b/kernel/printk.c
> index bd2cd06..5a2d6c0 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -751,7 +751,9 @@ int update_console_cmdline(char *name, i
>  	return -1;
>  }
>  
> -#ifndef CONFIG_DISABLE_CONSOLE_SUSPEND
> +
> +int disable_console_on_suspend;
> +
>  /**
>   * suspend_console - suspend the console subsystem
>   *
> @@ -759,17 +761,22 @@ #ifndef CONFIG_DISABLE_CONSOLE_SUSPEND
>   */
>  void suspend_console(void)
>  {
> -	printk("Suspending console(s)\n");
> -	acquire_console_sem();
> -	console_suspended = 1;
> +	if (disable_console_on_suspend) {
> +		printk("Suspending console(s)\n");
> +		acquire_console_sem();
> +		console_suspended = 1;
> +	}
>  }
>  
>  void resume_console(void)
>  {
> -	console_suspended = 0;
> -	release_console_sem();
> +	if (console_suspended) {
> +		BUG_ON(!disable_console_on_suspend);
> +		console_suspended = 0;
> +		release_console_sem();
> +	}
>  }
> -#endif /* CONFIG_DISABLE_CONSOLE_SUSPEND */
> +
>  
>  /**
>   * acquire_console_sem - lock the console system for exclusive use.
> 

-- 
"Premature optimization is the root of all evil." - Donald Knuth
