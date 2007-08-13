Return-Path: <linux-kernel-owner+w=401wt.eu-S948225AbXHMRct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S948225AbXHMRct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030379AbXHMR32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:29:28 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:39836 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S945103AbXHMR3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:29:20 -0400
Date: Mon, 13 Aug 2007 19:30:03 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Emelyanov <xemul@openvz.org>, Greg KH <gregkh@suse.de>
Subject: Re: [patch] encapsulate uevent()/add_uevent_var() buffer handling
Message-ID: <20070813193003.6542e4e7@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070813143711.GA24536@s15225674.onlinehome-server.info>
References: <20070813143711.GA24536@s15225674.onlinehome-server.info>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007 16:37:11 +0200,
Kay Sievers <kay.sievers@vrfy.org> wrote:

> Hi,
> this changes the uevent buffer stuff to use a struct instead
> of tons of parameters. It does no longer require the caller to
> do the proper buffer termination and size accounting, which is
> currently wrong in a lot of places.

I was working on a patch which tried to fix the same things but added
more parameters to uevent. Using a struct is really better.

> 
> This tells everything:
>   47 files changed, 265 insertions(+), 605 deletions(-)

Cool.

> 
> Thanks,
> Kay
> 
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: Driver core: encapsulate uevent()/add_uevent_var() buffer handling
> 
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> ---
>  arch/ia64/sn/kernel/tiocx.c                 |    3 
>  arch/powerpc/kernel/of_device.c             |   37 ++------
>  arch/powerpc/kernel/vio.c                   |   14 ---
>  arch/powerpc/platforms/ps3/system-bus.c     |    9 -
>  block/genhd.c                               |   35 +------
>  drivers/acpi/scan.c                         |   16 +--
>  drivers/amba/bus.c                          |    8 -
>  drivers/base/class.c                        |   42 ++-------
>  drivers/base/core.c                         |   83 +++++-------------
>  drivers/base/firmware_class.c               |   10 --
>  drivers/base/memory.c                       |    3 
>  drivers/base/platform.c                     |    6 -
>  drivers/eisa/eisa-bus.c                     |    9 -
>  drivers/firewire/fw-device.c                |    9 -
>  drivers/firmware/dmi-id.c                   |   16 +--
>  drivers/i2c/i2c-core.c                      |    8 -
>  drivers/ide/ide.c                           |   17 +--
>  drivers/ieee1394/nodemgr.c                  |   17 ---
>  drivers/infiniband/core/sysfs.c             |    9 -
>  drivers/input/input.c                       |   62 ++++---------
>  drivers/input/serio/serio.c                 |   11 --
>  drivers/media/video/pvrusb2/pvrusb2-sysfs.c |    4 
>  drivers/misc/tifm_core.c                    |    9 -
>  drivers/mmc/core/bus.c                      |   11 --
>  drivers/pci/hotplug.c                       |   28 +-----
>  drivers/pci/pci-driver.c                    |    3 
>  drivers/pci/pci.h                           |    3 
>  drivers/pcmcia/cs.c                         |   10 --
>  drivers/pcmcia/ds.c                         |   26 +----
>  drivers/power/power_supply.h                |    3 
>  drivers/power/power_supply_sysfs.c          |   16 +--
>  drivers/s390/cio/ccwgroup.c                 |    3 
>  drivers/s390/cio/device.c                   |   18 +--
>  drivers/s390/crypto/ap_bus.c                |   14 ---
>  drivers/scsi/scsi_sysfs.c                   |    9 -
>  drivers/spi/spi.c                           |    7 -
>  drivers/usb/core/driver.c                   |   29 +-----
>  drivers/usb/core/message.c                  |   17 ---
>  drivers/w1/w1.c                             |   18 +--
>  include/asm-powerpc/of_device.h             |    2 
>  include/linux/device.h                      |   15 +--
>  include/linux/kobject.h                     |   23 +++--
>  lib/kobject_uevent.c                        |  127 +++++++++-------------------
>  net/atm/atm_sysfs.c                         |    7 -
>  net/core/net-sysfs.c                        |   14 ---
>  net/wireless/sysfs.c                        |    3 
>  sound/aoa/soundbus/core.c                   |   27 +----
>  47 files changed, 265 insertions(+), 605 deletions(-)
> 

This is against current git? -mm has at least
drivers/mmc/core/sdio_bus.c in addition to convert, but that is
straightforward.

> diff --git a/arch/ia64/sn/kernel/tiocx.c b/arch/ia64/sn/kernel/tiocx.c
> index 5a289e4..a88eba3 100644
> --- a/arch/ia64/sn/kernel/tiocx.c
> +++ b/arch/ia64/sn/kernel/tiocx.c
> @@ -66,8 +66,7 @@ static int tiocx_match(struct device *dev, struct device_driver *drv)
> 
>  }
> 
> -static int tiocx_uevent(struct device *dev, char **envp, int num_envp,
> -			 char *buffer, int buffer_size)
> +static int tiocx_uevent(struct device *dev, struct kobj_uevent_env *env)
>  {
>  	return -ENODEV;
>  }

I'm not sure whether this bus wants to use uevent_suppress instead, but
that would be a different patch.

> diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
> index 268e301..455e280 100644
> --- a/drivers/amba/bus.c
> +++ b/drivers/amba/bus.c
> @@ -44,14 +44,12 @@ static int amba_match(struct device *dev, struct device_driver *drv)
>  }
> 
>  #ifdef CONFIG_HOTPLUG
> -static int amba_uevent(struct device *dev, char **envp, int nr_env, char *buf, int bufsz)
> +static int amba_uevent(struct device *dev, struct kobj_uevent_env *env)
>  {
>  	struct amba_device *pcdev = to_amba_device(dev);
> -	int retval = 0, i = 0, len = 0;
> +	int retval = 0;
> 
> -	retval = add_uevent_var(envp, nr_env, &i,
> -				buf, bufsz, &len,
> -				"AMBA_ID=%08x", pcdev->periphid);
> +	retval = add_uevent_var(env, "AMBA_ID=%08x", pcdev->periphid);
>  	envp[i] = NULL;

Forgotten NULL-setting.

>  	return retval;
>  }


> diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
> index df02814..06ffeda 100644
> --- a/lib/kobject_uevent.c
> +++ b/lib/kobject_uevent.c
> @@ -22,8 +22,6 @@
>  #include <linux/kobject.h>
>  #include <net/sock.h>
> 
> -#define BUFFER_SIZE	2048	/* buffer for the variables */
> -#define NUM_ENVP	32	/* number of env pointers */
> 
>  /* the strings here must match the enum in include/linux/kobject.h */
>  const char *kobject_actions[] = {
> @@ -54,31 +52,21 @@ static struct sock *uevent_sock;
>   * corresponding error when it fails.
>   */
>  int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
> -			char *envp_ext[])
> +		       char *envp_ext[])
>  {
> -	char **envp;
> -	char *buffer;
> -	char *scratch;
> -	const char *action_string;
> +	struct kobj_uevent_env *env;
> +	const char *action_string = kobject_actions[action];
>  	const char *devpath = NULL;
>  	const char *subsystem;
>  	struct kobject *top_kobj;
>  	struct kset *kset;
>  	struct kset_uevent_ops *uevent_ops;
>  	u64 seq;
> -	char *seq_buff;
>  	int i = 0;
>  	int retval = 0;
> -	int j;
> 
>  	pr_debug("%s\n", __FUNCTION__);
> 
> -	action_string = kobject_actions[action];
> -	if (!action_string) {
> -		pr_debug("kobject attempted to send uevent without action_string!\n");
> -		return -EINVAL;
> -	}
> -

Hm, unrelated change?

>  	/* search the kset we belong to */
>  	top_kobj = kobj;
>  	while (!top_kobj->kset && top_kobj->parent) {
> @@ -92,7 +80,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
>  	kset = top_kobj->kset;
>  	uevent_ops = kset->uevent_ops;
> 
> -	/*  skip the event, if the filter returns zero. */
> +	/* skip the event, if the filter returns zero. */
>  	if (uevent_ops && uevent_ops->filter)
>  		if (!uevent_ops->filter(kset, kobj)) {
>  			pr_debug("kobject filter function caused the event to drop!\n");
> @@ -109,18 +97,11 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
>  		return 0;
>  	}
> 
> -	/* environment index */
> -	envp = kzalloc(NUM_ENVP * sizeof (char *), GFP_KERNEL);
> -	if (!envp)
> +	/* environment buffer */
> +	env = kzalloc(sizeof(struct kobj_uevent_env), GFP_KERNEL);
> +	if (!env)
>  		return -ENOMEM;
> 
> -	/* environment values */
> -	buffer = kmalloc(BUFFER_SIZE, GFP_KERNEL);
> -	if (!buffer) {
> -		retval = -ENOMEM;
> -		goto exit;
> -	}
> -
>  	/* complete object path */
>  	devpath = kobject_get_path(kobj, GFP_KERNEL);
>  	if (!devpath) {
> @@ -128,29 +109,19 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
>  		goto exit;
>  	}
> 
> -	/* event environemnt for helper process only */
> -	envp[i++] = "HOME=/";
> -	envp[i++] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
> -
>  	/* default keys */
> -	scratch = buffer;
> -	envp [i++] = scratch;
> -	scratch += sprintf(scratch, "ACTION=%s", action_string) + 1;
> -	envp [i++] = scratch;
> -	scratch += sprintf (scratch, "DEVPATH=%s", devpath) + 1;
> -	envp [i++] = scratch;
> -	scratch += sprintf(scratch, "SUBSYSTEM=%s", subsystem) + 1;
> -	for (j = 0; envp_ext && envp_ext[j]; j++)
> -		envp[i++] = envp_ext[j];
> -	/* just reserve the space, overwrite it after kset call has returned */
> -	envp[i++] = seq_buff = scratch;
> -	scratch += strlen("SEQNUM=18446744073709551616") + 1;
> +	add_uevent_var(env, "ACTION=%s", action_string);
> +	add_uevent_var(env, "DEVPATH=%s", devpath);
> +	add_uevent_var(env, "SUBSYSTEM=%s", subsystem);
> +
> +	/* keys passed in from the caller */
> +	if (envp_ext)
> +		for (i = 0; envp_ext[i]; i++)
> +			add_uevent_var(env, envp_ext[i]);
> 
>  	/* let the kset specific function add its stuff */
>  	if (uevent_ops && uevent_ops->uevent) {
> -		retval = uevent_ops->uevent(kset, kobj,
> -				  &envp[i], NUM_ENVP - i, scratch,
> -				  BUFFER_SIZE - (scratch - buffer));
> +		retval = uevent_ops->uevent(kset, kobj, env);
>  		if (retval) {
>  			pr_debug ("%s - uevent() returned %d\n",
>  				  __FUNCTION__, retval);
> @@ -158,11 +129,11 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
>  		}
>  	}
> 
> -	/* we will send an event, request a new sequence number */
> +	/* we will send an event, so request a new sequence number */
>  	spin_lock(&sequence_lock);
>  	seq = ++uevent_seqnum;
>  	spin_unlock(&sequence_lock);
> -	sprintf(seq_buff, "SEQNUM=%llu", (unsigned long long)seq);
> +	add_uevent_var(env, "SEQNUM=%llu", (unsigned long long)seq);
> 
>  #if defined(CONFIG_NET)
>  	/* send netlink message */
> @@ -172,17 +143,19 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
> 
>  		/* allocate message with the maximum possible size */
>  		len = strlen(action_string) + strlen(devpath) + 2;
> -		skb = alloc_skb(len + BUFFER_SIZE, GFP_KERNEL);
> +		skb = alloc_skb(len + env->buflen, GFP_KERNEL);
>  		if (skb) {
> +			char *scratch;
> +
>  			/* add header */
>  			scratch = skb_put(skb, len);
>  			sprintf(scratch, "%s@%s", action_string, devpath);
> 
>  			/* copy keys to our continuous event payload buffer */
> -			for (i = 2; envp[i]; i++) {
> -				len = strlen(envp[i]) + 1;
> +			for (i = 0; i < env->envp_idx; i++) {
> +				len = strlen(env->envp[i]) + 1;
>  				scratch = skb_put(skb, len);
> -				strcpy(scratch, envp[i]);
> +				strcpy(scratch, env->envp[i]);
>  			}
> 
>  			NETLINK_CB(skb).dst_group = 1;
> @@ -198,13 +171,15 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
>  		argv [0] = uevent_helper;
>  		argv [1] = (char *)subsystem;
>  		argv [2] = NULL;
> -		call_usermodehelper (argv[0], argv, envp, UMH_WAIT_EXEC);
> +		add_uevent_var(env, "HOME=/");
> +		add_uevent_var(env, "PATH=/sbin:/bin:/usr/sbin:/usr/bin");
> +
> +		call_usermodehelper (argv[0], argv, env->envp, UMH_WAIT_EXEC);
>  	}
> 
>  exit:
>  	kfree(devpath);
> -	kfree(buffer);
> -	kfree(envp);
> +	kfree(env);
>  	return retval;
>  }
> 
> @@ -227,52 +202,32 @@ int kobject_uevent(struct kobject *kobj, enum kobject_action action)
>  EXPORT_SYMBOL_GPL(kobject_uevent);
> 
>  /**
> - * add_uevent_var - helper for creating event variables
> - * @envp: Pointer to table of environment variables, as passed into
> - * uevent() method.
> - * @num_envp: Number of environment variable slots available, as
> - * passed into uevent() method.
> - * @cur_index: Pointer to current index into @envp.  It should be
> - * initialized to 0 before the first call to add_uevent_var(),
> - * and will be incremented on success.
> - * @buffer: Pointer to buffer for environment variables, as passed
> - * into uevent() method.
> - * @buffer_size: Length of @buffer, as passed into uevent() method.
> - * @cur_len: Pointer to current length of space used in @buffer.
> - * Should be initialized to 0 before the first call to
> - * add_uevent_var(), and will be incremented on success.
> - * @format: Format for creating environment variable (of the form
> - * "XXX=%x") for snprintf().
> + * add_uevent_var - add key value string to the environment buffer
> + * @env: environment buffer structure
> + * @format: printf format for the key=value pair
>   *
>   * Returns 0 if environment variable was added successfully or -ENOMEM
>   * if no space was available.
>   */
> -int add_uevent_var(char **envp, int num_envp, int *cur_index,
> -		   char *buffer, int buffer_size, int *cur_len,
> -		   const char *format, ...)
> +int add_uevent_var(struct kobj_uevent_env *env, const char *format, ...)
>  {
>  	va_list args;
> +	int len;
> 
> -	/*
> -	 * We check against num_envp - 1 to make sure there is at
> -	 * least one slot left after we return, since kobject_uevent()
> -	 * needs to set the last slot to NULL.
> -	 */
> -	if (*cur_index >= num_envp - 1)
> +	if (env->envp_idx >= ARRAY_SIZE(env->envp))
>  		return -ENOMEM;
> 
> -	envp[*cur_index] = buffer + *cur_len;
> -
>  	va_start(args, format);
> -	*cur_len += vsnprintf(envp[*cur_index],
> -			      max(buffer_size - *cur_len, 0),
> -			      format, args) + 1;
> +	len = vsnprintf(&env->buf[env->buflen],
> +			sizeof(env->buf) - env->buflen,
> +			format, args);
>  	va_end(args);
> 
> -	if (*cur_len > buffer_size)
> +	if (len + 1 >= (sizeof(env->buf) - env->buflen))
>  		return -ENOMEM;
> 
> -	(*cur_index)++;
> +	env->envp[env->envp_idx++] = &env->buf[env->buflen];
> +	env->buflen += len + 1;
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(add_uevent_var);

Looks good!
