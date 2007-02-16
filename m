Return-Path: <linux-kernel-owner+w=401wt.eu-S1946096AbXBPT4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946096AbXBPT4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946098AbXBPT4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:56:45 -0500
Received: from mail.trixing.net ([87.230.125.58]:55196 "EHLO mail.trixing.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946096AbXBPT4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:56:44 -0500
Message-ID: <45D60C62.5080806@l4x.org>
Date: Fri, 16 Feb 2007 20:56:18 +0100
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20061220 Thunderbird/1.5.0.9 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Rodolfo Giometti <giometti@enneenne.com>
CC: linux-kernel@vger.kernel.org
References: <20070216185230.GO8882@enneenne.com>
In-Reply-To: <20070216185230.GO8882@enneenne.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.37
X-SA-Exim-Mail-From: jdi@l4x.org
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
X-SA-Exim-Version: 4.2.1 (built Mon, 27 Mar 2006 14:12:04 +0200)
X-SA-Exim-Scanned: Yes (on mail.trixing.net)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some non political comments

Rodolfo Giometti wrote:
> +Coding example
> +--------------
> +
> +To register a PPS source into the kernel you should define a struct
> +linuxpps_source_info_s as follow:
> +
> +    static struct linuxpps_source_info_s linuxpps_ktimer_info = {

Drop the linux prefix. It's in the linux kernel after all.

> +PROCFS support
> +--------------

New features shouldn't introduce new /proc stuff.

> +Resources
> +---------
> +
> +Wiki: http://wiki.enneenne.com/index.php/LinuxPPS_support and the LinuxPPS
> +ML:   http://ml.enneenne.com/cgi-bin/mailman/listinfo/linuxpps.

Add to MAINTAINERS

Your way to hook into lp and 8250 is pretty gross. It should at least be
possible to deactivate it via the kernel command line, but it would be
a lot nicer to have pps_lp and pps_8250 modules which you can load. Also
what happens if you've multiple lp ports? How do you control which to
grab?

- don't implement your own dbg() stuff, use dprintk and friends
- drop the inlines, gcc will do the right thing.

> --- a/drivers/char/lp.c
> +++ b/drivers/char/lp.c
>  static struct parport_driver lp_driver = {
> diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
> index b61c17b..426b0ac 100644
> --- a/drivers/parport/parport_pc.c
> +++ b/drivers/parport/parport_pc.c
> @@ -272,6 +272,14 @@ static int clear_epp_timeout(struct parport *pb)
>  
>  static irqreturn_t parport_pc_interrupt(int irq, void *dev_id)
>  {
> +#ifdef CONFIG_PPS_CLIENT_LP_PARPORT_PC
> +	struct parport *p = (struct parport *) dev_id;
> +
> +	linuxpps_event(p->pps_source, PPS_CAPTUREASSERT, p);

Perhaps just implement empty defines for the none pps cases and get
rid of the ifdefs? But this should really be controllabe via
sysfs or such.

> --- /dev/null
> +++ b/drivers/pps/clients/Kconfig
> @@ -0,0 +1,56 @@
> +#
> +# LinuxPPS clients configuration
> +#
> +
> +if PPS
> +
> +comment "PPS clients support"
> +
> +config PPS_CLIENT_KTIMER
> +	tristate "Kernel timer client (Testing client, use for debug)"
> +	help
> +	  If you say yes here you get support for a PPS debugging client
> +	  which uses a kernel timer to generate the PPS signal.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called ktimer.o.
> +
> +comment "UART serial support (forced off)"
> +	depends on SERIAL_CORE && ( PPS = m && SERIAL_CORE = y )
> +
> +config PPS_CLIENT_UART
> +	bool "UART serial support"
> +	depends on SERIAL_CORE && ! ( PPS = m && SERIAL_CORE = y )

help text

> +
> +comment "8250 serial support (forced off)"
> +	depends on PPS_CLIENT_UART && SERIAL_8250 && \
> +			( PPS = m && SERIAL_8250 = y )
> +
> +config PPS_CLIENT_UART_8250
> +	bool "8250 serial support"
> +	depends on PPS_CLIENT_UART && SERIAL_8250 && \
> +			! ( PPS = m && SERIAL_8250 = y )
> +	help
> +	  If you say yes here you get support for a PPS source connected
> +	  with the CD (Carrier Detect) pin of your 8250 serial line chip.
> +
> +comment "Parallel printer support (forced off)"
> +	depends on PRINTER && ( PPS = m && PRINTER = y )
> +
> +config PPS_CLIENT_LP
> +	bool "Parallel printer support"
> +	depends on PRINTER && ! ( PPS = m && PRINTER = y )

help text

> +comment "Parport PC support (forced off)"
> +	depends on PPS_CLIENT_LP && PARPORT_PC && \
> +			( PPS = m && PARPORT_PC = y )
> +
> +config PPS_CLIENT_LP_PARPORT_PC
> +	bool "Parport PC support"
> +	depends on PPS_CLIENT_LP && PARPORT_PC && \
> +                       ! ( PPS = m && PARPORT_PC = y )
> +	help
> +	  If you say yes here you get support for a PPS source connected
> +	  with the interrupt pin of your PC parallel port.

help text and difference to CLIENT_LP?

> +++ b/drivers/pps/kapi.c
> +/* --- Local functions ----------------------------------------------------- */
> +
> +#ifndef NSEC_PER_SEC
> +#define	NSEC_PER_SEC		1000000000
> +#endif

What's that for? Why is(n't) it defined?

> +		for (i = 0; i < LINUXPPS_MAX_SOURCES; i++)
> +			if (!__linuxpps_is_allocated(i))
> +				break;
> +		if (i >= LINUXPPS_MAX_SOURCES) {
> +			err("no free source ids");
> +			return -ENOMEM;
> +		}

Why no dynamically allocated array?


> +void linuxpps_event(int source, int event, void *data)
> +{
> +	struct timespec ts;
> +
> +	/* In this function we shouldn't need locking at all since each PPS
> +	 * source arrives once per second and due the per-PPS source data
> +	 * array... */

I wouldn't bet on that.

> +++ b/drivers/pps/pps.c
> @@ -0,0 +1,377 @@
> +/*
> + * main.c -- Main driver file

Doesn't match filename

> +++ b/drivers/pps/procfs.c

I'd drop that completely.

> +++ b/include/linux/netlink.h
> @@ -21,7 +21,7 @@
>  #define NETLINK_DNRTMSG		14	/* DECnet routing messages */
>  #define NETLINK_KOBJECT_UEVENT	15	/* Kernel messages to userspace */
>  #define NETLINK_GENERIC		16
> -/* leave room for NETLINK_DM (DM Events) */
> +#define NETLINK_PPSAPI          17      /* linuxPPS support */

You read the comment above your line?

>  #define DEFAULT_SPIN_TIME 500 /* us */
> diff --git a/include/linux/pps.h b/include/linux/pps.h
> new file mode 100644
> index 0000000..52f67ce
> --- /dev/null
> +++ b/include/linux/pps.h
> +#ifdef CONFIG_PPS_DEBUG
> +#define dbg(format, arg...) printk(KERN_DEBUG "%s: " format "\n" , \
> +	KBUILD_MODNAME , ## arg)
> +#else
> +#define dbg(format, arg...) do {} while (0)
> +#endif
> +
> +#define err(format, arg...) printk(KERN_ERR "%s: " format "\n" , \
> +	KBUILD_MODNAME , ## arg)
> +#define info(format, arg...) printk(KERN_INFO "%s: " format "\n" , \
> +	KBUILD_MODNAME , ## arg)

These should use dprintk and friends

> +
> +/* --- Global defines ------------------------------------------------------ */
> +
> +#define LINUXPPS_MAX_SOURCES		16

Isn't something like 4 more reasonable (lp + 8250 + ktimer?)

> +/* The main struct */
> +struct linuxpps_s {
> +	struct linuxpps_source_info_s *info;		/* PSS source info */
> +
> +	pps_params_t params;				/* PPS's current params */
> +
> +	volatile pps_seq_t assert_sequence;		/* PPS' assert event seq # */
> +	volatile pps_seq_t clear_sequence;		/* PPS' clear event seq # */
> +	volatile pps_timeu_t assert_tu;
> +	volatile pps_timeu_t clear_tu;

I think you can drop the volatiles, there was a discussion some time ago
that they mostly waste of words.

> +static inline int __linuxpps_is_allocated(int source) {
> +	return linuxpps_source[source].info != NULL;
> +}
> +
> +static inline int linuxpps_is_allocated(int source) {
> +	unsigned long flags;
> +	int ret;
> +
> +	spin_lock_irqsave(&linuxpps_lock, flags);
> +	ret = __linuxpps_is_allocated(source);
> +	spin_unlock_irqrestore(&linuxpps_lock, flags);
> +
> +	return ret;
> +}

This one looks pretty fishy. After the check you normally want
to use it, don't you? And then you already lost the guarantee.

> +#define to_class_dev(obj) container_of((obj), struct class_device, kobj)

pretty generic name.

> +++ b/include/linux/timepps.h
				   use a frequency-locked loop */
> +
> +/* --- Here begins the implementation-specific part! ----------------------- */
> +
> +#define LINUXPPS_MAX_NAME_LEN           32
> +struct pps_netlink_msg {
> +	int cmd;			  /* the command to execute */
> +	int source;
> +	char name[LINUXPPS_MAX_NAME_LEN]; /* symbolic name */
> +	char path[LINUXPPS_MAX_NAME_LEN]; /* path of the connected device */
> +	int consumer;			  /* selected kernel consumer */
> +	pps_params_t params;
> +	int mode;			  /* edge */
> +	int tsformat;			  /* format of time stamps */
> +	pps_info_t info;
> +	struct timespec timeout;
> +	int ret;
> +};

Have you thought about 32/64bit issues?


> +/* Private functions */
> +
> +static int netlink_msg(int socket, struct pps_netlink_msg *nlpps)

Function in .h?


Jan
