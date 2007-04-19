Return-Path: <linux-kernel-owner+w=401wt.eu-S1766965AbXDSTeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766965AbXDSTeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 15:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766966AbXDSTeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 15:34:00 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766965AbXDSTd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 15:33:59 -0400
Date: Thu, 19 Apr 2007 12:33:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, holger@eiboeck.de
Subject: Re: RFC: drivers/char/watchdog/pcwd.c +
 drivers/char/watchdog/pcwd_pci.c
Message-Id: <20070419123310.6a7a2193.akpm@linux-foundation.org>
In-Reply-To: <20070419190055.GA31632@infomag.infomag.iguana.be>
References: <20070417185849.GA2632@infomag.infomag.iguana.be>
	<20070417131624.5ae58d63.akpm@linux-foundation.org>
	<20070419190055.GA31632@infomag.infomag.iguana.be>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 21:00:55 +0200
Wim Van Sebroeck <wim@iguana.be> wrote:

> Hi Andrew,
> 
> > > On Tue, 17 Apr 2007 20:58:49 +0200 Wim Van Sebroeck <wim@iguana.be> wrote:
> > > Would anyone object if we would merge the "full bells and whistles" drivers for
> > > the pcwd isa and pci cards in the kernel tree. (It basically only adds some extra
> > > /proc routines). This would make it easier to maintain the "full bells and whistles"
> > > driver.
> > 
> > It's hard to answer that question.  Please send the patches out in the
> > usual manner for review and comment.
> 
> for the pcwd.c driver the patch would be as follows (see below).
> I'll create the patch for pcwd_pci.c later this week.
> 
>  #include <linux/module.h>	/* For module specific items */
> @@ -65,13 +73,18 @@
>  #include <linux/fs.h>		/* For file operations */
>  #include <linux/ioport.h>	/* For io-port access */
>  #include <linux/spinlock.h>	/* For spin_lock/spin_unlock/... */
> +#include <linux/string.h>	/* For string manipulations */
> +#ifdef CONFIG_PROC_FS
> +#include <linux/stat.h>		/* For S_IFREG/S_IRUGO/S_IWUSR */
> +#include <linux/proc_fs.h>	/* For create_proc_entry/remove_proc_entry/ ... */
> +#endif

Please avoid the ifdefs here if at all possible.  They increase the chances
of the build failing as people change configs.

>  /* module parameters */
> +#define CELSIUS		0
> +#define FAHRENHEIT	1
> +static int proc_temp_mode = CELSIUS;
> +module_param(proc_temp_mode, int, 0);
> +MODULE_PARM_DESC(proc_temp_mode, "which temperature mode to use in /proc/ 0=Celsius, 1=Fahrenheit (default=0)");

hm, is that a good idea?  Making the contents of /proc files dependent upon
some module parameter?

I'd have thought that it would be better to remove this option and either

a) offer two /proc files: one for Celcius, one for Fahrenheit

b) Put both values into the same /proc file (one per line)

c) Just remove the Fahrenheit option altogether - let it join cubits,
   furlongs, etc.

I mean, how is an application to make sense of that information if its units
depend upon some module parameter, or a kernel boot option?

> +	pcwd_private.card_status=ENABLED;

Missing a ' ' around the '='.  Several instances.

> -static int pcwd_get_temperature(int *temperature)
> +static int pcwd_get_temperature(int *temperature, int temp_mode)
>  {
>  	/* check that port 0 gives temperature info and no command results */
>  	if (pcwd_private.command_mode)
> @@ -543,22 +577,358 @@
>  	if (!pcwd_private.supports_temp)
>  		return -ENODEV;
>  
> +	spin_lock(&pcwd_private.io_lock);
> +	*temperature = inb(pcwd_private.io_addr);
> +	spin_unlock(&pcwd_private.io_lock);

I doubt if the locking here does anything useful.

> +
>  	/*
> -	 * Convert celsius to fahrenheit, since this was
> +	 * Convert celsius to fahrenheit, this is normally
>  	 * the decided 'standard' for this return value.
>  	 */
> -	spin_lock(&pcwd_private.io_lock);
> -	*temperature = ((inb(pcwd_private.io_addr)) * 9 / 5) + 32;
> -	spin_unlock(&pcwd_private.io_lock);
> +	if (temp_mode == FAHRENHEIT)
> +		*temperature = (*temperature * 9 / 5) + 32;
>  
>  	if (debug >= DEBUG) {
> -		printk(KERN_DEBUG PFX "temperature is: %d F\n",
> -			*temperature);
> +		printk(KERN_DEBUG PFX "temperature is: %d %s\n",
> +			*temperature, (temp_mode == CELSIUS) ? "C" :"F");
>  	}
>  
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PROC_FS
> +static int
> +pcwd_reset_pc(void)

	static int pcwd_reset_pc(void)

please.


> +static int
> +pcwd_set_timeout(char *sub_command)

Ditto (whole patchset (perhaps whole subsystem ;)))

> +{
> +	char *new_sub_command = sub_command;
> +	int i;
> +
> +	while (*sub_command == ' ')
> +		sub_command++;
> +	if (sub_command == new_sub_command) {
> +		printk(KERN_ERR PFX "illegal timeout argument '%s'\n", sub_command);
> +		return 1;
> +	}
> +	i = simple_strtoul(sub_command, NULL, 0);

darn, we do this sort of gunk in a lot of places.  Isn't there some library
function somewhere we can use?

> +	if (!pcwd_set_heartbeat(i)) {
> +		if (debug >= VERBOSE)
> +			printk(KERN_INFO PFX "timeout %d\n", heartbeat);
> +	} else {
> +		printk(KERN_ERR PFX
> +			"illegal timeout argument '%s', should be a number between 2 and 7200\n",


80 columns?

> +			sub_command);
> +		return 1;
> +	}
> +	return 0;
> +}
> +
>
> ..
>
> +static void
> +pcwd_user_help(void)
> +{
> +	printk(" pcwd proc command interface help:\n");
> +	printk("   ping, pong, tickle - tickle the timer\n");
> +	printk("   hardreset - reset pc\n");
> +	printk("   enable, start - start the watchdog\n");
> +	printk("   disable, stop - stop the watchdog\n");
> +	printk("   clear - clear trip status and led\n");
> +	printk("   verbose, debug, quiet - command reponse\n");
> +	printk("   fahrenheit, celsius - display temp in\n");
> +	printk(" extended commands:\n");
> +	printk("   arm [val] - isa [30,60,90]\n");
> +	printk("   timeout [val]\n");
> +}

This could all be done with a single printk() statement.

It's missing a KERN_FOO facility level.

> +static int
> +pcwd_user_command(char *user_command)
> +{
> +	if ((strcmp(user_command, "ping") == 0)
> +	    || (strcmp(user_command, "pong") == 0)
> +	    || (strcmp(user_command, "tickle") == 0)) {
> +		pcwd_keepalive();
> +		if (debug >= VERBOSE)
> +			printk(KERN_INFO PFX "ping...\n");
> +	} else if ((strcmp(user_command, "enable") == 0)
> +	    || (strcmp(user_command, "start") == 0)) {
> +		if (!pcwd_start()) {
> +			if (debug >= VERBOSE)
> +				printk(KERN_INFO PFX "watchdog enabled.\n");
> +		}
> +	} else if ((strcmp(user_command, "disable") == 0)
> +	    || (strcmp(user_command, "stop") == 0)) {
> +		if (!pcwd_stop()) {
> +			if (debug >= VERBOSE)
> +				printk(KERN_INFO PFX "watchdog disabled!\n");
> +		}
> +	} else if (strcmp(user_command, "clear") == 0) {
> +		pcwd_clear_status();
> +		if (debug >= VERBOSE)
> +			printk(KERN_INFO PFX "cleared trip status\n");
> +	} else if (strcmp(user_command, "hardreset") == 0) {
> +		pcwd_reset_pc();
> +		if (debug >= VERBOSE)
> +			printk(KERN_INFO PFX "hardreset PC!\n");
> +	} else if (strcmp(user_command, "quiet") == 0) {
> +		debug = QUIET;
> +	} else if (strcmp(user_command, "verbose") == 0) {
> +		debug = VERBOSE;
> +		printk(KERN_INFO PFX "verbose mode on.\n");
> +	} else if (strcmp(user_command, "debug") == 0) {
> +		debug = DEBUG;
> +		printk(KERN_INFO PFX "debug mode on.\n");
> +	} else if (strcmp(user_command, "celsius") == 0) {
> +		proc_temp_mode = CELSIUS;
> +		if (debug >= VERBOSE)
> +			printk(KERN_INFO PFX "display temp in Celsius.\n");
> +	} else if (strcmp(user_command, "fahrenheit") == 0) {
> +		proc_temp_mode = FAHRENHEIT;
> +		if (debug >= VERBOSE)
> +			printk(KERN_INFO PFX "display temp in Fahrenheit.\n");
> +	} else if (strcmp(user_command, "help") == 0) {
> +		pcwd_user_help();
> +	} else if (strncmp(user_command, "arm", 3) == 0) {
> +		if ((pcwd_private.fw_ver_str[0] >= '1')
> +		    && (pcwd_private.fw_ver_str[2] >= '2')) {
> +			if (pcwd_set_arm(&user_command[3])) {
> +				printk(KERN_ERR PFX "arm FAILED.\n");
> +				return 0;
> +			}
> +		} else {
> +			printk(KERN_ERR
> +			       "pcwd: ISA Card and firmware > 1.20 needed.\n");
> +			return 0;
> +		}
> +	} else if (strncmp(user_command, "timeout", 7) == 0) {
> +		if (pcwd_set_timeout(&user_command[7])) {
> +			printk(KERN_ERR PFX "timeout FAILED.\n");
> +			return 0;
> +		}
> +	} else {
> +		printk(KERN_ERR "illegal user command: '%s'\n", user_command);
> +		pcwd_user_help();
> +		return 0;
> +	}
> +	return 1;
> +}

parse, parse, parse, parse.  We really do need stronger libraries for this
sort of thing.

> +static int
> +pcwd_write_proc(struct file *file, const char *buffer,
> +		unsigned long count, void *data)
> +{
> +	char command_buffer[80];
> +	int rc, length;
> +
> +	/* write only allowed for root users */
> +	if (current->euid != 0)
> +		return -EACCES;

Are the permissions on the /proc file not sufficient?

Surely it's wrong to be testing for root anyway.  capable(CAP_SYS_ADMIN)
would be more typical.  Or CAP_RAW_IO or something.

But not this.

> +	if (count > sizeof (command_buffer) - 1)
> +		return -EINVAL;
> +
> +	if (copy_from_user(command_buffer, buffer, count))
> +		return -EFAULT;
> +
> +	command_buffer[count] = '\0';
> +	length = strlen(command_buffer);
> +	if (command_buffer[length - 1] == '\n')
> +		command_buffer[--length] = '\0';
> +
> +	spin_lock(&pcwd_private.proc_lock);
> +	rc = pcwd_user_command(command_buffer);
> +	spin_unlock(&pcwd_private.proc_lock);
> +	return (rc ? count : -EBUSY);
> +}
> +
> +/* This macro frees the machine specific function from bounds checking and
> + *  * this like that... [from nvram.c]*/
> +#define PRINT_PROC(fmt,args...)                         \
> +    do {                                                \
> +        *len += sprintf( buffer+*len, fmt, ##args );    \
> +        if (*begin + *len > offset + size)              \
> +            return( 0 );                                \
> +        if (*begin + *len < offset) {                   \
> +            *begin += *len;                             \
> +            *len = 0;                                   \
> +        }                                               \
> +    } while(0)

A `return' hidden in a macro like this is pretty foul.  We'd prefer that
new instances not be added to the kernel.

Can we please find a tasteful way of reimplementing this?  Cannot the
seq_file interface be used?

> +static int
> +pcwd_proc_info(unsigned char *buf, char *buffer, int *len,
> +	       off_t * begin, off_t offset, int size)
> +{
> +	int sw, i;
> +
> +	PRINT_PROC("%s\n", DRIVER_VERSION);
> +
> +	if (pcwd_private.revision == PCWD_REVISION_C) {
> +		PRINT_PROC("Firmware     : Version %s\n", pcwd_private.fw_ver_str);
> +		PRINT_PROC("Option Switch: Delay Time ");
> +		sw = pcwd_get_option_switches();
> +		switch (sw & 0x07) {
> +		case 0:
> +			PRINT_PROC("20 s");
> +			break;
> +		case 1:
> +			PRINT_PROC("40 s");
> +			break;
> +		case 2:
> +			PRINT_PROC("1 min");
> +			break;
> +		case 3:
> +			PRINT_PROC("5 min");
> +			break;
> +		case 4:
> +			PRINT_PROC("10 min");
> +			break;
> +		case 5:
> +			PRINT_PROC("30 min");
> +			break;
> +		case 6:
> +			PRINT_PROC("1 h");
> +			break;
> +		case 7:
> +			PRINT_PROC("2 h");
> +			break;
> +		}
> +		PRINT_PROC((sw & 0x08) ? ", POD on" : ", POD off");
> +		PRINT_PROC((sw & 0x10) ? ", TRE on" : ", TRE off");
> +		PRINT_PROC((sw & 0x20) ? ", R2M on" : ", R2M off");
> +		PRINT_PROC((sw & 0x40) ? ", R1M on" : ", R1M off");
> +		PRINT_PROC((sw & 0x80) ? ", RTM on\n" : ", RTM off\n");
> +	} else {
> +		PRINT_PROC("Firmware ROM not present\n");
> +	}
> +
> +	PRINT_PROC("Temperature  : ");
> +	if (pcwd_private.supports_temp && (!pcwd_get_temperature(&i, proc_temp_mode))) {
> +		PRINT_PROC("%d ", i);
> +		PRINT_PROC((proc_temp_mode == CELSIUS) ? "__C\n" : "__F\n");
> +	} else {
> +		PRINT_PROC("Card without temp option\n");
> +	}
> +
> +	if (pcwd_private.card_status == ENABLED)
> +		PRINT_PROC("Card status  : Timer enabled\n");
> +	else
> +		PRINT_PROC("Card status  : Timer disabled\n");
> +
> +	spin_lock(&pcwd_private.io_lock);
> +	if (pcwd_private.revision == PCWD_REVISION_A) {
> +		sw = inb_p(pcwd_private.io_addr) & WD_WDRST;
> +	} else {
> +		sw = inb_p(pcwd_private.io_addr + 1) & WD_REVC_WTRP;
> +	}
> +	spin_unlock(&pcwd_private.io_lock);
> +	PRINT_PROC("Reboot status: ");
> +	PRINT_PROC(sw ? "Tripped\n" : "Not tripped\n");
> +
> +	if ((pcwd_private.boot_status & WDIOF_CARDRESET) && (pcwd_private.boot_status & WDIOF_OVERHEAT)) {
> +		PRINT_PROC("Boot status  : CPU Overheat  + Watchdog caused reboot\n");
> +	} else if (pcwd_private.boot_status & WDIOF_CARDRESET) {
> +		PRINT_PROC("Boot status  : Watchdog caused reboot\n");
> +	} else if (pcwd_private.boot_status & WDIOF_OVERHEAT) {
> +		PRINT_PROC("Boot status  : CPU Overheat\n");
> +	} else {
> +		PRINT_PROC("Boot status  : Cold boot or reset\n");
> +	}

Lots of braces can (shold) be removed in here.

> +	// PRINT_PROC("Ping Count   : %d\n", ping_counter);
> +	return 1;
> +}
> +
> +static int
> +pcwd_read_proc(char *buffer, char **start, off_t offset,
> +	       int size, int *eof, void *data)
> +{
> +	int len = 0;
> +	off_t begin = 0;
> +
> +	spin_lock(&pcwd_private.proc_lock);
> +	*eof = pcwd_proc_info(NULL, buffer, &len, &begin, offset, size);
> +	spin_unlock(&pcwd_private.proc_lock);
> +
> +	if (offset >= begin + len)
> +		return (0);
> +	*start = buffer + (offset - begin);	// CORRECTED !!!!
> +	return (size < begin + len - offset ? size : begin + len - offset);
> +}
> +#endif				/* PROC_FS */
> +
>  
> ...
>
> +#ifdef CONFIG_PROC_FS
> +	if ((pcwd_private.proc_pcwd =
> +	     create_proc_entry(WATCHDOG_NAME, S_IFREG | S_IRUGO | S_IWUSR, 0))) {
> +		pcwd_private.proc_pcwd->read_proc = pcwd_read_proc;
> +		pcwd_private.proc_pcwd->write_proc = pcwd_write_proc;
> +	}
> +#endif

We prefer

	a = b();
	if (a)

over

	if ((a = b())



