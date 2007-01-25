Return-Path: <linux-kernel-owner+w=401wt.eu-S933116AbXAYAg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116AbXAYAg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 19:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933132AbXAYAg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 19:36:59 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:16178 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933116AbXAYAgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 19:36:43 -0500
Date: Wed, 24 Jan 2007 16:32:18 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Nadia.Derbey@bull.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/6] Tunable structure and registration routines
Message-Id: <20070124163218.ec54891d.randy.dunlap@oracle.com>
In-Reply-To: <20070116063028.375290000@bull.net>
References: <20070116061516.899460000@bull.net>
	<20070116063028.375290000@bull.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jan 2007 07:15:17 +0100 Nadia.Derbey@bull.net wrote:

> [PATCH 01/06]
> 
> Defines the auto_tune structure: this is the structure that contains the
> information needed by the adjustment routine for a given tunable.
> Also defines the registration routines.
> 
> The fork kernel component defines a tunable structure for the threads-max
> tunable and registers it.
> 
> Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
> ---
>  Documentation/00-INDEX      |    2 
>  Documentation/auto_tune.txt |  333 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/Kconfig                  |    2 
>  include/linux/akt.h         |  186 ++++++++++++++++++++++++
>  include/linux/akt_ops.h     |  186 ++++++++++++++++++++++++
>  init/main.c                 |    2 
>  kernel/Makefile             |    1 
>  kernel/autotune/Kconfig     |   30 +++
>  kernel/autotune/Makefile    |    7 
>  kernel/autotune/akt.c       |  123 ++++++++++++++++
>  kernel/fork.c               |   18 ++
>  11 files changed, 890 insertions(+)
> 
> Index: linux-2.6.20-rc4/Documentation/auto_tune.txt
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.20-rc4/Documentation/auto_tune.txt	2007-01-15 14:19:18.000000000 +0100
> @@ -0,0 +1,333 @@
> +			Automatic Kernel Tunables
> +                        =========================
> +
> +		   Nadia Derbey (Nadia.Derbey@bull.net)
> +
> +
> +
> +This feature aims at making the kernel automatically change the tunables
> +values as it sees resources running out.
> +
> +The AKT framework is made of 2 parts:
> +
> +1) Kernel part:
> +Interfaces are provided to the kernel subsystems, to (un)register the
> +tunables that might be automatically tuned in the future.
> +
> +Registering a tunable consists in the following steps:

                                 s/in/of/

> +- a structure is declared and filled by the kernel subsystem for the
> +registered tunable
> +- that tunable structure is registered into sysfs
> +
> +Registration should be done during the kernel subsystem initialization step.

...

> +Any kernel subsystem that has registered a tunable should call
> +auto_tune_func() as follows:
> +
> ++-------------------------+--------------------------------------------+
> +| Step                    | Routine to call                            |
> ++-------------------------+--------------------------------------------+
> +| Declaration phase       | DEFINE_TUNABLE(name, values...);           |
> ++-------------------------+--------------------------------------------+
> +| Initialization routine  | set_tunable_min_max(name, min, max);       |
> +|                         | set_autotuning_routine(name, routine);     |
> +|                         | register_tunable(&name);                   |
> +| Note: the 1st 2 calls   |                                            |
> +|       are optional      |                                            |
> ++-------------------------+--------------------------------------------+
> +| Alloc                   | activate_auto_tuning(AKT_UP, &name);       |
> ++-------------------------+--------------------------------------------+
> +| Free                    | activate_auto_tuning(AKT_DOWN, &name);     |

So does Free always use AKT_DOWN?  why does it matter?
Seems unneeded and inconsistent.
How does one activate a tunable for downward adjustment?

> ++-------------------------+--------------------------------------------+
> +| module_exit() routine   | unregister_tunable(&name);                 |
> ++-------------------------+--------------------------------------------+
> +
> +activate_auto_tuning is a static inline defined in akt.h, that does the
> +following:
> +. if <tunable is registered> and <auto tuning is allowd for tunable>

                                                    allowed

> +.   call the routine stored in tunable->auto_tune
> +
> +
> +The effect of the default automatic tuning routine is the following:
> +
> +           +----------------------------------------------------------------+
> +           |                 Tunable automatically adjustable               |
> +           +---------------+------------------------------------------------+
> +           |      NO       |                      YES                       |
> ++----------+---------------+------------------------------------------------+
> +| AKT_UP   | No effect     | If the tunable value exceeds the specified     |
> +|          |               | threshold, that value is increased up to a     |
> +|          |               | maximum value.                                 |
> +|          |               | The maximum value is specified during the      |
> +|          |               | tunable declaration and can be changed at any  |
> +|          |               | time through sysfs                             |
> ++----------+---------------+------------------------------------------------+
> +| AKT_DOWN | No effect     | If the tunable value falls under the specified |
> +|          |               | threshold, that value is decreased down to a   |
> +|          |               | minimum value.                                 |
> +|          |               | The minimum value is specified during the      |
> +|          |               | tunable declaration and can be changed at any  |
> +|          |               | time through sysfs                             |
> ++----------+---------------+------------------------------------------------+
> +
> +
> +1.6. Default automatic adjustment routine
> +
> +The last service provided by AKT at the kernel level is the default automatic
> +adjustment routine. As seen, above, this routine supports various tunables
> +types. It works as follows (only the AKT_UP direction is described here -
> +AKT_DOWN does the reverse operation):
> +
> +The 2nd parameter passed in to this routine is a pointer to a previously
> +registerd tunable structure. That structure contains the following fields (see
   registered

> +1.1 for the detailed description):
> +- threshold
> +- key
> +- min
> +- max
> +- tunable
> +- checked
> +
> +When this routine is entered, it does the following:
> +1. <*checked> is compared to <*tunable> * threshold
> +2. if <*checked> is greater, <*tunable> is set to:
> +	<*tunable> + (<*tunable> * (100 - threshold) / 100)
> +
> +
> +
> +1.6) akt and sysfs:
> +
...

> +
> +1.7) tunables that are namespace dependent
> +
...

> +
> +1.7.2) Initializing the tunable structure
> +
> +Then the tunable structure should be initialized by calling the following
> +routine:
> +
> +init_tunable_ipcns(namespace_ptr, structure_name, threshold, min, max,
> +		tunable_variable_ptr, checked_variable_ptr,
> +		tunable_variable_type);
> +
> +Parameters:
> +- namespace_ptr: pointer to the namespace the tunable belongs to.
> +
> +See DEFINE_TUNABLE for the other parameters

end with a period/full-stop '.'.

> +
> +1.7.3) Registering the tunable structure
> +
...

> +
> +2) User part:
> +
> +As seen above, the only way to activate automatic tuning is from user side:
> +- the directory /sys/tunables is created during the init phase.
> +- each time a tunable is registered by a kernel subsystem, a directory is
> +created for it under /sys/tunables.
> +- This directory contains 1 file for each tunable kobject attribute:

Please try to limit text documentation to 80 columns or less.

> ++-----------+---------------+-------------------+----------------------------+
> +| attribute | default value | how to set it     | effect                     |
> ++-----------+---------------+-------------------+----------------------------+
> +| autotune  | 0             | echo 1 > autotune | makes the tunable automatic|
> +|           |               | echo 0 > autotune | makes the tunable manual   |
> ++-----------+---------------+-------------------+----------------------------+
> +| max       | max value set | echo <M> > max    | sets the tunable max value |
> +|           | during tunable|                   | to <M>                     |
> +|           | definition    |                   |                            |
> ++-----------+---------------+-------------------+----------------------------+
> +| min       | min value set | echo <m> > min    | sets the tunable min value |
> +|           | during tunable|                   | to <m>                     |
> +|           | definition    |                   |                            |
> ++-----------+---------------+-------------------+----------------------------+
> +
> Index: linux-2.6.20-rc4/fs/Kconfig
> ===================================================================
> --- linux-2.6.20-rc4.orig/fs/Kconfig	2007-01-15 13:08:14.000000000 +0100
> +++ linux-2.6.20-rc4/fs/Kconfig	2007-01-15 14:20:20.000000000 +0100
> @@ -925,6 +925,8 @@ config PROC_KCORE
>  	bool "/proc/kcore support" if !ARM
>  	depends on PROC_FS && MMU
>  
> +source "kernel/autotune/Kconfig"

Why is that is the File systems menu?  Seems odd to me
for it to be there.  If it's just because it depends on
PROC_FS and SYSFS, then it should just go completely after
the File systems menu.

>  config PROC_VMCORE
>          bool "/proc/vmcore support (EXPERIMENTAL)"
>          depends on PROC_FS && EXPERIMENTAL && CRASH_DUMP
> Index: linux-2.6.20-rc4/include/linux/akt.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.20-rc4/include/linux/akt.h	2007-01-15 14:26:24.000000000 +0100
> @@ -0,0 +1,186 @@
> +
> +#ifndef AKT_H
> +#define AKT_H
> +
> +#include <linux/types.h>
> +#include <linux/kobject.h>
> +
> +/*
> + * First parameter passed to the adjustment routine
> + */
> +#define AKT_UP   0   /* adjustment "up" */
> +#define AKT_DOWN 1   /* adjustment "down" */
> +
> +
> +struct auto_tune {
> +	spinlock_t tunable_lck; /* serializes access to the stucture fields */
> +	auto_tune_fn auto_tune; /* auto tuning routine registered by the */
> +				/* calling kernel susbsystem. If NULL, the */
> +				/* auto tuning routine that will be called */
> +				/* is the default one that processes uints */
> +	int (*check_parms)(struct auto_tune *);	/* min / max checking */
> +						/* routine ptr: points to */
> +						/* the appropriate routine */
> +						/* depending on the */
> +						/* tunable type */
> +	const char *name;
> +	char flags;	/* Only 2 bits are meaningful: */

Make flags unsigned char so that no sign bit is needed.

> +			/* bit 0: set to 1 if the associated tunable can */
> +			/*        be automatically adjusted */
> +			/* bits 1: set to 1 if the tunable has been */
> +			/*         registered */
> +			/* bits 2-7: useless */

                                     unused ??

> +	char threshold;	/* threshold to enable the adjustment expressed as */
> +			/* a %age */
> +	struct typed_value min;	/* min value the tunable can ever reach */
> +				/* and associated show / store routines) */
> +	struct typed_value max;	/* max value the tunable can ever reach */
> +				/* and associated show / store routines) */
> +	void *tunable;	/* address of the tunable to adjust */
> +	void *checked;	/* address of the variable that is controlled by */
> +			/* the tunable. This is the calling subsystem's */
> +			/* object counter */
> +};
> +

...

> +
> +extern void fork_late_init(void);

Looks like the wrong header file for that extern.

> +#endif /* AKT_H */

> Index: linux-2.6.20-rc4/kernel/autotune/akt.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.20-rc4/kernel/autotune/akt.c	2007-01-15 14:51:54.000000000 +0100
> @@ -0,0 +1,123 @@
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/akt.h>
> +
> +
> +
> +	Too Much Whitespace.  :)
> +
> +
> +
> +/*
> + * FUNCTION:    Inserts a tunable structure into sysfs
> + *              This routine serves also as a checker for the tunable
> + *              structure fields.
> + *              This routine is called by any kernel subsystem that wants to
> + *              use akt services (automatic tunables adjustment) in the future
> + *
> + * NOTE: when calling this routine, the tunable structure should have already
> + *       been filled by defining it with DEFINE_TUNABLE()
> + *
> + * RETURN VALUE: 0: successful
> + *               <0 if failure
> + */

Please use kernel-doc format for function comment blocks.

> +int register_tunable(struct auto_tune *tun)
> +{
> +	if (tun == NULL) {
> +		printk(KERN_ERR "\tBad tunable structure pointer (NULL)\n");

	Each printk() needs something that tells that module or part
	of the kernel that it's coming from (sometimes called a prefix).
	And drop the \t (tab).  IOW, replace the tab with a prefix, e.g.:

		printk(KERN_ERR "autotune: Bad tunable structure NULL pointer\n");

> +		return -EINVAL;
> +	}
> +
> +	if (tun->threshold <= 0 || tun->threshold >= 100) {
> +		printk(KERN_ERR "\tBad threshold (%d) value "
> +			"- should be in the [1-99] interval\n",
> +			tun->threshold);

Replace \t with a prefix (and more below).

> +		return -EINVAL;
> +	}
> +
> +	if (tun->tunable == NULL) {
> +		printk(KERN_ERR "\tBad tunable pointer (NULL)\n");
> +		return -EINVAL;
> +	}
> +
> +	if (tun->checked == NULL) {
> +		printk(KERN_ERR "\tBad checked value pointer (NULL)\n");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Check the min / max value
> +	 */
> +	if (tun->check_parms(tun)) {
> +		printk(KERN_ERR "\tBad min / max values\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +
> +/*
> + * FUNCTION:    Removes a tunable structure from sysfs.
> + *              This routine is called by any kernel subsystem that doesn't
> + *              need the akt services anymore
> + *
> + * NOTE:  reg_tun should point to a previously registered tunable
> + *
> + * RETURN VALUE: 0: successful
> + *               <0 if failure
> + */
> +int unregister_tunable(struct auto_tune *reg_tun)
> +{
> +	if (reg_tun == NULL) {
> +		printk(KERN_ERR "\tBad tunable address (NULL)\n");
> +		return -EINVAL;
> +	}
> +
> +	spin_lock(&reg_tun->tunable_lck);
> +
> +	BUG_ON(!is_tunable_registered(reg_tun));
> +
> +	reg_tun->flags = 0;
> +
> +	spin_unlock(&reg_tun->tunable_lck);
> +
> +	return 0;
> +}
> +
> +	Too Much Whitespace....
> +
> +
> +EXPORT_SYMBOL_GPL(register_tunable);
> +EXPORT_SYMBOL_GPL(unregister_tunable);

---
~Randy
