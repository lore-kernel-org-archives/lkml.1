Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbYIIJrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbYIIJrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 05:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYIIJqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 05:46:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49104 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbYIIJqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 05:46:52 -0400
To: Jarod Wilson <jwilson@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
       Janne Grunau <j@jannau.net>, Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
From: Andi Kleen <andi@firstfloor.org>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
	<1220933164-10160-2-git-send-email-jwilson@redhat.com>
Date: Tue, 09 Sep 2008 11:46:48 +0200
In-Reply-To: <1220933164-10160-2-git-send-email-jwilson@redhat.com> (Jarod Wilson's message of "Tue,  9 Sep 2008 00:05:46 -0400")
Message-ID: <87hc8ptzw7.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson <jwilson@redhat.com> writes:

Just some quick comments, no complete review

> +EXTRA_CFLAGS =-DIRCTL_DEV_MAJOR=61 -DLIRC_SERIAL_TRANSMITTER -I$(src)

Put the Ds into some include instead?

> +
> +static int debug;
> +#define dprintk(fmt, args...)					\
> +	do {							\
> +		if (debug)					\
> +			printk(KERN_DEBUG fmt, ## args);	\
> +	} while (0)

There's some effort to replace that all with pr_printk

> +	dprintk(LOGHEAD "poll thread started\n", ir->p.name, ir->p.minor);
> +
> +	do {
> +		if (ir->open) {
> +			if (ir->jiffies_to_wait) {
> +				set_current_state(TASK_INTERRUPTIBLE);
> +				schedule_timeout(ir->jiffies_to_wait);
> +			} else {
> +				interruptible_sleep_on(
> +					ir->p.get_queue(ir->p.data));

sleep_on is really discouraged, consider replacing it with wait_event()

> +			}
> +			if (kthread_should_stop())
> +				break;
> +			if (!add_to_buf(ir))
> +				wake_up_interruptible(&ir->buf->wait_poll);
> +		} else {
> +			/* if device not opened so we can sleep half a second */
> +			set_current_state(TASK_INTERRUPTIBLE);
> +			schedule_timeout(HZ/2);

This means you always wake up every half a second? That will not make 
the powertop users happy. When there's nothing to do it should just sleep.


The checks in plugin_register seem a bit extreme.
At least make that all WARN_ONs

> +
> +	/* end up polling thread */
> +	if (ir->task) {
> +		wake_up_process(ir->task);
> +		kthread_stop(ir->task);
> +	}
> +
> +	dprintk("lirc_dev: plugin %s unregistered from minor number = %d\n",
> +		ir->p.name, ir->p.minor);
> +
> +	ir->attached = 0;
> +	if (ir->open) {
> +		dprintk(LOGHEAD "releasing opened plugin\n",
> +			ir->p.name, ir->p.minor);
> +		wake_up_interruptible(&ir->buf->wait_poll);

This seems racy with some users who are lockless

> +		mutex_lock(&ir->buffer_lock);
> +		ir->p.set_use_dec(ir->p.data);
> +		module_put(ir->p.owner);
> +		mutex_unlock(&ir->buffer_lock);
> +	} else
> +		cleanup(ir);
> +	mutex_unlock(&plugin_lock);
> +
> +/*
> + * Recent kernels should handle this autmatically by increasing/decreasing
> + * use count when a dependant module is loaded/unloaded.
> + */

All kernels are recent now.

> +#ifdef MODULE
> +
> +/*
> + *
> + */
> +int init_module(void)
> +{
> +	return lirc_dev_init();
> +}
> +
> +/*
> + *
> + */
> +void cleanup_module(void)
> +{
> +	/* unregister_chrdev returns void now */
> +	unregister_chrdev(IRCTL_DEV_MAJOR, IRCTL_DEV_NAME);
> +	class_destroy(lirc_class);
> +	dprintk("lirc_dev: module unloaded\n");
> +}
> +
> +MODULE_DESCRIPTION("LIRC base driver module");
> +MODULE_AUTHOR("Artur Lipowski");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS_CHARDEV_MAJOR(IRCTL_DEV_MAJOR);
> +
> +module_param(debug, bool, 0644);
> +MODULE_PARM_DESC(debug, "Enable debugging messages");
> +
> +#else /* not a MODULE */
> +subsys_initcall(lirc_dev_init);
> +
> +#endif /* MODULE */

Always use the #ifdef MODULE path, it does DTRT when compiled in too.
Remove the init_module wrapper, replace with module_init() 

... not read further ...
-Andi

-- 
ak@linux.intel.com
