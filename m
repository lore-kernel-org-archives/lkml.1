Return-Path: <linux-kernel-owner+w=401wt.eu-S1763627AbXF1P3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763627AbXF1P3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756745AbXF1P3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:29:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55306 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756832AbXF1P3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:29:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC] get rid of CONFIG_DISABLE_CONSOLE_SUSPEND
Date: Thu, 28 Jun 2007 17:34:54 +0200
User-Agent: KMail/1.9.5
Cc: seife@suse.de, nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       suspend-devel@lists.sourceforge.net
References: <20070628135108.GA1810@elf.ucw.cz>
In-Reply-To: <20070628135108.GA1810@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706281734.54642.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday, 28 June 2007 15:51, Pavel Machek wrote:
> Hi!
> 
> What about this? (Only compile tested, but looks pretty obvious to
> me). Something like this should get us rid of ugly option, and still
> solve debugging problems... Hmmm?
> 								Pavel
> 
> Kill CONFIG_DISABLE_CONSOLE_SUSPEND; it should not be configurable at
> all, instead, we should automatically keep console alive when
> possible.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> diff --git a/drivers/char/lp.c b/drivers/char/lp.c
> index 62051f8..8267ff8 100644
> --- a/drivers/char/lp.c
> +++ b/drivers/char/lp.c
> @@ -144,7 +144,7 @@ static unsigned int lp_count = 0;
>  static struct class *lp_class;
>  
>  #ifdef CONFIG_LP_CONSOLE
> -static struct parport *console_registered; // initially NULL
> +static struct parport *console_registered;
>  #endif /* CONFIG_LP_CONSOLE */

Could you please avoid fixing things like this, white space etc. in this patch?
It would be easier to read ...

>  #undef LP_DEBUG
> @@ -749,8 +749,8 @@ #endif /* console on line printer */
>  /* --- initialisation code ------------------------------------- */
>  
>  static int parport_nr[LP_NO] = { [0 ... LP_NO-1] = LP_PARPORT_UNSPEC };
> -static char *parport[LP_NO] = { NULL,  };
> -static int reset = 0;
> +static char *parport[LP_NO];
> +static int reset;
>  
>  module_param_array(parport, charp, NULL, 0);
>  module_param(reset, bool, 0);
> @@ -758,10 +758,10 @@ module_param(reset, bool, 0);
>  #ifndef MODULE
>  static int __init lp_setup (char *str)
>  {
> -	static int parport_ptr; // initially zero
> +	static int parport_ptr;
>  	int x;
>  
> -	if (get_option (&str, &x)) {
> +	if (get_option(&str, &x)) {
>  		if (x == 0) {
>  			/* disable driver on "lp=" or "lp=0" */
>  			parport_nr[0] = LP_PARPORT_OFF;
> @@ -808,7 +808,7 @@ static int lp_register(int nr, struct pa
>  #ifdef CONFIG_LP_CONSOLE
>  	if (!nr) {
>  		if (port->modes & PARPORT_MODE_SAFEININT) {
> -			register_console (&lpcons);
> +			register_console(&lpcons);
>  			console_registered = port;
>  			printk (KERN_INFO "lp%d: console ready\n", CONSOLE_LP);
>  		} else
> @@ -824,8 +824,7 @@ static void lp_attach (struct parport *p
>  {
>  	unsigned int i;
>  
> -	switch (parport_nr[0])
> -	{
> +	switch (parport_nr[0]) {
>  	case LP_PARPORT_UNSPEC:
>  	case LP_PARPORT_AUTO:
>  		if (parport_nr[0] == LP_PARPORT_AUTO &&
> @@ -856,7 +855,7 @@ static void lp_detach (struct parport *p
>  	/* Write this some day. */
>  #ifdef CONFIG_LP_CONSOLE
>  	if (console_registered == port) {
> -		unregister_console (&lpcons);
> +		unregister_console(&lpcons);
>  		console_registered = NULL;
>  	}
>  #endif /* CONFIG_LP_CONSOLE */
> diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
> index 69233f6..7f7c2ce 100644
> --- a/drivers/net/netconsole.c
> +++ b/drivers/net/netconsole.c
> @@ -75,7 +75,7 @@ static void write_msg(struct console *co
>  
>  	local_irq_save(flags);
>  
> -	for(left = len; left; ) {
> +	for (left = len; left; ) {
>  		frag = min(left, MAX_PRINT_CHUNK);
>  		netpoll_send_udp(&np, msg, frag);
>  		msg += frag;
> @@ -103,10 +103,10 @@ static int init_netconsole(void)
>  {
>  	int err;
>  
> -	if(strlen(config))
> +	if (strlen(config))
>  		option_setup(config);
>  
> -	if(!configured) {
> +	if (!configured) {
>  		printk("netconsole: not configured, aborting\n");
>  		return 0;
>  	}
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
> index 326020f..b2331a5 100644
> --- a/drivers/serial/serial_core.c
> +++ b/drivers/serial/serial_core.c
> @@ -1934,12 +1934,10 @@ int uart_suspend_port(struct uart_driver
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
> @@ -1982,12 +1980,10 @@ int uart_resume_port(struct uart_driver 
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
> index 62ef6e1..3cb477e 100644
> --- a/include/linux/console.h
> +++ b/include/linux/console.h
> @@ -120,14 +120,11 @@ extern void console_stop(struct console 
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
> index 7564c38..59f103b 100644
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -37,17 +37,6 @@ config PM_DEBUG
>  	code. This is helpful when debugging and reporting various PM bugs, 
>  	like suspend support.
>  
> -config DISABLE_CONSOLE_SUSPEND
> -	bool "Keep console(s) enabled during suspend/resume (DANGEROUS)"
> -	depends on PM && PM_DEBUG
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
>  	depends on PM && PM_DEBUG && X86_32 && EXPERIMENTAL
> @@ -57,8 +46,8 @@ config PM_TRACE
>  	RTC across reboots, so that you can debug a machine that just hangs
>  	during suspend (or more commonly, during resume).
>  
> -	To use this debugging feature you should attempt to suspend the machine,
> -	then reboot it, then run
> +	To use this debugging feature you should attempt to suspend the
> +	machine, then reboot it, then run
>  
>  		dmesg -s 1000000 | grep 'hash matches'
>  
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 0bbdeac..c057023 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -726,7 +726,8 @@ int __init add_preferred_console(char *n
>  	return 0;
>  }
>  
> -#ifndef CONFIG_DISABLE_CONSOLE_SUSPEND
> +int disable_console_on_suspend;
> +
>  /**
>   * suspend_console - suspend the console subsystem
>   *
> @@ -734,17 +735,22 @@ #ifndef CONFIG_DISABLE_CONSOLE_SUSPEND
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

Isn't that a bit extreme?

> +		console_suspended = 0;
> +		release_console_sem();
> +	}
>  }
> -#endif /* CONFIG_DISABLE_CONSOLE_SUSPEND */
> +
>  
>  /**
>   * acquire_console_sem - lock the console system for exclusive use.

I generally agree with the idea, but the patch needs a clean up, IMHO.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
