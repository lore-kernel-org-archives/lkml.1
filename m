Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbYBJUnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbYBJUnL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 15:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbYBJUmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 15:42:24 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:58087 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356AbYBJUmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 15:42:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=UItYiL9SsabSNTXKenW0XzzSiwKEFt6RJNANDYyN7NhhaMzdm97z3Xxv+2DfhJmJ166nQl6dr+PM1WMCk8bstbsBiOe1HeWru5nsM4BPmbEsAiTStA2ArE3ucN5Dv9OmfG5FcKMlKv3FR7raF2HEuRV7dlwI0RlA3EFcBWSPLak=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] kgdb light, v6
Date: Sun, 10 Feb 2008 21:55:46 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
References: <20080210071331.GC3851@elte.hu> <20080210093128.GA11350@infradead.org> <20080210171742.GF7088@elte.hu>
In-Reply-To: <20080210171742.GF7088@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802102155.46505.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


few minor issues (some may have been addressed already)

On Sunday 10 February 2008, Ingo Molnar wrote:

[...]

> diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
> new file mode 100644
> index 0000000..7130273
> --- /dev/null
> +++ b/arch/x86/kernel/kgdb.c

[...]

> +static struct hw_breakpoint {
> +	unsigned		enabled;
> +	unsigned		type;
> +	unsigned		len;
> +	unsigned long		addr;
> +} breakinfo[4] = {
> +	{ .enabled = 0 },
> +	{ .enabled = 0 },
> +	{ .enabled = 0 },
> +	{ .enabled = 0 },
> +};

is this initialization really needed?  the whole thing is static anyway

> +static void kgdb_correct_hw_break(void)
> +{
> +	unsigned long dr7;
> +	int correctit = 0;
> +	int breakbit;
> +	int breakno;
> +
> +	get_debugreg(dr7, 7);
> +	for (breakno = 0; breakno < 4; breakno++) {
> +		breakbit = 2 << (breakno << 1);
> +		if (!(dr7 & breakbit) && breakinfo[breakno].enabled) {
> +			correctit = 1;
> +			dr7 |= breakbit;
> +			dr7 &= ~(0xf0000 << (breakno << 2));
> +			dr7 |= ((breakinfo[breakno].len << 2) |
> +				 breakinfo[breakno].type) <<
> +			       ((breakno << 2) + 16);
> +			switch (breakno) {
> +			case 0:
> +				set_debugreg(breakinfo[0].addr, 0);
> +				break;
> +
> +			case 1:
> +				set_debugreg(breakinfo[1].addr, 1);
> +				break;
> +
> +			case 2:
> +				set_debugreg(breakinfo[2].addr, 2);
> +				break;
> +
> +			case 3:
> +				set_debugreg(breakinfo[3].addr, 3);
> +				break;

			if (breakno >= 0 && breakno <= 3)
				set_debugreg(breakinfo[breakno].addr, breakno);

[...]

> +/**
> + *	kgdb_arch_init - Perform any architecture specific initalization.
> + *
> + *	This function will handle the initalization of any architecture
> + *	specific callbacks.
> + */
> +int kgdb_arch_init(void)
> +{
> +	register_die_notifier(&kgdb_notifier);
> +	return 0;

return register_die_notifier();

[...]

> diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
> new file mode 100644
> index 0000000..a5d2d00
> --- /dev/null
> +++ b/drivers/serial/kgdboc.c

[...]

> +MODULE_DESCRIPTION("KGDB Console TTY Driver");
> +MODULE_LICENSE("GPL");

should be at the bottom of the file

> +static char config[MAX_KGDB_SERIAL_CONSOLE_CONFIG_STR];
> +static struct kparam_string kps = {
> +	.string			= config,
> +	.maxlen			= MAX_KGDB_SERIAL_CONSOLE_CONFIG_STR,
> +};
> +
> +static struct tty_driver	*kgdb_tty_driver;
> +static int			kgdb_tty_line;
> +
> +static int kgdboc_option_setup(char *opt)

__init

> +{
> +	if (strlen(opt) > MAX_KGDB_SERIAL_CONSOLE_CONFIG_STR) {
> +		printk(KERN_ERR "kgdboc: config string too long\n");
> +		return -ENOSPC;
> +	}
> +	strcpy(config, opt);
> +
> +	return 0;
> +}
> +__setup("kgdboc=", kgdboc_option_setup);

no need for obsolete __setup, we have module_param_call() below

> +static int configure_kgdboc(void)

__init

> +{
> +	struct tty_driver *p;
> +	int tty_line = 0;
> +	int err;
> +
> +	err = kgdboc_option_setup(config);
> +	if (err || !strlen(config) || isspace(config[0]))
> +		goto noconfig;
> +
> +	err = -ENODEV;
> +
> +	p = tty_find_polling_driver(config, &tty_line);
> +	if (!p)
> +		goto noconfig;
> +
> +	kgdb_tty_driver = p;
> +	kgdb_tty_line = tty_line;
> +
> +	err = kgdb_register_io_module(&kgdboc_io_ops);
> +	if (err)
> +		goto noconfig;
> +
> +	configured = 1;
> +
> +	return 0;
> +
> +noconfig:
> +	config[0] = 0;
> +	configured = 0;
> +
> +	return err;
> +}
> +
> +static int init_kgdboc(void)

__init

> +{
> +	/* Already configured? */
> +	if (configured == 1)
> +		return 0;
> +
> +	return configure_kgdboc();
> +}
> +
> +static void cleanup_kgdboc(void)

I would suggest __exit but it can be called from param_set_kgdboc_var()

[ I have a feeling that somethings is wrong with this but I'm too lazy
  to read the code in depth... ]

> diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
> index 0f5a179..a72116a 100644
> --- a/drivers/serial/serial_core.c
> +++ b/drivers/serial/serial_core.c

[...]

> +#ifdef CONFIG_CONSOLE_POLL
> +

unnecessary new line

[...]

> diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
> new file mode 100644
> index 0000000..7f4ee55
> --- /dev/null
> +++ b/include/linux/kgdb.h
> @@ -0,0 +1,329 @@

[...]

> +/* The maximum number of KGDB I/O modules that can be loaded */
> +#define KGDB_MAX_IO_HANDLERS	3

unused

> +#ifndef KGDB_MAX_BREAKPOINTS
> +# define KGDB_MAX_BREAKPOINTS	1000
> +#endif
> +
> +#define KGDB_HW_BREAKPOINT	1

unused

[...]

> +/*
> + * struct kgdb_io - Describe the interface for an I/O driver to talk with KGDB.
> + * @name: Name of the I/O driver.
> + * @read_char: Pointer to a function that will return one char.
> + * @write_char: Pointer to a function that will write one char.
> + * @flush: Pointer to a function that will flush any pending writes.
> + * @init: Pointer to a function that will initialize the device.
> + * @late_init: Pointer to a function that will do any setup that has

there is no late_init in the structure

> + * other dependencies.
> + * @pre_exception: Pointer to a function that will do any prep work for
> + * the I/O driver.
> + * @post_exception: Pointer to a function that will do any cleanup work
> + * for the I/O driver.
> + *
> + * The @init and @late_init function pointers allow for an I/O driver
> + * such as a serial driver to fully initialize the port with @init and
> + * be called very early, yet safely call request_irq() later in the boot
> + * sequence.
> + *
> + * @init is allowed to return a non-0 return value to indicate failure.
> + * If this is called early on, then KGDB will try again when it would call
> + * @late_init.  If it has failed later in boot as well, the user will be
> + * notified.
> + */
> +struct kgdb_io {
> +	const char		*name;
> +	int			(*read_char) (void);
> +	void			(*write_char) (u8);
> +	void			(*flush) (void);
> +	int			(*init) (void);
> +	void			(*pre_exception) (void);
> +	void			(*post_exception) (void);
> +};

[...]

> diff --git a/kernel/kgdb.c b/kernel/kgdb.c
> new file mode 100644
> index 0000000..b5dd949
> --- /dev/null
> +++ b/kernel/kgdb.c

[...]

> +/*
> + * SW breakpoint management:
> + */
> +static int kgdb_activate_sw_breakpoints(void)
> +{
> +	unsigned long addr;
> +	int error = 0;
> +	int i;
> +
> +	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
> +		if (kgdb_break[i].state != BP_SET)
> +			continue;
> +
> +		addr = kgdb_break[i].bpt_addr;
> +		error = kgdb_arch_set_breakpoint(addr,
> +				kgdb_break[i].saved_instr);
> +		if (error)
> +			return error;
> +
> +		if (CACHE_FLUSH_IS_SAFE) {
> +			if (current->mm && addr < TASK_SIZE) {
> +				flush_cache_range(current->mm->mmap_cache,
> +						addr, addr + BREAK_INSTR_SIZE);
> +			} else {
> +				flush_icache_range(addr, addr +
> +						BREAK_INSTR_SIZE);
> +			}
> +		}

identical cache flushing code is present in
kgdb_deactivate_sw_breakpoints() below

maybe it would make sense to have some common helper

> +		kgdb_break[i].state = BP_ACTIVE;
> +	}
> +	return 0;
> +}
> +
> +static int kgdb_set_sw_break(unsigned long addr)
> +{
> +	int error = kgdb_validate_break_address(addr);
> +	int breakno = -1;
> +	int i;
> +
> +	if (error < 0)
> +		return error;
> +
> +	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
> +		if ((kgdb_break[i].state == BP_SET) &&
> +					(kgdb_break[i].bpt_addr == addr))
> +			return -EEXIST;
> +	}
> +	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
> +		if (kgdb_break[i].state == BP_REMOVED &&
> +					kgdb_break[i].bpt_addr == addr) {
> +			breakno = i;
> +			break;
> +		}
> +	}

if kgdb_isremovedbreak() helper is moved before kgdb_set_sw_break()
and converted to return 'i' on success and '-1' on failure then it can
be used instead the above for () loop

> +
> +	if (breakno == -1) {
> +		for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
> +			if (kgdb_break[i].state == BP_UNDEFINED) {
> +				breakno = i;
> +				break;
> +			}
> +		}
> +	}
> +
> +	if (breakno == -1)
> +		return -E2BIG;
> +
> +	kgdb_break[breakno].state = BP_SET;
> +	kgdb_break[breakno].type = BP_BREAKPOINT;
> +	kgdb_break[breakno].bpt_addr = addr;
> +
> +	return 0;
> +}
> +
> +static int kgdb_deactivate_sw_breakpoints(void)
> +{
> +	unsigned long addr;
> +	int error = 0;
> +	int i;
> +
> +	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
> +		if (kgdb_break[i].state != BP_ACTIVE)
> +			continue;
> +		addr = kgdb_break[i].bpt_addr;
> +		error = kgdb_arch_remove_breakpoint(addr,
> +					kgdb_break[i].saved_instr);
> +		if (error)
> +			return error;
> +
> +		if (CACHE_FLUSH_IS_SAFE && current->mm &&
> +				addr < TASK_SIZE) {
> +			flush_cache_range(current->mm->mmap_cache,
> +					addr, addr + BREAK_INSTR_SIZE);
> +		} else if (CACHE_FLUSH_IS_SAFE) {
> +			flush_icache_range(addr, addr + BREAK_INSTR_SIZE);
> +		}
> +		kgdb_break[i].state = BP_SET;
> +	}
> +	return 0;
> +}
> +
> +static int kgdb_remove_sw_break(unsigned long addr)
> +{
> +	int i;
> +
> +	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
> +		if ((kgdb_break[i].state == BP_SET) &&
> +				(kgdb_break[i].bpt_addr == addr)) {
> +			kgdb_break[i].state = BP_REMOVED;

it would make a sense to have to have kgdb_isset() helper
to use here and in kgdb_set_sw_break()

> +			return 0;
> +		}
> +	}
> +	return -ENOENT;
> +}
> +
> +int kgdb_isremovedbreak(unsigned long addr)
> +{
> +	int i;
> +
> +	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
> +		if ((kgdb_break[i].state == BP_REMOVED) &&
> +					(kgdb_break[i].bpt_addr == addr))
> +			return 1;
> +	}
> +	return 0;
> +}

Thanks,
Bart
